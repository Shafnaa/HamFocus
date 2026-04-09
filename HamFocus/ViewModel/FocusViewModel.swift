//
//  FocusViewModel.swift
//  HamFocus
//
//  Created by Felicia Joshlyn Purnomo on 09/04/26.
//

import Combine
import Foundation

enum FocusState {
    case working  // Show Stopwatch
    case breaking  // Show 15:00 Countdown
}

class FocusViewModel: ObservableObject {
    //MARK: variable
    //to trigger the focus mode
    @Published var isFocusModeActive: Bool = false
    //the current task to pass for the focus mode
    @Published var currentTask: Task?
    //log the current session
    var currentSession: Timestamp?
    //time passed
    @Published var elapsedTime: TimeInterval = 0
    //accumulated time to save for after breaks
    private var accumulatedTime: TimeInterval = 0
    //current default state when entering focusstate
    @Published var currentState: FocusState = .working
    //15 minutes breaktime
    @Published var breakTimeRemaining: TimeInterval = 15 * 60
    //timer
    private var timer: Timer?
    //starttime
    private var startTime: Date?

    //MARK: RESET VIEWMODEL
    ///to reset the viewmodel to have a clean start everytime
    private func resetViewModel() {
        accumulatedTime = 0
        elapsedTime = 0
        breakTimeRemaining = 15 * 60
        currentState = .working
        startTime = nil
    }

    //MARK: FORMATTING
    /// Formatter for the Stopwatch (HH:MM:SS)
    var formattedStopwatch: String {
        let minutes = (Int(elapsedTime) % 3600) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    /// Formatter for the Break Countdown (MM:SS)
    var formattedBreakTime: String {
        let minutes = Int(breakTimeRemaining) / 60
        let seconds = Int(breakTimeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    //MARK: FOCUS SETTINGS
    ///this is the logic after clicking the start focus mode button
    func startFocusMode(for task: Task) {
        self.currentTask = task
        self.currentState = .working
        self.isFocusModeActive = true

        // Always reset when starting a fresh session
        self.accumulatedTime = 0
        self.elapsedTime = 0
        self.breakTimeRemaining = 15 * 60

        currentSession = Timestamp(
            type: .focus,
            startedAt: Date(),
            endedAt: nil,
        )

        startStopwatch()
    }

    /// stop the focus mode and return to home screen
    func stopFocusMode(done: Bool, onDelete: (() -> Void)? = nil) {
        timer?.invalidate()

        //MARK: review later
        //ALL THESE WOULD BE FOR IF WE DECIDE TO SAVE THE SESSIONS
        if var session = currentSession {
            let now = Date()
            session.endedAt = now  // Record the actual time it ended

            // Calculate total focus time accurately
            let finalFocusTime =
                (currentState == .working)
                ? (now.timeIntervalSince(startTime ?? now) + accumulatedTime)
                : accumulatedTime

            // session.duration = finalFocusTime // Use this once your model has it!

            print("--- SESSION SUMMARY ---")
            print("Task: \(currentTask?.title ?? "Unknown")")
            print("Started: \(session.startedAt)")
            print("Ended: \(now)")
            print("Total Focus Time: \(Int(finalFocusTime)) seconds")
            print("-----------------------")
        }

        if done {
            //this would need the button to decide it later
            onDelete?()
        }

        resetViewModel()
        isFocusModeActive = false
    }

    //MARK: STOPWATCH
    ///to start the stopwatch
    private func startStopwatch() {
        timer?.invalidate()
        startTime = Date()  // Fresh start point for this "segment"

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            [weak self] _ in
            guard let self = self, let start = self.startTime else { return }
            // Current segment + whatever we did before pausing
            self.elapsedTime =
                Date().timeIntervalSince(start) + self.accumulatedTime
        }
    }

    ///to pause the stopwatch
    private func pauseStopwatch() {
        timer?.invalidate()

        accumulatedTime = elapsedTime
        startTime = nil
    }

    //MARK: BREAK
    ///start breakmode dari focus mode, 15 minutes countdown
    func startBreakMode() {
        timer?.invalidate()
        pauseStopwatch()  // Automatically stop the focus work

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            [weak self] _ in
            guard let self = self else { return }
            if self.breakTimeRemaining > 0 {
                self.breakTimeRemaining -= 1
            } else {
                self.stopBreakMode()
            }
        }
        currentState = .breaking
    }

    ///stop the break mode totally
    func stopBreakMode() {
        timer?.invalidate()
        breakTimeRemaining = 15 * 60  // Reset for the next break

        // Switch state back to working and start the clock immediately
        currentState = .working
        startStopwatch()
    }

    ///the pause break logic
    func toggleBreak() {
        if currentState == .working {
            startBreakMode()
        } else {
            stopBreakMode()  // This acts as "Resume Work"
        }
    }
}
