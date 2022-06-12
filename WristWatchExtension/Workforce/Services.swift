//
//  Services.swift
//  WristWatch WatchKit Extension
//
//  Created by Kanstantsin Bucha on 12/06/2022.
//

import Foundation

public protocol Service: AnyObject {}
fileprivate typealias ServiceDeclaration = (service: AnyObject, interface: Any.Type)

fileprivate class ServiceLocator {
    private lazy var list: [String: AnyObject] = [:]
    
    func add(servicesList: [ServiceDeclaration]) {
        servicesList.forEach { add(service: $0.service, withInterface: $0.interface)}
    }

    func add(service: AnyObject, withInterface interface: Any.Type) {
        guard service is Service else {
            log.error("Failed. \(service.self) doesn't conform to the Service protocol")
            preconditionFailure("Failed. \(service.self) doesn't conform to the Service protocol")
        }
        list[key(forInterface: interface)] = service
    }

    func service<T>(forInterface interface: T.Type) -> T {
        guard let service = list[key(forInterface: interface)] else {
            log.error("Failed. Service doesn't exist for the requested interface \(interface)")
            preconditionFailure("Failed. Service doesn't exist for the requested interface \(interface)")
        }
        return service as! T
    }
    
    private func key(forInterface interface: Any.Type) -> String {
        return "\(interface.self)"
    }
    
    func removeAll() {
        list = [:]
    }
}

fileprivate let locator = ServiceLocator()

public func service<T>(_ interface: T.Type) -> T {
    locator.service(forInterface: interface)
}

public func removeAllServices() {
    locator.removeAll()
}

func setupServices() {
    let declaration: ServiceDeclaration = (service: GatesKeeper(), interface: GatesKeeper.self)
    let array: [ServiceDeclaration] = [declaration]
    locator.add(servicesList: array)
}



