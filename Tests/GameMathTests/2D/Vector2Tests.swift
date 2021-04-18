import XCTest
@testable import GameMath

extension Vector2Tests.Imposter: Codable where T: Codable {}

final class Vector2Tests: XCTestCase {
    struct Imposter<T: Numeric>: Vector2, Equatable {
        var x: T
        var y: T
        init(_ x: T, _ y: T) {
            self.x = x
            self.y = y
        }
    }
    
    struct Other<T: Numeric>: Vector2, Equatable {
        var x: T
        var y: T
        init(_ x: T, _ y: T) {
            self.x = x
            self.y = y
        }
    }

    func testInit() {
        do {//Repeating
            let vec = Imposter<Float>(repeating: 1)
            XCTAssertEqual(vec.x, 1)
            XCTAssertEqual(vec.y, 1)
        }
        do {//Float
            let vec = Imposter<Float>()
            XCTAssertEqual(vec.x, 0)
            XCTAssertEqual(vec.y, 0)
        }
        do {//Int
            let vec = Imposter<Int>()
            XCTAssertEqual(vec.x, 0)
            XCTAssertEqual(vec.y, 0)
        }
    }
    
    func testCastIntToInt() {
        let vec1 = Imposter<Int>(1, 2)
        let vec2 = Imposter<Int>(vec1)
        XCTAssertEqual(vec2.x, 1)
        XCTAssertEqual(vec2.y, 2)
    }
    
    func testCastIntToFloat() {
        let vec1 = Imposter<Int>(1, 2)
        let vec2 = Imposter<Float>(vec1)
        XCTAssertEqual(vec2.x, 1)
        XCTAssertEqual(vec2.y, 2)
    }
    
    func testCastFloatToFloat() {
        let vec1 = Imposter<Float>(1.1, 2.2)
        let vec2 = Imposter<Float>(vec1)
        XCTAssertEqual(vec2.x, 1.1)
        XCTAssertEqual(vec2.y, 2.2)
    }
    
    func testCastFloatToInt() {
        let vec1 = Imposter<Float>(1.1, 2.2)
        let vec2 = Imposter<Int>(vec1)
        XCTAssertEqual(vec2.x, 1)
        XCTAssertEqual(vec2.y, 2)
    }
    
    func testSquaredLength() {
        let vec = Imposter<Float>(1, 2)
        XCTAssertEqual(vec.squaredLength, 5)
    }
    
    func testDot() {
        let vec1 = Imposter<Float>(1, 2)
        let vec2 = Imposter<Float>(3, 4)
        XCTAssertEqual(vec1.dot(vec2), 11)
    }
    
    func testMagnitude() {
        let vec = Imposter<Float>(1, 2)
        XCTAssertEqual(vec.magnitude, 2.236068, accuracy: 0.000001)
    }

    func testLength() {
        var vec = Imposter<Float>(1, 2)
        XCTAssertEqual(vec.length, 3)
        
        vec.length = 4
        XCTAssertEqual(vec, Imposter(2, 2))
    }
    
    func testNormalized() {
        let vec = Imposter<Float>(2, 2).normalized
        XCTAssertEqual(vec.x, 0.70710677, accuracy: 0.000001)
        XCTAssertEqual(vec.y, 0.70710677, accuracy: 0.000001)
    }
    
    func testNormalize() {
        var vec = Imposter<Float>(2, 2)
        vec.normalize()
        XCTAssertEqual(vec.x, 0.70710677, accuracy: 0.000001)
        XCTAssertEqual(vec.y, 0.70710677, accuracy: 0.000001)
    }
    
    func testIsFinite() {
        XCTAssert(Imposter<Float>().isFinite)
        XCTAssertFalse(Imposter<Float>(.nan, 0).isFinite)
        XCTAssertFalse(Imposter<Float>(0, .infinity).isFinite)
    }
    
