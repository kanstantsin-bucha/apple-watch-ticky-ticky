//
//  SiteView.swift
//  BuzzWatchAppExtension
//
//  Created by Kanstantsin Bucha on 09/11/2022.
//

import SwiftUI

struct SiteView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("Scan QR code with iPhone")
                Spacer()
                Image("qrcode_kanstantsin-bucha.com")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                Spacer()
                Link(
                    "Or open site on the Watch",
                    destination: URL(string: "https://www.kanstantsin-bucha.com")!
                )
            }
        }
    }
}
