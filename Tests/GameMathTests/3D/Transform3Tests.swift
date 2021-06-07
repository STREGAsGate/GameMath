import XCTest
@testable import GameMath

final class Transform3Tests: XCTestCase {
    func testInit() {
        let p = Position3<Float>(1, 2, 3)
        let r = Quaternion<Float>(w: 1, x: 0, y: 0, z: 0)
        let s = Size3<Float>(1, 2, 3)
        let t = Transform3<Float>(position: p, rotation: r, scale: s)
        
        XCTAssertEqual(t.position, p)
        XCTAssertEqual(t.rotation, r)
        XCTAssertEqual(t.scale, s)
    }
}
