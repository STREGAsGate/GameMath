/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * http://stregasgate.com
 */

import Foundation

public protocol Vector2 {
    var x: Float {get set}
    var y: Float {get set}
    init(_ x: Float, _ y: Float)
}

extension Vector2 {
    @inlinable
    public init(_ value: Float) {
        self.init(value, value)
    }
    
    public init(_ values: [Float]) {
        assert(values.isEmpty || values.count == 2, "values must be empty or have 2 elements. Use init(repeating:) to fill with a single value.")
        if values.isEmpty {
            self.init(0, 0)
        }else{
            self.init(values[0], values[1])
        }
    }
}

extension Vector2 {
    public init<V: Vector2>(_ value: V) {
        self = Self(value.x, value.y)
    }
    public init() {
        self.init(0, 0)
    }
}

public extension Vector2 {
    static var zero: Self {
        return Self(0)
    }
}

extension Vector2 {
    public var isFinite: Bool {
        return x.isFinite && y.isFinite
    }
}

extension Vector2 {
    public subscript (_ index: Array<Float>.Index) -> Float {
        get {
            switch index {
            case 0: return x
            case 1: return y
            default:
                fatalError("Index \(index) out of range \(0 ..< 2) for type \(type(of: self)).")
            }
        }
        set {
            switch index {
            case 0: x = newValue
            case 1: y = newValue
            default:
                fatalError("Index \(index) out of range \(0 ..< 2) for type \(type(of: self)).")
            }
        }
    }
    
    public func dot<V: Vector2>(_ vector: V) -> Float {
        return (x * vector.x) + (y * vector.y)
    }
    
    /// Returns the hypothetical Z axis
    public func cross<V: Vector2>(_ vector: V) -> Float {
        return self.x * vector.y - vector.x * self.y
    }
}

extension Vector2 {
    @inlinable
    public var length: Float {
        return x + y
    }
    
    @inlinable
    public var squaredLength: Float {
        return x * x + y * y
    }
    
    @inlinable
    public var magnitude: Float {
        return squaredLength.squareRoot()
    }

    #if !GameMathUseFastInverseSquareRoot
    @inlinable
    public var normalized: Self {
        var copy = self
        copy.normalize()
        return copy
    }

    @inlinable
    public mutating func normalize() {
        let magnitude = self.magnitude
        guard magnitude != 0 else {return}

        let factor = 1 / magnitude
        self.x *= factor
        self.y *= factor
    }
    #endif
    
    public func squareRoot() -> Self {
        return Self(x.squareRoot(), y.squareRoot())
    }
}

extension Vector2 {
    public func interpolated<V: Vector2>(to: V, _ method: InterpolationMethod) -> Self {
        var copy = self
        copy.x.interpolate(to: to.x, method)
        copy.y.interpolate(to: to.y, method)
        return copy
    }
    public mutating func interpolate<V: Vector2>(to: V, _ method: InterpolationMethod) {
        self.x.interpolate(to: to.x, method)
        self.y.interpolate(to: to.y, method)
    }
}

public extension Vector2 {
    var max: Float {
        return Swift.max(x, y)
    }
    var min: Float {
        return Swift.min(x, y)
    }
}

//MARK: - SIMD
public extension Vector2 {
    var simd: SIMD2<Float> {
        return SIMD2<Float>(x, y)
    }
}

//MARK: - Operations
public func ceil<V: Vector2>(_ v: V) -> V {
    return V.init(ceil(v.x), ceil(v.y))
}

public func floor<V: Vector2>(_ v: V) -> V {
    return V.init(floor(v.x), floor(v.y))
}

public func round<V: Vector2>(_ v: V) -> V {
    return V.init(round(v.x), round(v.y))
}

public func abs<V: Vector2>(_ v: V) -> V {
    return V.init(abs(v.x), abs(v.y))
}

public func min<V: Vector2>(_ lhs: V, _ rhs: V) -> V {
    return V.init(min(lhs.x, rhs.x), min(lhs.y, rhs.y))
}

public func max<V: Vector2>(_ lhs: V, _ rhs: V) -> V {
    return V.init(max(lhs.x, rhs.x), max(lhs.y, rhs.y))
}

//MARK: Operators (Self)
extension Vector2 {
    //Multiplication
    public static func *(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x * rhs.x,
                    lhs.y * rhs.y)
    }
    public static func *=(lhs: inout Self, rhs: Self) {
        lhs.x *= rhs.x
        lhs.y *= rhs.y
    }
    
    //Addition
    public static func +(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x + rhs.x,
                    lhs.y + rhs.y)
    }
    public static func +=(lhs: inout Self, rhs: Self) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
    
    //Subtraction
    public static func -(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x - rhs.x,
                    lhs.y - rhs.y)
    }
    public static func -=(lhs: inout Self, rhs: Self) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }
}
extension Vector2 {
    //Division
    public static func /(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x / rhs.x,
                    lhs.y / rhs.y)
    }
    public static func /=(lhs: inout Self, rhs: Self) {
        lhs.x /= rhs.x
        lhs.y /= rhs.y
    }
}