    func testZero() {
        XCTAssertEqual(Imposter<Float>(0, 0), .zero)
    }
    
    func testSubscript() {
        var vec: Imposter<Float> = .zero
        vec[0] = 1
        XCTAssertEqual(vec[0], 1)
        vec[1] = 2
        XCTAssertEqual(vec[1], 2)
    }
    
    func testCross() {
        let vec1 = Imposter<Float>(1, 2)
        let vec2 = Imposter<Float>(3, 4)
        XCTAssertEqual(vec1.cross(vec2), -2)
    }
    
    func testSquareRoot() {
        let vec = Imposter<Float>(16, 64)
        XCTAssertEqual(vec.squareRoot(), Imposter(4, 8))
    }
    
    func testInterpolatedToLinear() {
        let start = Imposter<Float>(-1, -1)
        let end = Imposter<Float>(1, 1)
        // Start value
        XCTAssertEqual(start.interpolated(to: end, .linear(0.0)), start)
        // Halfway
        XCTAssertEqual(start.interpolated(to: end, .linear(0.5)), .zero)
        // End value
        XCTAssertEqual(start.interpolated(to: end, .linear(1.0)), end)
    }
    
    func testInterpolateToLinear() {
        let start = Imposter<Float>(-1, -1)
        let end = Imposter<Float>(1, 1)
        // Start value
        var val = start
        val.interpolate(to: end, .linear(0.0))
        XCTAssertEqual(val, start)
        // Halfway
        val = start
        val.interpolate(to: end, .linear(0.5))
        XCTAssertEqual(val, .zero)
        // End value
        val = start
        val.interpolate(to: end, .linear(1.0))
        XCTAssertEqual(val, end)
    }
    
    func testMinMax() {
        let vec = Imposter<Float>(-1, 1)
        XCTAssertEqual(vec.min, vec.x)
        XCTAssertEqual(vec.max, vec.y)
    }
    
    func testSIMD() {
        let vec = Imposter<Float>(1, 2)
        XCTAssertEqual(vec.simd, SIMD2(1, 2))
    }
    
    func testCeil() {
        let vec = ceil(Imposter<Float>(0.4, 0.6))
        XCTAssertEqual(vec, Imposter<Float>(1, 1))
    }
    
    func testFloor() {
        let vec = floor(Imposter<Float>(0.4, 0.6))
        XCTAssertEqual(vec, Imposter<Float>(0, 0))
    }
    
    func testRound() {
        let vec = round(Imposter<Float>(0.4, 0.6))
        XCTAssertEqual(vec, Imposter<Float>(0, 1))
    }
    
    func testAbs() {
        let vec = abs(Imposter<Float>(-0.4, 0.6))
        XCTAssertEqual(vec, Imposter<Float>(0.4, 0.6))
    }
    
    func testSelfMulSelf() {
        var vec1 = Imposter<Float>(1, 2)
        let vec2 = Imposter<Float>(3, 4)
        XCTAssertEqual(vec1 * vec2, Imposter(3, 8))
        vec1 *= vec2
        XCTAssertEqual(vec1, Imposter(3, 8))
    }
    
    func testSelfAddSelf() {
        var vec1 = Imposter<Float>(1, 2)
        let vec2 = Imposter<Float>(3, 4)
        XCTAssertEqual(vec1 + vec2, Imposter(4, 6))
        vec1 += vec2
        XCTAssertEqual(vec1, Imposter(4, 6))
    }
    
    func testSelfMinusSelf() {
        var vec1 = Imposter<Float>(1, 2)
        let vec2 = Imposter<Float>(3, 4)
        XCTAssertEqual(vec1 - vec2, Imposter(-2, -2))
        vec1 -= vec2
        XCTAssertEqual(vec1, Imposter(-2, -2))
    }
    
