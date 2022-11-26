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

#if GameMathUseSIMD
public struct Quaternion: SIMD {
    public typealias Scalar = Float
    public typealias MaskStorage = SIMD4<Float>.MaskStorage
    public typealias ArrayLiteralElement = Scalar
    
    @usableFromInline
    var _storage = Float.SIMD4Storage()
    
    @inline(__always)
    public var scalarCount: Int {_storage.scalarCount}

    public init(arrayLiteral elements: Self.ArrayLiteralElement...) {
        for index in elements.indices {
            _storage[index] = elements[index]
        }
    }
    
    public var w: Scalar {
        @_transparent get {
            return _storage[0]
        }
        @_transparent set {
            _storage[0] = newValue
        }
    }
    public var x: Scalar {
        @_transparent get {
            return _storage[1]
        }
        @_transparent set {
            _storage[1] = newValue
        }
    }
    public var y: Scalar {
        @_transparent get {
            return _storage[2]
        }
        @_transparent set {
            _storage[2] = newValue
        }
    }
    public var z: Scalar {
        @_transparent get {
            return _storage[3]
        }
        @_transparent set {
            _storage[3] = newValue
        }
    }
    
    public init() {
        
    }
    
    public init(w: Float, x: Float, y: Float, z: Float) {
        self.w = w
        self.x = x
        self.y = y
        self.z = z
    }
}
#else
public struct Quaternion {
    public var w, x, y, z: Float
    
    public init(w: Float, x: Float, y: Float, z: Float) {
        self.w = w
        self.x = x
        self.y = y
        self.z = z
    }
}
#endif

public extension Quaternion {
    subscript (_ index: Array<Float>.Index) -> Float {
        @inline(__always) get {
            switch index {
            case 0: return w
            case 1: return x
            case 2: return y
            case 3: return z
            default:
                fatalError("Index \(index) out of range \(0..<4) for type \(type(of: self))")
            }
        }
        @inline(__always) set {
            switch index {
            case 0: w = newValue
            case 1: x = newValue
            case 2: y = newValue
            case 3: z = newValue
            default:
                fatalError("Index \(index) out of range \(0..<4) for type \(type(of: self))")
            }
        }
    }
}

extension Quaternion {
    @inline(__always)
    public init(direction: Direction3, up: Direction3 = .up, right: Direction3 = .right) {
        self = Matrix3x3(direction: direction, up: up, right: right).rotation
    }
    
    public init(between v1: Direction3, and v2: Direction3) {
        let cosTheta = v1.dot(v2)
        let k = (v1.squaredLength * v2.squaredLength).squareRoot()
        
        if cosTheta / k == -1 {
            self = Quaternion(Radians(0), axis: v1.orthogonal())
        }else{
            self = Quaternion(Radians(cosTheta + k), axis: v1.cross(v2))
        }
    }
    
    /**
     Initialize as degrees around `axis`
     - parameter degrees: The angle to rotate
     - parameter axis: The direction to rotate around
     */
    public init(_ angle: any Angle, axis: Direction3) {
        // Will always be radians (becuase degrees is explicitly below), but leave ambiguous so degrees can use a literal
        let radians = angle.rawValueAsRadians
        let sinHalfAngle: Float = sin(radians / 2.0)
        let cosHalfAngle: Float = cos(radians / 2.0)
        
        x = axis.x * sinHalfAngle
        y = axis.y * sinHalfAngle
        z = axis.z * sinHalfAngle
        w = cosHalfAngle
    }
    
    /**
     Initialize as degrees around `axis`
     - parameter degrees: The angle to rotate
     - parameter axis: The direction to rotate around
     - note: Allows initialization with `degrees` as a literial. Example: `Quaternion(180, axis: .up)`.
     */
    @inline(__always)
    public init(_ degrees: Degrees, axis: Direction3) {
        self.init(Radians(degrees), axis: axis)
    }
    
