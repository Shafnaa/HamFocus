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
        
        // THE "IF" GOES HERE:
        // If we are in focus mode, we subtract elapsedTime to count UP.
        // If we are in break mode, we use Date() (now) so the 15 mins starts from the top.
        let adjustedDate: Date
        if mode == .focus {
            adjustedDate = Date().addingTimeInterval(-elapsedTime)
        } else {
            adjustedDate = Date()
        }
        
        let state = FocusAttributes.ContentState(mode: mode, startTime: adjustedDate)
        
        // Check for existing activity to update instead of restart
        if let existingActivity = Activity<FocusAttributes>.activities.first {
            Swift.Task {
                await existingActivity.update(using: state)
            }
            self.activity = existingActivity
        } else {
            do {
                activity = try Activity.request(
                    attributes: attributes,
                    content: .init(state: state, staleDate: nil)
                )
            } catch {
                print("Error: \(error)")
            }
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
