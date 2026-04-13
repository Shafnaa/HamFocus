//
//  RequestAuthorizer.swift
//  HamFocus
//
//  Created by Saujana Shafi on 06/04/26.
//

import FamilyControls
import Observation

/// Wraps Screen Time authorization status so the app root can react to changes.
@MainActor
@Observable
class RequestAuthorizer {
    private(set) var authorizationStatus: AuthorizationStatus

    // MARK: - Status

    var isAuthorized: Bool {
        authorizationStatus == .approved
    }

    init(
        authorizationStatus: AuthorizationStatus = AuthorizationCenter.shared.authorizationStatus
    ) {
        self.authorizationStatus = authorizationStatus
    }

    // MARK: - Authorization

    /// Presents Apple's Screen Time authorization flow and refreshes local status afterward.
    func requestAuthorization() {
        Swift.Task { @MainActor in
            do {
                try await AuthorizationCenter.shared.requestAuthorization(
                    for: .individual
                )
                print("Individual authorization successful")
            } catch {
                print("Error requesting authorization: \(error)")
            }

            refreshAuthorizationStatus()
        }
    }

    /// Reads the latest authorization value from FamilyControls.
    func refreshAuthorizationStatus() {
        authorizationStatus = AuthorizationCenter.shared.authorizationStatus
    }
}
