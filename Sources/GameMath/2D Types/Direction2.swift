/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

#if GameMathUseSIMD
public struct Direction2: Vector2 {
    public var x: Float
    public var y: Float
    
    public init(_ x: Float, _ y: Float) {
        self.x = x
        self.y = y
    }
}
#else
public struct Direction2: Vector2 {
    public var x: Float
    public var y: Float
    
    public init(_ x: Float, _ y: Float) {
        self.x = x
        self.y = y
    }
}
#endif

public extension Direction2 {
    init(x: Float, y: Float) {
        self.init(x, y)
    }
}

public extension Direction2 {
    init(from position1: Position2, to position2: Position2) {
        let d = Direction2(position2 - position1)
        self = d.normalized
    }
    
    init(_ radians: Radians) {
        self.x = cos(radians.rawValue)
        self.y = sin(radians.rawValue)
    }
    
    init(_ degrees: Degrees) {
        self.init(Radians(degrees))
    }
}

extension Direction2: Equatable {}
extension Direction2: Hashable {}
extension Direction2: Codable {}

public extension Direction2 {
    func angle(to rhs: Self) -> Radians {
        let v0 = self.normalized
        let v1 = rhs.normalized
        
        let dot = v0.dot(v1)
        return Radians(acos(dot))
    }
    
    var angleAroundZ: Radians {
        return Radians(atan2(x, -y))
    }
}

public extension Direction2 {
    func rotated(by rotation: Quaternion) -> Self {
        let conjugate = rotation.normalized.conjugate
        let w = rotation * self * conjugate
        let dir3 = w.direction
        return Direction2(dir3.x, dir3.y)
    }
    
    func reflected(off normal: Self) -> Self {
        let normal: Self = normal.normalized
        let dn: Float = -2 * self.dot(normal)
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
