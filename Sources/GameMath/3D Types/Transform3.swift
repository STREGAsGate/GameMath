/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * http://stregasgate.com
 */

public struct Transform3 {
    public var position: Position3 {
        didSet {
            assert(position.isFinite)
            guard _needsUpdate == false else {return}
            if oldValue != position {
                _needsUpdate = true
            }
        }
    }
    public var rotation: Quaternion {
        didSet {
            assert(rotation.isFinite)
            guard _needsUpdate == false else {return}
            if oldValue != rotation {
                _needsUpdate = true
            }
        }
    }
    public var scale: Size3 {
        didSet {
            assert(scale.isFinite)
            guard _needsUpdate == false else {return}
            if oldValue != scale {
                _needsUpdate = true
            }
        }
    }
    
    private var _needsUpdate: Bool = true
    private lazy var _matrix: Matrix4x4 = .identity
    private lazy var _roationMatrix: Matrix4x4 = .identity
    private lazy var _scaleMatrix: Matrix4x4 = .identity
}

public extension Transform3 {
    init(position: Position3 = .zero, rotation: Quaternion = .zero, scale: Size3 = .one) {
        self.position = position
        self.rotation = rotation
        self.scale = scale
    }
    
    @inlinable
    var isFinite: Bool {
        return position.isFinite && scale.isFinite && rotation.isFinite
    }
}

public extension Transform3 {
    ///Returns a cached matrix, creating the cache if needed.
    mutating func matrix() -> Matrix4x4 {
        if _needsUpdate {
            _matrix = self.createMatrix()
            _needsUpdate = false
        }
        return _matrix
    }
    
    ///Creates and returns a new matrix.
    @inlinable
    func createMatrix() -> Matrix4x4 {
        var matrix = Matrix4x4(position: self.position)
        matrix *= Matrix4x4(rotation: self.rotation)
        matrix *= Matrix4x4(scale: self.scale)
        return matrix
    }
}

extension Transform3: Equatable {}
extension Transform3: Hashable {}

extension Transform3 {
    @inlinable
    public mutating func rotate(_ degrees: Degrees, direction: Direction3) {
        self.rotation = Quaternion(degrees, axis: direction) * self.rotation
    }
}

extension Transform3 {
    @inlinable
    public static var zero: Self {
        return Self(position: .zero, rotation: .zero, scale: .zero)
    }
    @inlinable
    public static var empty: Self {
        return Self(position: .zero, rotation: .zero, scale: .one)
    }
}

extension Transform3 {
    @inlinable
    public func interpolated(to destination: Self, _ method: InterpolationMethod) -> Self {
        var copy = self
        copy.position.interpolate(to: destination.position, method)
        copy.rotation.interpolate(to: destination.rotation, method)
        copy.scale.interpolate(to: destination.scale, method)
        return copy
    }
    
    @inlinable
    public mutating func interpolate(to: Self, _ method: InterpolationMethod) {
        self.position.interpolate(to: to.position, method)
        self.rotation.interpolate(to: to.rotation, method)
        self.scale.interpolate(to: to.scale, method)
    }
    
    @inlinable
    public func difference(removing: Self) -> Self {
        var transform: Self = .empty
        transform.position = self.position - removing.position
        transform.rotation = self.rotation * removing.rotation.inverse
        return transform
    }
}

extension Transform3 {
    @inlinable
    public func distance(from: Self) -> Float {
        return self.position.distance(from: from.position)
    }
}

public extension Transform3 {
    @inlinable
    static func +=(lhs: inout Self, rhs: Self) {
        lhs.position += rhs.position
        lhs.rotation = rhs.rotation * lhs.rotation
        lhs.rotation.normalize()
        lhs.scale += rhs.scale
    }
    @inlinable
    static func +(lhs: Self, rhs: Self) -> Self {
        return Self(position: lhs.position + rhs.position, rotation: (rhs.rotation * lhs.rotation).normalized, scale: lhs.scale + rhs.scale)
    }
}

extension Transform3: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([position.x, position.y, position.z,
                              rotation.w, rotation.x, rotation.y, rotation.z,
                              scale.x, scale.y, scale.z])
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode(Array<Float>.self)
        
        self.position = Position3(x: values[0], y: values[1], z: values[2])
        self.rotation = Quaternion(w: values[3], x: values[4], y: values[5], z: values[6])
        self.scale = Size3(width: values[7], height: values[8], depth: values[9])
    }
}
