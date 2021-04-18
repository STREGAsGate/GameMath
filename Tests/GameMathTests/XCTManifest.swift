import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        // 3D
        testCase(Direction3Tests.allTests),
        testCase(Matrix3x3Tests.allTests),
        testCase(Matrix4x4Tests.allTests),
        testCase(Position3Tests.allTests),
        testCase(QuaternionTests.allTests),
        testCase(Size3Tests.allTests),
        testCase(Transform3Tests.allTests),
        testCase(Vector3Tests.allTests),

        // 2D
        testCase(CircleTests.allTests),
        testCase(Direction2Tests.allTests),
        testCase(InsetsTests.allTests),
        testCase(Position2Tests.allTests),
        testCase(RectTests.allTests),
        testCase(Size2Tests.allTests),
        testCase(Vector2Tests.allTests),

        testCase(RadiansTests.allTests),
        testCase(DegreesTests.allTests),
        testCase(InterpolationTests.allTests),
    ]
}
#endif