    public init(pitch: Degrees, yaw: Degrees, roll: Degrees) {
        let _pitch: Radians = Radians(pitch)
        let _yaw: Radians = Radians(yaw)
        let _roll: Radians = Radians(roll)
        let cy: Float = cos(_roll.rawValue * 0.5)
        let sy: Float = sin(_roll.rawValue * 0.5)
        let cp: Float = cos(_yaw.rawValue * 0.5)
        let sp: Float = sin(_yaw.rawValue * 0.5)
        let cr: Float = cos(_pitch.rawValue * 0.5)
        let sr: Float = sin(_pitch.rawValue * 0.5)

        self.x = sr * cp * cy - cr * sp * sy
        self.y = cr * sp * cy + sr * cp * sy
        self.z = cr * cp * sy - sr * sp * cy
        self.w = cr * cp * cy + sr * sp * sy
    }
}

extension Quaternion {
    public init(rotationMatrix rot: Matrix4x4) {
        let trace: Float = rot.a + rot.f + rot.k
        
        if trace > 0 {
            let s: Float = 0.5 / (trace + 1.0).squareRoot()
            w = 0.25 / s
            x = (rot.g - rot.j) * s
            y = (rot.i - rot.c) * s
            z = (rot.b - rot.e) * s
        }else{
            if rot.a > rot.f && rot.a > rot.k {
                let s: Float = 2.0 * (1.0 + rot.a - rot.f - rot.k).squareRoot()
                w = (rot.g - rot.j) / s
                x = 0.25 * s
                y = (rot.e + rot.b) / s
                z = (rot.i + rot.c) / s
            }else if rot.f > rot.k {
                let s: Float = 2.0 * (1.0 + rot.f - rot.a - rot.k).squareRoot()
                w = (rot.i - rot.c) / s
                x = (rot.e + rot.b) / s
                y = 0.25 * s
                z = (rot.j + rot.g) / s
            }else{
                let s: Float = 2.0 * (1.0 + rot.k - rot.a - rot.f).squareRoot()
                w = (rot.b - rot.e) / s
                x = (rot.i + rot.c) / s
                y = (rot.g + rot.j) / s
                z = 0.25 * s
            }
        }
        
        //Normalize
        let length: Float = self.magnitude
        x /= length;
        y /= length;
        z /= length;
        w /= length;
    }
    
    public init(rotationMatrix rot: Matrix3x3) {
        let trace: Float = rot.a + rot.f + rot.k
        
        if trace > 0 {
            let s: Float = 0.5 / (trace + 1.0).squareRoot()
            w = 0.25 / s
            x = (rot.g - rot.j) * s
            y = (rot.i - rot.c) * s
            z = (rot.b - rot.e) * s
        }else{
            if rot.a > rot.f && rot.a > rot.k {
                let s: Float = 2.0 * (1.0 + rot.a - rot.f - rot.k).squareRoot()
                w = (rot.g - rot.j) / s
                x = 0.25 * s
                y = (rot.e + rot.b) / s
                z = (rot.i + rot.c) / s
            }else if rot.f > rot.k {
                let s: Float = 2.0 * (1.0 + rot.f - rot.a - rot.k).squareRoot()
                w = (rot.i - rot.c) / s
                x = (rot.e + rot.b) / s
                y = 0.25 * s
                z = (rot.j + rot.g) / s
            }else{
                let s: Float = 2.0 * (1.0 + rot.k - rot.a - rot.f).squareRoot()
                w = (rot.b - rot.e) / s
                x = (rot.i + rot.c) / s
                y = (rot.g + rot.j) / s
                z = 0.25 * s
            }
        }
        
        //Normalize
        let length: Float = self.magnitude
        x /= length;
        y /= length;
        z /= length;
        w /= length;
    }
}

extension Quaternion {
    public mutating func lookAt(_ target: Position3, from source: Position3) {
        let forwardVector: Position3 = (source - target).normalized
        let dot: Float = Direction3.forward.dot(forwardVector)
        
        if abs(dot - -1) < .ulpOfOne {
            self.w = .pi
            self.direction = .up
        }else if abs(dot - 1) < .ulpOfOne {
            self.w = 1
            self.direction = .zero
        }else{
            let angle: Float = acos(dot)
            let axis: Direction3 = .forward.cross(forwardVector).normalized
            
            let halfAngle: Float = angle * 0.5
            let s: Float = sin(halfAngle)
            x = axis.x * s
            y = axis.y * s
            z = axis.z * s
            w = cos(halfAngle)
        }
        self = self.conjugate
    }
}

