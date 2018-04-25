//
//  Networking.swift
//  FoboBeta
//
//  Created by Lacy Rhoades on 11/9/16.
//  Copyright © 2016 Colordeaf. All rights reserved.
//

import Foundation

extension sockaddr_in {
    var addressString: String {
        let sadr: UInt32 = self.sin_addr.s_addr
        let b = (UInt8( sadr >> 24        ),
                 UInt8((sadr >> 16) & 0xff),
                 UInt8((sadr >>  8) & 0xff),
                 UInt8( sadr        & 0xff))
        return String(format:"%d.%d.%d.%d", b.0, b.1, b.2, b.3)
    }
    
    init(port: UInt16) {
        self.init()
        self.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        self.sin_family = 0
        self.sin_port = 0
        self.sin_addr = in_addr(s_addr: 0)
        self.sin_zero = (0,0,0,0,0,0,0,0)
        self.sin_family = UInt8(AF_INET)
        self.sin_port = port.bigEndian
    }
    
    init(_ saddr: sockaddr) {
        self = saddr.copyAsSockAddrIn()
    }
    
    func copyAsSockAddr() -> sockaddr {
        let len = self.sin_len
        let family = self.sin_family
        let port = self.sin_port.bigEndian
        let (hi, lo) = ((port >> 8).asInt8, (port & 0x00ff).asInt8)
        let sadr: UInt32 = self.sin_addr.s_addr.bigEndian
        let b = (Int8( sadr >> 24        ),
                 Int8((sadr >> 16) & 0xff),
                 Int8((sadr >>  8) & 0xff),
                 Int8( sadr        & 0xff))
        let z: Int8 = 0
        let data = (hi, lo, b.0, b.1, b.2, b.3, z,z,z,z,z,z,z,z)
        return sockaddr(sa_len: len, sa_family: family, sa_data: data)
    }
    
    func unsafeCopyAsSockAddr() -> sockaddr {
        return unsafeBitCast(self, to: sockaddr.self)
    }
}

extension sockaddr {
    init(_ saddr_in: sockaddr_in) {
        self = saddr_in.copyAsSockAddr()
    }
    
    func copyAsSockAddrIn() -> sockaddr_in {
        let len = UInt8(MemoryLayout<sockaddr_in>.size)
        let family = self.sa_family
        let (hi, lo) = (self.sa_data.0, self.sa_data.1)
        let port = (UInt16(hi) << 8) | UInt16(lo)
        let b = (UInt32(UInt8(bitPattern: self.sa_data.2)),
                 UInt32(UInt8(bitPattern: self.sa_data.3)),
                 UInt32(UInt8(bitPattern: self.sa_data.4)),
                 UInt32(UInt8(bitPattern: self.sa_data.5)))
        let sadr =  b.0 << 24 | b.1 << 16 | b.2 << 8 | b.3
        let addr = in_addr(s_addr: sadr)
        
        return sockaddr_in(sin_len: len, sin_family: family, sin_port: port,
                           sin_addr: addr, sin_zero: (0,0,0,0,0,0,0,0))
    }
    
    func unsafeCopyAsSockAddrIn() -> sockaddr_in {
        return unsafeBitCast(self, to: sockaddr_in.self)
    }
}

extension UInt16 {
    var asInt8: Int8 {
        let v = self & 0xff
        return Int8(v >> 4) << 4 | Int8(v & 0xf)
    }
}
