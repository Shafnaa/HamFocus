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
        case session
        case `break`
        case finish
    }

    static let defaultSize = CGSize(width: 140, height: 140)

    let task: Task

    private let animationState: AnimationState

    private init(
        task: Task,
        animationState: AnimationState
    ) {
        self.task = task
        self.animationState = animationState
    }

    var body: some View {
        content
            .frame(
                width: BreakAnimationState.defaultSize.width,
                height: BreakAnimationState.defaultSize.height
            )
    }

    @ViewBuilder
    private var content: some View {
        switch animationState {
        case .session:
            GIFAssetView(asset: .runningGIF)
        case .break:
            Image(task.priority.animationAsset.rawValue)
                .resizable()
                .scaledToFit()
        case .finish:
            GIFAssetView(asset: .tiredGIF)
        }
    }

    static func session(_ task: Task) -> BreakAnimationState {
        .init(task: task, animationState: .session)
    }

    static func `break`(_ task: Task) -> BreakAnimationState {
        .init(task: task, animationState: .break)
    }

    static func finish(_ task: Task) -> BreakAnimationState {
        .init(task: task, animationState: .finish)
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
    let task = Task(
        title: "Kerjain Tugas",
        dueAt: Date().timeIntervalSince1970 + 60 * 60,
        duration: 60 * 60,
        importance: .high
    )

    VStack(spacing: 24) {
        BreakAnimationState.session(task)
        BreakAnimationState.break(task)
        BreakAnimationState.finish(task)
    }
}
