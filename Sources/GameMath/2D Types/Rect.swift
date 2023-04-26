/*
 * Copyright © 2023 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 *
 * http://stregasgate.com
 */

import Foundation

#if GameMathUseSIMD
public struct Rect {
    public var position: Position2
    public var size: Size2
    
    @inlinable
    public init(position: Position2 = .zero, size: Size2) {
        self.position = position
        self.size = size
    }
}
#else
public struct Rect {
    public var position: Position2
    public var size: Size2
    
    @inlinable
    public init(position: Position2 = .zero, size: Size2) {
        self.position = position
        self.size = size
    }
}
#endif

public extension Rect {
    @inlinable
    init(x: Float, y: Float, width: Float, height: Float) {
        self.init(position: Position2(x: x, y: y), size: Size2(width: width, height: height))
    }
    
    @inlinable
    init(_ x: Float, _ y: Float, _ width: Float, _ height: Float) {
        self.init(position: Position2(x: x, y: y), size: Size2(width: width, height: height))
    }
}

extension Rect: Equatable {}
extension Rect: Hashable {}
extension Rect: Codable {}

public extension Rect {
    @_transparent
    var area: Float {
        return size.width * size.height
    }
    // The left side of the rect
    @_transparent
    var x: Float {
        get {
            return position.x
        }
        set(x) {
            position.x = x
        }
    }
    // The top of the rect
    @_transparent
    var y: Float {
        get {
            return position.y
        }
        set(y) {
            position.y = y
        }
    }
    @_transparent
    var width: Float {
        get {
            return size.width
        }
        set(width) {
            size.width = width
        }
    }
    @_transparent
    var height: Float {
        get {
            return size.height
        }
        set(height) {
            size.height = height
        }
    }
    
    // The right side of the rect
    @_transparent
    var maxX: Float {
        return x + width
    }
    // The bottom of the rect
    @_transparent
    var maxY: Float {
        return y + height
    }
}

extension Rect {
    @_transparent
    public var center: Position2 {
        get {
            return Position2(x: x + width / 2, y: y + height / 2)
        }
        set(point) {
            x = point.x - width / 2
            y = point.y - height / 2
        }
    }

    //TODO: Move this to GamePhysics in AxisAlignedBoundingBox2
    @available(*, deprecated, message: "This will be removed in a future update.")
    @inlinable
    public func nearest(outsidePositionFrom circle: Circle) -> Position2 {
        var position = circle.center
        
        if intersects(circle) {
            if circle.center.x > center.x {//Go Right
                position.x = circle.center.x + circle.radius + (width/2)
            }else if circle.center.x < center.x {//Go Left
                position.x = circle.center.x - circle.radius - (width/2)
            }
            if circle.center.y > center.y {//Go Up
                position.y = circle.center.y - circle.radius - (height/2)
            }else if circle.center.y < center.y {//Go Down
                position.y = circle.center.y + circle.radius + (height/2)
            }
        }
        
        return position
    }
}

extension Rect {
    //TODO: Move this to GamePhysics in AxisAlignedBoundingBox2
    @available(*, deprecated, message: "This will be removed in a future update.")
    @inlinable
    public func intersects(_ rect: Rect) -> Bool {
        var part1: Bool {
            let lhs = abs(x - rect.x) * 2
            let rhs = width + rect.width
            return lhs <= rhs
        }
        var part2: Bool {
            let lhs = abs(y - rect.y) * 2
            let rhs = height + rect.height
            return lhs <= rhs
        }
        return part1 && part2
    }
}

extension Rect {
    //TODO: Move this to GamePhysics in AxisAlignedBoundingBox2
    @available(*, deprecated, message: "This will be removed in a future update.")
    @inlinable
    public func contains(_ position: Position2) -> Bool {
        if position.x < x || position.x > maxX {
            return false
        }
        if position.y < y || position.y > maxY {
            return false
        }
        return true
    }

    //TODO: Move this to GamePhysics in AxisAlignedBoundingBox2
    @available(*, deprecated, message: "This will be removed in a future update.")
    @inlinable
    public func intersects(_ circle: Circle) -> Bool {
        let topLeft = Position2(x: circle.center.x - circle.radius, y: circle.center.y - circle.radius)
        if contains(topLeft) {
            return true
        }
        
        let topRight = Position2(x: circle.center.x + circle.radius, y: circle.center.y - circle.radius)
        if contains(topRight) {
            return true
        }
        
        let bottomLeft = Position2(x: circle.center.x - circle.radius, y: circle.center.y + circle.radius)
        if contains(bottomLeft) {
            return true
        }
        
        let bottomRight = Position2(x: circle.center.x + circle.radius, y: circle.center.y + circle.radius)
        if contains(bottomRight) {
            return true
        }
        
        return false
    }
}

public extension Rect {
    @_transparent
    var isFinite: Bool {
        return position.isFinite && size.isFinite
    }
}

public extension Rect {
    @_transparent
    func interpolated(to: Self, _ method: InterpolationMethod) -> Self {
        var copy = self
        copy.interpolate(to: to, method)
        return copy
    }
    @_transparent
    mutating func interpolate(to: Self, _ method: InterpolationMethod) {
        self.position.interpolate(to: to.position, method)
        self.size.interpolate(to: to.size, method)
    }
}

public extension Rect {
    @_transparent
    func inset(by insets: Insets) -> Rect {
        var copy = self
        copy.x += insets.leading
        copy.y += insets.top
        copy.width -= insets.leading + insets.trailing
        copy.height -= insets.top + insets.bottom
        return copy
    }
}

extension Rect {
    public static let zero = Self(x: 0, y: 0, width: 0, height: 0)
}

extension Rect {
    @_transparent
    public static func *=(lhs: inout Self, rhs: Float) {
        lhs = lhs * rhs
    }
    @_transparent
    public static func *(lhs: Self, rhs: Float) -> Self {
        return Rect(position: lhs.position * rhs, size: lhs.size * rhs)
    }
    
    @_transparent
    public static func /=(lhs: inout Self, rhs: Float) {
        lhs = lhs / rhs
    }
    @_transparent
    public static func /(lhs: Self, rhs: Float) -> Self {
        return Rect(position: lhs.position / rhs, size: lhs.size / rhs)
    }
}
