import XCTest
@testable import GameMath

final class Direction3Tests: XCTestCase {
    func testInit() {
        let direction = Direction3<Float>(x: 1, y: 2, z: 3)
        XCTAssertEqual(direction.x, 1)
        XCTAssertEqual(direction.y, 2)
        XCTAssertEqual(direction.z, 3)
    }
    
    func testInitFromTo() {
        do {//Up
            let src = Position3<Float>(x: 0, y: 0, z: 0)
            let dst = Position3<Float>(x: 0, y: 1, z: 0)
            XCTAssertEqual(Direction3<Float>(from: src, to: dst), .up)
        }
        do {//Down
            let src = Position3<Float>(x: 0, y: 1, z: 0)
            let dst = Position3<Float>(x: 0, y: 0, z: 0)
            XCTAssertEqual(Direction3<Float>(from: src, to: dst), .down)
        }
        do {//Left
            let src = Position3<Float>(x: 0, y: 0, z: 0)
            let dst = Position3<Float>(x: -1, y: 0, z: 0)
            XCTAssertEqual(Direction3<Float>(from: src, to: dst), .left)
        }
        do {//Right
            let src = Position3<Float>(x: 0, y: 0, z: 0)
            let dst = Position3<Float>(x: 1, y: 0, z: 0)
            XCTAssertEqual(Direction3<Float>(from: src, to: dst), .right)
        }
        do {//Forward
            let src = Position3<Float>(x: 0, y: 0, z: 0)
            let dst = Position3<Float>(x: 0, y: 0, z: -1)
            XCTAssertEqual(Direction3<Float>(from: src, to: dst), .forward)
        }
        do {//Backward
            let src = Position3<Float>(x: 0, y: 0, z: 0)
            let dst = Position3<Float>(x: 0, y: 0, z: 1)
            XCTAssertEqual(Direction3<Float>(from: src, to: dst), .backward)
        }
    }
    
    func testAngleTo() {
        let src: Direction3<Float> = .up
        let dst: Direction3<Float> = .right
        let value = src.angle(to: dst).rawValue
        let expected = Radians<Float>(Degrees(90)).rawValue
        XCTAssertEqual(value, expected, accuracy: 0.000001)
    }
    
    func testAngleAroundX() {
        XCTAssertEqual(Direction3<Float>.right.angleAroundX, Radians(0))
        XCTAssertEqual(Direction3<Float>.up.angleAroundX, Radians(Degrees(90)))
    }
    
    func testAngleAroundY() {
        XCTAssertEqual(Direction3<Float>.up.angleAroundY, Radians(0))
        XCTAssertEqual(Direction3<Float>.right.angleAroundY, Radians(Degrees(90)))
    }
    
    func testAngleAroundZ() {
        XCTAssertEqual(Direction3<Float>.forward.angleAroundZ, Radians(0))
        XCTAssertEqual(Direction3<Float>.up.angleAroundZ, Radians(Degrees(90)))
    }
    
    func testRotated() {
        let src: Direction3<Float> = .up
        let qat = Quaternion<Float>(Degrees(90), axis: .right)
        XCTAssertEqual(src.rotated(by: qat), Direction3(0, 0, 1))
    }
    
    func testOrthogonal() {
        XCTAssertEqual(Direction3<Float>(x: 1, y: 2, z: 3).orthogonal(), Direction3(0, 3, -2))
        XCTAssertEqual(Direction3<Float>(x: 2, y: 1, z: 3).orthogonal(), Direction3(-3, 0, 2))
        XCTAssertEqual(Direction3<Float>(x: -2, y: -1, z: 1).orthogonal(), Direction3(1, -2, 0))
        XCTAssertEqual(Direction3<Float>(x: -1, y: -2, z: 1).orthogonal(), Direction3(2, -1, 0))
    }
    
    func testReflectedOff() {
        let src: Direction3<Float> = .up
        let dst: Direction3<Float> = .down
        XCTAssertEqual(src.reflected(off: dst), .down)
    }
    
    func testUpDownLeftRightForwardBackward() {
        XCTAssertEqual(Direction3<Float>(x: 0, y: 1, z: 0), .up)
        XCTAssertEqual(Direction3<Float>(x: 0, y: -1, z: 0), .down)
        XCTAssertEqual(Direction3<Float>(x: -1, y: 0, z: 0), .left)
        XCTAssertEqual(Direction3<Float>(x: 1, y: 0, z: 0), .right)
        XCTAssertEqual(Direction3<Float>(x: 0, y: 0, z: -1), .forward)
        XCTAssertEqual(Direction3<Float>(x: 0, y: 0, z: 1), .backward)
    }

    static var allTests = [
        ("testInit", testInit),
        ("testInitFromTo", testInitFromTo),
        ("testAngleTo", testAngleTo),
        ("testAngleAroundX", testAngleAroundX),
        ("testAngleAroundY", testAngleAroundY),
        ("testAngleAroundZ", testAngleAroundZ),
        ("testRotated", testRotated),
        ("testOrthogonal", testOrthogonal),
        ("testReflectedOff", testReflectedOff),
        ("testUpDownLeftRightForwardBackward", testUpDownLeftRightForwardBackward),
    ]
}
