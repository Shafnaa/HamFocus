//
//  FocusDeviceActivityMonitor.swift
//  HamFocus
//

import DeviceActivity
import FamilyControls
import Foundation
import ManagedSettings

@MainActor
enum FocusDeviceActivityMonitor {
    static let activityName = DeviceActivityName("HamFocusFocusSession")

    private static let center = DeviceActivityCenter()
    private static let settingsStore = ManagedSettingsStore()

    static func startMonitoring() {
        applyShields()

        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )

        do {
            try center.startMonitoring(activityName, during: schedule)
        } catch {
            print("Unable to start focus device activity monitoring: \(error)")
        }
    }

    static func stopMonitoring() {
        center.stopMonitoring([activityName])
        clearShields()
    }

    private static func applyShields() {
        guard let selection = ShieldActivitySelectionStore.savedSelection() else {
            return
        }

        settingsStore.shield.applications = selection.applicationTokens.nilIfEmpty
        settingsStore.shield.webDomains = selection.webDomainTokens.nilIfEmpty
        settingsStore.shield.applicationCategories = selection.categoryTokens.isEmpty
            ? nil
            : .specific(selection.categoryTokens)
        settingsStore.shield.webDomainCategories = selection.categoryTokens.isEmpty
            ? nil
            : .specific(selection.categoryTokens)
    }

    private static func clearShields() {
        settingsStore.shield.applications = nil
        settingsStore.shield.webDomains = nil
        settingsStore.shield.applicationCategories = nil
        settingsStore.shield.webDomainCategories = nil
    }
}

private extension Set {
    var nilIfEmpty: Set<Element>? {
        isEmpty ? nil : self
    }
}
