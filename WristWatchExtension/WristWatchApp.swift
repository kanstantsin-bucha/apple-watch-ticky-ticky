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
    init() {
        setupServices()
    }
    
    @WKExtensionDelegateAdaptor private var extensionDelegate: WristWatchAppDelegate
   
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(appState: service(AppStatePersistence.self).state)
            }
        }
        WKNotificationScene(
            controller: NotificationController.self,
            category: NotificationCategory.watch
        )
    }
}
