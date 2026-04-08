//
//  TaskCarouselItemView.swift
//  HamFocus
//
//  Created by Saujana Shafi on 07/04/26.
//

import Foundation
import SwiftUI

struct TaskCarouselItemView: View {
    let task: Task

    var body: some View {
        VStack(spacing: 12) {
            Image(task.priority.iconNameCarousel)
                .resizable()
                .scaledToFit()
                .frame(width: 180)

            Text(task.title)
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    TaskCarouselItemView(
        task: Task(
            title: "Kerjain ADA",
            dueAt: Date().timeIntervalSince1970,
            duration: 60,
            importance: .medium
        )
    )
}
