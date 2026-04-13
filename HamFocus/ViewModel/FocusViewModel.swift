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

@MainActor
class FocusViewModel: ObservableObject {
    ///Shared Instance for AppIntents to find
    static let shared = FocusViewModel()
    //MARK: variable
    ///to trigger the focus mode
    @Published var isFocusModeActive: Bool = false
    ///the current task to pass for the focus mode
    @Published var currentTask: Task?
    ///log the current session
    var currentSession: Timestamp?
    ///time passed
    @Published var elapsedTime: TimeInterval = 0
    ///accumulated time to save for after breaks
    private var accumulatedTime: TimeInterval = 0
    ///current default state when entering focusstate
    @Published var currentState: FocusState = .working
    ///15 minutes breaktime
    @Published var breakTimeRemaining: TimeInterval = 15 * 60
    ///timer
    private var timer: Timer?
    ///starttime
    private var startTime: Date?

    @Published var isDone: Bool = false
    @Published var totalTime: TimeInterval = 0
    ///Live Activity Manager
    private let liveActivityManager = LiveActivityViewModel()

    init() {
        // Start listening for signals from the Widget
        observeWidgetSignals()
    }

    ///get signal from the widget
    private func observeWidgetSignals() {
        // Listen for when UserDefaults changes (the signal from the Intent)
        NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            let groupDefaults = UserDefaults(
                suiteName: "group.com.felicia.HamFocus"
            )
            let signalMode = groupDefaults?.string(forKey: "currentMode")

            // Sync your app state with the widget's click
            if signalMode == "breakTime" && self.currentState == .working {
                self.startBreakMode()
            } else if signalMode == "focus" && self.currentState == .breaking {
                self.stopBreakMode()
            }
        }
    }

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
        //start live activity
        liveActivityManager.start(
            taskName: task.title ?? "Focus Task",
            mode: .focus
        )
    }

    /// stop the focus mode and return to home screen
    /// stop the focus mode and return to home screen
    func stopFocusMode(done: Bool, onDelete: (() -> Void)? = nil) {
        timer?.invalidate()
        //stop live activity
        liveActivityManager.stop()

        let now = Date()

        // 1. Calculate the final precise time for this CURRENT session
        let sessionDuration =
            (currentState == .working)
            ? (now.timeIntervalSince(startTime ?? now) + accumulatedTime)
            : accumulatedTime

        // 2. Keep your past logic: Finalize the currentSession object for the log
        if var session = currentSession {
            session.endedAt = now

            print("--- SESSION SUMMARY ---")
            print("Task: \(currentTask?.title ?? "Unknown")")
            print("Started: \(session.startedAt)")
            print("Ended: \(now)")
            print("Current Session Duration: \(Int(sessionDuration)) seconds")
            print("-----------------------")
        }

        // 3. Add the new logic: Accumulate total time if the task is finished
        if done {
            // This adds this session's time to your persistent totalTime variable
            self.totalTime += sessionDuration
            self.isDone = true

            print("Total Cumulative Focus Time: \(Int(totalTime)) seconds")

            // Trigger the external deletion/completion logic
            onDelete?()
        }

        // 4. Cleanup
        resetViewModel()
        isFocusModeActive = false
    }

    //MARK: STOPWATCH
    ///to start the stopwatch
    private func startStopwatch() {
        timer?.invalidate()
        startTime = Date()  // Fresh start point for this "segment"

        // FocusViewModel.swift inside startStopwatch()

        // FocusViewModel.swift inside startStopwatch()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, let start = self.startTime else { return }
            self.elapsedTime = Date().timeIntervalSince(start) + self.accumulatedTime
            
            // --- SAVE TO TUNNEL ---
            let shared = UserDefaults(suiteName: "group.com.felicia.HamFocus")
            shared?.set(self.elapsedTime, forKey: "savedElapsedTime")
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

        //restart the timer
        liveActivityManager.start(
            taskName: currentTask?.title ?? "Break",
            mode: .breakTime
        )

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

        //switch live activity back to focus
        liveActivityManager.start(
                taskName: currentTask?.title ?? "Focus",
                mode: .focus,
                elapsedTime: self.elapsedTime // Pass the time we just saved!
            )
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
