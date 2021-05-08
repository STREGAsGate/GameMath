/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

import Foundation

public protocol Vector3 {
    associatedtype T: Numeric & SIMDScalar
    var x: T {get set}
    var y: T {get set}
    var z: T {get set}
    init(_ x: T, _ y: T, _ z: T)
}

extension Vector3 {
    public init(repeating value: T) {
        self.init(value, value, value)
    }
    
    public init(_ values: [T]) {
        assert(values.isEmpty || values.count == 3, "values must be empty or have 3 elements. Use init(repeating:) to fill with a single value.")
        if values.isEmpty {
            self.init(0, 0, 0)
        }else{
            self.init(values[0], values[1], values[2])
        }
    }
}

//Mark: Integer Casting
extension Vector3 where T: BinaryInteger {
    public init<V: Vector3>(_ value: V) where V.T: BinaryInteger {
        self = Self(T(value.x), T(value.y), T(value.z))
    }
    public init<V: Vector3>(_ value: V) where V.T: BinaryFloatingPoint {
        self = Self(T(value.x), T(value.y), T(value.z))
    }
    public init() {
        self.init(0, 0, 0)
    }
}

//Mark: FloatingPoint
extension Vector3 where T: BinaryFloatingPoint {
    public init<V: Vector3>(_ value: V) where V.T: BinaryFloatingPoint {
        self = Self(T(value.x), T(value.y), T(value.z))
    }
    public init<V: Vector3>(_ value: V) where V.T: BinaryInteger {
        self = Self(T(value.x), T(value.y), T(value.z))
    }
    public init() {
        self.init(0, 0, 0)
    }
}

public extension Vector3 {
    static var zero: Self {
        return Self(repeating: 0)
    }
}

extension Vector3 where T: FloatingPoint {
    public var isFinite: Bool {
        return x.isFinite && y.isFinite && z.isFinite
    }
}

extension Vector3 {
    public subscript (_ index: Array<T>.Index) -> T {
        get{
            assert(index < 3, "Index \(index) out of range \(0..<3) for type \(type(of: self))")
            switch index {
            case 0: return x
            case 1: return y
            case 2: return z
            default: return 0
            }
        }
        set{
            assert(index < 3, "Index \(index) out of range \(0..<3) for type \(type(of: self))")
            switch index {
            case 0: x = newValue
            case 1: y = newValue
            case 2: z = newValue
            default: return
            }
        }
    }
    
    public var squaredLength: T {
        return x * x + y * y + z * z
    }
    
    public func dot<V: Vector3>(_ vector: V) -> T where V.T == T {
        return (x * vector.x) + (y * vector.y) + (z * vector.z)
    }
    
    public func cross<V: Vector3>(_ vector: V) -> Self where V.T == T {
        return Self(y * vector.z - z * vector.y,
                    z * vector.x - x * vector.z,
                    x * vector.y - y * vector.x)
    }
}

extension Vector3 where T: FloatingPoint {
    public var length: T {
        get {
            return x + y + z
        }
        set(val) {
            x = val / 3
            y = val / 3
            z = val / 3
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
        return Self(x.squareRoot(), y.squareRoot(), z.squareRoot())
    }
}

extension Vector3 {
    public func interpolated<V: Vector3>(to: V, _ method: InterpolationMethod<T>) -> Self where V.T == T {
        var copy = self
        copy.x.interpolate(to: to.x, method)
        copy.y.interpolate(to: to.y, method)
        copy.z.interpolate(to: to.z, method)
        return copy
    }
    public mutating func interpolate<V: Vector3>(to: V, _ method: InterpolationMethod<T>) where V.T == T {
        self.x.interpolate(to: to.x, method)
        self.y.interpolate(to: to.y, method)
        self.z.interpolate(to: to.z, method)
    }
}

public extension Vector3 where T: Comparable {
    var max: T {
        return Swift.max(x, Swift.max(y, z))
    }
    var min: T {
        return Swift.min(x, Swift.min(y, z))
    }
}

//MARK: - SIMD
public extension Vector3 {
    var simd: SIMD3<T> {
        return SIMD3<T>(x, y, z)
    }
}

//MARK: - Operations
public func ceil<T: Vector3>(_ v: T) -> T where T.T: FloatingPoint {
    return T.init(ceil(v.x), ceil(v.y), ceil(v.z))
}

public func floor<T: Vector3>(_ v: T) -> T where T.T: FloatingPoint {
    return T.init(floor(v.x), floor(v.y), floor(v.z))
}

public func round<T: Vector3>(_ v: T) -> T where T.T: FloatingPoint {
    return T.init(round(v.x), round(v.y), round(v.z))
}

public func abs<T: Vector3>(_ v: T) -> T where T.T: SignedNumeric & Comparable {
    return T.init(abs(v.x), abs(v.y), abs(v.z))
}

//MARK: Operators (Self)
extension Vector3 {
    //Multiplication
    public static func *(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x * rhs.x,
                    lhs.y * rhs.y,
                    lhs.z * rhs.z)
    }
    public static func *=(lhs: inout Self, rhs: Self) {
        lhs.x *= rhs.x
        lhs.y *= rhs.y
        lhs.z *= rhs.z
    }
    
