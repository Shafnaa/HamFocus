//
//  Utils.swift
//  HamFocus
//
//  Created by Saujana Shafi on 09/04/26.
//

import Foundation

/// Format to MM:SS
func formatToMinuteSecond(of timeInterval: TimeInterval) -> String {
    let minutes = Int(timeInterval) / 60
    let seconds = Int(timeInterval) % 60

    return String(format: "%02d:%02d", minutes, seconds)
}
