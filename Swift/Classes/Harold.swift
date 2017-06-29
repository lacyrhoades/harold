//
//  Harold.swift
//  FoboBeta
//
//  Created by Lacy Rhoades on 11/5/16.
//  Copyright © 2016 Colordeaf. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

public protocol HaroldListener: class {
    func haroldReceived(fromHost host: String, message: String)
}

public protocol HaroldLoggingDelegate: class {
    func logFromHarold(_ message: String)
}

public class Harold: NSObject {
    public convenience init(port: Int) {
        self.init()
        self.listenPort = UInt16(port)
        self.broadcastPort = UInt16(port + 1)
    }
    
    public weak var loggingDelegate: HaroldLoggingDelegate?
    
    fileprivate var listeners: [HaroldListener] = []
    
    public func addListener(_ listener: HaroldListener) {
        if self.listeners.contains(where: { (eachlistener) -> Bool in
            return eachlistener === listener
        }) {
            return
        }
        
        self.listeners.append(listener)
    }
    
    private var listenSocket : GCDAsyncUdpSocket?
    private var broadcastSocket : GCDAsyncUdpSocket?
    
    fileprivate var listenPort: UInt16 = UInt16(4545)
    fileprivate var broadcastPort: UInt16 = UInt16(4546)
    fileprivate var broadcastAddress: String = "0.0.0.0"
    
    public func startScanning() {
        if listenSocket != nil {
            do {
                try listenSocket?.beginReceiving()
                return
            } catch {
                self.log("Issue with resuming on existing socket")
                self.log(error)
            }
        }
        
        self.listenSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.global(qos: .utility))
        
        listenSocket?.setIPv6Enabled(false)
        listenSocket?.setIPv4Enabled(true)
        
        do {
            var address = sockaddr_in(port: self.listenPort).copyAsSockAddr()
            let data = Data(bytes: &address, count: Int(address.sa_len))
            
            /*
             This does not seem to work
             Would be nice so that two apps could both listen on the same port I think? ...
             if let fd = listenSocket?.socketFD() {
             print("setting up socket sharing")
             var trueVal: Int = 1
             setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &trueVal, socklen_t(MemoryLayout<Int>.size));
             setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, &trueVal, socklen_t(MemoryLayout<Int>.size));
             } else {
             print("can't set up socket sharing")
             }
             */
            
            try listenSocket?.bind(toAddress: data)
            try listenSocket?.enableBroadcast(true)
            try listenSocket?.beginReceiving()
            self.log("Started scanning for harold signals")
        } catch {
            self.log("Issue with setting up socket")
            self.log(error)
        }
    }
    
    public func pauseScanning() {
        listenSocket?.close()
        listenSocket = nil
    }
    
    public var canBroadcast: Bool {
        return self.broadcastSocket != nil
    }
    
    public func setupBroadcast() {
        self.broadcastSocket = GCDAsyncUdpSocket(
            delegate: self,
            delegateQueue: DispatchQueue.global(qos: .utility)
        )
        broadcastSocket?.setIPv6Enabled(false)
        broadcastSocket?.setIPv4Enabled(true)
        
        do {
            var address = sockaddr_in(port: self.broadcastPort).copyAsSockAddr()
            let data = Data(bytes: &address, count: Int(address.sa_len))
            
            try broadcastSocket?.bind(toAddress: data)
            try broadcastSocket?.enableBroadcast(true)
            self.log("Ready to broadcast")
        } catch {
            self.log("Issue with setting up socket")
            self.log(error)
        }
    }
    
    public func disableBroadcast() {
        broadcastSocket?.closeAfterSending()
        broadcastSocket = nil
    }
    
    public func broadcast(message: String) {
        guard let _ = broadcastSocket else {
            return
        }
        
        if let data = message.data(using: .utf8) {
            broadcastSocket?.send(data, toHost: "255.255.255.255", port: self.listenPort, withTimeout: 1.0, tag: 1)
            self.log("Sent message: ".appending(message))
        } else {
            self.log("Trouble creating data from String: ".appending(message))
        }
    }
}

extension Harold: GCDAsyncUdpSocketDelegate {
    public func udpSocket(_ sock: GCDAsyncUdpSocket, didConnectToAddress address: Data) {
        // self.log("Socket did connect")
    }
    
    public func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
        // self.log("Socket did not connect")
        // self.log(error == nil ? "No error message" : error!.localizedDescription)
        if error != nil {
            self.log(error!.localizedDescription)
        }
    }
    
    public func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        // self.log("Socket did send data")
    }
    
    public func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        // self.log("Socket did not send data")
        // self.log(error == nil ? "No error message" : error!.localizedDescription)
        if error != nil {
            self.log(error!.localizedDescription)
        }
    }
    
    public func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        var host: NSString?
        var port: UInt16 = 0
        
        // self.log("Socket did recieve")
        
        GCDAsyncUdpSocket.getHost(&host, port: &port, fromAddress: address)
        
        if let host = host as String?, let text = String(data: data, encoding: String.Encoding.utf8) {
            self.listeners.forEach { (listener) in
                listener.haroldReceived(fromHost: host, message: text)
            }
        }
    }
    
    public func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
        self.log("Socket had error")
        self.log(error == nil ? "No error message" : error!.localizedDescription)
    }
    
    func log(_ message: Any) {
        let message = String(self.listenPort).appending(" - ").appending(String(describing: message))
        if let delegate = self.loggingDelegate {
            delegate.logFromHarold(message)
        } else {
            print(message)
        }
    }
}
