//
//  TaskCarouselView.swift
//  HamFocus
//
//  Created by Saujana Shafi on 05/04/26.
//

import SwiftUI
import SwiftData

struct TaskCarouselView: View {
    // MARK: - Properties
    
    // 1. Mengambil data langsung dari SwiftData (Rule 5: MVVM/SwiftData integration)
    // Kita sort berdasarkan priorityValue terbesar agar yang muncul di "Top 3" adalah yang paling penting
    @Query(sort: \Task.dueAt, order: .forward) private var allTasks: [Task]
    
    @State private var currentTaskIndex: Int = 0
    @State private var isShowingDetailSheet: Bool = false
    
    // 2. Logic Filter: Ambil maksimal 3 task dengan prioritas tertinggi (Rule 6)
    private var topThreeTasks: [Task] {
        // Kita urutkan manual berdasarkan priorityValue (Urgency * Importance)
        let sortedTasks = allTasks.sorted(by: { $0.priorityValue > $1.priorityValue })
        return Array(sortedTasks.prefix(3))
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            if topThreeTasks.isEmpty {
                // State 1: Kosong (No Tasks)
                emptyStateSection
            } else {
                // State 2: Ada task (Max 3)
                populatedStateSection
            }
        }
        .sheet(isPresented: $isShowingDetailSheet) {
            // Memanggil detail sheet (Pastikan file ini sudah ada)
            if currentTaskIndex < topThreeTasks.count {
//                TaskDetailSheetView(selectedTask: topThreeTasks[currentTaskIndex])
            }
        }
    }
    
    // MARK: - View Components
    
    // UI State Kosong
    private var emptyStateSection: some View {
        VStack(spacing: 20) {
            // PNG khusus untuk state kosong (Sesuai Priority.forget default)
            Image("PriorityEmpty")
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 220)
            
            Text("All caught up!")
                .font(.system(size: 24, weight: .medium, design: .default))
                .foregroundColor(.gray)
        }
    }
    
    // UI State Berisi Task
    private var populatedStateSection: some View {
        VStack(spacing: 20) {
            // 1. Slider Area
            TabView(selection: $currentTaskIndex) {
                ForEach(0..<topThreeTasks.count, id: \.self) { index in
                    // Memanggil view buatan teman (mengirim model Task asli)
                    // Image yang muncul akan otomatis mengikuti task.priority.iconName
                    TaskCarouselItemView(task: topThreeTasks[index])
                        .tag(index)
                        .onTapGesture {
                            isShowingDetailSheet = true
                        }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 300)
            
            // 2. Title Section (Menggunakan SF Pro)
            Text(topThreeTasks[currentTaskIndex].title)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.black)
            
            // 3. Dots Section (Append Effect)
            paginationDotsSection
        }
    }
    
    // Pagination dots yang memanjang secara dinamis
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

