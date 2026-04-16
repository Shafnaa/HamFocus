//
//  DeepFocusView.swift
//  HamFocus
//
//  Created by Matthew Sebastian Lesmana on 09/04/26.
//

import SwiftUI

//struct DeepFocusLabel: View {
//    let title: String
//    var subtitle: String? = nil
//
//    var body: some View {
//        VStack(spacing: 4) {
//            Text(title)
//                .font(.system(size: 29, weight: .bold))
//
//            if let subtitle {
//                Text(subtitle)
//                    .font(.system(size: 13))
//                    .foregroundColor(.secondary)
//                    .multilineTextAlignment(.center)
//            }
//        }
//        .frame(maxWidth: .infinity)
//        .padding(20)
//    }
//}
//
//#Preview {
//    VStack {
//        DeepFocusLabel(
//            title: "Let's Get to Work !",
//            subtitle: "Stay on the wheel, Finish what matters!"
//        )
//        DeepFocusLabel(
//            title: "Time for a Break",
//            subtitle: "Short breaks improve focus. Take a rest."
//        )
//        Spacer()
//    }
//}
import SwiftUI


struct DeepFocusLabel: View {
    let session: FocusState

    private var title: String {
        switch session {
        case .focus:     return "Let's Get to Work!"
        case .break: return "Time for a Break"
        }
    }

    private var subtitle: String? {
        switch session {
        case .focus:     return "Stay on the wheel, finish what matters!"
        case .break: return "Short breaks improve focus.\nTake a moment to reset."
        }
    }

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 34, weight: .bold))

            if let subtitle {
                Text(subtitle)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
    }
}

#Preview {
    VStack {
        DeepFocusLabel(session: .focus)
        DeepFocusLabel(session: .break)
        Spacer()
    }
}
