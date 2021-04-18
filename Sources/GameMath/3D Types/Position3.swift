/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

/// Represents a location in 3D space
public struct Position3<T: Numeric>: Vector3 {
    public var x: T
    public var y: T
    public var z: T
    public init(x: T, y: T, z: T) {
        self.x = x
        self.y = y
        self.z = z
    }
    public init(_ x: T, _ y: T, _ z: T) {
        self.init(x: x, y: y, z: z)
    }
}

extension Position3: Equatable where T: Equatable {}
extension Position3: Hashable where T: Hashable {}
extension Position3: Codable where T: Codable {}

public extension Position3 where T: FloatingPoint {
    /** The distance between `from` and `self`
    - parameter from: A value representing the source positon.
     */
    func distance(from: Self) -> T {
        let difference = self - from
        let distance = difference.dot(difference)
        return distance.squareRoot()
    }

    /** Returns true when the distance from `self` and  `rhs` is less then `threshhold`
    - parameter rhs: A value representing the destination positon.
    - parameter threshold: The maximum distance that is considered "near".
     */
    func isNear(_ rhs: Self, threshold: T) -> Bool {
        return self.distance(from: rhs) < threshold
    }
}

public extension Position3 where T: BinaryFloatingPoint {
    /** Creates a position a specified distance from self in a particular direction
    - parameter distance: The units away from `self` to create the new position.
    - parameter direction: The angle away from self to create the new position.
     */
    func moved(_ distance: T, toward direction: Direction3<T>) -> Self {
        return self + (direction.normalized * distance)
    }

    /** Moves `self` by a specified distance from in a particular direction
    - parameter distance: The units away to move.
    - parameter direction: The angle to move.
     */
    mutating func move(_ distance: T, toward direction: Direction3<T>) {
        self = moved(distance, toward: direction)
    }
}