    func testSelfDivSelf() {
        do {
            var vec1 = Imposter<Int>(12, 4)
            let vec2 = Imposter<Int>(3, 2)
            XCTAssertEqual(vec1 / vec2, Imposter(4, 2))
            vec1 /= vec2
            XCTAssertEqual(vec1, Imposter(4, 2))
        }
        do {
            var vec1 = Imposter<Float>(12, 4)
            let vec2 = Imposter<Float>(3, 2)
            XCTAssertEqual(vec1 / vec2, Imposter(4, 2))
            vec1 /= vec2
            XCTAssertEqual(vec1, Imposter(4, 2))
        }
    }
    
    func testSelfMulT() {
        var vec1 = Imposter<Float>(1, 2)
        let t: Float = 2
        XCTAssertEqual(vec1 * t, Imposter(2, 4))
        vec1 *= t
        XCTAssertEqual(vec1, Imposter(2, 4))
    }
    
    func testSelfAddT() {
        var vec1 = Imposter<Float>(1, 2)
        let t: Float = 2
        XCTAssertEqual(vec1 + t, Imposter(3, 4))
        vec1 += t
        XCTAssertEqual(vec1, Imposter(3, 4))
    }
    
    func testSelfMinusT() {
        var vec1 = Imposter<Float>(1, 2)
        let t: Float = 2
        XCTAssertEqual(vec1 - t, Imposter(-1, 0))
        vec1 -= t
        XCTAssertEqual(vec1, Imposter(-1, 0))
    }
    
    func testTMinusSelf() {
        let t: Float = 2
        var vec = Imposter<Float>(1, 2)
        XCTAssertEqual(t - vec, Imposter(1, 0))
        t -= vec
        XCTAssertEqual(vec, Imposter(1, 0))
    }
    
    func testSelfDivT() {
        do {
            var vec1 = Imposter<Int>(12, 4)
            let t: Int = 2
            XCTAssertEqual(vec1 / t, Imposter(6, 2))
            vec1 /= t
            XCTAssertEqual(vec1, Imposter(6, 2))
        }
        do {
            var vec1 = Imposter<Float>(12, 4)
            let t: Float = 2
            XCTAssertEqual(vec1 / t, Imposter(6, 2))
            vec1 /= t
            XCTAssertEqual(vec1, Imposter(6, 2))
        }
    }
    
    func testTDivSelf() {
        do {
            var vec1 = Imposter<Int>(3, 2)
            let t: Int = 12
            XCTAssertEqual(t / vec1, Imposter(4, 6))
            t /= vec1
            XCTAssertEqual(vec1, Imposter(4, 6))
        }
        do {
            var vec1 = Imposter<Float>(3, 2)
            let t: Float = 12
            XCTAssertEqual(t / vec1, Imposter(4, 6))
            t /= vec1
            XCTAssertEqual(vec1, Imposter(4, 6))
        }
    }
    
    func testSelfMulV() {
        var vec1 = Imposter<Float>(1, 2)
        let vec2 = Other<Float>(3, 4)
        XCTAssertEqual(vec1 * vec2, Imposter(3, 8))
        vec1 *= vec2
        XCTAssertEqual(vec1, Imposter(3, 8))
    }
    
    func testSelfAddV() {
        var vec1 = Imposter<Float>(1, 2)
        let vec2 = Other<Float>(3, 4)
        XCTAssertEqual(vec1 + vec2, Imposter(4, 6))
        vec1 += vec2
        XCTAssertEqual(vec1, Imposter(4, 6))
    }
    
    func testSelfMinusV() {
        var vec1 = Imposter<Float>(1, 2)
        let vec2 = Other<Float>(3, 4)
        XCTAssertEqual(vec1 - vec2, Imposter(-2, -2))
        vec1 -= vec2
        XCTAssertEqual(vec1, Imposter(-2, -2))
    }
    
