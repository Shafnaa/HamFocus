//
//  HamFocusApp.swift
//  HamFocus
//
//  Created by Saujana Shafi on 06/04/26.
//

import SwiftUI

@main
struct HamFocusApp: App {
    @State private var appVM: AppViewModel = .init()
    @StateObject private var focusVM: FocusViewModel = .init()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appVM)
                .environmentObject(focusVM)
        }
    }
}
