/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * http://stregasgate.com
 */

#if GameMathUseSIMD
public struct Position2: Vector2 {
    public var x: Float
    public var y: Float
    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
}
#else
public struct Position2: Vector2 {
    public var x: Float
    public var y: Float
    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
}
#endif

extension Position2: Equatable {}
extension Position2: Hashable {}
extension Position2: Codable {}

public extension Position2 {
    init(_ x: Float, _ y: Float) {
        self.init(x: x, y: y)
    }
    
    static var zero: Self {
        return Self(x: 0, y: 0)
    }
}

public extension Position2 {
    func distance(from: Self) -> Float {
        let difference = self - from
        let distance = difference.dot(difference)
        return distance.squareRoot()
    }
}


//Addition
extension Position2 {
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
extension Position2 {
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
extension Position2 {
    //Self:Self
    public static func /(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x / rhs.x,
                    lhs.y / rhs.y)
    }
    public static func /=(lhs: inout Self, rhs: Self) {
        lhs =  lhs / rhs
    }
}

public extension Position2 {
    /** Creates a position a specified distance from self in a particular direction
    - parameter distance: The units away from `self` to create the new position.
    - parameter direction: The angle away from self to create the new position.
     */
    func moved(_ distance: Float, toward direction: Direction2) -> Self {
        return self + (direction.normalized * distance)
    }

    /** Moves `self` by a specified distance from in a particular direction
    - parameter distance: The units away to move.
    - parameter direction: The angle to move.
     */
    mutating func move(_ distance: Float, toward direction: Direction2) {
        self = moved(distance, toward: direction)
    }
}
