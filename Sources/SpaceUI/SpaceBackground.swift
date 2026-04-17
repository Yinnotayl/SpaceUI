import SwiftUI

// SpaceBackground.swift
// Contains custom background View and View modifier

public struct SpaceBackground: View {
    public init() {}
    public var body: some View {
        Image("SpaceBackground", bundle: .module)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
}
extension View {
    @ViewBuilder
    public func spaceBackground(clipped: Bool = false) -> some View {
        Group {
            if clipped {
                self.background(
                    Image("SpaceBackground", bundle: .module)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
            } else {
                ZStack {
                    SpaceBackground()
                    self
                }
            }
        }
    }
}
