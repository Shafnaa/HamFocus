//
//  TaskListView.swift
//  HamFocus
//
//  Created by Saujana Shafi on 07/04/26.
//

import Foundation
import SwiftUI

struct TaskListView: View {
    var taskList: [Task]

    var body: some View {
        List {
            ForEach(taskList) { task in
                TaskListItemView(
                    task: task
                )
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

struct TaskListViewPreview: PreviewProvider {
    static var taskList: [Task] = [
        Task(
            title: "Task",
            dueAt: Date().timeIntervalSince1970,
            duration: 6000,
            importance: .high,
        ),
        Task(
            title: "Task",
            dueAt: Date().timeIntervalSince1970,
            duration: 6000,
            importance: .high,
        ),
        Task(
            title: "Task",
            dueAt: Date().timeIntervalSince1970,
            duration: 6000,
            importance: .high,
        ),
    ]

    @ViewBuilder static var previews: some View {
        TaskListView(taskList: taskList)
    }
}

#Preview {
    TaskListViewPreview.previews
}
