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



public struct SpaceAdaptiveStack<Content: View>: View {
    private let content: Content
    
    private var isVertical: Bool
    private var spacing: CGFloat
    private var alignment: HorizontalAlignment
    
    public init(
        isVertical: Bool,
        spacing: CGFloat = 12,
        alignment: HorizontalAlignment = .center,
        @ViewBuilder content: () -> Content
    ) {
        self.isVertical = isVertical
        self.spacing = spacing
        self.alignment = alignment
        self.content = content()
    }
    
    public var body: some View {
        Group {
            if isVertical {
                VStack(alignment: alignment, spacing: spacing) {
                    content
                }
            } else {
                HStack(spacing: spacing) {
                    content
                }
            }
        }
    }
}

public struct SpaceResponsiveStack<Content: View>: View {
    private let content: Content
    private var spacing: CGFloat
    
    public init(
        spacing: CGFloat = 12,
        @ViewBuilder content: () -> Content
    ) {
        self.spacing = spacing
        self.content = content()
    }
    
    public var body: some View {
        ViewThatFits {
            HStack(spacing: spacing) {
                content
            }
            
            VStack(spacing: spacing) {
                content
            }
        }
    }
}

public extension View {
    func spaceLayoutMaxWidth(_ width: CGFloat = 600) -> some View {
        self
            .frame(maxWidth: .infinity)
            .frame(maxWidth: width)
    }
    
    func spaceLayoutScrollable(
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat = 16
    ) -> some View {
        ScrollView {
            VStack(alignment: alignment, spacing: spacing) {
                self
            }
            .frame(maxWidth: .infinity, alignment: Alignment(horizontal: alignment, vertical: .center))
        }
        .scrollBounceBehavior(.basedOnSize)
    }
}
