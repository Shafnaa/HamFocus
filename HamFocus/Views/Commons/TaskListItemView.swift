//
//  TaskListItemView.swift
//  HamFocus
//
//  Created by Saujana Shafi on 07/04/26.
//

import SwiftUI

// Komponen untuk menampilkan satu task di dalam list
struct TaskListItemView: View {

    // Data task yang ditampilkan
    var taskName: String
    var deadline: Date
    var isDone: Bool

    // Closure untuk toggle status selesai
    var onToggle: () -> Void

    // Format tanggal sesuai referensi: DD/MM/YY
    private var formattedDeadline: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: deadline)
    }

    var body: some View {
        HStack(spacing: 12) {

            // Image task dari asset (kiri)
            Image("")
                .resizable()
                .frame(width: 36, height: 36)

            // Nama task dan tanggal deadline (tengah)
            VStack(alignment: .leading, spacing: 2) {
                Text(taskName)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(formattedDeadline)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Tombol checkbox (kanan)
            Button(action: onToggle) {
                Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isDone ? Color.accentColor : Color.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        
        .swipeActions(
            edge: .trailing,
            allowsFullSwipe: true
        ) {
            Button(role:.destructive){
            }label: {
                Label("Delete", systemImage: "trash")
            }
            }
    }
    
}

// Preview untuk development
#Preview {
    List {
        TaskListItemView(
            taskName: "Wireframing for Apple",
            deadline: Date(),
            isDone: false,
            onToggle: {}
        )

        TaskListItemView(
            taskName: "Wireframing for Apple",
            deadline: Date(),
            isDone: true,
            onToggle: {}
        )
    }
}
