//
//  WristWatchApp.swift
//  WristWatch WatchKit Extension
//
//  Created by Kanstantsin Bucha on 11/06/2022.
//

import SwiftUI
import WatchKit

@main
struct WristWatchApp: App {
    @WKExtensionDelegateAdaptor private var extensionDelegate: WristWatchAppDelegate
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
        WKNotificationScene(
            controller: NotificationController.self,
            category: NotificationCategory.watch
        )
    }
}
