//
//  AppDelegate.swift
//  HaroldSender
//
//  Created by Lacy Rhoades on 6/28/17.
//  Copyright © 2017 Lacy Rhoades. All rights reserved.
//

import UIKit
import Harold

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var broadcaster: Harold?
    
    var broadcastTimer: Timer?
    var broadcastTimerRunLoop = RunLoop.main
    
    var mainMenu: ViewController? {
        return self.window?.rootViewController as? ViewController
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.broadcaster = Harold()
        
        self.broadcaster?.loggingDelegate = mainMenu
        
        let tapDown = TouchDownGestureRecognizer(target: self, action: #selector(didTapDown))
        tapDown.delegate = self
        mainMenu?.view.addGestureRecognizer(tapDown)

        let tapUp = TouchUpGestureRecognizer(target: self, action: #selector(didTapUp))
        tapUp.delegate = self
        mainMenu?.view.addGestureRecognizer(tapUp)
        
        return true
    }
    
    func didTapDown() {
        let message = "Sender did tapDown"
        print(message)
        self.broadcaster?.broadcast(message: message)
        self.mainMenu?.updateUI(withString: message)
    }
    
    func didTapUp() {
        let message = "Sender did tapUp"
        print(message)
        self.broadcaster?.broadcast(message: message)
        self.mainMenu?.updateUI(withString: message)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        self.stopBroadcast()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        self.startBroadcast()
    }
    
}

extension AppDelegate {
    func startBroadcast() {
        if let broadcaster = self.broadcaster, broadcaster.canBroadcast == false {
            broadcaster.setupBroadcast()
        }
        
        self.broadcastTimer?.invalidate()
        let timer = Timer(timeInterval: 2, repeats: true, block: { (timer) in
            self.broadcaster?.broadcast(message: "Hello everyone!")
        })
        self.broadcastTimer = timer
        self.broadcastTimerRunLoop.add(timer, forMode: .commonModes)
    }
    
    func stopBroadcast() {
        self.broadcastTimer?.invalidate()
        self.broadcaster?.disableBroadcast()
    }
}

extension AppDelegate: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
