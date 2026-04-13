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
    @State private var hasShieldSelection = ShieldActivitySelectionStore.hasSavedSelection()

    var body: some Scene {
        WindowGroup {
            // Gate the main app until Screen Time access is approved.
            Group {
                if requestAuthorizer.isAuthorized && hasShieldSelection {
                    ContentView()
                        .environment(appViewModel)
                        .environmentObject(focusViewModel)
                } else if requestAuthorizer.isAuthorized {
                    ShieldSelectionView {
                        hasShieldSelection = ShieldActivitySelectionStore.hasSavedSelection()
                    }
                } else {
                    IntroView {
                        requestAuthorizer.requestAuthorization()
                    }
                }
            }
            .onAppear {
                requestAuthorizer.refreshAuthorizationStatus()
                hasShieldSelection = ShieldActivitySelectionStore.hasSavedSelection()
            }
        }
    }
}
