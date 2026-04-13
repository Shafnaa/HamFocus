//
//  HamFocusApp.swift
//  HamFocus
//
//  Created by Saujana Shafi on 06/04/26.
//

import SwiftUI

@main
struct HamFocusApp: App {
    @State private var appViewModel = AppViewModel()
    @State private var requestAuthorizer = RequestAuthorizer()

    var body: some Scene {
        WindowGroup {
            Group {
                if requestAuthorizer.isAuthorized {
                    ContentView()
                        .environment(appViewModel)
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
