//
//  HamFocusApp.swift
//  HamFocus
//
//  Created by Saujana Shafi on 06/04/26.
//

import SwiftUI

@main
struct HamFocusApp: App {
    // 1. Create the instances
    @State private var appViewModel = AppViewModel() // For @Observable
    @StateObject private var focusViewModel = FocusViewModel.shared // For ObservableObject
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // 2. Inject BOTH into the environment
                .environment(appViewModel)           // Modern bucket
                .environmentObject(focusViewModel)    // Classic bucket
        }
    }
}
