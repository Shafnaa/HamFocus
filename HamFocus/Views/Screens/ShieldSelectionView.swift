//
//  ShieldSelectionView.swift
//  HamFocus
//

import FamilyControls
import SwiftUI

struct ShieldSelectionView: View {
    let onComplete: () -> Void

    @State private var selection = ShieldActivitySelectionStore.savedSelection() ?? FamilyActivitySelection()
    @State private var isPickerPresented = false
    @State private var errorMessage: String?

    private var hasSelection: Bool {
        !selection.isEmpty
    }

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            VStack(spacing: 14) {
                Image(systemName: "shield.lefthalf.filled")
                    .font(.system(size: 64, weight: .semibold))
                    .foregroundStyle(Color.accentColor)

                Text("Choose your focus blocks")
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)

                Text("Pick the apps and websites that usually pull you away. HamFocus will only shield them during a focus session.")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }

            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    selectionCountLabel(
                        count: selection.applicationTokens.count,
                        title: "Apps",
                        iconName: "app.dashed"
                    )

                    selectionCountLabel(
                        count: selection.categoryTokens.count,
                        title: "Categories",
                        iconName: "square.grid.2x2"
                    )

                    selectionCountLabel(
                        count: selection.webDomainTokens.count,
                        title: "Sites",
                        iconName: "globe"
                    )
                }

                ActionButton(
                    title: hasSelection ? "Edit blocked apps" : "Choose blocked apps",
                    iconName: "plus.circle.fill"
                ) {
                    isPickerPresented = true
                }
            }

            if let errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            ActionButton(
                title: "Continue",
                iconName: "checkmark.circle.fill",
                isDisabled: !hasSelection
            ) {
                saveSelection()
            }
            .padding(.horizontal, 44)
            .padding(.bottom, 28)
        }
        .padding(.horizontal, 24)
        .background(Color(.systemBackground))
        .familyActivityPicker(
            title: "Choose Apps to Block",
            headerText: "Select apps, websites, or categories to shield during focus sessions.",
            footerText: "You can change this later.",
            isPresented: $isPickerPresented,
            selection: $selection
        )
    }

    private func selectionCountLabel(count: Int, title: String, iconName: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.system(size: 20, weight: .semibold))

            Text("\(count)")
                .font(.system(size: 22, weight: .bold))

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private func saveSelection() {
        do {
            try ShieldActivitySelectionStore.save(selection)
            errorMessage = nil
            onComplete()
        } catch {
            errorMessage = "Could not save your blocked apps. Try again."
            print("Unable to save shield selection: \(error)")
        }
    }
}

#Preview {
    ShieldSelectionView {
        print("Completed shield selection")
    }
}
