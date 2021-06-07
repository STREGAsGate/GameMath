import XCTest
@testable import GameMath

final class InterpolationTests: XCTestCase {
    
    func testInterpolatedToLinear() {
        // Start value
        XCTAssertEqual(Float(-1.0).interpolated(to: 1.0, .linear(0.0)), -1.0)
        // Halfway
        XCTAssertEqual(Float(-1.0).interpolated(to: 1.0, .linear(0.5)), 0.0)
        // End value
        XCTAssertEqual(Float(-1.0).interpolated(to: 1.0, .linear(1.0)), 1.0)
    }
    
    
    func testInterpolateToLinear() {
        var value: Float = 0
        // Start value
        value = -1
        value.interpolate(to: 1.0, .linear(0.0))
        XCTAssertEqual(value, -1.0)
        // Halfway
        value = -1
        value.interpolate(to: 1.0, .linear(0.5))
        XCTAssertEqual(value, 0.0)
        // End value
        value = -1
        value.interpolate(to: 1.0, .linear(1.0))
        XCTAssertEqual(value, 1.0)
    }
    
    func testPosition3Linear() {
        let start = Position3<Float>(-1, -1, -1)
        let end = Position3<Float>(1, 1, 1)
        // Start value
        XCTAssertEqual(start.interpolated(to: end, .linear(0.0)), start)
        // Halfway
        XCTAssertEqual(start.interpolated(to: end, .linear(0.5)), .zero)
        // End value
        XCTAssertEqual(start.interpolated(to: end, .linear(1.0)), end)
    }
    
    func testSize3Linear() {
        let start = Size3<Float>(-1, -1, -1)
        let end = Size3<Float>(1, 1, 1)
        // Start value
        XCTAssertEqual(start.interpolated(to: end, .linear(0.0)), start)
        // Halfway
        XCTAssertEqual(start.interpolated(to: end, .linear(0.5)), .zero)
        // End value
        XCTAssertEqual(start.interpolated(to: end, .linear(1.0)), end)
    }
    
    func testDirection3Linear() {
        let start = Direction3<Float>(-1, -1, -1)
        let end = Direction3<Float>(1, 1, 1)
        // Start value
        XCTAssertEqual(start.interpolated(to: end, .linear(0.0)), start)
        // Halfway
        XCTAssertEqual(start.interpolated(to: end, .linear(0.5)), .zero)
        // End value
        XCTAssertEqual(start.interpolated(to: end, .linear(1.0)), end)
    }
    
    func testQuaternionLinear() {
        let start = Quaternion<Float>(Degrees(0), axis: .right)
        let end = Quaternion<Float>(Degrees(90), axis: .right)
        
        do {// Start value
            let value = start.interpolated(to: end, .linear(0.0, shortest: false))
            let expected = start
            XCTAssertEqual(value.w, expected.w, accuracy: 0.000001)
            XCTAssertEqual(value.x, expected.x, accuracy: 0.000001)
            XCTAssertEqual(value.y, expected.y, accuracy: 0.000001)
            XCTAssertEqual(value.z, expected.z, accuracy: 0.000001)
        }
        
        do {// Halfway
            let value = start.interpolated(to: end, .linear(0.5, shortest: false))
            let expected = Quaternion<Float>(Degrees(45), axis: .right)
            XCTAssertEqual(value.w, expected.w, accuracy: 0.000001)
            XCTAssertEqual(value.x, expected.x, accuracy: 0.000001)
            XCTAssertEqual(value.y, expected.y, accuracy: 0.000001)
            XCTAssertEqual(value.z, expected.z, accuracy: 0.000001)
        }
        
        do {// End value
            let value = start.interpolated(to: end, .linear(1.0, shortest: false))
            let expected = end
            XCTAssertEqual(value.w, expected.w, accuracy: 0.000001)
            XCTAssertEqual(value.x, expected.x, accuracy: 0.000001)
            XCTAssertEqual(value.y, expected.y, accuracy: 0.000001)
            XCTAssertEqual(value.z, expected.z, accuracy: 0.000001)
        }
    }
    
    func testQuaternionShortest() {
        // This test is diffcult to perform accuraualy. To help, results are unitNormaized to bring them as close to the same format as possible before comparison. Because results are modified this a poor test, but good enough for regetion chcking.
        
        let start = Quaternion<Float>(Degrees(45), axis: .right)
        let end = Quaternion<Float>(Degrees(405), axis: .right)
        
        do {// Start value
            let value = start.interpolated(to: end, .linear(0.0, shortest: true)).unitNormalized
            let expected = start.unitNormalized
            XCTAssertEqual(value.w, expected.w, accuracy: 0.000001)
            XCTAssertEqual(value.x, expected.x, accuracy: 0.000001)
            XCTAssertEqual(value.y, expected.y, accuracy: 0.000001)
            XCTAssertEqual(value.z, expected.z, accuracy: 0.000001)
        }
        
        do {// Halfway
            let value = start.interpolated(to: end, .linear(0.5, shortest: true)).unitNormalized
            let expected = Quaternion<Float>(Degrees(0), axis: .right).unitNormalized
            XCTAssertEqual(value.w, expected.w, accuracy: 0.01)
            XCTAssertEqual(value.x, expected.x, accuracy: 0.01)
            XCTAssertEqual(value.y, expected.y, accuracy: 0.01)
            XCTAssertEqual(value.z, expected.z, accuracy: 0.01)
        }
        
        do {// End value
            let value = start.interpolated(to: end, .linear(1.0, shortest: true)).unitNormalized
            let expected = end.unitNormalized
            XCTAssertEqual(value.w, expected.w, accuracy: 0.000001)
            XCTAssertEqual(value.x, expected.x, accuracy: 0.000001)
            XCTAssertEqual(value.y, expected.y, accuracy: 0.000001)
            XCTAssertEqual(value.z, expected.z, accuracy: 0.000001)
        }
    }
}
