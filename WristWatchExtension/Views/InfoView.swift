//
//  InfoView.swift
//  WristWatchExtension
//
//  Created by Kanstantsin Bucha on 19/06/2022.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("It creates a state of avareness that life is short")
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
                VStack {
                    Text("It will produce \"tick\" haptics every minute")
                        .multilineTextAlignment(.center)
                        .padding()
                    Text("It will produce \"start\" haptics every 5 minute")
                        .multilineTextAlignment(.center)
                        .padding()
                }
                Spacer()
                Text("Try to present in a moment and notice every haptic event")
                    .multilineTextAlignment(.center)
                    .padding()
                Text("Session duration is 30 min")
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
}
