/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * http://stregasgate.com
 */

/// Represents a location in 3D space
#if GameMathUseSIMD
public struct Position3: Vector3, SIMD {
    public typealias Scalar = Float
    public typealias MaskStorage = SIMD3<Float>.MaskStorage
    public typealias ArrayLiteralElement = Scalar
    
    @usableFromInline
    var _storage = Float.SIMD4Storage()

    public init(arrayLiteral elements: Self.ArrayLiteralElement...) {
        for index in elements.indices {
            _storage[index] = elements[index]
        }
    }
    
    public var x: Scalar {
        @inline(__always) get {
            return _storage[0]
        }
        @inline(__always) set {
            _storage[0] = newValue
        }
    }
    public var y: Scalar {
        @inline(__always) get {
            return _storage[1]
        }
        @inline(__always) set {
            _storage[1] = newValue
        }
    }
    public var z: Scalar {
        @inline(__always) get {
            return _storage[2]
        }
        @inline(__always) set {
            _storage[2] = newValue
        }
    }
    
    public init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
}
#else
public struct Position3: Vector3 {
    public var x: Float
    public var y: Float
    public var z: Float
    
    public init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
}
#endif

public extension Position3 {
    @inline(__always)
    init(_ x: Float, _ y: Float, _ z: Float) {
        self.init(x: x, y: y, z: z)
    }
}

public extension Position3 {
    /** The distance between `from` and `self`
    - parameter from: A value representing the source positon.
     */
    @inline(__always)
    func distance(from: Self) -> Float {
        let difference = self - from
        let distance = difference.dot(difference)
        return distance.squareRoot()
    }

    /** Returns true when the distance from `self` and  `rhs` is less then `threshhold`
    - parameter rhs: A value representing the destination positon.
    - parameter threshold: The maximum distance that is considered "near".
     */
    @inline(__always)
    func isNear(_ rhs: Self, threshold: Float) -> Bool {
        return self.distance(from: rhs) < threshold
    }
}

public extension Position3 {
    /** Creates a position a specified distance from self in a particular direction
    - parameter distance: The units away from `self` to create the new position.
    - parameter direction: The angle away from self to create the new position.
     */
    @inline(__always)
    func moved(_ distance: Float, toward direction: Direction3) -> Self {
        return self + (direction.normalized * distance)
    }

    /** Moves `self` by a specified distance from in a particular direction
    - parameter distance: The units away to move.
    - parameter direction: The angle to move.
     */
    @inline(__always)
    mutating func move(_ distance: Float, toward direction: Direction3) {
        self = moved(distance, toward: direction)
    }
}

public extension Position3 {
    /** Creates a position by rotating self around an anchor point.
    - parameter origin: The anchor to rotate around.
    - parameter rotation: The direction and angle to rotate.
     */
    @inline(__always)
    func rotated(around anchor: Self = .zero, by rotation: Quaternion) -> Self {
        let d = self.distance(from: anchor)
        return anchor.moved(d, toward: rotation.forward)
    }

    /** Rotates `self` around an anchor position.
     - parameter origin: The anchor to rotate around.
     - parameter rotation: The direction and angle to rotate.
     */
    @inline(__always)
    mutating func rotate(around anchor: Self = .zero, by rotation: Quaternion) {
        self = rotated(around: anchor, by: rotation)
    }
}

#if !GameMathUseSIMD
public extension Position3 {
    static var zero = Self(0)
}
#endif

extension Position3: Hashable {}
extension Position3: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([x, y, z])
    }
}
extension Position3: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode(Array<Float>.self)
        self.init(values[0], values[1], values[2])
    }
}

