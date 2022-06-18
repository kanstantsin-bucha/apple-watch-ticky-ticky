//
//  ContentView.swift
//  WristWatch WatchKit Extension
//
//  Created by Kanstantsin Bucha on 11/06/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Wrist Watch")
                .padding()
            Text("It will produce haptics")
                .padding()
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
