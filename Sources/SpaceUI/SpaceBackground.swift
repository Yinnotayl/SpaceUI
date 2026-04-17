import SwiftUI

// SpaceBackground.swift
// Contains custom background View struct and View modifier

public struct SpaceBackground: View {
    public init() {}
    public var body: some View {
        #if canImport(UIKit)
        if let uiImage = UIImage(named: "SpaceBackground.png", in: .module, with: nil) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        }
        #elseif canImport(AppKit)
        if let nsImage = Bundle.module.image(forResource: "SpaceBackground.png") {
            Image(nsImage: nsImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        }
        #endif
    }
}

extension View {
    @ViewBuilder
    public func spaceBackground(clipped: Bool = false) -> some View {
        if clipped {
            self.background(SpaceBackground())
                .clipped()
        } else {
            ZStack {
                SpaceBackground()
                self
            }
        }
    }
}
