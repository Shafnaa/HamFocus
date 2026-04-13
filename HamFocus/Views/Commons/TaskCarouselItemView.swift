//
//  TaskCarouselItemView.swift
//  HamFocus
//
//  Created by Saujana Shafi on 07/04/26.
//

import Foundation
import SwiftUI

struct TaskCarouselItemView: View {
    @State private var isDetailPresented = false

    let task: Task

    var body: some View {
        TaskDetailSheet(
            task: task,
            isPresented: $isDetailPresented,
        ) {
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
            .onTapGesture {
                isDetailPresented = true
            }
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
    ).environment(AppViewModel())
}
