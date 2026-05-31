import SwiftUI

public enum SpaceSplitSide: Equatable, Sendable {
    case left
    case right
}

public struct SpaceSplitView<LeftContent: View, RightContent: View>: View {
    @Binding private var focusedSide: SpaceSplitSide

    private let dimming: Bool
    private let leftContent: LeftContent
    private let rightContent: RightContent

    public init(
        focusedSide: Binding<SpaceSplitSide>,
        dimming: Bool = true,
        @ViewBuilder leftContent: () -> LeftContent,
        @ViewBuilder rightContent: () -> RightContent
    ) {
        self._focusedSide = focusedSide
        self.dimming = dimming
        self.leftContent = leftContent()
        self.rightContent = rightContent()
    }

    public var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                splitPane(.left, totalWidth: geo.size.width) {
                    leftContent
                }

                Divider()
                    .overlay(.white.opacity(0.85))
                    .rotationEffect(focusedSide == .left ? .degrees(5) : .degrees(-5))

                splitPane(.right, totalWidth: geo.size.width) {
                    rightContent
                }
            }
        }
        .animation(.interpolatingSpring, value: focusedSide)
    }

    @ViewBuilder
    private func splitPane<Content: View>(
        _ side: SpaceSplitSide,
        totalWidth: CGFloat,
        @ViewBuilder content: () -> Content
    ) -> some View {
        ZStack {
            content()
                .opacity(dimming ? (focusedSide == side ? 1 : 0.7) : 1)

            if dimming && focusedSide != side {
                GeometryReader { geo in
                    let slant = slantAmount(for: side, height: geo.size.height)
                    SpaceSlantedRect(side: side, slant: slant)
                        .fill(Color.black.opacity(0.5))
                        .contentShape(SpaceSlantedRect(side: side, slant: slant))
                        .onTapGesture {
                            focusedSide = side
                        }
                }
                .transition(.blurReplace)
            }
        }
        .frame(width: width(for: side, total: totalWidth))
    }

    private func width(for side: SpaceSplitSide, total: CGFloat) -> CGFloat {
        focusedSide == side ? total * 2 / 3 : total * 1 / 3
    }

    private func slantAmount(for side: SpaceSplitSide, height: CGFloat) -> CGFloat {
        let shift = height * tan(5.0 * .pi / 180.0)
        switch focusedSide {
        case .left:
            return side == .left ? 0 : shift
        case .right:
            return side == .right ? 0 : -shift
        }
    }
}

struct SpaceSlantedRect: Shape {
    let side: SpaceSplitSide
    var slant: CGFloat

    var animatableData: CGFloat {
        get { slant }
        set { slant = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let half = slant / 2

        switch side {
        case .left:
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX + half, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - half, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        case .right:
            path.move(to: CGPoint(x: rect.minX + half, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX - half, y: rect.maxY))
        }

        path.closeSubpath()
        return path
    }
}

public struct SpacePulseText: View {
    private let text: String
    private let style: SpaceTextStyle
    private let font: SpaceFont?
    private let color: Color?
    private let minOpacity: Double
    private let maxOpacity: Double
    private let duration: Double

    @State private var isPulsing = false

    public init(
        _ text: String,
        style: SpaceTextStyle = .subtitle,
        font: SpaceFont? = .orbitronMedium,
        color: Color? = .white.opacity(0.8),
        minOpacity: Double = 0.3,
        maxOpacity: Double = 1,
        duration: Double = 1.1
    ) {
        self.text = text
        self.style = style
        self.font = font
        self.color = color
        self.minOpacity = minOpacity
        self.maxOpacity = maxOpacity
        self.duration = duration
    }

    public var body: some View {
        Text(text)
            .tracking(3)
            .spaceTextStyle(style, font: font, color: color)
            .opacity(isPulsing ? maxOpacity : minOpacity)
            .animation(.easeInOut(duration: duration).repeatForever(autoreverses: true), value: isPulsing)
            .onAppear {
                isPulsing = true
            }
    }
}
