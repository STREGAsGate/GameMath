/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

import Foundation

public protocol Vector3 {
    var x: Float {get set}
    var y: Float {get set}
    var z: Float {get set}
    init(_ x: Float, _ y: Float, _ z: Float)
}

extension Vector3 {
    @inlinable
    public init(_ value: Float) {
        self.init(value, value, value)
    }
    
    public init(_ values: [Float]) {
        assert(values.isEmpty || values.count == 3, "values must be empty or have 3 elements. Use init(repeating:) to fill with a single value.")
        if values.isEmpty {
            self.init(0, 0, 0)
        }else{
            self.init(values[0], values[1], values[2])
        }
    }
}

//Mark: Integer Casting
extension Vector3 {
    @inlinable
    public init<V: Vector3>(_ value: V) {
        self = Self(value.x, value.y, value.z)
    }
    @inlinable
    public init() {
        self.init(0, 0, 0)
    }
}

public extension Vector3 {
    @_transparent
    static var zero: Self {
        return Self(0)
    }
}

extension Vector3 {
    @inlinable
    public var isFinite: Bool {
        return x.isFinite && y.isFinite && z.isFinite
    }
}

extension Vector3 {
    public subscript (_ index: Array<Float>.Index) -> Float {
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
    
    @inlinable
    public var squaredLength: Float {
        return x * x + y * y + z * z
    }
    
    @inlinable
    public func dot<V: Vector3>(_ vector: V) -> Float {
        return (x * vector.x) + (y * vector.y) + (z * vector.z)
    }
    
    @inlinable
    public func cross<V: Vector3>(_ vector: V) -> Self {
        return Self(y * vector.z - z * vector.y,
                    z * vector.x - x * vector.z,
                    x * vector.y - y * vector.x)
    }
}

extension Vector3 {
    @_transparent
    public var length: Float {
        return x + y + z
    }
    
    @_transparent
    public var magnitude: Float {
        return squaredLength.squareRoot()
    }

    #if !GameMathUseFastInverseSquareRoot
    @_transparent
    public var normalized: Self {
        return self / self.magnitude
    }
    
    @_transparent
    public mutating func normalize() {
        self /= magnitude
    }
    #endif
    
    @_transparent
    public func squareRoot() -> Self {
        return Self(x.squareRoot(), y.squareRoot(), z.squareRoot())
    }
}

extension Vector3 {
    @inlinable
    public func interpolated<V: Vector3>(to: V, _ method: InterpolationMethod) -> Self {
        var copy = self
        copy.x.interpolate(to: to.x, method)
        copy.y.interpolate(to: to.y, method)
        copy.z.interpolate(to: to.z, method)
        return copy
    }
    @inlinable
    public mutating func interpolate<V: Vector3>(to: V, _ method: InterpolationMethod) {
        self.x.interpolate(to: to.x, method)
        self.y.interpolate(to: to.y, method)
        self.z.interpolate(to: to.z, method)
    }
}

public extension Vector3 {
    @inlinable
    var max: Float {
        return Swift.max(x, Swift.max(y, z))
    }
    @inlinable
    var min: Float {
        return Swift.min(x, Swift.min(y, z))
    }
}

//MARK: - SIMD
public extension Vector3 {
    @inlinable
    var simd: SIMD3<Float> {
        return SIMD3<Float>(x, y, z)
    }
}

//MARK: - Operations
@inlinable
public func ceil<V: Vector3>(_ v: V) -> V {
    return V.init(ceil(v.x), ceil(v.y), ceil(v.z))
}

@inlinable
public func floor<V: Vector3>(_ v: V) -> V {
    return V.init(floor(v.x), floor(v.y), floor(v.z))
}

@inlinable
public func round<V: Vector3>(_ v: V) -> V {
    return V.init(round(v.x), round(v.y), round(v.z))
}

@inlinable
public func abs<V: Vector3>(_ v: V) -> V {
    return V.init(abs(v.x), abs(v.y), abs(v.z))
}

@inlinable
public func min<V: Vector3>(_ lhs: V, _ rhs: V) -> V {
    return V.init(min(lhs.x, rhs.x), min(lhs.y, rhs.y), min(lhs.z, rhs.z))
}

@inlinable
public func max<V: Vector3>(_ lhs: V, _ rhs: V) -> V {
    return V.init(max(lhs.x, rhs.x), max(lhs.y, rhs.y), max(lhs.z, rhs.z))
}


//MARK: Operators (Self)
extension Vector3 {
    //Multiplication
    @_transparent
    public static func *(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x * rhs.x,
                    lhs.y * rhs.y,
                    lhs.z * rhs.z)
    }
    @_transparent
    public static func *=(lhs: inout Self, rhs: Self) {
        lhs.x *= rhs.x
        lhs.y *= rhs.y
        lhs.z *= rhs.z
    }
    
