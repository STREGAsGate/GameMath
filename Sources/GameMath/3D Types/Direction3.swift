/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

public struct Direction3<T: FloatingPoint>: Vector3 {
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

extension Direction3: Equatable where T: Equatable {}
extension Direction3: Hashable where T: Hashable {}
extension Direction3: Codable where T: Codable {}

public extension Direction3 where T: BinaryFloatingPoint {
    init(from position1: Position3<T>, to position2: Position3<T>) {
        self = Self(position2 - position1).normalized
    }
}

public extension Direction3 where T: BinaryFloatingPoint {
    func angle(to rhs: Self) -> Radians<T> {
        let v0 = self.normalized
        let v1 = rhs.normalized
        
        let dot = v0.dot(v1)
        return Radians(acos(dot / (v0.magnitude * v1.magnitude)))
    }
    var angleAroundX: Radians<T> {
        return Radians(atan2(y, z))
    }
    var angleAroundY: Radians<T> {
        return Radians(atan2(x, z))
    }
    var angleAroundZ: Radians<T> {
        return Radians(atan2(y, x))
    }
}

public extension Direction3 {
    func rotated(by rotation: Quaternion<T>) -> Self {
        let conjugate = rotation.normalized.conjugate
        let w = rotation * self * conjugate
        return w.direction
    }
    
    func orthogonal() -> Self {
        let x = abs(self.x)
        let y = abs(self.y)
        let z = abs(self.z)
        
        let other: Direction3<T> = x < y ? (x < z ? .right : .forward) : (y < z ? .up : .forward)
        return self.cross(other)
    }
    
    func reflected(off normal: Self) -> Self {
        let normal = normal.normalized
        let dn = -2 * self.dot(normal)
        return (normal * dn) + self
    }
}

public extension Direction3 {
    static var up: Self {
        return Self(x: 0, y: 1, z: 0)
    }
    static var down: Self {
        return Self(x: 0, y: -1, z: 0)
    }
    static var left: Self {
        return Self(x: -1, y: 0, z: 0)
    }
    static var right: Self {
        return Self(x: 1, y: 0, z: 0)
    }
    static var forward: Self {
        return Self(x: 0, y: 0, z: -1)
    }
    static var backward: Self {
        return Self(x: 0, y: 0, z: 1)
    }
}
