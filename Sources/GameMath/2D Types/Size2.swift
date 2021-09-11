/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

#if GameMathUseSIMD
public struct Size2: Vector2 {
    public var width: Float
    public var height: Float
    
    public init(width: Float, height: Float) {
        self.width = width
        self.height = height
    }
}
#else
public struct Size2: Vector2 {
    public var width: Float
    public var height: Float
    
    public init(width: Float, height: Float) {
        self.width = width
        self.height = height
    }
}
#endif

extension Size2: Equatable {}
extension Size2: Hashable {}
extension Size2: Codable {}

//MARK: Vector2
extension Size2 {
    public var x: Float {
        get {
            return width
        }
        set(x) {
            self.width = x
        }
    }
    
    public var y: Float {
        get {
            return height
        }
        set(y) {
            self.height = y
        }
    }
    
    public init(_ x: Float, _ y: Float) {
        self.width = x
        self.height = y
    }
}

public extension Size2 {
    static var zero: Self {Self(width: 0, height: 0)}
    static var one: Self {Self(width: 1, height: 1)}
}

public extension Size2 {
    var aspectRatio: Float {
        return width / height
    }
}

public extension Size2 {
    static func *(lhs: Size2, rhs: Float) -> Self {
        return Size2(width: lhs.width * rhs, height: lhs.height * rhs)
    }
    static func *=(lhs: inout Self, rhs: Float) {
        lhs = lhs * rhs
    }
}


//Addition
public extension Size2 {
    //Self:Self
    static func +(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x + rhs.x,
                    lhs.y + rhs.y)
    }
    static func +=(lhs: inout Self, rhs: Self) {
        lhs =  lhs + rhs
    }
}

//Subtraction
public extension Size2 {
    //Self:Self
    static func -(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x - rhs.x,
                    lhs.y - rhs.y)
    }
    static func -=(lhs: inout Self, rhs: Self) {
        lhs =  lhs - rhs
    }
}

//Division(FloatingPoint)
public extension Size2 {
    //Self:Self
    static func /(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x / rhs.x,
                    lhs.y / rhs.y)
    }
    static func /=(lhs: inout Self, rhs: Self) {
        lhs =  lhs / rhs
    }
}
