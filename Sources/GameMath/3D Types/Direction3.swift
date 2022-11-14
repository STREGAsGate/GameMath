/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * http://stregasgate.com
 */

import Foundation

public struct Direction3: Vector3 {
    public var x: Float
    public var y: Float
    public var z: Float
    
    public init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
}

public extension Direction3 {
    @inline(__always)
    init(_ x: Float, _ y: Float, _ z: Float) {
        self.init(x: x, y: y, z: z)
    }
}

extension Direction3: Equatable {}
extension Direction3: Hashable {}
extension Direction3: Codable {}

public extension Direction3  {
    init(from position1: Position3, to position2: Position3) {
        self = Self(position2 - position1).normalized
    }
}

public extension Direction3  {
    @inline(__always)
    func angle(to rhs: Self) -> Radians {
        let v0 = self.normalized
        let v1 = rhs.normalized
        
        let dot = v0.dot(v1)
        return Radians(acos(dot / (v0.magnitude * v1.magnitude)))
    }
    @inline(__always)
    var angleAroundX: Radians {
        guard isFinite else {return Radians(0)}
        return Radians(atan2(y, z))
    }
    @inline(__always)
    var angleAroundY: Radians {
        guard isFinite else {return Radians(0)}
        return Radians(atan2(x, z))
    }
    @inline(__always)
    var angleAroundZ: Radians {
        guard isFinite else {return Radians(0)}
        return Radians(atan2(y, x))
    }
}

public extension Direction3 {
    @inline(__always)
    func rotated(by rotation: Quaternion) -> Self {
        let conjugate = rotation.normalized.conjugate
        let w = rotation * self * conjugate
        return w.direction
    }
    
    @inline(__always)
    func orthogonal() -> Self {
        let x = abs(self.x)
        let y = abs(self.y)
        let z = abs(self.z)
        
        let other: Direction3 = x < y ? (x < z ? .right : .forward) : (y < z ? .up : .forward)
        return self.cross(other)
    }
    
    @inline(__always)
    func reflected(off normal: Self) -> Self {
        let normal = normal.normalized
        let dn = -2 * self.dot(normal)
        return (normal * dn) + self
    }
    
    /// true if the difference in angles is less than 180°
    @inline(__always)
    func isFrontFacing(toward direction: Direction3) -> Bool {
        return (self.dot(direction) <= 0) == false
    }
}

public extension Direction3 {
    static let up = Self(x: 0, y: 1, z: 0)
    static let down = Self(x: 0, y: -1, z: 0)
    static var left = Self(x: -1, y: 0, z: 0)
    static var right = Self(x: 1, y: 0, z: 0)
    static var forward = Self(x: 0, y: 0, z: -1)
    static var backward = Self(x: 0, y: 0, z: 1)
}

public extension Direction3 {
    static let zero = Self(0)
}
