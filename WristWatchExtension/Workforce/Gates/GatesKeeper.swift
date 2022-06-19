//
//  GatesKeeper.swift
//  WristWatch WatchKit Extension
//
//  Created by Kanstantsin Bucha on 12/06/2022.
//

import Foundation

protocol Gate {
    var isOpen: Bool { get }
    
    func summon()
    func open()
    func close()
}

class GatesKeeper: Service {
    let cloudGate = CloudGate()
    let notificationsGate = PushNotificationsGate()
    
    func summonAll() {
        cloudGate.summon()
        notificationsGate.summon()
    }
}

class CloudGate: Gate {
    let isOpen = false
    
    func summon() {}
    func open() {}
    func close() {}
}
