//
//  IntroViewModel.swift
//  HamFocus
//
//  Created by OpenAI on 13/04/26.
//

import Foundation

@MainActor
@Observable
class IntroViewModel {
    let title = "One Last Step"
    let subtitle = "We need Screen Time Access to get started"
    let imageName = "HamsterOnFire"
    let buttonTitle = "Allow Screen Time Access"
    let messageLines = [
        "Let's be real. Staying focused is hard.",
        "HamFocus helps you cut distractions so you can actually get things done.",
        "To do that, we need Screen Time access. We'll only use it to block apps that break your focus, nothing else.",
        "No tracking. No weird stuff. Just better focus.",
    ]

    func requestAuthorization(using authorize: @escaping () -> Void) {
        authorize()
    }
}
