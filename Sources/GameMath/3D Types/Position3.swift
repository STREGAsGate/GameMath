/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * http://stregasgate.com
 */

/// Represents a location in 3D space
#if GameMathUseSIMD
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

extension Position3: Equatable {}
extension Position3: Hashable {}
extension Position3: Codable {}

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
    static var zero = Self(0)
}