extension Quaternion {
    public enum LookAtConstraint {
        case none
        case justYaw
        case justPitch
        case pitchAndYaw
    }
    
    public init(lookingAt target: Position3, from source: Position3, up: Direction3 = .up, right: Direction3 = .right, constraint: LookAtConstraint, isCamera: Bool = false) {
        self.init(Direction3(from: source, to: target), up: up, right: right, constraint: constraint, isCamera: isCamera)
    }
    
    /**
     Creates a quaternion a forward direction and optionally constrained to an Euler angle.
     - Parameter direction: The forward axis
     - Parameter up: The relative up vector, defualt is  `Direction3.up`.
     - Parameter right: The relative right axis. Defualt value is  `Direction3.right`.
     - Parameter constraint: Limits the rotation to an Euler angle. Use this to look in directions without a roll.
     */
    public init(_ direction: Direction3, up: Direction3 = .up, right: Direction3 = .right, constraint: LookAtConstraint, isCamera: Bool = false) {
        switch constraint {
        case .none:
            self.init(direction: direction, up: up, right: right)
        case .justPitch:
            let magnitude = Direction2(x: direction.x, y: direction.z).magnitude
            if isCamera {
                self.init(Radians(atan2(direction.y, magnitude)), axis: right)
            }else{
                self.init(Radians(-atan2(direction.y, magnitude)), axis: right)
            }
        case .justYaw:
            self.init(direction.angleAroundY, axis: up)
            if isCamera {
                self *= Quaternion(180, axis: .up)
            }
        case .pitchAndYaw:
            self = Self(direction, up: up, right: right, constraint: .justYaw, isCamera: isCamera)
                * Self(direction, up: up, right: right, constraint: .justPitch, isCamera: isCamera)
        }
    }
}

public extension Quaternion {
    @inline(__always)
    var isFinite: Bool {
        return x.isFinite && y.isFinite && z.isFinite && w.isFinite
    }
    
    @inline(__always)
    var squaredLength: Float {
        var value: Float
        value  = x * x
        value += y * y
        value += z * z
        value += w * w
        return value
    }
    
    @inline(__always)
    var magnitude: Float {
        return squaredLength.squareRoot()
    }
    
    @inline(__always)
    var normalized: Self {
        let magnitude: Float = self.magnitude
        return Self(w: w / magnitude, x: x / magnitude, y: y / magnitude, z: z / magnitude)
    }
    
    @inline(__always)
    mutating func normalize() {
        self = self.normalized
    }
}

public extension Quaternion {
    @inline(__always)
    var direction: Direction3 {
        get {
            return Direction3(x: x, y: y, z: z)
        }
        set {
            self.x = newValue.x
            self.y = newValue.y
            self.z = newValue.z
        }
    }
    
    @inline(__always)
    var forward: Direction3 {
        return Direction3.forward.rotated(by: self)
    }
    @inline(__always)
    var backward: Direction3 {
        return Direction3.backward.rotated(by: self)
    }
    @inline(__always)
    var up: Direction3 {
        return Direction3.up.rotated(by: self)
    }
    @inline(__always)
    var down: Direction3 {
        return Direction3.down.rotated(by: self)
    }
    @inline(__always)
    var left: Direction3 {
        return Direction3.left.rotated(by: self)
    }
    @inline(__always)
    var right: Direction3 {
        return Direction3.right.rotated(by: self)
    }
}

public extension Quaternion {
    static let zero = Self(Radians(0), axis: .forward)
    
    @inline(__always)
    var inverse: Self {
        var absoluteValue: Float = magnitude
        absoluteValue *= absoluteValue
        absoluteValue = 1 / absoluteValue
        
        let conjugateValue = conjugate
        
        let w: Float = conjugateValue.w * absoluteValue
        let vector = conjugateValue.direction * absoluteValue
        return Self(Radians(w), axis: vector)
    }
}

public extension Quaternion {
    @inline(__always)
    var conjugate: Self {
        return Self(w: w, x: -x, y: -y, z: -z)
    }
    @inline(__always)
    var transposed: Self {
        return Matrix4x4(rotation: self).transposed().rotation
    }
}

