import SwiftUI

// SpaceUIEffects.swift
// Contains custom space effects

extension View {
    func spaceGlow(active: Bool = true) -> some View {
        self.shadow(
            color: .cyan.opacity(active ? 1 : 0.3),
            radius: active ? 10 : 8
        )
    }
}
