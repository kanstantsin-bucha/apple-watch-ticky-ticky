//
//  WristWatchAppDelegate.swift
//  WristWatch WatchKit Extension
//
//  Created by Kanstantsin Bucha on 12/06/2022.
//

import Foundation
import WatchKit

class WristWatchAppDelegate: NSObject, WKExtensionDelegate, ObservableObject {
    private let sessionDelegate = WristWatchSessionDelegate()
    
    func applicationDidFinishLaunching() {
        setupServices()
        log.event("Application DidFinishLaunching")
    }

    func applicationDidBecomeActive() {
        log.event("Application DidBecomeActive")
        sessionDelegate.currentSession.start(at: Date().addingTimeInterval(1))
        service(GatesKeeper.self).notificationsGate.open()
    }

    func applicationWillResignActive() {
        log.event("Application WillResignActive")
    }

    func applicationWillEnterForeground() {
        log.event("Application WillEnterForeground")
    }

    func applicationDidEnterBackground() {
        log.event("Application DidEnterBackground")
    }
    
    func didRegisterForRemoteNotifications(withDeviceToken token: Data) {
        service(GatesKeeper.self).notificationsGate.handle(deviceToken: token)
    }
    
    func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        service(GatesKeeper.self).notificationsGate.handleFailToRegister(error: error)
    }

}
