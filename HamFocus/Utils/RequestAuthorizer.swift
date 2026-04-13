//
//  RequestAuthorizer.swift
//  HamFocus
//
//  Created by Saujana Shafi on 06/04/26.
//

import FamilyControls
import Observation

@MainActor
@Observable
class RequestAuthorizer {
    private(set) var authorizationStatus: AuthorizationStatus

    var isAuthorized: Bool {
        authorizationStatus == .approved
    }

    init(
        authorizationStatus: AuthorizationStatus = AuthorizationCenter.shared.authorizationStatus
    ) {
        self.authorizationStatus = authorizationStatus
    }

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

    func refreshAuthorizationStatus() {
        authorizationStatus = AuthorizationCenter.shared.authorizationStatus
    }
}
