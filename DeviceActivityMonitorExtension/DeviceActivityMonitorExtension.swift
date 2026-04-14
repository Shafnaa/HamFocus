//
//  DeviceActivityMonitorExtension.swift
//  DeviceActivityMonitorExtension
//
//  Created by Heidy Mudita Sutedjo on 13/04/26.
//

import DeviceActivity
import OSLog

private let log = Logger(
    subsystem: "com.saujanashafi.HamFocus.monitor",
    category: "DeviceActivity"
)

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)

        log.info("intervalDidStart for activity: \(activity.rawValue)")
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)

        log.info("intervalDidEnd for activity: \(activity.rawValue)")
    }

    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)

        log.info("eventDidReachThreshold for event: \(event.rawValue), activity: \(activity.rawValue)")
    }

    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)

        log.info("intervalWillStartWarning for activity: \(activity.rawValue)")
    }

    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)

        log.info("intervalWillEndWarning for activity: \(activity.rawValue)")
    }

    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)

        log.info("eventWillReachThresholdWarning for event: \(event.rawValue), activity: \(activity.rawValue)")
    }
}
