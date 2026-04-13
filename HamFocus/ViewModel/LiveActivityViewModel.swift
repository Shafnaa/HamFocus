//
//  LiveActivityViewModel.swift
//  HamFocus
//
//  Created by Felicia Joshlyn Purnomo on 12/04/26.
//

import ActivityKit
import Foundation

@MainActor
class LiveActivityViewModel {
    private var activity: Activity<FocusAttributes>? = nil

    // LiveActivityViewModel.swift

    // LiveActivityViewModel.swift

    func start(taskName: String, mode: FocusAttributes.SessionMode, elapsedTime: TimeInterval = 0) {
        let attributes = FocusAttributes(taskName: taskName)
        
        // THE TRICK: Subtract the elapsed time from "Now"
        // If elapsedTime is 600s (10 mins), the UI will think we started 10 mins ago.
        let adjustedDate = Date().addingTimeInterval(-elapsedTime)
        
        let state = FocusAttributes.ContentState(mode: mode, startTime: adjustedDate)
        
        do {
            stop() // End the old activity
            activity = try Activity.request(
                attributes: attributes,
                content: .init(state: state, staleDate: nil)
            )
        } catch {
            print("Error: \(error)")
        }
    }

    func stop() {
        // Capture the current activity in a local variable
        // so the background task knows exactly which one to kill
        guard let activityToEnd = activity else { return }

        Swift.Task {
            await activityToEnd.end(dismissalPolicy: .immediate)
            print("⏹️ LiveActivity: Manually stopped")
        }
        self.activity = nil
    }
}
