//
//  WristWatchSessionDelegate.swift
//  WristWatchExtension
//
//  Created by Kanstantsin Bucha on 18/06/2022.
//

import WatchKit

public final class WristWatchSessionDelegate: NSObject, WKExtendedRuntimeSessionDelegate {
    public private(set) lazy var currentSession: WKExtendedRuntimeSession = {
        let session = WKExtendedRuntimeSession()
        session.delegate = self
        return session
    }()
    
    public func extendedRuntimeSession(
        _ session: WKExtendedRuntimeSession,
        didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason,
        error: Error?
    ) {
        log.event("""
            RuntimeSession DidInvalidate, \
            error: \(String(describing: error))
            """
        )
    }

    public func extendedRuntimeSessionDidStart(
        _ session: WKExtendedRuntimeSession
    ) {
        log.event("""
            RuntimeSession DidStart, expiration: \
            \(String(describing: session.expirationDate))
            """
        )
        let correctionInterval = secondsToElapseToFullMinute(date: Date())
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(correctionInterval)) { [weak self] in
            self?.playHaptic()
        }
        log.info("Scheduled first haptic play event after \(correctionInterval) seconds")
    }

    public func extendedRuntimeSessionWillExpire(
        _ session: WKExtendedRuntimeSession
    ) {
        log.event("""
            RuntimeSession WillExpire soon, expiration: \
            \(String(describing: session.expirationDate))
            """
        )
        if let launchDate = session.expirationDate?.addingTimeInterval(1) {
            currentSession.invalidate()
            currentSession = WKExtendedRuntimeSession()
            currentSession.delegate = self
            currentSession.start(at: launchDate)
            log.info("Going to start new session at \(launchDate)")
        }
    }
    
    private func playHaptic() {
        guard currentSession.state == .running else {
            log.error("Session is not running, skip haptic action")
            return
        }
        log.event("Play haptic")
        let type = hapticType(date: Date())
        currentSession.notifyUser(hapticType: type) { [weak self] typePointer in
            let nextPlayInterval: TimeInterval = 60
            guard let self = self else { return nextPlayInterval }
            let type = self.hapticType(date: Date().addingTimeInterval(nextPlayInterval))
            typePointer.pointee = type
            log.event("Play repeating haptic: \(type)")
            return nextPlayInterval
        }
    }
    
    private func hapticType(date: Date) -> WKHapticType {
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date)
        switch minutes {
        case 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55:
            return .start
        default:
            return .click
        }
    }
    
    private func secondsToElapseToFullMinute(date: Date) -> Int {
        let calendar = Calendar.current
        return 60 - calendar.component(.second, from: date)
    }
}
