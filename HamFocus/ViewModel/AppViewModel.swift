//
//  AppViewModel.swift
//  HamFocus
//
//  Created by Saujana Shafi on 05/04/26.
//

import Foundation

@MainActor
@Observable
class AppViewModel {
    var tasks: [Task] = []
    var sessions: [Session] = []

    init() {
        refresh()
    }

    func refresh() {
        refreshTask()
        refreshSession()
    }

    //    MARK: Task
    private func refreshTask() {
        do {
            self.tasks = try Array(Task.fetchAll())
        } catch {
            self.tasks = []
        }
    }

    func addTask(
        title: String,
        note: String? = nil,
        dueAt: TimeInterval,
        duration: TimeInterval,
        importance: Importance,
        isCompleted: Bool = false,
    ) {
        let newTask = Task(
            title: title,
            note: note,
            dueAt: dueAt,
            duration: duration,
            importance: importance,
            isCompleted: isCompleted,
        )

        do {
            try newTask.save()

            refreshTask()
        } catch {

        }
    }

    func deleteTask(at offsets: IndexSet) {
        offsets.forEach {
            do {
                try self.tasks[$0].delete()
            } catch {

            }
        }
    }

    //    MARK: Session
    private func refreshSession() {
        do {
            self.sessions = try Array(Session.fetchAll())
        } catch {
            self.sessions = []
        }
    }

    func addSession(
        _ timestamps: [Timestamp],
        taskId: UUID,
    ) {
        guard let task = tasks.first(where: { $0.id == taskId }) else { return }

        let newSession = Session(
            timestamps: timestamps,
            task: task,
        )

        do {
            try newSession.save()

            refreshSession()
        } catch {

        }
    }

    func deleteSession(at offsets: IndexSet) {
        offsets.forEach {
            do {
                try self.sessions[$0].delete()
            } catch {

            }
        }
    }
    
    // MARK: get top three
    //get top three tasks that are already sorted by the priority
    /// Fungsi untuk mengambil 3 task teratas berdasarkan priorityValue
    func getTopThree() -> [Task] {
        // 1. Filter: Hanya ambil task yang belum selesai
        // 2. Sort: Urutkan berdasarkan priorityValue (Urgency * Importance) dari besar ke kecil
        // 3. Prefix: Ambil 3 data pertama
        return tasks
            .filter { !$0.isCompleted }
            .sorted(by: { $0.priorityValue > $1.priorityValue })
            .prefix(3)
            .map { $0 }
    }
    
    func sortTasks() -> [Task] {
        return tasks
            .sorted(by: { $0.priorityValue > $1.priorityValue })
            .map { $0 }
    }
}
