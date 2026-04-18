import XCTest
@testable import SpaceUI

final class SpaceUITests: XCTestCase {
    func testHelloWorldText() {
        let view = SpaceButton("hello") { print("hello world") }.spaceBackground()
        XCTAssertNotNil(view)
    }
}
