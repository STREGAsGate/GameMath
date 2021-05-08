/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

import Foundation

public struct Rect<T: Numeric & SIMDScalar> {
    public var position: Position2<T>
    public var size: Size2<T>
    
    public init(position: Position2<T> = .zero, size: Size2<T>) {
        self.position = position
        self.size = size
    }
    
    public init(x: T, y: T, width: T, height: T) {
        self.init(position: Position2(x: x, y: y), size: Size2(width: width, height: height))
    }
}

extension Rect: Equatable where T: Equatable {}
extension Rect: Hashable where T: Hashable {}
extension Rect: Codable where T: Codable {}

public extension Rect {
    var area: T {
        return size.width * size.height
    }
    // The left side of the rect
    var x: T {
        get {
            return position.x
        }
        set(x) {
            position.x = x
        }
    }
    // The top of the rect
    var y: T {
        get {
            return position.y
        }
        set(y) {
            position.y = y
        }
    }
    var width: T {
        get {
            return size.width
        }
        set(width) {
            size.width = width
        }
    }
    var height: T {
        get {
            return size.height
        }
        set(height) {
            size.height = height
        }
    }
    
    // The right side of the rect
    var maxX: T {
        return x + width
    }
    // The bottom of the rect
    var maxY: T {
        return y + height
    }
}

extension Rect where T: FloatingPoint {
    public var center: Position2<T> {
        get{
            return Position2(x: x + width / 2, y: y + height / 2)
        }
        set(point) {
            x = point.x - width / 2
            y = point.y - height / 2
        }
    }

    //TODO: Move this to GamePhysics in AxisAlignedBoundingBox2
    public func nearest(outsidePositionFrom circle: Circle<T>) -> Position2<T> {
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

extension Rect where T: Comparable & SignedNumeric {
    //TODO: Move this to GamePhysics in AxisAlignedBoundingBox2
    public func intersects(_ rect: Rect<T>) -> Bool {
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

extension Rect where T: Comparable {
    //TODO: Move this to GamePhysics in AxisAlignedBoundingBox2
    public func contains(_ position: Position2<T>) -> Bool {
        if position.x < x || position.x > x + width {
            return false
        }
        if position.y < y || position.y > y + height {
            return false
        }
        return true
    }

    //TODO: Move this to GamePhysics in AxisAlignedBoundingBox2
    public func intersects(_ circle: Circle<T>) -> Bool {
        let topLeft = Position2<T>(x: circle.center.x - circle.radius, y: circle.center.y - circle.radius)
        if contains(topLeft) {
            return true
        }
        
        let topRight = Position2<T>(x: circle.center.x + circle.radius, y: circle.center.y - circle.radius)
        if contains(topRight) {
            return true
        }
        
        let bottomLeft = Position2<T>(x: circle.center.x - circle.radius, y: circle.center.y + circle.radius)
        if contains(bottomLeft) {
            return true
        }
        
        let bottomRight = Position2<T>(x: circle.center.x + circle.radius, y: circle.center.y + circle.radius)
        if contains(bottomRight) {
            return true
        }
        
        return false
    }
}

public extension Rect where T == Float {
    var isFinite: Bool {
        return position.isFinite && size.isFinite
    }
}

public extension Rect where T: BinaryFloatingPoint {
    func interpolated(to: Self, _ method: InterpolationMethod<T>) -> Self {
        var copy = self
        copy.interpolate(to: to, method)
        return copy
    }
    mutating func interpolate(to: Self, _ method: InterpolationMethod<T>) {
        self.position.interpolate(to: to.position, method)
        self.size.interpolate(to: to.size, method)
    }
}

extension Rect {
    public static var zero: Self {Self(x: 0, y: 0, width: 0, height: 0)}
}

extension Rect {
    public static func *=(lhs: inout Self, rhs: T) {
        lhs = lhs * rhs
    }
    public static func *(lhs: Self, rhs: T) -> Self {
        return Rect(position: lhs.position * rhs, size: lhs.size * rhs)
    }
}
