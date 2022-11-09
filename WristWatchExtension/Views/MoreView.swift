//
//  InfoView.swift
//  WristWatchExtension
//
//  Created by Kanstantsin Bucha on 19/06/2022.
//

import SwiftUI

struct MoreView: View {
    var body: some View {
        ScrollView {
            VStack {
                useCasesView
                Spacer()
                tickingLogicView
                Spacer()
                oneMoreThingView
            }
        }
    }
    
    private var useCasesView: some View {
        VStack {
            Text("You can use it during interval studying or training.")
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
            Text("Noticing time intervals during day routine can raise your awareness too.")
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
            Text("After you open App or Press start - Watch will vibe with intervals.")
                .multilineTextAlignment(.center)
                .padding()
            Text("To stop - press the stop button anytime")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
    
    private var tickingLogicView: some View {
        VStack {
            Text("It will produce \"tick\" haptics every minute")
                .multilineTextAlignment(.center)
                .padding()
            Text("It will produce \"start\" haptics every 5 minute")
                .multilineTextAlignment(.center)
                .padding()
            Text("It will produce \"retry\" haptics every 15 minute")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
    
    private var oneMoreThingView: some View {
        VStack {
            Text("Session duration is 1 hour")
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
            NavigationLink(destination: SiteView()) {
                Text("Open the Site to learn more")
            }
        }
    }
}
