//
//  AnimatedIntroContainer.swift
//  HamFocus
//
//  Created by Saujana Shafi on 08/04/26.
//

import SwiftUI

struct AnimatedIntroContainer: View {
    @State private var viewModel = IntroViewModel()
    let onRequestAuthorization: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            PermissionsIntroScreen(viewModel: viewModel)

            ActionButton(
                title: viewModel.buttonTitle,
                iconName: "shield.lefthalf.filled"
            ) {
                viewModel.requestAuthorization(
                    using: onRequestAuthorization
                )
            }
            .padding(.horizontal, 44)
            .padding(.bottom, 28)
        }
        .padding(.top, 10)
        .background(Color(.systemBackground))
    }
}

#Preview {
    AnimatedIntroContainer(
        onRequestAuthorization: {
            print("Request authorization")
        }
    )
}
