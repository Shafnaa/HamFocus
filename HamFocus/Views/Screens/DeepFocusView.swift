//
//  DeepFocusView.swift
//  HamFocus
//
//  Created by Felicia Joshlyn Purnomo on 09/04/26.
//

import SwiftUI

struct DeepFocusView: View {
    @EnvironmentObject var focusVM: FocusViewModel
    @State private var isShowingDoneAlert: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                DeepFocusLabel(session: focusVM.currentState)
                Spacer()
                //MARK: focus mode
                if focusVM.isFocusModeActive {
                    if focusVM.currentState == .working {
                        BreakAnimationState.session(
                            priority: focusVM.currentTask!.priority,
                            timerText: focusVM.formattedStopwatch
                        )
                        ActionButton(title: "BREAK", longPressEnabled: true) {
                            focusVM.startBreakMode()
                        }
                    } else if focusVM.currentState == .breaking {
                        BreakAnimationState.break(
                            priority: focusVM.currentTask!.priority,
                            timerText: focusVM.formattedBreakTime
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
                    Button {
                        // End session without marking task done
                        focusVM.stopFocusMode(done: false)
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .accessibilityLabel("Close")
                }

                // Right side: Check button (confirm/done)
                ToolbarItem(placement: .navigationBarTrailing) {
                    DeepFocusAlert(
                        isPresented: $isShowingDoneAlert,
                        content: {
                            Button {
                                // Show confirmation alert before marking done
                                isShowingDoneAlert = true
                            } label: {
                                Image(systemName: "checkmark")
                            }
                            .accessibilityLabel("Done")

                        }
                    )

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
