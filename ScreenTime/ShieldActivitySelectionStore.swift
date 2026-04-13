//
//  ShieldActivitySelectionStore.swift
//  HamFocus
//

import FamilyControls
import Foundation
import SwiftData

@Model
final class ShieldActivitySelectionRecord {
    @Attribute(.unique) var id: String
    var selectionData: Data
    var updatedAt: Date

    init(
        id: String = "default",
        selectionData: Data,
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.selectionData = selectionData
        self.updatedAt = updatedAt
    }
}

@MainActor
enum ShieldActivitySelectionStore {
    static let recordID = "default"

    static func savedSelection() -> FamilyActivitySelection? {
        guard
            let record = try? fetchRecord(),
            let selection = try? JSONDecoder().decode(
                FamilyActivitySelection.self,
                from: record.selectionData
            )
        else {
            return nil
        }

        return selection
    }

    static func hasSavedSelection() -> Bool {
        guard let selection = savedSelection() else { return false }
        return !selection.isEmpty
    }

    static func save(_ selection: FamilyActivitySelection) throws {
        guard let context = DataBase.shared.persistenceStack.context else {
            throw DataLayerError.invalidModelType
        }

        let data = try JSONEncoder().encode(selection)

        if let record = try fetchRecord() {
            record.selectionData = data
            record.updatedAt = Date()
        } else {
            context.insert(ShieldActivitySelectionRecord(selectionData: data))
        }

        try context.save()
    }

    private static func fetchRecord() throws -> ShieldActivitySelectionRecord? {
        guard let context = DataBase.shared.persistenceStack.context else {
            throw DataLayerError.invalidModelType
        }

        let descriptor = FetchDescriptor<ShieldActivitySelectionRecord>(
            predicate: #Predicate { record in
                record.id == recordID
            }
        )

        return try context.fetch(descriptor).first
    }
}

extension FamilyActivitySelection {
    var isEmpty: Bool {
        applicationTokens.isEmpty && categoryTokens.isEmpty && webDomainTokens.isEmpty
    }
}
