/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * http://stregasgate.com
 */

import Foundation
#if GameMathUseSIMD && canImport(simd)
import simd
#endif

#if GameMathUseSIMD && canImport(Accelerate)
import Accelerate
#endif

#if GameMathUseSIMD
public protocol Vector3: SIMD, Equatable where Scalar == Float, MaskStorage == SIMD3<Float>.MaskStorage, ArrayLiteralElement == Scalar {
    var x: Scalar {get set}
    var y: Scalar {get set}
    var z: Scalar {get set}
    init(_ x: Scalar, _ y: Scalar, _ z: Scalar)
    
    static var zero: Self {get}
}
#else
public protocol Vector3: Equatable {
    var x: Float {get set}
    var y: Float {get set}
    var z: Float {get set}
    init(_ x: Float, _ y: Float, _ z: Float)
    
    static var zero: Self {get}
}
#endif

#if GameMathUseSIMD
public extension Vector3 {
    @inline(__always)
    var scalarCount: Int {return 3}
    
    @inline(__always)
    init(_ simd: SIMD3<Float>) {
        self.init(simd[0], simd[1], simd[2])
    }
}
#endif
 
public extension Vector3 {
    subscript (_ index: Array<Float>.Index) -> Float {
        @inline(__always) get {
            switch index {
            case 0: return x
            case 1: return y
            case 2: return z
            default:
                fatalError("Index \(index) out of range \(0..<3) for type \(type(of: self))")
            }
        }
        @inline(__always) set {
            switch index {
            case 0: x = newValue
            case 1: y = newValue
            case 2: z = newValue
            default:
                fatalError("Index \(index) out of range \(0..<3) for type \(type(of: self))")
            }
        }
    }
}

extension Vector3 {
    @inline(__always)
    public init(_ value: Float) {
        self.init(value, value, value)
    }
    
    public init(_ values: [Float]) {
        assert(values.isEmpty || values.count == 3, "values must be empty or have 3 elements. Use init(_:) to fill with a single value.")
        if values.isEmpty {
            self.init(0, 0, 0)
        }else{
            self.init(values[0], values[1], values[2])
        }
    }
}

//Mark: Integer Casting
extension Vector3 {
    @inline(__always)
    public init<V: Vector3>(_ value: V) {
        self = Self(value.x, value.y, value.z)
    }
    @inline(__always)
    public init() {
        self.init(0, 0, 0)
    }
}

extension Vector3 {
    @inline(__always)
    public var isFinite: Bool {
        return x.isFinite && y.isFinite && z.isFinite
    }
}

extension Vector3 {
    @inline(__always)
    public func dot<V: Vector3>(_ vector: V) -> Float {
        #if GameMathUseSIMD && canImport(simd)
        return simd_dot(self.simd, vector.simd)
        #else
        return (x * vector.x) + (y * vector.y) + (z * vector.z)
        #endif
    }
    
    @inline(__always)
    public func cross<V: Vector3>(_ vector: V) -> Self {
        #if GameMathUseSIMD && canImport(simd)
        return Self(simd_cross(self.simd, vector.simd))
        #else
        return Self(y * vector.z - z * vector.y,
                    z * vector.x - x * vector.z,
                    x * vector.y - y * vector.x)
        #endif
       
    }
}

extension Vector3 {
    @inline(__always)
    public var length: Float {
        #if GameMathUseSIMD
        return self.sum()
        #else
        return x + y + z
        #endif
    }
    
    @inline(__always)
    public var squaredLength: Float {
        #if GameMathUseSIMD && canImport(simd)
        return simd_length_squared(self.simd)
        #else
        return x * x + y * y + z * z
        #endif
    }
    
    @inline(__always)
    public var magnitude: Float {
        return squaredLength.squareRoot()
    }

    #if !GameMathUseFastInverseSquareRoot
    @inline(__always)
    public var normalized: Self {
        var copy = self
        copy.normalize()
        return copy
    }
    
    @inline(__always)
    public mutating func normalize() {
        if self != Self.zero {
            #if GameMathUseSIMD && canImport(simd)
            self.simd = simd_fast_normalize(self.simd)
            #else
            let magnitude = self.magnitude
            let factor = 1 / magnitude
            self *= factor
            #endif
        }
    }
    #endif
    
    @inline(__always)
    public func squareRoot() -> Self {
        #if GameMathUseSIMD && canImport(Accelerate)
        if #available(macOS 10.15, macCatalyst 13, iOS 13, tvOS 13, watchOS 13, *) {
            let count = 3
            let values = [Float](unsafeUninitializedCapacity: count) { buffer, initializedCount in
                vForce.sqrt(self.valuesArray(), result: &buffer)
                initializedCount = count
            }
            return Self(values)
        }else{
            return Self(x.squareRoot(), y.squareRoot(), z.squareRoot())
        }
        #else
            return Self(x.squareRoot(), y.squareRoot(), z.squareRoot())
        #endif
    }
}

