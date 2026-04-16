//
//  Task.swift
//  HamFocus
//
//  Created by Saujana Shafi on 03/04/26.
//

import Foundation
import SwiftData

enum Importance: Int, Codable, CaseIterable {
    case low = 1
    case medium = 5
    case high = 10
}

enum Priority: String, CaseIterable {
    case doNow = "do"
    case schedule = "schedule"
    case delegate = "delegate"
    case forget = "forget"

    var iconName: String {
        switch self {
        case .doNow: "PriorityApple"
        case .schedule: "PriorityBanana"
        case .delegate: "PriorityPear"
        default: "PriorityWood"
        }
    }

    var iconNameCarousel: String {
        switch self {
        case .doNow: "PriorityAppleGlow"
        case .schedule: "PriorityBananaGlow"
        case .delegate: "PriorityPearGlow"
        default: "PriorityWoodGlow"
        }
    }
}

/// Task Model
///
/// - Parameters:
///   - title: `String`
///   - note: `String?`
///   - dueAt: `TimeInterval`
///   - duration: `TimeInterval`
///   - importance: `Importance`
///   - isCompleted: `Bool?`
@Model
final class Task: ActiveRecord {
    var id: UUID

    var title: String
    var note: String?

    var dueAt: TimeInterval
    var duration: TimeInterval

    var importance: Importance

    var isCompleted: Bool = false

    @Relationship(deleteRule: .cascade)
    var sessions: [Session] = []

    init(
        title: String,
        note: String? = nil,
        dueAt: TimeInterval,
        duration: TimeInterval,
        importance: Importance,
        isCompleted: Bool = false
    ) {
        self.id = UUID()

        self.title = title
        self.note = note

        self.dueAt = dueAt
        self.duration = duration

        self.importance = importance

        self.isCompleted = isCompleted
    }
}

extension Task {
    //    return in minutes
    var leadTime: Int {
        return Int(
            Date
                .init(timeIntervalSince1970: self.dueAt)
                .timeIntervalSinceNow
                / 60
        )
    }

    //    Scale from 1 - 10 based on leadTime and duration
    //    I want to consider 1 day effective working time is 4 hours
    var urgency: Int {
        // 1. Setup Constants
        let secondsInHour: Double = 3600
        let maxWorkHoursHorizon: Double = 40 // 10 days of work (4hrs/day) = Urgency 1
        let effectiveRatio = 4.0 / 24.0
        
        // 2. Calculate Effective Work Seconds Left
        // If due now or in the past, workSecondsLeft is 0
        let realSecondsLeft = max(0, self.leadTime)
        let workSecondsLeft = Double(realSecondsLeft) * effectiveRatio
        let workHoursLeft = workSecondsLeft / secondsInHour
        
        // 3. Duration's impact
        // If the task takes 10 hours, and you only have 10 work hours left,
        // you are already at maximum urgency.
        let taskDurationHours = Double(self.duration) / secondsInHour
        
        // 4. Calculate Urgency based on "Headroom"
        // Headroom is how much extra time you have beyond the duration.
        let headroom = workHoursLeft - taskDurationHours
        
        if headroom <= 0 {
            return 10 // No time left or overdue
        }
        
        // 5. Scale the urgency
        // We map headroom (0 to 40 hours) to urgency (10 to 1)
        let scaledUrgency = 10 - (headroom / (maxWorkHoursHorizon / 10))
        
        return max(1, min(Int(scaledUrgency), 10))
    }

    //    Priority scale 1 - 100
    var priorityValue: Int {
        return self.urgency * self.importance.rawValue
    }

    var priority: Priority {
        switch self.priorityValue {
        case 80...: .doNow
        case 50..<80: .schedule
        case 20..<50: .delegate
        default: .forget
        }
    }
}
