//
//  FocusIntent.swift
//  HamFocus
//
//  Created by Felicia Joshlyn Purnomo on 12/04/26.
//

import ActivityKit
import AppIntents
import Foundation

// The "STOP" button on the notification
struct StopSessionIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Stop Session"

    func perform() async throws -> some IntentResult {
        let groupDefaults = UserDefaults(suiteName: AppConfig.appGroupID)

        // 1. Send a "Stop" signal through the tunnel
        groupDefaults?.set(true, forKey: "shouldStopSession")

        // 2. Kill the Live Activity immediately
        for activity in Activity<FocusAttributes>.activities {
            await activity.end(dismissalPolicy: .immediate)
        }

        return .result()
    }
}

// The "BREAK" button (Toggle)
struct ToggleBreakIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Toggle Break"

    // FocusIntent.swift inside ToggleBreakIntent

    // FocusIntent.swift inside ToggleBreakIntent

    func perform() async throws -> some IntentResult {
        let groupDefaults = UserDefaults(suiteName: AppConfig.appGroupID)

        // 1. Get current state and saved time
        let currentMode =
            groupDefaults?.string(forKey: "currentMode") ?? "focus"
        let nextMode = (currentMode == "focus") ? "breakTime" : "focus"
        let savedElapsed =
            groupDefaults?.double(forKey: "savedElapsedTime") ?? 0

        groupDefaults?.set(nextMode, forKey: "currentMode")

        // 2. Update Live Activity UI
        for activity in Activity<FocusAttributes>.activities {
            let adjustedDate: Date
            if nextMode == "focus" {
                // Use the saved time so it doesn't restart at 00:00
                adjustedDate = Date().addingTimeInterval(-savedElapsed)
            } else {
                adjustedDate = Date()  // Breaks start fresh at 15:00
            }

            let newState = FocusAttributes.ContentState(
                mode: nextMode == "focus" ? .focus : .breakTime,
                startTime: adjustedDate
            )
            await activity.update(.init(state: newState, staleDate: nil))
        }

        return .result()
    }
}