extension Vector3 {
    @inline(__always)
    public func interpolated<V: Vector3>(to: V, _ method: InterpolationMethod) -> Self {
        var copy = self
        copy.x.interpolate(to: to.x, method)
        copy.y.interpolate(to: to.y, method)
        copy.z.interpolate(to: to.z, method)
        return copy
    }
    @inline(__always)
    public mutating func interpolate<V: Vector3>(to: V, _ method: InterpolationMethod) {
        self.x.interpolate(to: to.x, method)
        self.y.interpolate(to: to.y, method)
        self.z.interpolate(to: to.z, method)
    }
}

public extension Vector3 {
    @inline(__always)
    var max: Float {
        #if GameMathUseSIMD
        return self.max()
        #else
        return Swift.max(x, Swift.max(y, z))
        #endif
        
    }
    @inline(__always)
    var min: Float {
        #if GameMathUseSIMD
        return self.min()
        #else
        return Swift.min(x, Swift.min(y, z))
        #endif
    }
}

//MARK: - SIMD
public extension Vector3 {
    var simd: SIMD3<Float> {
        @inline(__always) get {
            return SIMD3<Float>(x, y, z)
        }
        @inline(__always) set {
            x = newValue[0]
            y = newValue[1]
            z = newValue[2]
        }
    }
}

//MARK: - Operations
@inline(__always)
public func ceil<V: Vector3>(_ v: V) -> V {
    return V.init(ceil(v.x), ceil(v.y), ceil(v.z))
}

@inline(__always)
public func floor<V: Vector3>(_ v: V) -> V {
    return V.init(floor(v.x), floor(v.y), floor(v.z))
}

@inline(__always)
public func round<V: Vector3>(_ v: V) -> V {
    return V.init(round(v.x), round(v.y), round(v.z))
}

@inline(__always)
public func abs<V: Vector3>(_ v: V) -> V {
    return V.init(abs(v.x), abs(v.y), abs(v.z))
}

@inline(__always)
public func min<V: Vector3>(_ lhs: V, _ rhs: V) -> V {
    return V.init(min(lhs.x, rhs.x), min(lhs.y, rhs.y), min(lhs.z, rhs.z))
}

@inline(__always)
public func max<V: Vector3>(_ lhs: V, _ rhs: V) -> V {
    return V.init(max(lhs.x, rhs.x), max(lhs.y, rhs.y), max(lhs.z, rhs.z))
}


#if !GameMathUseSIMD
//MARK: Operators (Self)
extension Vector3 {
    //Multiplication
    @inline(__always)
    public static func *(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs
        lhs *= rhs
        return lhs
    }
    @inline(__always)
    public static func *=(lhs: inout Self, rhs: Self) {
        #if GameMathUseLoopVectorization
        for index in 0 ..< 3 {
            lhs[index] *= rhs[index]
        }
        #else
        lhs.x *= rhs.x
        lhs.y *= rhs.y
        lhs.z *= rhs.z
        #endif
    }
    
    //Addition
    @inline(__always)
    public static func +(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs
        lhs += rhs
        return lhs
    }
    @inline(__always)
    public static func +=(lhs: inout Self, rhs: Self) {
        #if GameMathUseLoopVectorization
        for index in 0 ..< 3 {
            lhs[index] += rhs[index]
        }
        #else
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
        #endif
    }
    
    //Subtraction
    @inline(__always)
    public static func -(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs
        lhs -= rhs
        return lhs
    }
    @inline(__always)
    public static func -=(lhs: inout Self, rhs: Self) {
        #if GameMathUseLoopVectorization
        for index in 0 ..< 3 {
            lhs[index] -= rhs[index]
        }
        #else
        lhs.x -= rhs.x
        lhs.y -= rhs.y
        lhs.z -= rhs.z
        #endif
    }
}
extension Vector3 {
    //Division
    @inline(__always)
    public static func /(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs
        lhs /= rhs
        return lhs
    }
    @inline(__always)
    public static func /=(lhs: inout Self, rhs: Self) {
        #if GameMathUseLoopVectorization
        for index in 0 ..< 3 {
            lhs[index] /= rhs[index]
        }
        #else
        lhs.x /= rhs.x
        lhs.y /= rhs.y
        lhs.z /= rhs.z
        #endif
    }
}

//MARK: Operators (Integers and Floats)
extension Vector3 {
    //Multiplication Without Casting
    @inline(__always)
    public static func *(lhs: Self, rhs: Float) -> Self {
        var lhs = lhs
        lhs *= rhs
        return lhs
    }
    @inline(__always)
    public static func *=(lhs: inout Self, rhs: Float) {
        #if GameMathUseLoopVectorization
        for index in 0 ..< 3 {
            lhs[index] *= rhs
        }
        #else
        lhs.x *= rhs
        lhs.y *= rhs
        lhs.z *= rhs
        #endif
    }
    
