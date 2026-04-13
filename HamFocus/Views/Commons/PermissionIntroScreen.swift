//
//  PermissionIntroScreen.swift
//  HamFocus
//
//  Created by Saujana Shafi on 08/04/26.
//

import SwiftUI

struct PermissionsIntroScreen: View {
    @Bindable var viewModel: IntroViewModel

    @State private var showContent: Bool = false
    @State private var imageScale: CGFloat = 0.5
    @State private var pulseAnimation: Bool = false

    var body: some View {
        VStack(spacing: 28) {
            VStack(spacing: 8) {
                Text(viewModel.title)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.primary)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : -20)

                Text(viewModel.subtitle)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : -20)
            }

            Spacer()

            ZStack {
                ForEach(0..<2) { index in
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.accentColor.opacity(0.3),
                                    Color.accentColor.opacity(0.1),
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                        .frame(width: 220, height: 220)
                        .scaleEffect(pulseAnimation ? 1.3 : 1.0)
                        .opacity(pulseAnimation ? 0 : 0.6)
                        .animation(
                            .easeOut(duration: 2)
                                .repeatForever(autoreverses: false)
                                .delay(Double(index) * 0.6),
                            value: pulseAnimation
                        )
                }

                Image(viewModel.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)
                    .scaleEffect(imageScale)
                    .opacity(showContent ? 1 : 0)
            }
            .frame(height: 260)

            VStack(spacing: 14) {
                ForEach(Array(viewModel.messageLines.enumerated()), id: \.offset) { index, line in
                    Text(line)
                        .font(index == 0 ? .system(size: 20, weight: .semibold) : .system(size: 17, weight: .medium))
                        .foregroundColor(index == 0 || index == viewModel.messageLines.count - 1 ? .primary : .secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }

            }
            .padding(.horizontal, 10)
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 24)
        .onAppear {
            withAnimation(
                .spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)
                    .delay(0.2)
            ) {
                imageScale = 1.0
            }

            withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                showContent = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                pulseAnimation = true
            }
        }
    }
}

#Preview {
    PermissionsIntroScreen(viewModel: IntroViewModel())
        .background(Color(.systemBackground))
}
