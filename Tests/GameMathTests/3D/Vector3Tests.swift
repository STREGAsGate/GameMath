import XCTest
@testable import GameMath

final class Vector3Tests: XCTestCase {
    struct Imposter: Vector3 {
        typealias T = Float
        var x: T
        var y: T
        var z: T
        init(_ x: T, _ y: T, _ z: T) {
            self.x = x
            self.y = y
            self.z = z
        }
    }

    func testInit() {
        let vec = Imposter(1, 2, 3)
        XCTAssertEqual(vec.x, 1)
        XCTAssertEqual(vec.y, 2)
        XCTAssertEqual(vec.z, 3)
    }

    static var allTests = [
        ("testInit", testInit),
    ]
}
