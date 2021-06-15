/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

#if GameMathUseSIMD
public struct Direction2<T: FloatingPoint & SIMDScalar>: Vector2 {
    public var x: T
    public var y: T
    
    public init(_ x: T, _ y: T) {
        self.x = x
        self.y = y
    }
}
#else
public struct Direction2<T: FloatingPoint>: Vector2 {
    public var x: T
    public var y: T
    
    public init(_ x: T, _ y: T) {
        self.x = x
        self.y = y
    }
}
#endif

public extension Direction2 {
    init(x: T, y: T) {
        self.init(x, y)
    }
}

public extension Direction2 where T: BinaryFloatingPoint {
    init(from position1: Position2<T>, to position2: Position2<T>) {
        let d = Direction2<T>(position2 - position1)
        self = d.normalized
    }
    
    init(_ radians: Radians<T>) {
        self.x = cos(radians.rawValue)
        self.y = sin(radians.rawValue)
    }
    
    init(_ degrees: Degrees<T>) {
        self.init(Radians(degrees))
    }
}

extension Direction2: Equatable where T: Equatable {}
extension Direction2: Hashable where T: Hashable {}
extension Direction2: Codable where T: Codable {}

public extension Direction2 where T: BinaryFloatingPoint {
    func angle(to rhs: Self) -> Radians<T> {
        let v0 = self.normalized
        let v1 = rhs.normalized
        
        let dot = v0.dot(v1)
        return Radians<T>(acos(dot))
    }
    
    var angleAroundZ: Radians<T> {
        return Radians<T>(atan2(x, -y))
    }
}

public extension Direction2 {
    func rotated(by rotation: Quaternion<T>) -> Self {
        let conjugate = rotation.normalized.conjugate
        let w = rotation * self * conjugate
        let dir3 = w.direction
        return Direction2(dir3.x, dir3.y)
    }
    
    func reflected(off normal: Self) -> Self {
        let normal: Self = normal.normalized
        let dn: T = -2 * self.dot(normal)
        return (normal * dn) + self
    }
}

public extension Direction2 {
    static var zero: Self {
        return Self(x: 0, y: 0)
    }
    
    static var up: Self {
        return Self(x: 0, y: 1)
    }
    static var down: Self {
        return Self(x: 0, y: -1)
    }
    static var left: Self {
        return Self(x: -1, y: 0)
    }
    static var right: Self {
        return Self(x: 1, y: 0)
    }
}
