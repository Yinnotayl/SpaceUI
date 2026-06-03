import XCTest
import SwiftUI
@testable import SpaceUI

final class SpaceUITests: XCTestCase {
    @MainActor
    func testHelloWorldText() {
        let view = SpaceButton("hello") { print("hello world") }.spaceBackground()
        XCTAssertNotNil(view)
    }

    @MainActor
    func testInheritedAndScopedStylesConstruct() {
        let view = VStack {
            SpaceCard {
                SpaceButton("Nested") {}
            }
            .spaceCardStyle(.glass(role: .confirm, highlighted: true))

            SpaceButton("Deploy") {}
                .spaceButtonStyle(.primary(role: .confirm, highlighted: true))

            SpaceTextField(text: .constant(""), placeholder: "Callsign")
                .spaceTextFieldStyle(.glass)

            SpacePanel {
                SpaceText("Telemetry")
            }
            .spacePanelStyle(.glass)

            SpaceChip("AI", isOn: .constant(true), icon: "sparkles")
                .spaceChipStyle(.glass(role: .confirm))

            SpaceIconButton("xmark", accessibilityLabel: "Close") {}
                .spaceIconButtonStyle(.glass(role: .destructive, highlighted: true))
        }
        .spaceUIStyle(.primary)
        .spaceStyleTokens(SpaceUIStyleTokens())

        XCTAssertNotNil(view)
    }

    @MainActor
    func testListRowsSplitViewAndDisplayTypographyConstruct() {
        let view = VStack {
            SpaceLargeDisplay("HyperThrust")
            SpaceDisplay("HOST")
            SpaceDisplay2("Raider MKII")
            SpaceCaption("Tap anywhere to begin")
                .spacePulse()

            SpaceSection("Servers") {
                SpaceListRow(title: "Server 1", status: "JOIN") {}
                    .spaceListRowStyle(.glass(role: .confirm))
                SpaceListRow(title: "Server 2", status: "CONNECTING", selected: true, disabled: true)
                    .spaceListRowStyle(.glass)
            }

            SpaceSplitView(focusedSide: .constant(.left), dimming: false) {
                Text("Left").spaceDisplay()
            } rightContent: {
                Text("Right").spaceDisplay()
            }
            .frame(height: 200)
        }

        XCTAssertNotNil(view)
    }
}
