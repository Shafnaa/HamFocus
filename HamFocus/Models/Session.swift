//
//  Session.swift
//  HamFocus
//
//  Created by Saujana Shafi on 05/04/26.
//

import Foundation
import SwiftData

enum TimestampType: Codable {
    case focus
    case rest
}

/// Timestamp Struct
///
/// - Parameters:
///   - type: `TimestampType`
///   - startedAt: `Date`
///   - endedAt: `Date`
struct Timestamp: Codable {
    var type: TimestampType

    var startedAt: Date
    var endedAt: Date?
}

/// Session Model
///
/// - Parameters:
///   - timestamps: `[Timestamp]`
///   - task: `Task`
@Model
final class Session: ActiveRecord {
    var id: UUID

    var timestamps: [Timestamp]

    @Relationship()
    var task: Task

    init(
        timestamps: [Timestamp] = [],
        task: Task,
    ) {
        self.id = UUID()

        self.timestamps = timestamps

        self.task = task
    }
}

extension Session: Equatable {
    var focusDuration: TimeInterval {
        var duration: TimeInterval = 0

        for timestamp in timestamps where timestamp.type == .focus {
            duration += timestamp.endedAt?.timeIntervalSince(timestamp.startedAt) ?? 0
        }

        return duration
    }

    var restDuration: TimeInterval {
        var duration: TimeInterval = 0

        for timestamp in timestamps where timestamp.type == .rest {
            duration += timestamp.endedAt?.timeIntervalSince(timestamp.startedAt) ?? 0
        }

        return duration
    }
}