    //Addition
    @_transparent
    public static func +(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x + rhs.x,
                    lhs.y + rhs.y,
                    lhs.z + rhs.z)
    }
    @_transparent
    public static func +=(lhs: inout Self, rhs: Self) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
    }
    
    //Subtraction
    @_transparent
    public static func -(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x - rhs.x,
                    lhs.y - rhs.y,
                    lhs.z - rhs.z)
    }
    @_transparent
    public static func -=(lhs: inout Self, rhs: Self) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
        lhs.z -= rhs.z
    }
}
extension Vector3 {
    //Division
    @_transparent
    public static func /(lhs: Self, rhs: Self) -> Self {
        return Self(lhs.x / rhs.x,
                    lhs.y / rhs.y,
                    lhs.z / rhs.z)
    }
    @_transparent
    public static func /=(lhs: inout Self, rhs: Self) {
        lhs.x /= rhs.x
        lhs.y /= rhs.y
        lhs.z /= rhs.z
    }
}

//MARK: Operators (Integers and Floats)
extension Vector3 {
    //Multiplication Without Casting
    @_transparent
    public static func *(lhs: Self, rhs: Float) -> Self {
        return Self(lhs.x * rhs,
                    lhs.y * rhs,
                    lhs.z * rhs)
    }
    @_transparent
    public static func *=(lhs: inout Self, rhs: Float) {
        lhs.x *= rhs
        lhs.y *= rhs
        lhs.z *= rhs
    }
    
    //Addition Without Casting
    @_transparent
    public static func +(lhs: Self, rhs: Float) -> Self {
        return Self(lhs.x + rhs,
                    lhs.y + rhs,
                    lhs.z + rhs)
    }
    @_transparent
    public static func +=(lhs: inout Self, rhs: Float) {
        lhs.x += rhs
        lhs.y += rhs
        lhs.z += rhs
    }
    
    //Subtraction Without Casting
    @_transparent
    public static func -(lhs: Self, rhs: Float) -> Self {
        return Self(lhs.x - rhs,
                    lhs.y - rhs,
                    lhs.z - rhs)
    }
    @_transparent
    public static func -=(lhs: inout Self, rhs: Float) {
        lhs.x -= rhs
        lhs.y -= rhs
        lhs.z -= rhs
    }
    
    @_transparent
    public static func -(lhs: Float, rhs: Self) -> Self {
        return Self(lhs - rhs.x,
                    lhs - rhs.y,
                    lhs - rhs.z)
    }
    
    @_transparent
    public static func -=(lhs: Float, rhs: inout Self) {
        rhs.x = lhs - rhs.x
        rhs.y = lhs - rhs.y
        rhs.z = lhs - rhs.z
    }
}

extension Vector3 {
    //Division Without Casting
    @_transparent
    public static func /(lhs: Self, rhs: Float) -> Self {
        return Self(lhs.x / rhs,
                    lhs.y / rhs,
                    lhs.z / rhs)
    }
    @_transparent
    public static func /=(lhs: inout Self, rhs: Float) {
        lhs.x /= rhs
        lhs.y /= rhs
        lhs.z /= rhs
    }
    
