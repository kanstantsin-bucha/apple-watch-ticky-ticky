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
            Text("Ticky-Ticky")
                .font(.caption)
                .foregroundColor(.yellow)
                .padding()
           
            Button(isRunning ? "Stop Ticking" : "Start Ticking") {
                log.event("Start/Stop button tapped")
                if isRunning {
                    service(ExtendedSessionService.self).stop()
                } else {
                    service(ExtendedSessionService.self).start()
                }
            }
            .foregroundColor(.green)
            NavigationLink(destination: MoreView()) {
                Text("More")
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
