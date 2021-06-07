/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

import Foundation

public protocol Vector2 {
    #if GameMathUseSIMD
    associatedtype T: Numeric & SIMDScalar
    #else
    associatedtype T: Numeric
    #endif
    var x: T {get set}
    var y: T {get set}
    init(_ x: T, _ y: T)
}

extension Vector2 {
    @inlinable
    public init(repeating value: T) {
        self.init(value, value)
    }
    
    public init(_ values: [T]) {
        assert(values.isEmpty || values.count == 2, "values must be empty or have 2 elements. Use init(repeating:) to fill with a single value.")
        if values.isEmpty {
            self.init(0, 0)
        }else{
            self.init(values[0], values[1])
        }
    }
}

//Mark: BinaryInteger
extension Vector2 where T: BinaryInteger {
    public init<V: Vector2>(_ value: V) where V.T: BinaryInteger {
        self = Self(T(value.x), T(value.y))
    }
    public init<V: Vector2>(_ value: V) where V.T: BinaryFloatingPoint {
        self = Self(T(value.x), T(value.y))
    }
    public init() {
        self.init(0, 0)
    }
}

//Mark: FloatingPoint
extension Vector2 where T: BinaryFloatingPoint {
    public init<V: Vector2>(_ value: V) where V.T: BinaryInteger {
        self = Self(T(value.x), T(value.y))
    }
    public init<V: Vector2>(_ value: V) where V.T: BinaryFloatingPoint {
        self = Self(T(value.x), T(value.y))
    }
    public init() {
        self.init(0, 0)
    }
}

public extension Vector2 {
    static var zero: Self {
        return Self(repeating: 0)
    }
}

extension Vector2 where T: FloatingPoint {
    public var isFinite: Bool {
        return x.isFinite && y.isFinite
    }
}

extension Vector2 {
    public subscript (_ index: Array<T>.Index) -> T {
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
    
    public var squaredLength: T {
        return x * x + y * y
    }
    
    public func dot<V: Vector2>(_ vector: V) -> T where V.T == T {
        return (x * vector.x) + (y * vector.y)
    }
    
    /// Returns the hypothetical Z axis
    public func cross<V: Vector2>(_ vector: V) -> T where V.T == T {
        return self.x * vector.y - vector.x * self.y
    }
}

extension Vector2 where T: FloatingPoint {
    public var length: T {
        get {
            return x + y
        }
        set(val) {
            x = val / 2
            y = val / 2
        }
    }
    
    public var magnitude: T {
        return squaredLength.squareRoot()
    }
    
    public var normalized: Self {
        return self / self.magnitude
    }
    
    public mutating func normalize() {
        self /= magnitude
    }
    
