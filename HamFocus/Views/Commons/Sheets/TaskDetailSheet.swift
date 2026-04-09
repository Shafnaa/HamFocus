//
//  TaskAddSheet.swift
//  HamFocus
//
//  Created by Saujana Shafi on 05/04/26.
//

import Foundation
import SwiftUI

struct TaskDetailSheet<Content: View>: View {
    @Environment(AppViewModel.self) var appVM

    @Binding var isPresented: Bool

    private let content: Content

    //  MARK: New Task

    private var task: Task

    @State private var newTaskTitle: String
    @State private var newTaskNote: String

    @State private var newTaskDueAt: Date
    /// Minutes in `TimeInterval` (1 minutes = 60)
    @State private var newTaskDuration: TimeInterval

    @State private var newTaskImportance: Importance = .low

    //  MARK: Error

    @State private var errorTaskTitle: String? = nil

    init(
        task: Task,
        isPresented: Binding<Bool>,
        @ViewBuilder content: () -> Content,
    ) {
        self.task = task

        _isPresented = isPresented

        self.content = content()

        self.newTaskTitle = task.title
        self.newTaskNote = task.note ?? ""
        self.newTaskDueAt = Date(timeIntervalSince1970: task.dueAt)
        self.newTaskDuration = task.duration
        self.newTaskImportance = task.importance
    }

    var body: some View {
        content
            .sheet(
                isPresented: $isPresented,
            ) {
                NavigationStack {
                    Form {
                        Section(header: Text("Title")) {
                            TextField(
                                "Task title",
                                text: $newTaskTitle,
                            )

                            if let error = errorTaskTitle {
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }

                        Section(header: Text("Note")) {
                            TextField(
                                "Task note",
                                text: $newTaskNote,
                            )
                        }

                        Section(header: Text("Due At")) {
                            DatePicker(selection: $newTaskDueAt) {}
                                .datePickerStyle(.wheel)
                        }

                        Section(header: Text("Duration")) {
                            Stepper(
                                value: $newTaskDuration,
                                in: ClosedRange(
                                    uncheckedBounds: (10 * 60.0, 60 * 60.0)
                                ),
                                step: 5 * 60.0
                            ) {
                                Text(
                                    "Current: \(Int(newTaskDuration / 60)) min "
                                        + "stepping by \(5) min"
                                )
                            }
                            .padding(10)
                        }

                        Section(header: Text("Importance")) {
                            Picker(
                                "Importance",
                                selection: $newTaskImportance,
                            ) {
                                Text("Low").tag(
                                    Importance.low
                                )
                                Text("Medium").tag(Importance.medium)
                                Text("High").tag(Importance.high)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    .navigationTitle("Task Detail")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: { isPresented = false }) {
                                Label("Close", systemImage: "xmark")
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                guard handleAdd() else {
                                    print(errorTaskTitle!)
                                    return
                                }

                                isPresented = false
                            }) {
                                Image(systemName: "checkmark")
                            }
                            .keyboardShortcut(.defaultAction)
                        }
                    }
                }
            }
    }

    func handleAdd() -> Bool {
        guard !newTaskTitle.isEmpty else {
            errorTaskTitle = "Title can't be empty"

            return false
        }

        appVM.editTask(
            taskId: task.id,
            title: newTaskTitle,
            note: newTaskNote.isEmpty ? nil : newTaskNote,
            dueAt: newTaskDueAt.timeIntervalSince1970,
            duration: newTaskDuration,
            importance: newTaskImportance,
            isCompleted: task.isCompleted,
        )

        print("masuk")

        return true
    }
}

#Preview {
    struct Wrapper: View {
        var appVM = AppViewModel()

        @State private var isPresented: Bool = true

        var body: some View {
            TaskDetailSheet(
                task: .init(
                    title: "Test",
                    dueAt: Date().timeIntervalSince1970,
                    duration: 60000,
                    importance: .high
                ),
                isPresented: $isPresented,
            ) {
                Button(action: {
                    isPresented.toggle()
                }) {
                    Text("Hello, World!")
                }
            }
            .environment(appVM)
        }
    }

    return Wrapper()
}
