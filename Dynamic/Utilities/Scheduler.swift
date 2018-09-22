//
//  Scheduler.swift
//  Dynamic
//
//  Created by Apollo Zhu on 6/13/18.
//  Copyright © 2018 Dynamic. All rights reserved.
//

import CoreLocation
import UserNotifications
import Solar

extension Notification.Name {
    static let DarkModeOn = Notification.Name(#function)
    static let DarkModeOff = Notification.Name(#function)
}

public final class Scheduler {
    public static let shared = Scheduler()
    private init() { schedule() }
    
    public var darkMode: (on: Date, off: Date)? {
        didSet {
            schedule()
        }
    }
    
    private var timer: Timer?
    
    private func schedule() {
        guard let darkMode = darkMode else { return }
        let closer = min(darkMode.on, darkMode.off)
        timer = Timer(fire: closer, interval: 0, repeats: false)
        { [weak self] _ in
            self?.timer?.invalidate()
            self?.schedule()
        }
    }
    
    public enum Zenith: Int, CaseIterable {
        case official
        case civil
        case nautical
        case astronimical
        case custom
    }
    
    public func scheduleBetweenSunsetSunrise(ofType zenithType: Zenith,
                                             at loc: CLLocationCoordinate2D) {
        let solar = Solar(coordinate: loc)!
        switch zenithType {
        case .custom:
            break
        case .official:
            darkMode = (
                on: solar.sunset!,
                off: solar.sunrise!
            )
        case .civil:
            darkMode = (
                on: solar.civilSunset!,
                off: solar.civilSunrise!
            )
        case .nautical:
            darkMode = (
                on: solar.nauticalSunset!,
                off: solar.nauticalSunrise!
            )
        case .astronimical:
            darkMode = (
                on: solar.astronomicalSunset!,
                off: solar.astronomicalSunrise!
            )
        }
    }
}
