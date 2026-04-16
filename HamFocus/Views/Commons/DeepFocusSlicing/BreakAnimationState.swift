//
//  BreakAnimationState.swift
//  HamFocus
//
//  Created by Heidy Mudita Sutedjo on 09/04/26.
//

import ImageIO
import SwiftUI
import UIKit

struct BreakAnimationState: View {
    private enum AnimationState {
        case focus
        case `break`
        case finish
    }

    private static let animationSize = CGSize(width: 140, height: 140)

    let priority: Priority
    let timerText: String

    private let animationState: AnimationState

    private init(
        priority: Priority,
        timerText: String,
        animationState: AnimationState
    ) {
        self.priority = priority
        self.timerText = timerText
        self.animationState = animationState
    }

    var body: some View {
        VStack(spacing: 16) {
            animationContent
                .frame(
                    width: Self.animationSize.width,
                    height: Self.animationSize.height
                )

            Text(timerText)
                .font(.system(size: 48, weight: .black, design: .rounded))
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var animationContent: some View {
        switch animationState {
        case .focus:
            GIFAssetView(asset: .runningGIF)
        case .break:
            Image(priority.animationAsset.rawValue)
                .resizable()
                .scaledToFit()
        case .finish:
            GIFAssetView(asset: .tiredGIF)
        }
    }

    static func session(
        priority: Priority,
        timerText: String
    ) -> BreakAnimationState {
        make(priority: priority, timerText: timerText, animationState: .focus)
    }

    static func `break`(
        priority: Priority,
        timerText: String
    ) -> BreakAnimationState {
        make(priority: priority, timerText: timerText, animationState: .break)
    }

    static func finish(
        priority: Priority,
        timerText: String
    ) -> BreakAnimationState {
        make(priority: priority, timerText: timerText, animationState: .finish)
    }

    private static func make(
        priority: Priority,
        timerText: String,
        animationState: AnimationState
    ) -> BreakAnimationState {
        .init(
            priority: priority,
            timerText: timerText,
            animationState: animationState
        )
    }
}

private enum AnimationAsset: String {
    case runningGIF = "HamsterRunningGIF"
    case tiredGIF = "HamsterCapekGIF"
    case eatApple = "HamsterEatApple"
    case eatBanana = "HamsterEatBanana"
    case eatPear = "HamsterEatPear"
    case sit = "HamsterSit"
}

private extension Priority {
    var animationAsset: AnimationAsset {
        switch self {
        case .doNow:
            return .eatApple
        case .schedule:
            return .eatBanana
        case .delegate:
            return .eatPear
        case .forget:
            return .sit
        }
    }
}

private struct GIFAssetView: UIViewRepresentable {
    let asset: AnimationAsset

    func makeUIView(context: Context) -> GIFContainerView {
        let imageView = GIFImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear

        let containerView = GIFContainerView()
        containerView.embed(imageView)
        return containerView
    }

    func updateUIView(_ containerView: GIFContainerView, context: Context) {
        let imageView = containerView.imageView
        guard imageView.accessibilityIdentifier != asset.rawValue else { return }

        imageView.accessibilityIdentifier = asset.rawValue
        imageView.image = GIFImageLoader.animatedImage(named: asset.rawValue)
        imageView.startAnimating()
    }
}

private final class GIFContainerView: UIView {
    private(set) var imageView = GIFImageView()

    override var intrinsicContentSize: CGSize {
        .zero
    }

    func embed(_ imageView: GIFImageView) {
        self.imageView.removeFromSuperview()
        self.imageView = imageView
        self.imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(self.imageView)

        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.imageView.topAnchor.constraint(equalTo: topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

private final class GIFImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        .zero
    }
}

private enum GIFImageLoader {
    private static var cache: [String: UIImage] = [:]

    static func animatedImage(named assetName: String) -> UIImage? {
        if let cachedImage = cache[assetName] {
            return cachedImage
        }

        guard
            let asset = NSDataAsset(name: assetName),
            let source = CGImageSourceCreateWithData(asset.data as CFData, nil)
        else {
            return nil
        }

        let frameCount = CGImageSourceGetCount(source)
        guard frameCount > 0 else { return nil }

        var images: [UIImage] = []
        var duration: TimeInterval = 0

        for index in 0..<frameCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, index, nil) else {
                continue
            }

            images.append(UIImage(cgImage: cgImage))
            duration += frameDuration(for: source, at: index)
        }

        guard !images.isEmpty else { return nil }

        let totalDuration = duration > 0 ? duration : Double(images.count) * 0.1
        let animatedImage = UIImage.animatedImage(with: images, duration: totalDuration)

        if let animatedImage {
            cache[assetName] = animatedImage
        }

        return animatedImage
    }

    private static func frameDuration(for source: CGImageSource, at index: Int) -> TimeInterval {
        guard
            let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [CFString: Any],
            let gifProperties = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any]
        else {
            return 0.1
        }

        if let unclampedDelay = gifProperties[kCGImagePropertyGIFUnclampedDelayTime] as? Double,
           unclampedDelay > 0 {
            return unclampedDelay
        }

        if let delay = gifProperties[kCGImagePropertyGIFDelayTime] as? Double,
           delay > 0 {
            return delay
        }

        return 0.1
    }
}

#Preview {
    VStack(spacing: 24) {
        BreakAnimationState.session(priority: .doNow, timerText: "37:21")
        BreakAnimationState.break(priority: .schedule, timerText: "15:00")
        BreakAnimationState.finish(priority: .delegate, timerText: "41:52")
    }
}
