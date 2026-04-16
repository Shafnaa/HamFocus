//
//  TabHomeView.swift
//  HamFocus
//
//  Created by Heidy Mudita Sutedjo on 08/04/26.
//

import Foundation
import SwiftUI

struct TabHomeView: View {
    @EnvironmentObject var focusVM: FocusViewModel
    @Environment(AppViewModel.self) private var appVM

    @State private var taskIndex: Int = 0

    private var topThreeTasks: [Task] {
        return appVM.getTopThree()
    }

    var body: some View {
        NavigationStack {
            VStack {
                TaskCarouselView(tasks: topThreeTasks, taskIndex: $taskIndex)

                if !topThreeTasks.isEmpty {
                    ActionButton(
                        note: "Hold to start",
                        iconName: "play.fill",
                        foregroundColor: .black,
                        backgroundColor: .gray,
                        longPressEnabled: true,
                    ) {
                        let task =
                            topThreeTasks.indices.contains(taskIndex)
                            ? topThreeTasks[taskIndex] : topThreeTasks.first

                        if let task = task {
                            focusVM.startFocusMode(for: task)
                        }
                    }
                    .padding(.horizontal, 100)
                    .padding(.vertical, 10)
                }
            }
            .navigationTitle(Text("Space"))
            .navigationBarTitleDisplayMode(.inline)
            // Fix: Use $focusVM directly and remove the parameter
            .fullScreenCover(isPresented: $focusVM.isFocusModeActive) {
                DeepFocusView()
            }
        }
    }
}

#Preview {
    TabHomeView()
        .environment(AppViewModel())
        .environmentObject(FocusViewModel.shared)  // <--- Add this
}