    //Addition
    public static func +(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x + rhs.x,
                    lhs.y + rhs.y,
                    lhs.z + rhs.z)
    }
    public static func +=(lhs: inout Self, rhs: Self) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
    }
    
    //Subtraction
    public static func -(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x - rhs.x,
                    lhs.y - rhs.y,
                    lhs.z - rhs.z)
    }
    public static func -=(lhs: inout Self, rhs: Self) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
        lhs.z -= rhs.z
    }
}
extension Vector3 where T: FloatingPoint {
    //Division
    public static func /(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x / rhs.x,
                    lhs.y / rhs.y,
                    lhs.z / rhs.z)
    }
    public static func /=(lhs: inout Self, rhs: Self) {
        lhs.x /= rhs.x
        lhs.y /= rhs.y
        lhs.z /= rhs.z
    }
}
extension Vector3 where T: BinaryInteger {
    //Division
    public static func /(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x / rhs.x,
                    lhs.y / rhs.y,
                    lhs.z / rhs.z)
    }
    public static func /=(lhs: inout Self, rhs: Self) {
        lhs.x /= rhs.x
        lhs.y /= rhs.y
        lhs.z /= rhs.z
    }
}

//MARK: Operators (Integers and Floats)
extension Vector3 {
    //Multiplication Without Casting
    public static func *(lhs: Self, rhs: T) -> Self {
        return Self(lhs.x * rhs,
                    lhs.y * rhs,
                    lhs.z * rhs)
    }
    public static func *=(lhs: inout Self, rhs: T) {
        lhs.x *= rhs
        lhs.y *= rhs
        lhs.z *= rhs
    }
    
    //Addition Without Casting
    public static func +(lhs: Self, rhs: T) -> Self {
        return Self(lhs.x + rhs,
                    lhs.y + rhs,
                    lhs.z + rhs)
    }
    public static func +=(lhs: inout Self, rhs: T) {
        lhs.x += rhs
        lhs.y += rhs
        lhs.z += rhs
    }
    
    //Subtraction Without Casting
    public static func -(lhs: Self, rhs: T) -> Self {
        return Self(lhs.x - rhs,
                    lhs.y - rhs,
                    lhs.z - rhs)
    }
    public static func -=(lhs: inout Self, rhs: T) {
        lhs.x -= rhs
        lhs.y -= rhs
        lhs.z -= rhs
    }
    
    public static func -(lhs: T, rhs: Self) -> Self {
        return Self(lhs - rhs.x,
                    lhs - rhs.y,
                    lhs - rhs.z)
    }
    
    public static func -=(lhs: T, rhs: inout Self) {
        rhs.x = lhs - rhs.x
        rhs.y = lhs - rhs.y
        rhs.z = lhs - rhs.z
    }
}
extension Vector3 where T: BinaryInteger {
    //Division Without Casting
    public static func /(lhs: Self, rhs: T) -> Self {
        return Self(lhs.x / rhs,
                    lhs.y / rhs,
                    lhs.z / rhs)
    }
    public static func /=(lhs: inout Self, rhs: T) {
        lhs.x /= rhs
        lhs.y /= rhs
        lhs.z /= rhs
    }
    
    public static func /(lhs: T, rhs: Self) -> Self {
        return Self(lhs / rhs.x,
                    lhs / rhs.y,
                    lhs / rhs.z)
    }
    public static func /=(lhs: T, rhs: inout Self) {
        rhs.x = lhs / rhs.x
        rhs.y = lhs / rhs.y
        rhs.z = lhs / rhs.z
    }
}
extension Vector3 where T: FloatingPoint {
    //Division Without Casting
    public static func /(lhs: Self, rhs: T) -> Self {
        return Self(lhs.x / rhs,
                    lhs.y / rhs,
                    lhs.z / rhs)
    }
    public static func /=(lhs: inout Self, rhs: T) {
        lhs.x /= rhs
        lhs.y /= rhs
        lhs.z /= rhs
    }
    
