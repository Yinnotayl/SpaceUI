import SwiftUI

// SpaceUIEffects.swift
// Contains custom space effects

public extension View {
    func spaceGlow(active: Bool = true) -> some View {
        self.shadow(
            color: .cyan.opacity(active ? 1 : 0.3),
            radius: active ? 10 : 8
        )
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
