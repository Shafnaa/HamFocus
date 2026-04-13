//
//  IntroView.swift
//  HamFocus
//
//  Created by Saujana Shafi on 08/04/26.
//

import SwiftUI

struct IntroView: View {
    let onRequestAuthorization: () -> Void

    var body: some View {
        AnimatedIntroContainer(
            onRequestAuthorization: onRequestAuthorization
        )
    }
}

#Preview {
    IntroView {
        RequestAuthorizer().requestAuthorization()
    }
}
