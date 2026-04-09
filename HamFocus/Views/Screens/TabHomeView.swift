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
    @Environment(AppViewModel.self) private var vm
    @State private var taskIndex: Int = 0

    private var topThreeTasks: [Task] {
        vm.getTopThree()
    }

    var body: some View {
        NavigationStack {
            VStack {
                TaskCarouselView(tasks: topThreeTasks, taskIndex: $taskIndex)

                if !topThreeTasks.isEmpty {
                    ActionButton(title: "Start", iconName: "play.fill") {
                        let task = topThreeTasks.indices.contains(taskIndex) ? topThreeTasks[taskIndex] : topThreeTasks.first
                        
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
    TabHomeView().environment(AppViewModel())
        .environmentObject(FocusViewModel())
}