public extension Quaternion {
    @inline(__always)
    func interpolated(to: Self, _ method: InterpolationMethod) -> Self {
        switch method {
        case let .linear(factor, shortest):
            if shortest {
                return self.slerped(to: to, factor: factor)
            }else{
                return self.lerped(to: to, factor: factor)
            }
        }
    }
    
    @inline(__always)
    mutating func interpolate(to: Self, _ method: InterpolationMethod) {
        self = self.interpolated(to: to, method)
    }
}

internal extension Quaternion {
    @inline(__always) @usableFromInline
    func lerped(to q2: Self, factor t: Float) -> Self {
        var qr: Quaternion = .zero
        
        let t_ = 1 - t
        qr.x = t_ * self.x + t * q2.x
        qr.y = t_ * self.y + t * q2.y
        qr.z = t_ * self.z + t * q2.z
        qr.w = t_ * self.w + t * q2.w
        
        return qr
    }
    
    @inline(__always) @usableFromInline
    mutating func lerp(to q2: Self, factor: Float) {
        self = self.lerped(to: q2, factor: factor)
    }
    
    @inline(__always) @usableFromInline
    func slerped(to destination: Self, factor t: Float) -> Self {
        // Adapted from javagl.JglTF
        
        let a: Self = self
        let b: Self = destination
        
        let aw: Float = a.w
        let ax: Float = a.x
        let ay: Float = a.y
        let az: Float = a.z
        
        var bw: Float = b.w
        var bx: Float = b.x
        var by: Float = b.y
        var bz: Float = b.z
        
        var dot: Float = ax * bx + ay * by + az * bz + aw * bw
        if dot < 0 {
            bx = -bx
            by = -by
            bz = -bz
            bw = -bw
            dot = -dot
        }
        var s0: Float
        var s1: Float
        if (1 - dot) > .ulpOfOne {
            let omega: Float = acos(dot)
            let invSinOmega = 1 / sin(omega)
            s0 = sin((1 - t) * omega) * invSinOmega
            s1 = sin(t * omega) * invSinOmega
        }else{
            s0 = 1 - t
            s1 = t
        }
        
        let rx = s0 * ax + s1 * bx
        let ry = s0 * ay + s1 * by
        let rz = s0 * az + s1 * bz
        let rw = s0 * aw + s1 * bw

        return Quaternion(w: rw, x: rx, y: ry, z: rz)
    }
    
    @inline(__always) @usableFromInline
    func _slerped(to qb: Self, factor t: Float) -> Self {
        let qa: Self = self
        var qb: Self = qb
        // Calculate angle between them.
        var cosHalfTheta: Float = qa.w * qb.w
        cosHalfTheta += qa.x * qb.x
        cosHalfTheta += qa.y * qb.y
        cosHalfTheta += qa.z * qb.z
        if cosHalfTheta < 0 {
            qb.w = -qb.w
            qb.x = -qb.x
            qb.y = -qb.y
            cosHalfTheta = -cosHalfTheta
        }
        // if qa=qb or qa=-qb then theta = 0 and we can return qa
        if abs(cosHalfTheta) >= 1 {
            return qa
        }
        
        // quaternion to return
        var qm: Quaternion = Quaternion(w: 1, x: 0, y: 0, z: 0)
        
        // Calculate temporary values.
        let halfTheta: Float = acos(cosHalfTheta)
        let sinHalfTheta: Float = sqrt(1 - cosHalfTheta * cosHalfTheta)
        // if theta = 180 degrees then result is not fully defined
        // we could rotate around any axis normal to qa or qb
        if abs(sinHalfTheta) < 0.001 { // fabs is floating point absolute
            qm.w = (qa.w * 0.5 + qb.w * 0.5)
            qm.x = (qa.x * 0.5 + qb.x * 0.5)
            qm.y = (qa.y * 0.5 + qb.y * 0.5)
            qm.z = (qa.z * 0.5 + qb.z * 0.5)
            return qm
        }
        let ratioA: Float = sin((1 - t) * halfTheta) / sinHalfTheta
        let ratioB: Float = sin(t * halfTheta) / sinHalfTheta
        //calculate Quaternion.
        qm.w = (qa.w * ratioA + qb.w * ratioB)
        qm.x = (qa.x * ratioA + qb.x * ratioB)
        qm.y = (qa.y * ratioA + qb.y * ratioB)
        qm.z = (qa.z * ratioA + qb.z * ratioB)
        return qm
    }
    
