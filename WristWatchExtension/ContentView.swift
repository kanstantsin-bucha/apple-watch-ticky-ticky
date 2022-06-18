//
//  ContentView.swift
//  WristWatch WatchKit Extension
//
//  Created by Kanstantsin Bucha on 11/06/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("Death Watch")
                    .font(.caption)
                    .padding()
                Text("It inclined to wake up your mind and create a state of avareness")
                    .padding()
                Text("It will produce tick haptics every minute")
                    .padding()
                Text("It will produce start haptics every 5 minute")
                    .padding()
                Text("Try to present in a moment and notice every haptic event")
                    .padding()
                Text("Session duration is 30 min")
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
