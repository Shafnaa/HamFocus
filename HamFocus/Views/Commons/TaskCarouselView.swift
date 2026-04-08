//
//  TaskCarouselView.swift
//  HamFocus
//
//  Created by Saujana Shafi on 08/04/26.
//

import SwiftUI

struct TaskCarouselView: View {
    // MARK: - Properties
    
    // Memanggil VM yang sudah di-inject di level App (Environment)
    @Environment(AppViewModel.self) private var vm
    
    // State untuk kontrol UI
    @State private var currentTaskIndex: Int = 0
    @State private var isShowingDetailSheet: Bool = false
    
    // Computed property untuk mempermudah akses top 3 dari VM
    private var topThreeTasks: [Task] {
        vm.getTopThree()
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 30) {
            if topThreeTasks.isEmpty {
                // State 1: Kosong (Sesuai permintaan: 1 png, tidak bisa klik/slide)
                emptyStateSection
            } else {
                // State 2: Berisi (Slideable, clickable, dots append)
                populatedStateSection
            }
        }
        .sheet(isPresented: $isShowingDetailSheet) {
            // Memastikan index aman sebelum menampilkan sheet
            if currentTaskIndex < topThreeTasks.count {
//                TaskDetailSheetView(selectedTask: topThreeTasks[currentTaskIndex])
            }
        }
        // Reset index ke 0 jika jumlah task berubah (menghindari crash)
        .onChange(of: topThreeTasks.count) {
            currentTaskIndex = 0
        }
    }
    
    // MARK: - View Components
    
    // UI untuk kondisi tidak ada task
    private var emptyStateSection: some View {
        VStack(spacing: 10) {
            Image("HamsterOnFire")
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 220)
            
            Text("No tasks for now")
                .font(.system(size: 24, weight: .medium, design: .default))
                .foregroundColor(.gray)
        }
    }
    
    // UI utama carousel
    private var populatedStateSection: some View {
        VStack(spacing: 20) {
            // 1. Slider Area (Wajib pakai .tag agar bisa sliding)
            TabView(selection: $currentTaskIndex) {
                ForEach(0..<topThreeTasks.count, id: \.self) { index in
                    // Memanggil View buatan teman
                    TaskCarouselItemView(task: topThreeTasks[index])
                        .tag(index) // Identitas slide untuk selection binding
                        .onTapGesture {
                            isShowingDetailSheet = true
                        }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 300)
        
            // 3. Dots (Efek Append/Memanjang)
            paginationDotsSection
        }
    }
    
    // Dots yang memanjang secara dinamis saat aktif
    private var paginationDotsSection: some View {
        HStack(spacing: 8) {
            ForEach(0..<topThreeTasks.count, id: \.self) { index in
                let isActive = currentTaskIndex == index
                
                Capsule()
                    .fill(isActive ? Color.black : Color.black.opacity(0.2))
                    // Efek "Append": Lebar memanjang jika aktif
                    .frame(width: isActive ? 30 : 10, height: 10)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: currentTaskIndex)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    // Mocking Environment untuk Preview
    TaskCarouselView()
        .environment(AppViewModel())
        .padding()
}
