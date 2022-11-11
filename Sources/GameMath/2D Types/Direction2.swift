/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * http://stregasgate.com
 */

import Foundation

public struct Direction2: Vector2 {
    public var x: Float
    public var y: Float
    
    public init(_ x: Float, _ y: Float) {
        self.x = x
        self.y = y
    }
}

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
    @inline(__always)
    func angle(to rhs: Self) -> Radians {
        let v0 = self.normalized
        let v1 = rhs.normalized
        
        let dot = v0.dot(v1)
        return Radians(acos(dot))
    }
    
    @inline(__always)
    var angleAroundZ: Radians {
        return Radians(atan2(x, -y))
    }
}

public extension Direction2 {
    @inline(__always)
    func rotated(by rotation: Quaternion) -> Self {
        let conjugate = rotation.normalized.conjugate
        let w = rotation * self * conjugate
        let dir3 = w.direction
        return Direction2(dir3.x, dir3.y).normalized
    }
    
    @inline(__always)
    func reflected(off normal: Self) -> Self {
        let normal: Self = normal.normalized
        let dn: Float = -2 * self.dot(normal)
        return (normal * dn) + self
    }
}

public extension Direction2 {
    static let zero = Self(x: 0, y: 0)
    
    static let up = Self(x: 0, y: 1)
    static let down = Self(x: 0, y: -1)
    static let left = Self(x: -1, y: 0)
    static let right = Self(x: 1, y: 0)
}
