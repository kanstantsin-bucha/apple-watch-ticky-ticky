//
//  AppStatePersistence.swift
//  WristWatchExtension
//
//  Created by Kanstantsin Bucha on 19/06/2022.
//

import SwiftUI

public final class AppStatePersistence: Service {
    public var state = AppState(sessionState: .none)
}

public class AppState: ObservableObject {
    @Published public var sessionState: SessionState
    
    public init(sessionState: SessionState) {
        self.sessionState = sessionState
    }
}

public enum SessionState {
    case none
    case scheduled
    case running(expiry: Date)
}
