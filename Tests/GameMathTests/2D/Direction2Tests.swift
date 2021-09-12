import XCTest
@testable import GameMath

final class Direction2Tests: XCTestCase {
    func testInit() {
        let direction = Direction2(x: 1, y: 2)
        XCTAssertEqual(direction.x, 1)
        XCTAssertEqual(direction.y, 2)
    }
    
    func testInitFromTo() {
        do {//Up
            let src = Position2(x: 0, y: 0)
            let dst = Position2(x: 0, y: 1)
            XCTAssertEqual(Direction2(from: src, to: dst), .up)
        }
        do {//Down
            let src = Position2(x: 0, y: 1)
            let dst = Position2(x: 0, y: 0)
            XCTAssertEqual(Direction2(from: src, to: dst), .down)
        }
        do {//Left
            let src = Position2(x: 0, y: 0)
            let dst = Position2(x: -1, y: 0)
            XCTAssertEqual(Direction2(from: src, to: dst), .left)
        }
        do {//Right
            let src = Position2(x: 0, y: 0)
            let dst = Position2(x: 1, y: 0)
            XCTAssertEqual(Direction2(from: src, to: dst), .right)
        }
    }
    
    func testAngleTo() {
        let src: Direction2 = .up
        let dst: Direction2 = .right
        let value = src.angle(to: dst).rawValue
        let expected = Radians(Degrees(90)).rawValue
        XCTAssertEqual(value, expected, accuracy: 0.000001)
    }
    
    func testAngleAroundZ() {
        let direction: Direction2 = .right
        XCTAssertEqual(direction.angleAroundZ, Radians(Degrees(90)))
    }
    
    func testZero() {
        let direction = Direction2(0, 0)
        XCTAssertEqual(direction, .zero)
    }
    
    func testUp() {
        let direction = Direction2(0, 1)
        XCTAssertEqual(direction, .up)
    }
    
    func testDown() {
        let direction = Direction2(0, -1)
        XCTAssertEqual(direction, .down)
    }
    
    func testLeft() {
        let direction = Direction2(-1, 0)
        XCTAssertEqual(direction, .left)
    }
    
    func testRight() {
        let direction = Direction2(1, 0)
        XCTAssertEqual(direction, .right)
    }
}