    //Addition Without Casting
    @inline(__always)
    public static func +(lhs: Self, rhs: Float) -> Self {
        var lhs = lhs
        lhs += rhs
        return lhs
    }
    @inline(__always)
    public static func +=(lhs: inout Self, rhs: Float) {
        #if GameMathUseLoopVectorization
        for index in 0 ..< 3 {
            lhs[index] += rhs
        }
        #else
        lhs.x += rhs
        lhs.y += rhs
        lhs.z += rhs
        #endif
    }
    
    //Subtraction Without Casting
    @inline(__always)
    public static func -(lhs: Self, rhs: Float) -> Self {
        var lhs = lhs
        lhs -= rhs
        return lhs
    }
    @inline(__always)
    public static func -=(lhs: inout Self, rhs: Float) {
        #if GameMathUseLoopVectorization
        for index in 0 ..< 3 {
            lhs[index] -= rhs
        }
        #else
        lhs.x -= rhs
        lhs.y -= rhs
        lhs.z -= rhs
        #endif
    }
}

extension Vector3 {
    //Division Without Casting
    @inline(__always)
    public static func /(lhs: Self, rhs: Float) -> Self {
        var lhs = lhs
        lhs /= rhs
        return lhs
    }
    @inline(__always)
    public static func /=(lhs: inout Self, rhs: Float) {
        #if GameMathUseLoopVectorization
        for index in 0 ..< 3 {
            lhs[index] /= rhs
        }
        #else
        lhs.x /= rhs
        lhs.y /= rhs
        lhs.z /= rhs
        #endif
    }
}

extension Vector3 {
    @inline(__always)
    public static prefix func -(rhs: Self) -> Self {
        return Self(-rhs.x, -rhs.y, -rhs.z)
    }

    @inline(__always)
    public static prefix func +(rhs: Self) -> Self {
        return Self(+rhs.x, +rhs.y, +rhs.z)
    }
}
#endif

extension Vector3 {
    //Multiplication
    @inline(__always)
    public static func *<V: Vector3>(lhs: Self, rhs: V) -> Self {
        var lhs = lhs
        lhs *= rhs
        return lhs
    }
    @inline(__always)
    public static func *=<V: Vector3>(lhs: inout Self, rhs: V) {
        #if GameMathUseSIMD
        lhs.simd *= rhs.simd
        #elseif GameMathUseLoopVectorization
        for index in 0 ..< 3 {
            lhs[index] *= rhs[index]
        }
        #else
        lhs.x *= rhs.x
        lhs.y *= rhs.y
        lhs.z *= rhs.z
        #endif
    }
    
    //Addition
    @inline(__always)
    public static func +<V: Vector3>(lhs: Self, rhs: V) -> Self {
        var lhs = lhs
        lhs += rhs
        return lhs
    }
    @inline(__always)
    public static func +=<V: Vector3>(lhs: inout Self, rhs: V) {
        #if GameMathUseSIMD
        lhs.simd += rhs.simd
        #elseif GameMathUseLoopVectorization
        for index in 0 ..< 3 {
            lhs[index] += rhs[index]
        }
        #else
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
        #endif
    }
    
    //Subtraction
    @inline(__always)
    public static func -<V: Vector3>(lhs: Self, rhs: V) -> Self {
        var lhs = lhs
        lhs -= rhs
        return lhs
    }
    @inline(__always)
    public static func -=<V: Vector3>(lhs: inout Self, rhs: V) {
        #if GameMathUseSIMD
        lhs.simd -= rhs.simd
        #elseif GameMathUseLoopVectorization
        for index in 0 ..< 3 {
            lhs[index] -= rhs[index]
        }
        #else
        lhs.x -= rhs.x
        lhs.y -= rhs.y
        lhs.z -= rhs.z
        #endif
    }
}

extension Vector3 {
    //Division
    @inline(__always)
    public static func /<V: Vector3>(lhs: Self, rhs: V) -> Self {
        var lhs = lhs
        lhs /= rhs
        return lhs
    }
    @inline(__always)
    public static func /=<V: Vector3>(lhs: inout Self, rhs: V) {
        #if GameMathUseSIMD
        lhs.simd /= rhs.simd
        #elseif GameMathUseLoopVectorization
        for index in 0 ..< 3 {
            lhs[index] /= rhs[index]
        }
        #else
        lhs.x /= rhs.x
        lhs.y /= rhs.y
        lhs.z /= rhs.z
        #endif
    }
}

//MARK: Matrix4
public extension Vector3 {
    @inline(__always)
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
    
    @inline(__always)
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
    
    @inline(__always)
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

extension Vector3 where Self: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([x, y, z])
    }
}
extension Vector3 where Self: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode(Array<Float>.self)
        self.init(values[0], values[1], values[2])
    }
}

extension Vector3 {
    @inline(__always)
    public func valuesArray() -> [Float] {return [x, y, z]}
}
