/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

#if GameMathUseSIMD
public struct Size3: Vector3 {
    public var x: Float
    public var y: Float
    public var z: Float
    
    public init(_ x: Float, _ y: Float, _ z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
}
#else
public struct Size3: Vector3 {
    public var x: Float
    public var y: Float
    public var z: Float
    
    public init(_ x: Float, _ y: Float, _ z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
}
#endif

public extension Size3 {
    init(width: Float, height: Float, depth: Float) {
        self.x = width
        self.y = height
        self.z = depth
    }
}

extension Size3: Equatable {}
extension Size3: Hashable {}
extension Size3: Codable {}

public extension Size3 {
    static var one: Self {
        return Self(width: 1, height: 1, depth: 1)
    }
}

extension Size3 {
    public var width: Float {
        get{
            return x
        }
        set(val) {
            x = val
        }
    }
    public var height: Float {
        get{
            return y
        }
        set(val) {
            y = val
        }
    }
    public var depth: Float {
        get{
            return z
        }
        set(val) {
            z = val
        }
    }
}
