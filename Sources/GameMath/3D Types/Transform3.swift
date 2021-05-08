/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

public struct Transform3<T: BinaryFloatingPoint & SIMDScalar> {
    public var position: Position3<T> {
        didSet {
            assert(position.isFinite)
            guard _needsUpdate == false else {return}
            if oldValue != position {
                _needsUpdate = true
            }
        }
    }
    public var rotation: Quaternion<T> {
        didSet {
            assert(rotation.isFinite)
            guard _needsUpdate == false else {return}
            if oldValue != rotation {
                _needsUpdate = true
            }
        }
    }
    public var scale: Size3<T> {
        didSet {
            assert(scale.isFinite)
            guard _needsUpdate == false else {return}
            if oldValue != scale {
                _needsUpdate = true
            }
        }
    }
    
    private var _needsUpdate: Bool = true
    private lazy var _matrix: Matrix4x4<T> = .identity
    private lazy var _roationMatrix: Matrix4x4<T> = .identity
    private lazy var _scaleMatrix: Matrix4x4<T> = .identity
    ///Returns a cached matrix, creating the cache if needed.
    public mutating func matrix() -> Matrix4x4<T> {
        if _needsUpdate {
            _matrix = self.createMatrix()
            _needsUpdate = false
        }
        return _matrix
    }
    
    ///Creates and returns a new matrix.
    public func createMatrix() -> Matrix4x4<T> {
        var matrix = Matrix4x4<T>(position: self.position)
        matrix *= Matrix4x4<T>(rotation: self.rotation)
        matrix *= Matrix4x4<T>(scale: self.scale)
        return matrix
    }
    
    public init(position: Position3<T> = .zero, rotation: Quaternion<T> = .zero, scale: Size3<T> = .one) {
        self.position = position
        self.rotation = rotation
        self.scale = scale
    }
    
    public var isFinite: Bool {
        return position.isFinite && scale.isFinite && rotation.isFinite
    }
}

extension Transform3: Equatable where T: Equatable {}
extension Transform3: Hashable where T: Hashable {}

extension Transform3 {
    public mutating func rotate(_ degrees: Degrees<T>, direction: Direction3<T>) {
        self.rotation = Quaternion<T>(degrees, axis: direction) * self.rotation
    }
}

extension Transform3 {
    public static var zero: Self {
        return Self(position: .zero, rotation: .zero, scale: .zero)
    }
    public static var empty: Self {
        return Self(position: .zero, rotation: .zero, scale: .one)
    }
}

extension Transform3 {
    public func interpolated(to destination: Self, _ method: InterpolationMethod<T>) -> Self {
        var copy = self
        copy.position.interpolate(to: destination.position, method)
        copy.rotation.interpolate(to: destination.rotation, method)
        copy.scale.interpolate(to: destination.scale, method)
        return copy
    }
    
    public mutating func interpolate(to: Self, _ method: InterpolationMethod<T>) {
        self.position.interpolate(to: to.position, method)
        self.rotation.interpolate(to: to.rotation, method)
        self.scale.interpolate(to: to.scale, method)
    }
    
    public func difference(removing: Self) -> Self {
        var transform: Self = .empty
        transform.position = self.position - removing.position
        transform.rotation = self.rotation * removing.rotation.inverse
        return transform
    }
}

extension Transform3 {
    public func distance(from: Self) -> T {
        return self.position.distance(from: from.position)
    }
}

public extension Transform3 {
    static func +=(lhs: inout Self, rhs: Self) {
        lhs.position += rhs.position
        lhs.rotation = rhs.rotation * lhs.rotation
        lhs.rotation.normalize()
        lhs.scale += rhs.scale
    }
    static func +(lhs: Self, rhs: Self) -> Self {
        return Self(position: lhs.position + rhs.position, rotation: (rhs.rotation * lhs.rotation).normalized, scale: lhs.scale + rhs.scale)
    }
}

extension Transform3: Codable where T: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([position.x, position.y, position.z,
                              rotation.w, rotation.x, rotation.y, rotation.z,
                              scale.x, scale.y, scale.z])
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode(Array<T>.self)
        
        self.position = Position3<T>(x: values[0], y: values[1], z: values[2])
        self.rotation = Quaternion<T>(w: values[3], x: values[4], y: values[5], z: values[6])
        self.scale = Size3<T>(width: values[7], height: values[8], depth: values[9])
    }
}
