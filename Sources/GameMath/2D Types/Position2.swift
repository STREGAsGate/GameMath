/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * http://stregasgate.com
 */

#if GameMathUseSIMD
public struct Position2: Vector2 {
    @usableFromInline
    var storage: SIMD2<Float>
    public init(x: Float, y: Float) {
        self.storage = SIMD2(x: x, y: y)
    }
    
    @inline(__always)
    public var x: Float {
        get {
            return storage.x
        }
        set {
            storage.x = newValue
        }
    }
    
    @inline(__always)
    public var y: Float {
        get {
            return storage.y
        }
        set {
            storage.y = newValue
        }
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
    
    static let zero = Self(x: 0, y: 0)
}

public extension Position2 {
    @inline(__always)
    func distance(from: Self) -> Float {
        let difference = self - from
        let distance = difference.dot(difference)
        return distance.squareRoot()
    }
}


//Addition
extension Position2 {
    //Self:Self
    @inline(__always)
    public static func +(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x + rhs.x,
                    lhs.y + rhs.y)
    }
    @inline(__always)
    public static func +=(lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
}

//Subtraction
extension Position2 {
    //Self:Self
    @inline(__always)
    public static func -(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x - rhs.x,
                    lhs.y - rhs.y)
    }
    @inline(__always)
    public static func -=(lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
}

//Division
extension Position2 {
    //Self:Self
    @inline(__always)
    public static func /(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x / rhs.x,
                    lhs.y / rhs.y)
    }
    @inline(__always)
    public static func /=(lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
}

public extension Position2 {
    /** Creates a position a specified distance from self in a particular direction
    - parameter distance: The units away from `self` to create the new position.
    - parameter direction: The angle away from self to create the new position.
     */
    @inline(__always)
    func moved(_ distance: Float, toward direction: Direction2) -> Self {
        return self + (direction * distance)
    }

    /** Moves `self` by a specified distance from in a particular direction
    - parameter distance: The units away to move.
    - parameter direction: The angle to move.
     */
    @inline(__always)
    mutating func move(_ distance: Float, toward direction: Direction2) {
        self = moved(distance, toward: direction)
    }
}

public extension Position2 {
    @inline(__always)
    mutating func clamp(within rect: Rect) {
        self.x = .maximum(self.x, rect.x)
        self.x = .minimum(self.x, rect.maxX)
        self.y = .maximum(self.y, rect.y)
        self.y = .minimum(self.y, rect.maxY)
    }
    
    @inline(__always)
    func clamped(within rect: Rect) -> Position2 {
        var copy = self
        copy.clamp(within: rect)
        return copy
    }
}
