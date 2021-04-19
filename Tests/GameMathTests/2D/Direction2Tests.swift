import XCTest
@testable import GameMath

final class Direction2Tests: XCTestCase {
    func testInit() {
        let direction = Direction2<Float>(x: 1, y: 2)
        XCTAssertEqual(direction.x, 1)
        XCTAssertEqual(direction.y, 2)
    }
    
    func testInitFromTo() {
        do {//Up
            let src = Position2<Float>(x: 0, y: 0)
            let dst = Position2<Float>(x: 0, y: 1)
            XCTAssertEqual(Direction2<Float>(from: src, to: dst), .up)
        }
        do {//Down
            let src = Position2<Float>(x: 0, y: 1)
            let dst = Position2<Float>(x: 0, y: 0)
            XCTAssertEqual(Direction2<Float>(from: src, to: dst), .down)
        }
        do {//Left
            let src = Position2<Float>(x: 0, y: 0)
            let dst = Position2<Float>(x: -1, y: 0)
            XCTAssertEqual(Direction2<Float>(from: src, to: dst), .left)
        }
        do {//Right
            let src = Position2<Float>(x: 0, y: 0)
            let dst = Position2<Float>(x: 1, y: 0)
            XCTAssertEqual(Direction2<Float>(from: src, to: dst), .right)
        }
    }
    
    func testAngleTo() {
        let src: Direction2<Float> = .up
        let dst: Direction2<Float> = .right
        let value = src.angle(to: dst).rawValue
        let expected = Radians<Float>(Degrees(90)).rawValue
        XCTAssertEqual(value, expected, accuracy: 0.000001)
    }
    
    func testAngleAroundZ() {
        let direction: Direction2<Float> = .right
        XCTAssertEqual(direction.angleAroundZ, Radians(Degrees(90)))
    }
    
    func testZero() {
        let direction = Direction2<Float>(0, 0)
        XCTAssertEqual(direction, .zero)
    }
    
    func testUp() {
        let direction = Direction2<Float>(0, 1)
        XCTAssertEqual(direction, .up)
    }
    
    func testDown() {
        let direction = Direction2<Float>(0, -1)
        XCTAssertEqual(direction, .down)
    }
    
    func testLeft() {
        let direction = Direction2<Float>(-1, 0)
        XCTAssertEqual(direction, .left)
    }
    
    func testRight() {
        let direction = Direction2<Float>(1, 0)
        XCTAssertEqual(direction, .right)
    }
    
    static var allTests = [
        ("testInit", testInit),
        ("testInitFromTo", testInitFromTo),
        ("testAngleTo", testAngleTo),
        ("testZero", testZero),
        ("testUp", testUp),
        ("testDown", testDown),
        ("testLeft", testLeft),
        ("testRight", testRight),
    ]
}
