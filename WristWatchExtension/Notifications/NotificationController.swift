//
//  NotificationController.swift
//  WristWatch WatchKit Extension
//
//  Created by Kanstantsin Bucha on 11/06/2022.
//

import WatchKit
import SwiftUI
import UserNotifications

enum NotificationCategory {
    static let watch = "Watch_Category"
}

class NotificationController: WKUserNotificationHostingController<NotificationView> {
    private var isActive = false

    override var body: NotificationView {
        return NotificationView()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        isActive = true
        buzz()
        print("NotificationController willActivate")
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        isActive = false
        print("NotificationController didDeactivate")
    }

    override func didReceive(_ notification: UNNotification) {
        print("NotificationController didReceive")
        guard notification.request.content.categoryIdentifier == NotificationCategory.watch else {
            WKInterfaceDevice.current().play(.failure)
            return
        }
        WKInterfaceDevice.current().play(.success)
        // This method is called when a notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
    }
    
    // MARK: - Private methods
    
    private func buzz() {
        guard isActive else { return }
        WKInterfaceDevice.current().play(.success)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) { [weak self] in
            self?.buzz()
        }
    }
}
