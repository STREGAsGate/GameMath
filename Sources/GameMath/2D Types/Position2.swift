/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

public struct Position2<T: Numeric>: Vector2 {
    public var x: T
    public var y: T
    public init(x: T, y: T) {
        self.x = x
        self.y = y
    }
    
    public init(_ x: T, _ y: T) {
        self.init(x: x, y: y)
    }
}

extension Position2: Equatable where T: Equatable {}
extension Position2: Hashable where T: Hashable {}
extension Position2: Codable where T: Codable {}

public extension Position2 {
    static var zero: Self {
        return Self(x: 0, y: 0)
    }
}

public extension Position2 where T: FloatingPoint {
    func distance(from: Self) -> T {
        let difference = self - from
        let distance = difference.dot(difference)
        return distance.squareRoot()
    }
}


//Addition
extension Position2 where T: Numeric {
    //Self:Self
    public static func +(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x + rhs.x,
                    lhs.y + rhs.y)
    }
    public static func +=(lhs: inout Self, rhs: Self) {
        lhs =  lhs + rhs
    }
}

//Subtraction
extension Position2 where T: Numeric {
    //Self:Self
    public static func -(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x - rhs.x,
                    lhs.y - rhs.y)
    }
    public static func -=(lhs: inout Self, rhs: Self) {
        lhs =  lhs - rhs
    }
}

//Division(FloatingPoint)
extension Position2 where T: FloatingPoint {
    //Self:Self
    public static func /(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x / rhs.x,
                    lhs.y / rhs.y)
    }
    public static func /=(lhs: inout Self, rhs: Self) {
        lhs =  lhs / rhs
    }
}

//Division(Integer)
extension Position2 where T: BinaryInteger {
    //Self:Self
    public static func /(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x / rhs.x,
                    lhs.y / rhs.y)
    }
    public static func /=(lhs: inout Self, rhs: Self) {
        lhs =  lhs / rhs
    }
}
