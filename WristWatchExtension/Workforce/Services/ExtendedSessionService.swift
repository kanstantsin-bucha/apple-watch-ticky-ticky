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
    
    public func start() {
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
        session.start()
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
        countTime()
    }

    public func extendedRuntimeSessionWillExpire(
        _ session: WKExtendedRuntimeSession
    ) {
        log.event("""
            RuntimeSession WillExpire soon, expiration: \
            \(String(describing: session.expirationDate))
            """
        )
    }
    
    // MARK: - Private
    
    private func countTime() {
        let correctionInterval = secondsToElapseToFullMinute(date: Date())
        log.info("Scheduled haptic play event after \(correctionInterval) seconds")
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(correctionInterval)) { [weak self] in
            guard let self = self else { return }
            // TODO: - check if the watch is on a wrist
            self.playHaptic(type: self.hapticType(date: Date()))
            guard let session = self.currentSession,
                  session.state == .running
            else {
                return
            }
            self.countTime()
        }
    }
    
    private func playHaptic(type: WKHapticType) {
        guard let session = currentSession, session.state == .running else {
            log.error("Session is not running, skip haptic action")
            return
        }
        log.event("Play haptic: \(String(describing: type))")
        WKInterfaceDevice.current().play(type)
    }
    
    private func hapticType(date: Date) -> WKHapticType {
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date)
        if minutes % 15 == 0 {
            return .retry
        }
        if minutes % 5 == 0 {
            return .start
        }
        return .click
    }
    
    private func secondsToElapseToFullMinute(date: Date) -> Int {
        let calendar = Calendar.current
        return 60 - calendar.component(.second, from: date)
    }
}
