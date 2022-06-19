//
//  ContentView.swift
//  WristWatch WatchKit Extension
//
//  Created by Kanstantsin Bucha on 11/06/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var appState: AppState
    var body: some View {
        VStack {
            Text("Death Watch")
                .font(.caption)
                .padding()
           
            Button(isRunning ? "Stop" : "Start") {
                log.event("Start/Stop button tapped")
                if isRunning {
                    service(ExtendedSessionService.self).stop()
                } else {
                    service(ExtendedSessionService.self).start(after: 1)
                }
            }
            .foregroundColor(.green)
            NavigationLink(destination: InfoView()) {
                Text("Info")
            }
        }
    }
    
    private var isRunning: Bool {
        if case .running = appState.sessionState {
            return true
        }
        return false
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(appState: service(AppStatePersistence.self).state)
        }
    }
}
