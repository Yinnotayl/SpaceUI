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
        }
        .spaceUIStyle(.primary)
        .spaceStyleTokens(SpaceUIStyleTokens())

        XCTAssertNotNil(view)
    }

    @MainActor
    func testListRowsSplitViewAndDisplayTypographyConstruct() {
        let view = VStack {
            SpaceLargeDisplay("HYPER")
            SpaceDisplay("HOST")
            SpaceDisplay2("Raider MKII")
            SpacePulseText("Tap anywhere to begin")

            SpaceSection("Servers") {
                SpaceListRow(title: "Yijue's iPad", status: "JOIN") {}
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
