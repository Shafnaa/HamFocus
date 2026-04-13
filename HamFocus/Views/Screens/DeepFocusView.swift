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

    var body: some View {
        NavigationStack {
            VStack {
                DeepFocusLabel(session: focusVM.currentState)

                Spacer()

                //MARK: focus mode
                if focusVM.isFocusModeActive {
                    if focusVM.currentState == .working {
                        BreakAnimationState.session(
                            priority: focusVM.currentTask?.priority ?? .forget,
                            timerText: formatToMinuteSecond(
                                of: focusVM.elapsedTime
                            )
                        )
                        ActionButton(title: "BREAK", longPressEnabled: true) {
                            focusVM.startBreakMode()
                        }
                    } else if focusVM.currentState == .breaking {
                        BreakAnimationState.break(
                            priority: focusVM.currentTask?.priority ?? .forget,
                            timerText: formatToMinuteSecond(
                                of: focusVM.breakTimeRemaining
                            )
                        )
                        ActionButton(title: "BACK TO WORK") {
                            focusVM.stopBreakMode()
                        }
                    }
                } else {
                    //MARK: session done
                }

                Spacer()
            }
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
                    }
                }

                // Right side: Check button (confirm/done)
                ToolbarItem(placement: .navigationBarTrailing) {
                    DeepFocusFinishAlert(
                        isPresented: $isShowingDoneAlert,
                        timeInterval: focusVM.elapsedTime,
                        action: {
                            guard let currentTask = focusVM.currentTask else {
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
                    }
                }
            }
        }
    }
}
#Preview {
    DeepFocusView()
        .environmentObject(FocusViewModel())
        .environment(AppViewModel())
}
