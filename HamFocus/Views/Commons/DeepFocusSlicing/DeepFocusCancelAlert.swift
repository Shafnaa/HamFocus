//
//  DeepFocusAlert.swift
//  HamFocus
//
//  Created by Raff Melvern Surya Gunawan on 09/04/26.
//

import SwiftUI

//Alert Button untuk ketika selesai task
struct DeepFocusCancelAlert<Content: View>: View {
    @Binding var isPresented: Bool
    var timeInterval: TimeInterval

    private var action: () -> Void

    private let content: Content

    init(
        isPresented: Binding<Bool>,
        timeInterval: TimeInterval,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content,
    ) {
        _isPresented = isPresented
        self.timeInterval = timeInterval

        self.action = action

        self.content = content()
    }

    var body: some View {
        content
            .alert(
                "Want to close your focus session?",
                isPresented: $isPresented
            ) {
                Button(
                    "Back",
                    role: .cancel,
                ) {
                    isPresented = false
                }
                Button(
                    "Close",
                    role: .confirm,
                ) {
                    action()

                    isPresented = false
                }
            } message: {
                Text(
                    "Your focus session was \(formatToMinuteSecond(of: timeInterval))"
                )
            }
    }
}

#Preview {
    DeepFocusCancelAlert(
        isPresented: .constant(true),
        timeInterval: 600,
        action: {

        },
    ) {
        Button("muncul") {

        }
    }
}
