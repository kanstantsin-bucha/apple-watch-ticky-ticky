//
//  WristWatchAppDelegate.swift
//  WristWatch WatchKit Extension
//
//  Created by Kanstantsin Bucha on 12/06/2022.
//

import Foundation
import WatchKit

class WristWatchAppDelegate: NSObject, WKExtensionDelegate, ObservableObject {
    func applicationDidFinishLaunching() {
        setupServices()
        log.event("applicationDidFinishLaunching")
    }

    func applicationDidBecomeActive() {
        log.event("applicationDidBecomeActive")
        service(GatesKeeper.self).notificationsGate.open()
    }

    func applicationWillResignActive() {
        log.event("applicationWillResignActive")
    }

    func applicationWillEnterForeground() {
        log.event("applicationWillEnterForeground")
    }

    func applicationDidEnterBackground() {
        log.event("applicationDidEnterBackground")
    }
    
    func didRegisterForRemoteNotifications(withDeviceToken token: Data) {
        service(GatesKeeper.self).notificationsGate.handle(deviceToken: token)
    }
    
    func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        service(GatesKeeper.self).notificationsGate.handleFailToRegister(error: error)
    }

}
