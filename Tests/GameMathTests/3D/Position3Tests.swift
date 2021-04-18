import XCTest
@testable import GameMath

final class Position3Tests: XCTestCase {
    func testInit() {
        let position = Position3<Float>(x: 1, y: 2, z: 3)
        XCTAssertEqual(position.x, 1)
        XCTAssertEqual(position.y, 2)
        XCTAssertEqual(position.z, 3)
    }

    func testDistance() {
        let src = Position3<Float>(0, 1, 0)
        let dst = Position3<Float>(0, 2, 0)
        XCTAssertEqual(src.distance(from: dst), 1)
    }

    func testIsNear() {
        let src = Position3<Float>(0, 1.6, 0)
        let dst = Position3<Float>(0, 2, 0)
        XCTAssert(src.isNear(dst, threshold: 0.5))
    }

    func testMoved() {
        let src = Position3<Float>(0, 1, 0)
        let dst = Position3<Float>(0, 2, 0)
        XCTAssertEqual(src.moved(1, toward: .up), dst)
    }

    func testMove() {
        var src = Position3<Float>(0, 1, 0)
        let dst = Position3<Float>(0, 2, 0)
        src.move(1, toward: .up)
        XCTAssertEqual(src, dst)
    }

    static var allTests = [
        ("testInit", testInit),
        ("testDistance", testDistance),
        ("testIsNear", testIsNear),
        ("testMoved", testMoved),
        ("testMove", testMove),
    ]
}
