//
//  FocusAttributes.swift
//  HamFocus
//
//  Created by Felicia Joshlyn Purnomo on 12/04/26.
//

import Foundation
import ActivityKit

struct FocusAttributes: ActivityAttributes {
    ///the content state for mode and when the session started
    public struct ContentState: Codable, Hashable {
        var mode: SessionMode // Focus or Break
        var startTime: Date   // When the session started
    }

    ///the modes for the session for live activity
    enum SessionMode: String, Codable {
        case focus, breakTime
    }
    
    ///task name to display on live activity
    var taskName: String
}
