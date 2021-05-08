/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

public struct Size2<T: Numeric & SIMDScalar>: Vector2 {
    public var width: T
    public var height: T
    
    public init(width: T, height: T) {
        self.width = width
        self.height = height
    }
}

extension Size2: Equatable where T: Equatable {}
extension Size2: Hashable where T: Hashable {}
extension Size2: Codable where T: Codable {}

//MARK: Vector2
extension Size2 {
    public var x: T {
        get {
            return width
        }
        set(x) {
            self.width = x
        }
    }
    
    public var y: T {
        get {
            return height
        }
        set(y) {
            self.height = y
        }
    }
    
    public init(_ x: T, _ y: T) {
        self.width = x
        self.height = y
    }
}

public extension Size2 {
    static var zero: Self {Self(width: 0, height: 0)}
    static var one: Self {Self(width: 1, height: 1)}
}

public extension Size2 where T: FloatingPoint {
    var aspectRatio: T {
        return width / height
    }
}

public extension Size2 {
    static func *(lhs: Size2, rhs: T) -> Self {
        return Size2(width: lhs.width * rhs, height: lhs.height * rhs)
    }
    static func *=(lhs: inout Self, rhs: T) {
        lhs = lhs * rhs
    }
}


//Addition
public extension Size2 where T: Numeric {
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
public extension Size2 where T: Numeric {
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
public extension Size2 where T: FloatingPoint {
    //Self:Self
    static func /(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x / rhs.x,
                    lhs.y / rhs.y)
    }
    static func /=(lhs: inout Self, rhs: Self) {
        lhs =  lhs / rhs
    }
}

//Division(Integer)
public extension Size2 where T: BinaryInteger {
    //Self:Self
    static func /(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x / rhs.x,
                    lhs.y / rhs.y)
    }
    static func /=(lhs: inout Self, rhs: Self) {
        lhs =  lhs / rhs
    }
}
