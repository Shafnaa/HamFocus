//
//  RequestAuthorizer.swift
//  HamFocus
//
//  Created by Saujana Shafi on 06/04/26.
//

import Combine
import DeviceActivity
import FamilyControls
import ManagedSettings
import SwiftUI

class RequestAuthorizer: ObservableObject {
    @Published var isAuthorized = false

    func requestAuthorization() {
        Swift.Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(
                    for: .individual
                )
                print("Individual authorization successful")

                self.isAuthorized = true
            } catch {
                print("Error requesting authorization: \(error)")
                self.isAuthorized = false
            }
        }
    }

    func getAuthorizationStatus() -> AuthorizationStatus {
        return AuthorizationCenter.shared.authorizationStatus
    }
}
