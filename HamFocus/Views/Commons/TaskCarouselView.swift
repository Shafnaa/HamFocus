//
//  TaskCarouselView.swift
//  HamFocus
//
//  Created by Saujana Shafi on 05/04/26.
//

import SwiftUI

// MARK: - Task Priority
/// Tipe priority untuk menentukan PNG yang muncul
enum TaskPriority {
    case high, medium, low
}

// MARK: - Task Model
struct TaskItem: Identifiable {
    let id = UUID()
    let title: String
    let priority: TaskPriority
    
    // Function untuk mendapatkan nama asset berdasarkan priority (Rule 2)
    var priorityIconName: String {
        switch priority {
        case .high:   return "priority_high_png"   // Ganti dengan nama asset aslimu
        case .medium: return "priority_medium_png"
        case .low:    return "priority_low_png"
        }
    }
}

struct TaskCarouselView: View {
    // MARK: - Properties
    
    // Ganti data di sini untuk test "Empty State"
    @State private var allTasks: [TaskItem] = [
        TaskItem(title: "Deep Work", priority: .high),
        TaskItem(title: "Revision", priority: .medium),
        TaskItem(title: "Read Book", priority: .low)
    ]
    
    @State private var currentTaskIndex: Int = 0
    @State private var isShowingDetailSheet: Bool = false
    
    // Filter maksimal 3 task teratas (Rule 6)
    private var topThreeTasks: [TaskItem] {
        Array(allTasks.prefix(3))
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            if topThreeTasks.isEmpty {
                // State 1: No Tasks (Tidak bisa di-slide/klik)
                emptyStateSection
            } else {
                // State 2: Has Tasks (Bisa slide & klik)
                populatedStateSection
            }
        }
        .sheet(isPresented: $isShowingDetailSheet) {
            // Pastikan TaskDetailSheetView menerima TaskItem
//            TaskDetailSheetView(selectedTask: topThreeTasks[currentTaskIndex])
        }
    }
    
    // MARK: - View Components
    
    // UI ketika tidak ada task
    private var emptyStateSection: some View {
        VStack(spacing: 20) {
            Image("no_tasks_png") // PNG khusus untuk state kosong
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 220)
            
            Text("No tasks for now")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.gray)
        }
    }
    
    // UI Utama ketika ada task (Slider + Title + Dots)
    private var populatedStateSection: some View {
        VStack(spacing: 20) {
            // 1. Slider Area
            TabView(selection: $currentTaskIndex) {
                ForEach(0..<topThreeTasks.count, id: \.self) { index in
                    // Memanggil view buatan temanmu
                    TaskCarouselItemView(/*task: topThreeTasks[index]*/)
                        .tag(index)
                        .onTapGesture {
                            isShowingDetailSheet = true
                        }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 300)
            
            // 2. Title Section
            Text(topThreeTasks[currentTaskIndex].title)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.black)
            
            // 3. Dots Section (Append Effect)
            paginationDotsSection
        }
    }
    
    // Dots yang memanjang saat active
    private var paginationDotsSection: some View {
        HStack(spacing: 8) {
            ForEach(0..<topThreeTasks.count, id: \.self) { index in
                let isActive = currentTaskIndex == index
                Capsule()
                    .fill(isActive ? Color.black : Color.black.opacity(0.2))
                    .frame(width: isActive ? 30 : 10, height: 10)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: currentTaskIndex)
            }
        }
    }
}

// MARK: - Previews
#Preview {
    TaskCarouselView()
        .padding()
}
