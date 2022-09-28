/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * http://stregasgate.com
 */
#if GameMathUseSIMD
public struct Transform2 {
    public var position: Position2 {
        didSet {
            assert(position.isFinite)
            guard _needsUpdate == false else {return}
            if oldValue != position {
                _needsUpdate = true
            }
        }
    }
    public var rotation: Degrees {
        didSet {
            assert(rotation.isFinite)
            guard _needsUpdate == false else {return}
            if oldValue != rotation {
                _needsUpdate = true
            }
        }
    }
    public var scale: Size2 {
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
#else
public struct Transform2 {
    public var position: Position2 {
        didSet {
            assert(position.isFinite)
            guard _needsUpdate == false else {return}
            if oldValue != position {
                _needsUpdate = true
            }
        }
    }
    public var rotation: Degrees {
        didSet {
            assert(rotation.isFinite)
            guard _needsUpdate == false else {return}
            if oldValue != rotation {
                _needsUpdate = true
            }
        }
    }
    public var scale: Size2 {
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
#endif

public extension Transform2 {
    init(position: Position2 = .zero, rotation: Degrees = Degrees(0), scale: Size2 = .one) {
        self.position = position
        self.rotation = rotation
        self.scale = scale
    }
    
    var isFinite: Bool {
        return position.isFinite && scale.isFinite && rotation.isFinite
    }
}

extension Transform2: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.position == rhs.position && lhs.rotation == rhs.rotation && lhs.scale == rhs.scale
    }
}
extension Transform2: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(position)
        hasher.combine(rotation)
        hasher.combine(scale)
    }
}

extension Transform2 {
    public static var zero: Self {
        return Self(position: .zero, rotation: Degrees(0), scale: .zero)
    }
    public static var empty: Self {
        return Self(position: .zero, rotation: Degrees(0), scale: .one)
    }
}

extension Transform2 {
    public func interpolated(to destination: Self, _ method: InterpolationMethod) -> Self {
        var copy = self
        copy.position.interpolate(to: destination.position, method)
        copy.rotation.interpolate(to: destination.rotation, method)
        copy.scale.interpolate(to: destination.scale, method)
        return copy
    }
    
    public mutating func interpolate(to: Self, _ method: InterpolationMethod) {
        self.position.interpolate(to: to.position, method)
        self.rotation.interpolate(to: to.rotation, method)
        self.scale.interpolate(to: to.scale, method)
    }
    
    public func difference(removing: Self) -> Self {
        var transform: Self = .empty
        transform.position = self.position - removing.position
        transform.rotation = self.rotation - removing.rotation
        return transform
    }
}

extension Transform2 {
    public func distance(from: Self) -> Float {
        return self.position.distance(from: from.position)
    }
}

public extension Transform2 {
    static func +=(lhs: inout Self, rhs: Self) {
        lhs.position += rhs.position
        lhs.rotation += rhs.rotation
        lhs.scale += rhs.scale
    }
    static func +(lhs: Self, rhs: Self) -> Self {
        return Self(position: lhs.position + rhs.position, rotation: lhs.rotation + rhs.rotation, scale: lhs.scale + rhs.scale)
    }
}

extension Transform2: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([position.x, position.y,
                              rotation.rawValue,
                              scale.x, scale.y])
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode(Array<Float>.self)
        
        self.position = Position2(x: values[0], y: values[1])
        self.rotation = Degrees(values[2])
        self.scale = Size2(width: values[3], height: values[4])
    }
}
