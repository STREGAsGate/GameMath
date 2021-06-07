import XCTest
@testable import GameMath

final class CircleTests: XCTestCase {
    func testInit() {
        let circle = Circle<Float>(center: .zero, radius: 1)
        XCTAssertEqual(circle.center, .zero)
        XCTAssertEqual(circle.radius, 1)
    }
}
