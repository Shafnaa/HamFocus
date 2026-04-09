//
//  TabTaskListView.swift
//  HamFocus
//
//  Created by Heidy Mudita Sutedjo on 08/04/26.
//

import Foundation
import SwiftUI

struct TabTaskListView: View {
    @Environment(AppViewModel.self) var appVM: AppViewModel

    @State var showTaskAddSheet: Bool = false

    var body: some View {
        NavigationStack {
            TaskListView(
                taskList: appVM.sortTasks(),
                onDeleteAction: { task in
                    appVM.deleteTask(of: task)
                },
                onCheckAction: { task in
                    appVM.deleteTask(of: task)
                }
            )
            .navigationTitle("Task List")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing:
                    TaskAddSheet(
                        isPresented: $showTaskAddSheet,
                    ) {
                        Button(action: {
                            showTaskAddSheet.toggle()
                        }) {
                            Image(systemName: "plus")
                        }
                    }
            )
        }
    }
}

#Preview {
    TabTaskListView().environment(AppViewModel())
}