    @_transparent
    public static func /(lhs: Float, rhs: Self) -> Self {
        return Self(lhs / rhs.x,
                    lhs / rhs.y,
                    lhs / rhs.z)
    }
    @_transparent
    public static func /=(lhs: Float, rhs: inout Self) {
        rhs.x = lhs / rhs.x
        rhs.y = lhs / rhs.y
        rhs.z = lhs / rhs.z
    }
}

extension Vector3 {
    //Multiplication
    @_transparent
    public static func *<V: Vector3>(lhs: Self, rhs: V) -> Self {
        return Self(lhs.x * rhs.x,
                    lhs.y * rhs.y,
                    lhs.z * rhs.z)
    }
    @_transparent
    public static func *=<V: Vector3>(lhs: inout Self, rhs: V) {
        lhs.x *= rhs.x
        lhs.y *= rhs.y
        lhs.z *= rhs.z
    }
    
    //Addition
    @_transparent
    public static func +<V: Vector3>(lhs: Self, rhs: V) -> Self {
        return Self(lhs.x + rhs.x,
                    lhs.y + rhs.y,
                    lhs.z + rhs.z)
    }
    @_transparent
    public static func +=<V: Vector3>(lhs: inout Self, rhs: V) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
    }
    
    //Subtraction
    @_transparent
    public static func -<V: Vector3>(lhs: Self, rhs: V) -> Self {
        return Self(lhs.x - rhs.x,
                    lhs.y - rhs.y,
                    lhs.z - rhs.z)
    }
    @_transparent
    public static func -=<V: Vector3>(lhs: inout Self, rhs: V) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
        lhs.z -= rhs.z
    }
}

extension Vector3 {
    //Division
    @_transparent
    public static func /<V: Vector3>(lhs: Self, rhs: V) -> Self {
        return Self(lhs.x / rhs.x,
                    lhs.y / rhs.y,
                    lhs.z / rhs.z)
    }
    @_transparent
    public static func /=<V: Vector3>(lhs: inout Self, rhs: V) {
        lhs.x /= rhs.x
        lhs.y /= rhs.y
        lhs.z /= rhs.z
    }
}

//MARK: Matrix4
public extension Vector3 {
    @_transparent
    static func *(lhs: Self, rhs: Matrix4x4) -> Self {
        var x: Float = lhs.x * rhs.a
        x += lhs.y * rhs.b
        x += lhs.z * rhs.c
        x += rhs.d
        
        var y: Float = lhs.x * rhs.e
        y += lhs.y * rhs.f
        y += lhs.z * rhs.g
        y += rhs.h
        
        var z: Float = lhs.x * rhs.i
        z += lhs.y * rhs.j
        z += lhs.z * rhs.k
        z += rhs.l
        
        return Self(x, y, z)
    }
    
    @_transparent
    static func *(lhs: Matrix4x4, rhs: Self) -> Self {
        var x: Float = rhs.x * lhs.a
        x += rhs.y * lhs.e
        x += rhs.z * lhs.i
        x += lhs.m
        
        var y: Float = rhs.x * lhs.b
        y += rhs.y * lhs.f
        y += rhs.z * lhs.j
        y += lhs.n
        
        var z: Float = rhs.x * lhs.c
        z += rhs.y * lhs.g
        z += rhs.z * lhs.k
        z += lhs.o
        
        return Self(x, y, z)
    }
    
    @_transparent
    static func *(lhs: Self, rhs: Matrix3x3) -> Self {
        var vector: Self = .zero
        
        for i in 0 ..< 3 {
            for j in 0 ..< 3 {
                vector[i] += lhs[j] * rhs[i][j]
            }
        }
        return vector
    }
}

extension Vector3 {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([x, y, z])
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode(Array<Float>.self)
        self.init(values[0], values[1], values[2])
    }
}

extension Vector3 {
    @inlinable
    public func valuesArray() -> [Float] {return [x, y, z]}
}
