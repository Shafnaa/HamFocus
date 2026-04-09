//
//  TaskListItemView.swift
//  HamFocus
//
//  Created by Saujana Shafi on 07/04/26.
//

import SwiftUI

// Komponen untuk menampilkan satu task di dalam list
struct TaskListItemView: View {
    @State private var isDetailPresented = false

    // Data task yang ditampilkan
    var task: Task

    var onDeleteAction: (_ task: Task) -> Void
    var onCheckAction: (_ task: Task) -> Void

    // Format tanggal sesuai referensi: DD/MM/YY
    private var formattedDeadline: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: Date(timeIntervalSince1970: task.dueAt))
    }

    var body: some View {
        TaskDetailSheet(
            task: task,
            isPresented: $isDetailPresented,
        ) {
            HStack(spacing: 12) {
                // Image task dari asset (kiri)
                Image(task.priority.iconName)
                    .resizable()
                    .frame(width: 36, height: 36)

                // Nama task dan tanggal deadline (tengah)
                VStack(alignment: .leading, spacing: 2) {
                    Text(task.title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(formattedDeadline)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                // Tombol checkbox (kanan)
                Button(action: {
                    onCheckAction(task)
                }) {
                    Image(systemName: "circle")
                        .font(.title2)
                        .foregroundStyle(Color.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .onTapGesture {
                isDetailPresented = true
            }
            .swipeActions(
                edge: .trailing,
                allowsFullSwipe: false,
            ) {
                Button(role: .destructive) {
                    onDeleteAction(task)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }

}

// Preview untuk development
#Preview {
    let task = Task(
        title: "Wireframing for Apple",
        dueAt: Date().timeIntervalSince1970,
        duration: 25,
        importance: .high
    )

    List {
        TaskListItemView(
            task: task,
            onDeleteAction: { task in },
            onCheckAction: { task in },
        ).environment(AppViewModel())
    }
}
