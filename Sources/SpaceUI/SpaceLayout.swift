import SwiftUI

// SpaceLayout.swift
// Contains all layout and arrangement structs and modifiers

public struct SpaceContainer<Content: View>: View {
    private let content: Content
    
    private var alignment: HorizontalAlignment
    private var spacing: CGFloat
    private var maxWidth: CGFloat?
    private var padding: CGFloat
    
    public init(
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat = 20,
        maxWidth: CGFloat? = 550,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.alignment = alignment
        self.spacing = spacing
        self.maxWidth = maxWidth
        self.padding = padding
    }
    
    public var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            content
        }
        .frame(maxWidth: .infinity)
        .frame(maxWidth: maxWidth)
        .padding(padding)
    }
}

public struct SpaceSection<Content: View>: View {
    @Environment(\.spaceInheritedStyle) private var inheritedStyle
    @Environment(\.spaceStyleTokens) private var tokens

    var text: String? = nil
    var role: SpaceUIRole?
    var content: Content

    public init(@ViewBuilder content: () -> Content = { EmptyView() }) {
        self.content = content()
        self.role = nil
    }

    public init(_ text: String, role: SpaceUIRole? = nil, @ViewBuilder content: () -> Content = { EmptyView() }) {
        self.text = text
        self.role = role
        self.content = content()
    }
    
    public var body: some View {
        let resolvedStyle = (inheritedStyle ?? .primary)
            .resolving(role: role, highlighted: nil)

        VStack(alignment: .leading, spacing: 8) {
            if let text {
                Text(text.uppercased())
                    .spaceCaption(.orbitronMedium, color: .white.opacity(0.82))
                    .tracking(3)
            }
            Divider()
                .overlay(tokens.color(for: resolvedStyle.role).opacity(0.75))
            content
        }
    }
}



public enum SpaceSplitSide: Equatable, Sendable {
    case left
    case right
}
public struct SpaceSplitView<LeftContent: View, RightContent: View>: View {
    @State private var internalFocusedSide: SpaceSplitSide
    private let externalBinding: Binding<SpaceSplitSide>?   // nil → self-managed

    private let dimming: Bool
    private let leftContent: LeftContent
    private let rightContent: RightContent

    private var focusedSide: SpaceSplitSide {
        get { externalBinding?.wrappedValue ?? internalFocusedSide }
        nonmutating set {
            if let binding = externalBinding {
                binding.wrappedValue = newValue
            } else {
                internalFocusedSide = newValue
            }
        }
    }
    public init(
        focusedSide: Binding<SpaceSplitSide>,
        dimming: Bool = true,
        @ViewBuilder leftContent: () -> LeftContent,
        @ViewBuilder rightContent: () -> RightContent
    ) {
        self._internalFocusedSide = State(initialValue: focusedSide.wrappedValue)
        self.externalBinding = focusedSide
        self.dimming = dimming
        self.leftContent = leftContent()
        self.rightContent = rightContent()
    }
    public init(
        initialSide: SpaceSplitSide = .left,
        dimming: Bool = true,
        @ViewBuilder leftContent: () -> LeftContent,
        @ViewBuilder rightContent: () -> RightContent
    ) {
        self._internalFocusedSide = State(initialValue: initialSide)
        self.externalBinding = nil
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
            
            GeometryReader { geo in
                let slant = slantAmount(for: side, height: geo.size.height)
                SpaceSlantedRect(side: side, slant: slant)
                    .fill(Color.black.opacity(0.5))
                    .contentShape(SpaceSlantedRect(side: side, slant: slant))
                    .onTapGesture { focusedSide = side }
            }
            .transition(.blurReplace)
            .opacity(dimming && focusedSide != side ? 1 : 0)
        }
        .frame(width: width(for: side, total: totalWidth))
    }

    private func width(for side: SpaceSplitSide, total: CGFloat) -> CGFloat {
        focusedSide == side ? total * 2 / 3 : total * 1 / 3
    }

    private func slantAmount(for side: SpaceSplitSide, height: CGFloat) -> CGFloat {
        let shift = height * tan(5.0 * .pi / 180.0)
        switch focusedSide {
        case .left: return shift
        case .right: return -shift
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




struct AdaptiveScrollView<Content: View>: View {
    var content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        VStack {
            ViewThatFits(in: .vertical) {
                content
                
                ScrollView(.vertical) {
                    content
                }
            }
        }
    }
}
public extension View {
    func adaptiveScrollView() -> some View {
        AdaptiveScrollView { self }
    }
}
