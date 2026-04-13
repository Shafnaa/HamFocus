//
//  ShieldConfigurationExtension.swift
//  ShieldConfigurationExtension
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        createCustomShieldConfiguration(
            for: .app,
            title: application.localizedDisplayName ?? "App"
        )
    }

    override func configuration(
        shielding application: Application,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        createCustomShieldConfiguration(
            for: .app,
            title: application.localizedDisplayName ?? "App"
        )
    }

    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        createCustomShieldConfiguration(
            for: .website,
            title: webDomain.domain ?? "Website"
        )
    }

    override func configuration(
        shielding webDomain: WebDomain,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        createCustomShieldConfiguration(
            for: .website,
            title: webDomain.domain ?? "Website"
        )
    }

    private func createCustomShieldConfiguration(
        for type: BlockedContentType,
        title: String
    ) -> ShieldConfiguration {
        let message = funBlockMessage(for: type, title: title)

        return ShieldConfiguration(
            backgroundBlurStyle: .dark,
            backgroundColor: UIColor(red: 0.13, green: 0.42, blue: 0.38, alpha: 1.0),
            icon: UIImage(named: "HamsterIdleFix") ?? makeEmojiIcon(message.emoji, size: 96),            title: ShieldConfiguration.Label(
                text: message.title,
                color: .white
            ),
            subtitle: ShieldConfiguration.Label(
                text: message.subtitle,
                color: UIColor.white.withAlphaComponent(0.88)
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: message.buttonText,
                color: .black
            ),
            primaryButtonBackgroundColor: .white,
            secondaryButtonLabel: nil
        )
    }

    private func funBlockMessage(
        for type: BlockedContentType,
        title: String
    ) -> (emoji: String, title: String, subtitle: String, buttonText: String) {
        typealias FunMessage = (emoji: String, title: String, subtitle: String, buttonText: String)

        let contentName = type == .app ? title : "this site"
        let messages: [FunMessage] = [
            ("📵", "Not right now", "\(contentName) can wait. Come back after this focus session.", "Back"),
            ("🎯", "Stay on target", "One small step toward your task first. Then decide on \(contentName).", "Continue"),
            ("⏳", "Protect the time", "A few minutes can become an hour. Keep your momentum.", "Stay focused"),
            ("🔒", "Locked in", "This block is temporary. Your focus is protected.", "Return"),
            ("🧠", "Brain check", "Was this intentional, or just autopilot?", "Got it"),
            ("🛡️", "Shield up", "You made a plan. This is you sticking to it.", "Back")
        ]

        let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let dayKey = (components.year ?? 0) * 10_000
            + (components.month ?? 0) * 100
            + (components.day ?? 0)

        let seed = Int(stableSeed(for: title) % UInt64(Int.max)) ^ dayKey
        let index = abs(seed) % messages.count

        return messages[index]
    }

    private func stableSeed(for title: String) -> UInt64 {
        var hash: UInt64 = 14_695_981_039_346_656_037

        for scalar in title.unicodeScalars {
            hash ^= UInt64(scalar.value)
            hash &*= 1_099_511_628_211
        }

        return hash
    }

    private func makeEmojiIcon(_ emoji: String, size: CGFloat) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))

        return renderer.image { _ in
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: size * 0.78),
                .paragraphStyle: paragraph
            ]

            let rect = CGRect(x: 0, y: 0, width: size, height: size)
            let attributed = NSAttributedString(string: emoji, attributes: attributes)
            let bounds = attributed.boundingRect(
                with: rect.size,
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                context: nil
            )

            let drawRect = CGRect(
                x: rect.minX,
                y: rect.minY + (rect.height - bounds.height) / 2,
                width: rect.width,
                height: bounds.height
            )

            attributed.draw(in: drawRect)
        }
    }
}

private enum BlockedContentType {
    case app
    case website
}
