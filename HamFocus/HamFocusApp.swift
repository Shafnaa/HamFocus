//
//  HamFocusApp.swift
//  HamFocus
//
//  Created by Saujana Shafi on 06/04/26.
//

import SwiftUI

@main
struct HamFocusApp: App {
    // MARK: - App State

    @State private var appViewModel = AppViewModel()
    @StateObject private var focusViewModel = FocusViewModel.shared // For ObservableObject
    @State private var requestAuthorizer = RequestAuthorizer()

    var body: some Scene {
        WindowGroup {
            // Gate the main app until Screen Time access is approved.
            Group {
                if requestAuthorizer.isAuthorized {
                    ContentView()
                // 2. Inject BOTH into the environment
                      .environment(appViewModel)           // Modern bucket
                      .environmentObject(focusViewModel)    // Classic bucket
                } else {
                    IntroView {
                        requestAuthorizer.requestAuthorization()
                    }
                }
            }
            .onAppear {
                requestAuthorizer.refreshAuthorizationStatus()
            }
        }
    }
}