    public func squareRoot() -> Self {
        return Self(x.squareRoot(), y.squareRoot())
    }
}

extension Vector2 {
    public func interpolated<V: Vector2>(to: V, _ method: InterpolationMethod<T>) -> Self where V.T == T {
        var copy = self
        copy.x.interpolate(to: to.x, method)
        copy.y.interpolate(to: to.y, method)
        return copy
    }
    public mutating func interpolate<V: Vector2>(to: V, _ method: InterpolationMethod<T>) where V.T == T {
        self.x.interpolate(to: to.x, method)
        self.y.interpolate(to: to.y, method)
    }
}

public extension Vector2 where T: Comparable {
    var max: T {
        return Swift.max(x, y)
    }
    var min: T {
        return Swift.min(x, y)
    }
}

//MARK: - SIMD
public extension Vector2 where T: SIMDScalar {
    var simd: SIMD2<T> {
        return SIMD2<T>(x, y)
    }
}

//MARK: - Operations
public func ceil<T: Vector2>(_ v: T) -> T where T.T: FloatingPoint {
    return T.init(ceil(v.x), ceil(v.y))
}

public func floor<T: Vector2>(_ v: T) -> T where T.T: FloatingPoint {
    return T.init(floor(v.x), floor(v.y))
}

public func round<T: Vector2>(_ v: T) -> T where T.T: FloatingPoint {
    return T.init(round(v.x), round(v.y))
}

public func abs<T: Vector2>(_ v: T) -> T where T.T: SignedNumeric & Comparable {
    return T.init(abs(v.x), abs(v.y))
}

public func min<T: Vector2>(_ lhs: T, _ rhs: T) -> T where T.T: Comparable {
    return T.init(min(lhs.x, rhs.x), min(lhs.y, rhs.y))
}

public func max<T: Vector2>(_ lhs: T, _ rhs: T) -> T where T.T: Comparable {
    return T.init(max(lhs.x, rhs.x), max(lhs.y, rhs.y))
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
extension Vector2 where T: FloatingPoint {
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
extension Vector2 where T: BinaryInteger {
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
    public static func *(lhs: Self, rhs: T) -> Self {
        return Self(lhs.x * rhs,
                    lhs.y * rhs)
    }
    public static func *=(lhs: inout Self, rhs: T) {
        lhs.x *= rhs
        lhs.y *= rhs
    }
    
    //Addition Without Casting
    public static func +(lhs: Self, rhs: T) -> Self {
        return Self(lhs.x + rhs,
                    lhs.y + rhs)
    }
    public static func +=(lhs: inout Self, rhs: T) {
        lhs.x += rhs
        lhs.y += rhs
    }
    
    //Subtraction Without Casting
    public static func -(lhs: Self, rhs: T) -> Self {
        return Self(lhs.x - rhs,
                    lhs.y - rhs)
    }
    public static func -=(lhs: inout Self, rhs: T) {
        lhs.x -= rhs
        lhs.y -= rhs
    }
    
    public static func -(lhs: T, rhs: Self) -> Self {
        return Self(lhs - rhs.x,
                    lhs - rhs.y)
    }
    
    public static func -=(lhs: T, rhs: inout Self) {
        rhs.x = lhs - rhs.x
        rhs.y = lhs - rhs.y
    }
}
extension Vector2 where T: BinaryInteger {
    //Division Without Casting
    public static func /(lhs: Self, rhs: T) -> Self {
        return Self(lhs.x / rhs,
                    lhs.y / rhs)
    }
    public static func /=(lhs: inout Self, rhs: T) {
        lhs.x /= rhs
        lhs.y /= rhs
    }
    
    public static func /(lhs: T, rhs: Self) -> Self {
        return Self(lhs / rhs.x,
                    lhs / rhs.y)
    }
    public static func /=(lhs: T, rhs: inout Self) {
        rhs.x = lhs / rhs.x
        rhs.y = lhs / rhs.y
    }
}
extension Vector2 where T: FloatingPoint {
    //Division Without Casting
    public static func /(lhs: Self, rhs: T) -> Self {
        return Self(lhs.x / rhs,
                    lhs.y / rhs)
    }
    public static func /=(lhs: inout Self, rhs: T) {
        lhs.x /= rhs
        lhs.y /= rhs
    }
    
    public static func /(lhs: T, rhs: Self) -> Self {
        return Self(lhs / rhs.x,
                    lhs / rhs.y)
    }
    public static func /=(lhs: T, rhs: inout Self) {
        rhs.x = lhs / rhs.x
        rhs.y = lhs / rhs.y
    }
}

extension Vector2 {
    //Multiplication
    public static func *<V: Vector2>(lhs: Self, rhs: V) -> Self where V.T == T {
        return Self(lhs.x * rhs.x,
                    lhs.y * rhs.y)
    }
    public static func *=<V: Vector2>(lhs: inout Self, rhs: V) where V.T == T {
        lhs.x *= rhs.x
        lhs.y *= rhs.y
    }
    
    //Addition
    public static func +<V: Vector2>(lhs: Self, rhs: V) -> Self where V.T == T {
        return Self(lhs.x + rhs.x,
                    lhs.y + rhs.y)
    }
    public static func +=<V: Vector2>(lhs: inout Self, rhs: V) where V.T == T {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
    
    //Subtraction
    public static func -<V: Vector2>(lhs: Self, rhs: V) -> Self where V.T == T {
        return Self(lhs.x - rhs.x,
                    lhs.y - rhs.y)
    }
    public static func -=<V: Vector2>(lhs: inout Self, rhs: V) where V.T == T {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }
}
extension Vector2 where T: BinaryInteger {
    //Division
    public static func /<V: Vector2>(lhs: Self, rhs: V) -> Self where V.T == T {
        return Self(lhs.x / rhs.x,
                    lhs.y / rhs.y)
    }
    public static func /=<V: Vector2>(lhs: inout Self, rhs: V) where V.T == T {
        lhs.x /= rhs.x
        lhs.y /= rhs.y
    }
}
extension Vector2 where T: FloatingPoint {
    //Division
    public static func /<V: Vector2>(lhs: Self, rhs: V) -> Self where V.T == T {
        return Self(lhs.x / rhs.x,
                    lhs.y / rhs.y)
    }
    public static func /=<V: Vector2>(lhs: inout Self, rhs: V) where V.T == T {
        lhs.x /= rhs.x
        lhs.y /= rhs.y
    }
}

//MARK: Matrix4
public extension Vector2 where T: FloatingPoint {
    static func *(lhs: Self, rhs: Matrix4x4<T>) -> Self {
        var x: T = lhs.x * rhs.a
        x += lhs.y * rhs.b
        x += rhs.d
        
        var y: T = lhs.x * rhs.e
        y += lhs.y * rhs.f
        y += rhs.h
        
        return Self(x, y)
    }
    
    static func *(lhs: Matrix4x4<T>, rhs: Self) -> Self {
        var x: T = rhs.x * lhs.a
        x += rhs.y * lhs.e
        x += lhs.m
        
        var y: T = rhs.x * lhs.b
        y += rhs.y * lhs.f
        y += lhs.n
        
        return Self(x, y)
    }
    
    static func *(lhs: Self, rhs: Matrix3x3<T>) -> Self {
        var vector: Self = .zero
        
        for i in 0 ..< 2 {
            for j in 0 ..< 2 {
                vector[i] += lhs[j] * rhs[i][j]
            }
        }
        return vector
    }
}

extension Vector2 where T: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([x, y])
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode(Array<T>.self)
        self.init(values[0], values[1])
    }
}

extension Vector2 {
    public func valuesArray() -> [T] {return [x, y]}
}