    @inline(__always) @usableFromInline
    mutating func slerp(to qb: Self, factor: Float) {
        self = self.slerped(to: qb, factor: factor)
    }
}

#if !GameMathUseSIMD
public extension Quaternion {
    @inline(__always)
    static func *(lhs: Self, rhs: Float) -> Self {
        return Self(w: lhs.w * rhs, x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }
    @inline(__always)
    static func /(lhs: Self, rhs: Float) -> Self {
        return Self(w: lhs.w / rhs, x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }
    @inline(__always)
    static func /=(lhs: inout Self, rhs: Float) {
        lhs = lhs / rhs
    }
    @inline(__always)
    static func +=(lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    @inline(__always)
    static func +(lhs: Self, rhs: Self) -> Self {
        return Self(w: lhs.w + rhs.w, x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    @inline(__always)
    static func -=(lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    @inline(__always)
    static func -(lhs: Self, rhs: Self) -> Self {
        return Self(w: lhs.w - rhs.w, x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
}
#endif

public extension Quaternion {
    @inline(__always)
    static func *=(lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    @inline(__always)
    static func *(lhs: Self, rhs: Self) -> Self {
        var w: Float = lhs.w * rhs.w
        w -= lhs.x * rhs.x
        w -= lhs.y * rhs.y
        w -= lhs.z * rhs.z
        var x: Float = lhs.x * rhs.w
        x += lhs.w * rhs.x
        x += lhs.y * rhs.z
        x -= lhs.z * rhs.y
        var y: Float = lhs.y * rhs.w
        y += lhs.w * rhs.y
        y += lhs.z * rhs.x
        y -= lhs.x * rhs.z
        var z: Float = lhs.z * rhs.w
        z += lhs.w * rhs.z
        z += lhs.x * rhs.y
        z -= lhs.y * rhs.x
        
        return Self(w: w, x: x, y: y, z: z)
    }
    
    @inline(__always)
    static func *=<V: Vector2>(lhs: inout Self, rhs: V) {
        lhs = lhs * rhs
    }
    @inline(__always)
    static func *<V: Vector2>(lhs: Self, rhs: V) -> Self {
        var w: Float = -lhs.x * rhs.x
        w -= lhs.y * rhs.y
        var x: Float =  lhs.w * rhs.x
        x -= lhs.z * rhs.y
        var y: Float =  lhs.w * rhs.y
        y += lhs.z * rhs.x
        var z: Float =  lhs.x * rhs.y
        z -= lhs.y * rhs.x
        return Self(w: w, x: x, y: y, z: z)
    }
    
    @inline(__always)
    static func *=<V: Vector3>(lhs: inout Self, rhs: V) {
        lhs = lhs * rhs
    }
    @inline(__always)
    static func *<V: Vector3>(lhs: Self, rhs: V) -> Self {
        var w: Float = -lhs.x * rhs.x
        w -= lhs.y * rhs.y
        w -= lhs.z * rhs.z
        var x: Float =  lhs.w * rhs.x
        x += lhs.y * rhs.z
        x -= lhs.z * rhs.y
        var y: Float =  lhs.w * rhs.y
        y += lhs.z * rhs.x
        y -= lhs.x * rhs.z
        var z: Float =  lhs.w * rhs.z
        z += lhs.x * rhs.y
        z -= lhs.y * rhs.x
        return Self(w: w, x: x, y: y, z: z)
    }
}

//MARK: - SIMD
public extension Quaternion {
    var simd: SIMD4<Float> {
        @inline(__always) get {
            return SIMD4<Float>(w, x, y, z)
        }
        @inline(__always) set {
            w = newValue[0]
            x = newValue[1]
            y = newValue[2]
            z = newValue[3]
        }
    }
}

extension Quaternion: Equatable {}
extension Quaternion: Hashable {}

extension Quaternion: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([w, x, y, z])
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode(Array<Float>.self)
        
        self.w = values[0]
        self.x = values[1]
        self.y = values[2]
        self.z = values[3]
    }
}
