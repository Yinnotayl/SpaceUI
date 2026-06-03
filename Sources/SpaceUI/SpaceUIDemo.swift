import SwiftUI

// SpaceUIDemo.swift
// A simple demo for the SpaceUI components

struct SpaceUIDemo: View {
    init() { SpaceFont.register() }
    
    var body: some View {
        VStack {
            Text("SpaceUI")
                .spaceTextStyle(.largeDisplay)
                .spaceGlow()
            Text("A scifi-themed UI package")
                .foregroundStyle(.white)
                .spaceTextStyle(.body)
                .spacePulse()
        }
        .spaceBackground(animated: true)
    }
}

#if ENABLE_SPACEUI_PREVIEWS
#Preview {
    SpaceUIDemo()
}
#endif
