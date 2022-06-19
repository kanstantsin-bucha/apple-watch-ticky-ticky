//
//  WKHapticType.swift
//  WristWatchExtension
//
//  Created by Kanstantsin Bucha on 19/06/2022.
//

import WatchKit

extension WKHapticType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .success:
            return "success"
            
        case .failure:
            return "failure"
            
        case .start:
            return "start"
            
        case .stop:
            return "stop"
            
        case .retry:
            return "retry"
            
        case .click:
            return "click"
            
        case .directionDown:
            return "directionDown"
            
        case .directionUp:
            return "directionUp"
            
        case .navigationGenericManeuver:
            return "navigationGenericManeuver"
            
        case .navigationLeftTurn:
            return "navigationLeftTurn"
            
        case .navigationRightTurn:
            return "navigationRightTurn"
            
        case .notification:
            return "notification"
            
        }
    }
}
