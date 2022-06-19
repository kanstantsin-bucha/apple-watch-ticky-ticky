//
//  WristWatchSessionDelegate.swift
//  WristWatchExtension
//
//  Created by Kanstantsin Bucha on 18/06/2022.
//

import WatchKit

public final class ExtendedSessionService: NSObject, Service, WKExtendedRuntimeSessionDelegate {
    public private(set) var currentSession: WKExtendedRuntimeSession?
    
    public func stop() {
        guard let previous = currentSession, previous.state == .running else {
            return
        }
        playHaptic(type: .stop)
        previous.invalidate()
    }
    
    public func start(after postponeInterval: TimeInterval) {
        log.info("""
            RuntimeSession going to create new session, previous: \
            \(String(describing: currentSession))
            """
        )
        if let previous = currentSession,
           previous.state == .running || previous.state == .scheduled {
            log.info("Skip start because the session already running or schediled.")
            return
        }
        let session = WKExtendedRuntimeSession()
        session.delegate = self
        session.start(at: Date(timeIntervalSinceNow: postponeInterval))
        self.currentSession = session
        service(AppStatePersistence.self).state.sessionState = .scheduled
        WKInterfaceDevice.current().play(.click)
        log.event("RuntimeSession created new session")
    }
    
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
    
        WKInterfaceDevice.current().play(error != nil ? .failure : .click)
        service(AppStatePersistence.self).state.sessionState = .none
    }

    public func extendedRuntimeSessionDidStart(
        _ session: WKExtendedRuntimeSession
    ) {
        log.event("""
            RuntimeSession DidStart, expiration: \
            \(String(describing: session.expirationDate))
            """
        )
        WKInterfaceDevice.current().play(.start)
        service(AppStatePersistence.self).state.sessionState = .running(
            expiry: session.expirationDate ?? .distantPast
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
//        if let launchDate = session.expirationDate?.addingTimeInterval(1) {
//            WKInterfaceDevice.current().play(.retry)
//            start(after: 1)
//            log.info("Going to start new session at \(launchDate)")
//        }
    }
    
    // MARK: - Private
    
    private func playHaptic(type: WKHapticType? = nil) {
        guard let session = currentSession, session.state == .running else {
            log.error("Session is not running, skip haptic action")
            return
        }
        log.event("Play haptic: \(String(describing: type))")
        let type = type ?? hapticType(date: Date())
        session.notifyUser(hapticType: type) { [weak self] typePointer in
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
        guard minutes % 5 == 0 else {
            return .click
        }
        return .start
    }
    
    private func secondsToElapseToFullMinute(date: Date) -> Int {
        let calendar = Calendar.current
        return 60 - calendar.component(.second, from: date)
    }
}
