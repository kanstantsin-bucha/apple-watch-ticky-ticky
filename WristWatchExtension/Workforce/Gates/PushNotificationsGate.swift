//
//  PushNotificationsGate.swift
//  WristWatch WatchKit Extension
//
//  Created by Kanstantsin Bucha on 12/06/2022.
//

import WatchKit
import UserNotifications

public final class PushNotificationsGate: NSObject {
    func handle(deviceToken: Data) {
        guard service(GatesKeeper.self).cloudGate.isOpen else {
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(5 * 60)) { [weak self] in
                self?.handle(deviceToken: deviceToken)
            }
            return
        }
        let token = deviceToken.hexEncodedString()
        log.event("Got device token for notifications: \(token)")
    }
    
    func handleFailToRegister(error: Error) {
        log.error("Failed to register for push notifications: \(error)")
        DispatchQueue.global().asyncAfter(
            deadline: .now() + .seconds(10 * 60)
        ) { [weak self] in
            // Try again after 10 min
            self?.open()
        }
    }
}

extension PushNotificationsGate: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        log.event("Got notification: \(notification.request)")
        return [.banner, .sound, .badge]
    }
}

extension PushNotificationsGate: Gate {
    var isOpen: Bool { true }
    
    func summon() {
        UNUserNotificationCenter.current().delegate = self
    }
    
    func open() {
        Task {
            do {
                try await UNUserNotificationCenter.current().requestAuthorization(
                    options: [.alert, .badge, .sound]
                )
                await WKExtension.shared().registerForRemoteNotifications()
                log.event("App requested a registeration for remote notifications")
            } catch {
                log.error("Failed to request authorisation for push notifications: \(error)")
            }
        }
    }
    
    func close() {}
}
