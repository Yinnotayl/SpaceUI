import SwiftUI

// SpaceBackground.swift
// Contains custom background View struct and View modifier

public struct SpaceBackground: View {
    public init() {}
    public var body: some View {
        Image("SpaceBackground", bundle: .module)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity)
            .ignoresSafeArea()
    }
}

public extension Image {
    static var spaceBackground: Image {
        Image("SpaceBackground", bundle: .module)
    }
}

public extension View {
    @ViewBuilder
    func spaceBackground(clipped: Bool = false) -> some View {
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
