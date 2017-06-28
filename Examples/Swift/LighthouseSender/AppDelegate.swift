//
//  AppDelegate.swift
//  LighthouseSender
//
//  Created by Lacy Rhoades on 6/28/17.
//  Copyright © 2017 Lacy Rhoades. All rights reserved.
//

import UIKit
import Lighthouse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var lighthouse: Lighthouse?
    
    var broadcastTimer: Timer?
    var broadcastTimerRunLoop = RunLoop.main
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.lighthouse = Lighthouse(port: 4545)
        self.lighthouse?.setupBroadcast()
        
        if let mainMenu = self.window?.rootViewController as? ViewController {
            self.lighthouse?.loggingDelegate = mainMenu
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        self.pauseBroadcast()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        self.startBroadcast()
    }
    
}

extension AppDelegate {
    func startBroadcast() {
        self.broadcastTimer?.invalidate()
        let timer = Timer(timeInterval: 0.5, repeats: true, block: { (timer) in
            self.lighthouse?.broadcast(message: "Hello everyone!")
        })
        self.broadcastTimer = timer
        self.broadcastTimerRunLoop.add(timer, forMode: .commonModes)
    }
    
    func pauseBroadcast() {
        self.broadcastTimer?.invalidate()
    }
}

