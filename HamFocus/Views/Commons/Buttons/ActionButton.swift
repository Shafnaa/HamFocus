//
//  ActionButton.swift
//  HamFocus
//
//  Created by Saujana Shafi on 03/04/26.
//

import Combine
import SwiftUI

/// ActionButton
///
/// - Parameters:
///   - title: `String?`
///   - note: `String?`
///   - iconName: `String?`
///   - iconColor: `Color?`
///   - foregroundColor: `Color?`
///   - backgroundColor: `Color?`
///   - isLoading: `Bool?`
///   - isDisabled: `Bool?`
///   - longPressEnabled: `Bool?`
///   - longPressDuration: `Bool?`
///   - action: `() -> void`
struct ActionButton: View {
    let title: String?
    let note: String?

    let iconName: String?
    let iconColor: Color?

    let foregroundColor: Color?
    let backgroundColor: Color?

    let isLoading: Bool
    let isDisabled: Bool

    let longPressEnabled: Bool
    let longPressDuration: Double

    let action: () -> Void

    init(
        title: String? = nil,
        note: String? = nil,
        iconName: String? = nil,
        iconColor: Color? = nil,
        foregroundColor: Color? = nil,
        backgroundColor: Color? = nil,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        longPressEnabled: Bool = false,
        longPressDuration: Double = 0.5,
        action: @escaping () -> Void,
    ) {
        self.title = title
        self.note = note

        self.iconName = iconName
        self.iconColor = iconColor

        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor

        self.isLoading = isLoading
        self.isDisabled = isDisabled

        self.longPressEnabled = longPressEnabled
        self.longPressDuration = longPressDuration

        self.action = action
    }

    var body: some View {
        if longPressEnabled {
            longPressButton
        } else {
            standardButton
        }
    }

    private var standardButton: some View {
        Button(action: action) {
            buttonContent
        }
        .buttonStyle(PressableButtonStyle())
        .frame(minWidth: 0, maxWidth: .infinity)
        .disabled(isLoading || isDisabled)
    }

    @State private var timer = Timer.publish(
        every: 0.01,
        on: .current,
        in: .common
    ).autoconnect()

    @State private var isPressed = false
    @State private var pressProgress: CGFloat = 0

    private var longPressButton: some View {
        VStack {
            ZStack(alignment: .leading) {
                ZStack {
                    Capsule()
                        .fill(.ultraThinMaterial)

                    // Make it grows from center
                    GeometryReader { geo in
                        let rawWidth = geo.size.width * pressProgress
                        let safeWidth =
                            rawWidth.isFinite
                            ? max(0, min(rawWidth, geo.size.width)) : 0
                        Capsule()
                            .fill(foregroundColor ?? .accentColor)
                            .frame(width: safeWidth)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 6, alignment: .center)
                .padding(.horizontal, 12)
                .opacity(pressProgress > 0 ? 1 : 0)
                .animation(.spring(response: 0.3), value: pressProgress)

                if let note = note {
                    HStack {
                        Text(note)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .opacity(isPressed ? 0 : 1)
                    .animation(.spring(response: 0.3), value: isPressed)
                }
            }

            buttonContent
                .contentShape(Rectangle())
                .frame(minWidth: 0, maxWidth: .infinity)
                .scaleEffect(isPressed ? 0.96 : 1.0)
                .animation(.spring(response: 0.3), value: isPressed)
                .onLongPressGesture(
                    minimumDuration: longPressDuration,
                    perform: {
                        action()
                        isPressed = false
                        pressProgress = 0
                    },
                    onPressingChanged: { pressing in
                        if !isLoading && !isDisabled {
                            isPressed = pressing
                        }
                    }
                )
        }
        .onReceive(timer) { _ in
            if isPressed {
                pressProgress += CGFloat(0.01 / max(0.001, longPressDuration))
                if !pressProgress.isFinite { pressProgress = 0 }
                pressProgress = min(max(pressProgress, 0), 1)
            } else {
                if pressProgress > 0 {
                    pressProgress -= 0.05
                    if !pressProgress.isFinite { pressProgress = 0 }
                    pressProgress = max(pressProgress, 0)
                } else {
                    pressProgress = 0
                }
            }
        }
    }

    private var buttonContent: some View {
        HStack(spacing: 6) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(
                        CircularProgressViewStyle(
                            tint: foregroundColor ?? .accentColor
                        )
                    )
                    .scaleEffect(0.8)
            } else {
                if let iconName = iconName {
                    Image(systemName: iconName)
                        .font(.system(size: 20, weight: .medium))
                }
                if let title = title {
                    Text(title)
                        .font(.system(size: 20, weight: .semibold))
                }
            }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity
        )
        .padding(.vertical, 12)
        .padding(.horizontal, nil)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.thinMaterial)
                .background(
                    (backgroundColor ?? Color.primary).opacity(0.8),
                )
                .cornerRadius(16)
        )
        .foregroundColor(foregroundColor ?? .secondary)
    }
}

private struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}

#Preview("Action Button Examples") {
    VStack(spacing: 20) {
        // Basic button
        ActionButton(title: "Save") {
            print("Save tapped")
        }

        // Button Press with icon & title
        ActionButton(
            title: "Start",
            iconName: "play.fill",
            foregroundColor: .red,
            backgroundColor: .blue,
            //            isLoading: true,
        ) {
            print("Started press")
        }

        // Button Long Press with icon
        ActionButton(
            note: "Hold for 1 seconds",
            iconName: "play.fill",
            foregroundColor: .black,
            backgroundColor: .gray,
            //            isLoading: true,
            longPressEnabled: true,
            longPressDuration: 0.8,
        ) {
            print("Started hold")
        }

        // Loading state
        ActionButton(
            title: "Saving...",
            isLoading: true,
        ) {
            print("This won't execute while loading")
        }

        // Custom background with icon
        ActionButton(
            title: "Delete",
            iconName: "trash",
            backgroundColor: .red,
        ) {
            print("Delete tapped")
        }

        // Success button with icon
        ActionButton(
            title: "Complete",
            iconName: "checkmark.circle",
            backgroundColor: .green,
        ) {
            print("Complete tapped")
        }

        // Custom icon color example
        ActionButton(
            title: "Favorite",
            iconName: "heart.fill",
            iconColor: .red,
            backgroundColor: .gray,
        ) {
            print("Favorite tapped")
        }

        // Loading with custom color
        ActionButton(
            title: "Processing...",
            backgroundColor: .orange,
            isLoading: true
        ) {
            print("Processing")
        }

        // Warning button
        ActionButton(
            title: "Backup",
            iconName: "cloud.fill",
            backgroundColor: .yellow,
        ) {
            print("Backup tapped")
        }

        // Icon only style (short title)
        ActionButton(
            title: "Share",
            iconName: "square.and.arrow.up",
            backgroundColor: .blue,
        ) {
            print("Share tapped")
        }

        // Disabled state
        ActionButton(
            title: "Disabled",
            iconName: "lock.fill",
            backgroundColor: .gray,
            isDisabled: true
        ) {
            print("Should not tap")
        }
    }
    .padding(24)
}
