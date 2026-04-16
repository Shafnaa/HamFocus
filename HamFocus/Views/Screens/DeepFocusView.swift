//
//  DeepFocusView.swift
//  HamFocus
//
//  Created by Felicia Joshlyn Purnomo on 09/04/26.
//

import SwiftUI

struct DeepFocusView: View {
    @Environment(AppViewModel.self) var appVM: AppViewModel
    @EnvironmentObject var focusVM: FocusViewModel

    @State private var isShowingDoneAlert: Bool = false
    @State private var isShowingCancelAlert: Bool = false

    @State private var isShowingControls: Bool = false
    @State private var hideControlsTask: Swift.Task<Void, Never>? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    //MARK: focus mode
                    if focusVM.isFocusModeActive {
                        if focusVM.currentState == .focus {
                            BreakAnimationState.session(
                                priority: focusVM.currentTask?.priority
                                    ?? .forget,
                                timerText: formatToMinuteSecond(
                                    of: focusVM.elapsedTime
                                )
                            )
                        } else if focusVM.currentState == .break {
                            BreakAnimationState.break(
                                priority: focusVM.currentTask?.priority
                                    ?? .forget,
                                timerText: formatToMinuteSecond(
                                    of: focusVM.breakTimeRemaining
                                )
                            )
                        }
                    } else {
                        //MARK: session done
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isShowingControls = true
                    }
                    scheduleAutoHideControls()
                }

                VStack {
                    DeepFocusLabel(
                        session: focusVM.currentState
                    )

                    Spacer()

                    //MARK: focus mode
                    if focusVM.isFocusModeActive {
                        if focusVM.currentState == .focus {
                            ActionButton(
                                note: "Hold to take a break",
                                iconName: "pause.fill",
                                foregroundColor: .black,
                                backgroundColor: .gray,
                                longPressEnabled: true,
                            ) {
                                focusVM.startBreakMode()
                            }
                        } else if focusVM.currentState == .break {
                            ActionButton(
                                note: "Hold to continue",
                                iconName: "play.fill",
                                foregroundColor: .black,
                                backgroundColor: .gray,
                                longPressEnabled: true,
                            ) {
                                focusVM.stopBreakMode()
                            }
                        }
                    } else {
                        //MARK: session done
                    }
                }
                .padding(.horizontal, 16)
                .toolbar {
                    // Left side: X button (cancel/close)
                    ToolbarItem(placement: .navigationBarLeading) {
                        DeepFocusFinishAlert(
                            isPresented: $isShowingCancelAlert,
                            timeInterval: focusVM.elapsedTime,
                            action: {
                                focusVM.stopFocusMode(done: false)
                            },
                        ) {
                            Button {
                                // End session without marking task done
                                isShowingCancelAlert = true
                            } label: {
                                Image(systemName: "xmark")
                            }
                            .accessibilityLabel("Close")
                            .opacity(isShowingControls ? 1 : 0)
                            .transition(.opacity)
                        }
                    }

                    // Right side: Check button (confirm/done)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        DeepFocusFinishAlert(
                            isPresented: $isShowingDoneAlert,
                            timeInterval: focusVM.elapsedTime,
                            action: {
                                guard let currentTask = focusVM.currentTask
                                else {
                                    return
                                }

                                focusVM.stopFocusMode(done: true) {
                                    appVM.deleteTask(of: currentTask)
                                }
                            },
                        ) {
                            Button {
                                // Show confirmation alert before marking done
                                isShowingDoneAlert = true
                            } label: {
                                Image(systemName: "checkmark")
                            }
                            .accessibilityLabel("Done")
                            .opacity(isShowingControls ? 1 : 0)
                            .transition(.opacity)
                        }
                    }
                }
                .opacity(isShowingControls ? 1 : 0)
                .transition(.opacity)
                .onChange(of: isShowingControls) { _, newValue in
                    if newValue {
                        scheduleAutoHideControls()
                    } else {
                        cancelAutoHideControls()
                    }
                }
            }
        }
    }

    private func scheduleAutoHideControls() {
        // Cancel any pending hide task
        hideControlsTask?.cancel()
        hideControlsTask = Swift.Task { @MainActor in
            try? await Swift.Task.sleep(for: .seconds(3))
            if !Swift.Task.isCancelled {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isShowingControls = false
                }
            }
        }
    }

    private func cancelAutoHideControls() {
        hideControlsTask?.cancel()
        hideControlsTask = nil
    }
}
#Preview {
    DeepFocusView()
        .environmentObject(FocusViewModel())
        .environment(AppViewModel())
}
