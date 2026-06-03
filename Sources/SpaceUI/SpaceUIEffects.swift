import SwiftUI

// SpaceUIEffects.swift
// Contains custom space effects/modifiers

public extension View {
    func spaceGlow(active: Bool = true) -> some View {
        self.shadow(
            color: .cyan.opacity(active ? 1 : 0.3),
            radius: active ? 10 : 8
        )
    }
}



struct SpacePulseModifier: ViewModifier {
    @State private var isPulsing = false

    let duration: Double
    let minOpacity: Double
    let maxOpacity: Double
    
    public init(duration: Double = 1.1, minOpacity: Double = 0.3, maxOpacity: Double = 1.0) {
        self.duration = duration
        self.minOpacity = minOpacity
        self.maxOpacity = maxOpacity
    }

    func body(content: Content) -> some View {
        content
            .opacity(isPulsing ? maxOpacity : minOpacity)
            .animation(
                .easeInOut(duration: duration)
                    .repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear {
                isPulsing = true
            }
    }
}
public extension View {
    func spacePulse(duration: Double = 1.1, minOpacity: Double = 0.3, maxOpacity: Double = 1.0) -> some View {
        modifier(SpacePulseModifier(duration: duration, minOpacity: minOpacity, maxOpacity: maxOpacity))
    }
}



public extension View {
    @ViewBuilder
    func spaceHoverEffect() -> some View {
        #if os(iOS)
        self.hoverEffect(.lift)
        #elseif os(macOS)
        self.modifier(SpaceHoverLiftModifier())
        #else
        self
        #endif
    }
}
#if os(macOS)
private struct SpaceHoverLiftModifier: ViewModifier {
    @State private var isHovered = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .shadow(color: .cyan.opacity(isHovered ? 0.3 : 0), radius: isHovered ? 8 : 0, y: isHovered ? 4 : 0)
            .animation(.easeOut(duration: 0.15), value: isHovered)
            .onHover { isHovered = $0 }
    }
}
#endif



public extension Image {
    static var spaceBackground: Image {
        Image("SpaceBackground", bundle: .module)
    }

    static var spaceStars: Image {
        Image("SpaceStars", bundle: .module)
    }

    static var spaceFog: Image {
        Image("SpaceFog", bundle: .module)
    }
}

public struct SpaceBackground: View {
    public init() {}
    public var body: some View {
        Image("SpaceBackground", bundle: .module)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity)
            .clipped()
            .ignoresSafeArea()
    }
}
public struct SpaceAnimatedBackground: View {
    public var starOpacity: Double
    public var fogOpacity: Double
    public var starSpeed: CGFloat
    public var fogSpeed: CGFloat

    public init(
        starOpacity: Double = 0.3,
        fogOpacity: Double = 0.2,
        starSpeed: CGFloat = 15,
        fogSpeed: CGFloat = 50
    ) {
        self.starOpacity = starOpacity
        self.fogOpacity = fogOpacity
        self.starSpeed = starSpeed
        self.fogSpeed = fogSpeed
    }

    public var body: some View {
        GeometryReader { geo in
            TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
                let t = CGFloat(timeline.date.timeIntervalSinceReferenceDate)

                ZStack {
                    SpaceBackground()
                    scrollingLayer(
                        Image.spaceStars,
                        in: geo.size,
                        offset: t * starSpeed,
                        opacity: starOpacity
                    )
                    scrollingLayer(
                        Image.spaceFog,
                        in: geo.size,
                        offset: t * fogSpeed,
                        opacity: fogOpacity
                    )
                }
            }
        }
        .ignoresSafeArea()
    }

    @ViewBuilder
    private func scrollingLayer(
        _ image: Image,
        in size: CGSize,
        offset: CGFloat,
        opacity: Double
    ) -> some View {
        let height = max(size.height, 1)
        let scroll = offset.truncatingRemainder(dividingBy: height)

        ZStack {
            image
                .resizable()
                .interpolation(.none)
                .scaledToFill()
                .frame(width: size.width, height: height)
                .clipped()
                .offset(y: scroll)
            image
                .resizable()
                .interpolation(.none)
                .scaledToFill()
                .frame(width: size.width, height: height)
                .clipped()
                .offset(y: scroll - height)
        }
        .opacity(opacity)
        .allowsHitTesting(false)
    }
}

public extension View {
    @ViewBuilder
    func spaceBackground(animated: Bool = false) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                if animated {
                    SpaceAnimatedBackground()
                } else {
                    SpaceBackground()
                }
            }
    }
}
