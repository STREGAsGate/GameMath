/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * http://stregasgate.com
 */

import Foundation

#if GameMathUseSIMD
public struct Quaternion {
    public var w, x, y, z: Float
    
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

extension Quaternion {
    public init(direction: Direction3, up: Direction3 = .up, right: Direction3 = .right) {
        self = Matrix3x3(direction: direction.normalized).rotation.normalized
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
    
    public init(_ radians: Radians, axis: Direction3) {
        let sinHalfAngle: Float = sin(radians.rawValue / 2.0)
        let cosHalfAngle: Float = cos(radians.rawValue / 2.0)
        
        x = axis.x * sinHalfAngle
        y = axis.y * sinHalfAngle
        z = axis.z * sinHalfAngle
        w = cosHalfAngle
    }
    
    public init(_ degrees: Degrees, axis: Direction3) {
        self.init(Radians(degrees), axis: axis)
    }
    
    public init(pitch: Degrees, yaw: Degrees, roll: Degrees) {
        let cy = cos(roll.rawValue * 0.5)
        let sy = sin(roll.rawValue * 0.5)
        let cp = cos(yaw.rawValue * 0.5)
        let sp = sin(yaw.rawValue * 0.5)
        let cr = cos(pitch.rawValue * 0.5)
        let sr = sin(pitch.rawValue * 0.5)

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
        let forwardVector = (source - target).normalized
        let dot = Direction3.forward.dot(forwardVector)
        
        if abs(dot - -1) < .ulpOfOne {
            self.w = .pi
            self.direction = .up
        }else if abs(dot - 1) < .ulpOfOne {
            self.w = 1
            self.direction = .zero
        }else{
            let angle: Float = acos(dot)
            let axis = Direction3.forward.cross(forwardVector).normalized
            
            let halfAngle: Float = angle * 0.5
            let s: Float = sin(halfAngle)
            x = axis.x * s
            y = axis.y * s
            z = axis.z * s
            w = cos(halfAngle)
        }
        self = self.normalized.conjugate
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
                self *= Quaternion(Degrees(180), axis: .up)
            }
        case .pitchAndYaw:
            self = Self(direction, up: up, right: right, constraint: .justYaw, isCamera: isCamera)
                * Self(direction, up: up, right: right, constraint: .justPitch, isCamera: isCamera)
        }
    }
}

public extension Quaternion {
    var isFinite: Bool {
        return x.isFinite && y.isFinite && z.isFinite && w.isFinite
    }
    
    var squaredLength: Float {
        var value: Float = x * x
        value += y * y
        value += z * z
        value += w * w
        return value
    }
    
    var magnitude: Float {
        return squaredLength.squareRoot()
    }
    
    var normalized: Self {
        let magnitude: Float = self.magnitude
        return Self(w: w / magnitude, x: x / magnitude, y: y / magnitude, z: z / magnitude)
    }
    
    mutating func normalize() {
        self = self.normalized
    }
}

public extension Quaternion {
    var unitNormalized: Self {
        let angle: Float = w
        let degrees: Float = cos(angle * 0.5)
        let vector = self.direction * sin(angle * 0.5)
        return Self(Degrees(degrees), axis: vector)
    }
}

public extension Quaternion {
    @inlinable
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
    
    @inlinable
    var forward: Direction3 {
        return Direction3.forward.rotated(by: self)
    }
    @inlinable
    var backward: Direction3 {
        return Direction3.backward.rotated(by: self)
    }
    @inlinable
    var up: Direction3 {
        return Direction3.up.rotated(by: self)
    }
    @inlinable
    var down: Direction3 {
        return Direction3.down.rotated(by: self)
    }
    @inlinable
    var left: Direction3 {
        return Direction3.left.rotated(by: self)
    }
    @inlinable
    var right: Direction3 {
        return Direction3.right.rotated(by: self)
    }
}

public extension Quaternion {
    @inlinable
    static var zero: Self {
        return Self(Radians(0), axis: .forward)
    }
    
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
    @inlinable
    var conjugate: Self {
        return Self(w: w, x: -x, y: -y, z: -z)
    }
    @inlinable
}

public extension Quaternion {
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
    
    mutating func interpolate(to: Self, _ method: InterpolationMethod) {
        self = self.interpolated(to: to, method)
    }
}

private extension Quaternion {
    func lerped(to q2: Self, factor t: Float) -> Self {
        var qr: Quaternion = .zero
        
        let t_ = 1 - t
        qr.x = t_ * self.x + t * q2.x
        qr.y = t_ * self.y + t * q2.y
        qr.z = t_ * self.z + t * q2.z
        qr.w = t_ * self.w + t * q2.w
        
        return qr.normalized
    }
    
    mutating func lerp(to q2: Self, factor: Float) {
        self = self.lerped(to: q2, factor: factor)
    }
    
    func slerped(to qb: Self, factor t: Float) -> Self {
        let qa = self
        var qb = qb
        // Calculate angle between them.
        var cosHalfTheta = qa.w * qb.w
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
    
    mutating func slerp(to qb: Self, factor: Float) {
        self = self.slerped(to: qb, factor: factor)
    }
}

public extension Quaternion {
    static func *(lhs: Self, rhs: Float) -> Self {
        return Self(w: lhs.w * rhs, x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }
    static func *=(lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
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
    
    static func *=<V: Vector2>(lhs: inout Self, rhs: V) {
        lhs = (lhs * rhs).normalized
    }
    static func *<V: Vector2>(lhs: Self, rhs: V) -> Self {
        var w: Float = -lhs.x * rhs.x
        w -= lhs.y * rhs.y
        w -= lhs.z * 0
        var x: Float =  lhs.w * rhs.x
        x += lhs.y * 0
        x -= lhs.z * rhs.y
        var y: Float =  lhs.w * rhs.y
        y += lhs.z * rhs.x
        y -= lhs.x * 0
        var z: Float =  lhs.w * 0
        z += lhs.x * rhs.y
        z -= lhs.y * rhs.x
        return Self(w: w, x: x, y: y, z: z)
    }
    
    static func *=<V: Vector3>(lhs: inout Self, rhs: V) {
        lhs = (lhs * rhs).normalized
    }
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
    
    static func /(lhs: Self, rhs: Float) -> Self {
        return Self(w: lhs.w / rhs, x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }
    static func /=(lhs: inout Self, rhs: Float) {
        lhs = lhs / rhs
    }
    
    static func +=(lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    static func +(lhs: Self, rhs: Self) -> Self {
        return Self(w: lhs.w + rhs.w, x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    static func -=(lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    static func -(lhs: Self, rhs: Self) -> Self {
        return Self(w: lhs.w - rhs.w, x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
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