//MARK: Operators (Integers and Floats)
extension Vector2 {
    //Multiplication Without Casting
    public static func *(lhs: Self, rhs: Float) -> Self {
        return Self(lhs.x * rhs,
                    lhs.y * rhs)
    }
    public static func *=(lhs: inout Self, rhs: Float) {
        lhs.x *= rhs
        lhs.y *= rhs
    }
    
    //Addition Without Casting
    public static func +(lhs: Self, rhs: Float) -> Self {
        return Self(lhs.x + rhs,
                    lhs.y + rhs)
    }
    public static func +=(lhs: inout Self, rhs: Float) {
        lhs.x += rhs
        lhs.y += rhs
    }
    
    //Subtraction Without Casting
    public static func -(lhs: Self, rhs: Float) -> Self {
        return Self(lhs.x - rhs,
                    lhs.y - rhs)
    }
    public static func -=(lhs: inout Self, rhs: Float) {
        lhs.x -= rhs
        lhs.y -= rhs
    }
    
    public static func -(lhs: Float, rhs: Self) -> Self {
        return Self(lhs - rhs.x,
                    lhs - rhs.y)
    }
    
    public static func -=(lhs: Float, rhs: inout Self) {
        rhs.x = lhs - rhs.x
        rhs.y = lhs - rhs.y
    }
}

extension Vector2 {
    //Division Without Casting
    public static func /(lhs: Self, rhs: Float) -> Self {
        return Self(lhs.x / rhs,
                    lhs.y / rhs)
    }
    public static func /=(lhs: inout Self, rhs: Float) {
        lhs.x /= rhs
        lhs.y /= rhs
    }
    
    public static func /(lhs: Float, rhs: Self) -> Self {
        return Self(lhs / rhs.x,
                    lhs / rhs.y)
    }
    public static func /=(lhs: Float, rhs: inout Self) {
        rhs.x = lhs / rhs.x
        rhs.y = lhs / rhs.y
    }
}

extension Vector2 {
    //Multiplication
    public static func *<V: Vector2>(lhs: Self, rhs: V) -> Self {
        return Self(lhs.x * rhs.x,
                    lhs.y * rhs.y)
    }
    public static func *=<V: Vector2>(lhs: inout Self, rhs: V) {
        lhs.x *= rhs.x
        lhs.y *= rhs.y
    }
    
    //Addition
    public static func +<V: Vector2>(lhs: Self, rhs: V) -> Self {
        return Self(lhs.x + rhs.x,
                    lhs.y + rhs.y)
    }
    public static func +=<V: Vector2>(lhs: inout Self, rhs: V) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
    
    //Subtraction
    public static func -<V: Vector2>(lhs: Self, rhs: V) -> Self {
        return Self(lhs.x - rhs.x,
                    lhs.y - rhs.y)
    }
    public static func -=<V: Vector2>(lhs: inout Self, rhs: V) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }
}

extension Vector2 {
    //Division
    public static func /<V: Vector2>(lhs: Self, rhs: V) -> Self{
        return Self(lhs.x / rhs.x,
                    lhs.y / rhs.y)
    }
    public static func /=<V: Vector2>(lhs: inout Self, rhs: V) {
        lhs.x /= rhs.x
        lhs.y /= rhs.y
    }
}

//MARK: Matrix4
public extension Vector2 {
    static func *(lhs: Self, rhs: Matrix4x4) -> Self {
        var x: Float = lhs.x * rhs.a
        x += lhs.y * rhs.b
        x += rhs.d
        
        var y: Float = lhs.x * rhs.e
        y += lhs.y * rhs.f
        y += rhs.h
        
        return Self(x, y)
    }
    
    static func *(lhs: Matrix4x4, rhs: Self) -> Self {
        var x: Float = rhs.x * lhs.a
        x += rhs.y * lhs.e
        x += lhs.m
        
        var y: Float = rhs.x * lhs.b
        y += rhs.y * lhs.f
        y += lhs.n
        
        return Self(x, y)
    }
    
    static func *(lhs: Self, rhs: Matrix3x3) -> Self {
        var vector: Self = .zero
        
        for i in 0 ..< 2 {
            for j in 0 ..< 2 {
                vector[i] += lhs[j] * rhs[i][j]
            }
        }
        return vector
    }
}

extension Vector2 {
    @_transparent
    public static prefix func -(rhs: Self) -> Self {
        return Self(-rhs.x, -rhs.y)
    }

    @_transparent
    public static prefix func +(rhs: Self) -> Self {
        return Self(+rhs.x, +rhs.y)
    }
}

extension Vector2 {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([x, y])
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode(Array<Float>.self)
        self.init(values[0], values[1])
    }
}

extension Vector2 {
    public func valuesArray() -> [Float] {return [x, y]}
}