    func testSelfDivV() {
        do {
            var vec1 = Imposter<Int>(12, 4)
            let vec2 = Other<Int>(3, 2)
            XCTAssertEqual(vec1 / vec2, Imposter(4, 2))
            vec1 /= vec2
            XCTAssertEqual(vec1, Imposter(4, 2))
        }
        do {
            var vec1 = Imposter<Float>(12, 4)
            let vec2 = Other<Float>(3, 2)
            XCTAssertEqual(vec1 / vec2, Imposter(4, 2))
            vec1 /= vec2
            XCTAssertEqual(vec1, Imposter(4, 2))
        }
    }
    
    func testSelfMulMatrix4x4() {
        let vec = Imposter<Float>(1, 2)
        let mtx = Matrix4x4<Float>(position: Position3(x: 2, y: 2, z: 0))
        XCTAssertEqual(vec * mtx, Imposter(3, 4))
    }
    
    func testMatrix4x4MulSelf() {
        let vec = Imposter<Float>(1, 2)
        let mtx = Matrix4x4<Float>(position: Position3(x: 2, y: 2, z: 0))
        XCTAssertEqual(mtx * vec, Imposter(1, 2))
    }
    
    func testSelfMulMatrix3x3() {
        let vec = Imposter<Float>(1, 2)
        let mtx = Matrix3x3<Float>(direction: .forward)
        XCTAssertEqual(vec * mtx, Imposter(-1, 2))
    }
    
    func testCodableJSON() {
        let vec = Imposter<Float>(-.ulpOfOne, 9999999)
        do {
            let data = try JSONEncoder().encode(vec)
            let val = try JSONDecoder().decode(Imposter<Float>.self, from: data)
            XCTAssertEqual(vec, val)
        }catch{
            XCTFail()
        }
    }
    
    func testValuesArray() {
        let vec = Imposter<Float>(1, 2)
        XCTAssertEqual(vec.valuesArray(), [1, 2])
    }
    
    static var allTests = [
        ("testInit", testInit),
        ("testCastIntToInt", testCastIntToInt),
        ("testCastIntToFloat", testCastIntToFloat),
        ("testCastFloatToFloat", testCastFloatToFloat),
        ("testCastFloatToInt", testCastFloatToInt),
        ("testSquaredLength", testSquaredLength),
        ("testDot", testDot),
        ("testMagnitude", testMagnitude),
        ("testLength", testLength),
        ("testNormalized", testNormalized),
        ("testNormalize", testNormalize),
        ("testIsFinite", testIsFinite),
        ("testZero", testZero),
        ("testSubscript", testSubscript),
        ("testCross", testCross),
        ("testSquareRoot", testSquareRoot),
        ("testInterpolatedToLinear", testInterpolatedToLinear),
        ("testInterpolateToLinear", testInterpolateToLinear),
        ("testCeil", testCeil),
        ("testFloor", testFloor),
        ("testRound", testRound),
        ("testAbs", testAbs),
        ("testSelfMulSelf", testSelfMulSelf),
        ("testSelfAddSelf", testSelfAddSelf),
        ("testSelfMinusSelf", testSelfMinusSelf),
        ("testSelfDivSelf", testSelfDivSelf),
        ("testSelfMulT", testSelfMulT),
        ("testSelfAddT", testSelfAddT),
        ("testSelfMinusT", testSelfMinusT),
        ("testTMinusSelf", testTMinusSelf),
        ("testSelfDivT", testSelfDivT),
        ("testTDivSelf", testTDivSelf),
        ("testSelfMulV", testSelfMulV),
        ("testSelfAddV", testSelfAddV),
        ("testSelfMinusV", testSelfMinusV),
        ("testSelfDivV", testSelfDivV),
        ("testSelfMulMatrix4x4", testSelfMulMatrix4x4),
        ("testMatrix4x4MulSelf", testMatrix4x4MulSelf),
        ("testSelfMulMatrix3x3", testSelfMulMatrix3x3),
        ("testCodableJSON", testCodableJSON),
        ("testValuesArray", testValuesArray),
    ]
}
