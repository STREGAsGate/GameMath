/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

public struct Size3<T: Numeric & SIMDScalar>: Vector3 {
    public var x: T
    public var y: T
    public var z: T
    
    public init(_ x: T, _ y: T, _ z: T) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public init(width: T, height: T, depth: T) {
        self.x = width
        self.y = height
        self.z = depth
    }
}

extension Size3: Equatable where T: Equatable {}
extension Size3: Hashable where T: Hashable {}
extension Size3: Codable where T: Codable {}

public extension Size3 {
    static var one: Self {
        return Self(width: 1, height: 1, depth: 1)
    }
}

extension Size3 {
    public var width: T {
        get{
            return x
        }
        set(val) {
            x = val
        }
    }
    public var height: T {
        get{
            return y
        }
        set(val) {
            y = val
        }
    }
    public var depth: T {
        get{
            return z
        }
        set(val) {
            z = val
        }
    }
}
