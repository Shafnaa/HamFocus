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
        default: "PriorityEmpty"
        }
    }

    var iconNameCarousel: String {
        switch self {
        case .doNow: "PriorityAppleGlow"
        case .schedule: "PriorityBananaGlow"
        case .delegate: "PriorityPearGlow"
        default: "PriorityEmpty"
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
        let buffer = 2 * 60

        let leadTime = min(0, self.leadTime - buffer)
        let duration = self.duration

        let urgency = 10 - Int(Double(leadTime) / Double(duration))

        return max(1, min(urgency, 10))
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