    public static func /(lhs: T, rhs: Self) -> Self {
        return Self(lhs / rhs.x,
                    lhs / rhs.y,
                    lhs / rhs.z)
    }
    public static func /=(lhs: T, rhs: inout Self) {
        rhs.x = lhs / rhs.x
        rhs.y = lhs / rhs.y
        rhs.z = lhs / rhs.z
    }
}

extension Vector3 {
    //Multiplication
    public static func *<V: Vector3>(lhs: Self, rhs: V) -> Self where V.T == T {
        return Self(lhs.x * rhs.x,
                    lhs.y * rhs.y,
                    lhs.z * rhs.z)
    }
    public static func *=<V: Vector3>(lhs: inout Self, rhs: V) where V.T == T {
        lhs.x *= rhs.x
        lhs.y *= rhs.y
        lhs.z *= rhs.z
    }
    
    //Addition
    public static func +<V: Vector3>(lhs: Self, rhs: V) -> Self where V.T == T {
        return Self(lhs.x + rhs.x,
                    lhs.y + rhs.y,
                    lhs.z + rhs.z)
    }
    public static func +=<V: Vector3>(lhs: inout Self, rhs: V) where V.T == T {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
    }
    
    //Subtraction
    public static func -<V: Vector3>(lhs: Self, rhs: V) -> Self where V.T == T {
        return Self(lhs.x - rhs.x,
                    lhs.y - rhs.y,
                    lhs.z - rhs.z)
    }
    public static func -=<V: Vector3>(lhs: inout Self, rhs: V) where V.T == T {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
        lhs.z -= rhs.z
    }
}
extension Vector3 where T: BinaryInteger {
    //Division
    public static func /<V: Vector3>(lhs: Self, rhs: V) -> Self where V.T == T {
        return Self(lhs.x / rhs.x,
                    lhs.y / rhs.y,
                    lhs.z / rhs.z)
    }
    public static func /=<V: Vector3>(lhs: inout Self, rhs: V) where V.T == T {
        lhs.x /= rhs.x
        lhs.y /= rhs.y
        lhs.z /= rhs.z
    }
}
extension Vector3 where T: FloatingPoint {
    //Division
    public static func /<V: Vector3>(lhs: Self, rhs: V) -> Self where V.T == T {
        return Self(lhs.x / rhs.x,
                    lhs.y / rhs.y,
                    lhs.z / rhs.z)
    }
    public static func /=<V: Vector3>(lhs: inout Self, rhs: V) where V.T == T {
        lhs.x /= rhs.x
        lhs.y /= rhs.y
        lhs.z /= rhs.z
    }
}

//MARK: Matrix4
public extension Vector3 where T: FloatingPoint {
    static func *(lhs: Self, rhs: Matrix4x4<T>) -> Self {
        var x: T = lhs.x * rhs.a
        x += lhs.y * rhs.b
        x += lhs.z * rhs.c
        x += rhs.d
        
        var y: T = lhs.x * rhs.e
        y += lhs.y * rhs.f
        y += lhs.z * rhs.g
        y += rhs.h
        
        var z: T = lhs.x * rhs.i
        z += lhs.y * rhs.j
        z += lhs.z * rhs.k
        z += rhs.l
        
        return Self(x, y, z)
    }
    
    static func *(lhs: Matrix4x4<T>, rhs: Self) -> Self {
        var x: T = rhs.x * lhs.a
        x += rhs.y * lhs.e
        x += rhs.z * lhs.i
        x += lhs.m
        
        var y: T = rhs.x * lhs.b
        y += rhs.y * lhs.f
        y += rhs.z * lhs.j
        y += lhs.n
        
        var z: T = rhs.x * lhs.c
        z += rhs.y * lhs.g
        z += rhs.z * lhs.k
        z += lhs.o
        
        return Self(x, y, z)
    }
    
    static func *(lhs: Self, rhs: Matrix3x3<T>) -> Self {
        var vector: Self = .zero
        
        for i in 0 ..< 3 {
            for j in 0 ..< 3 {
                vector[i] += lhs[j] * rhs[i][j]
            }
        }
        return vector
    }
}

extension Vector3 where T: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([x, y, z])
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode(Array<T>.self)
        self.init(values[0], values[1], values[2])
    }
}

extension Vector3 {
    public func valuesArray() -> [T] {return [x, y, z]}
}
