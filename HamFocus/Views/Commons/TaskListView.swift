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

    var onDeleteAction: (_ task: Task) -> Void
    var onCheckAction: (_ task: Task) -> Void

    var body: some View {
        if taskList.isEmpty {
            Text("Task is empty")
        } else {
            List {
                ForEach(taskList) { task in
                    TaskListItemView(
                        task: task,
                        onDeleteAction: { task in
                            onDeleteAction(task)
                        },
                        onCheckAction: { task in
                            onCheckAction(task)
                        },
                    )
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }
}

#Preview("Populated") {
    TaskListView(
        taskList: [
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
        ],
        onDeleteAction: { task in },
        onCheckAction: { task in },
    )
}

#Preview("Empty") {
    TaskListView(
        taskList: [],
        onDeleteAction: { task in },
        onCheckAction: { task in },
    )
}
