/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

import Foundation

/// Represents an angle in radians
public struct Radians: RawRepresentable {
    public typealias RawValue = Float
    /// The radians as a scalar value
    public var rawValue: RawValue
    
    /// Creates a new angle with an intial value in radians
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
    /// Creates a new angle with an intial value in radians
    public init(_ rawValue: Float) {
        self.rawValue = rawValue
    }
}

public extension Radians {
    /// Converts degrees to radians
    init(_ value: Degrees) {
        self.rawValue = value.rawValue * (RawValue.pi / 180)
    }
    
    var isFinite: Bool {
        return rawValue.isFinite
    }
    
    mutating func interpolate(to: Self, _ method: InterpolationMethod) {
        self.rawValue.interpolate(to: to.rawValue, method)
    }
    
    mutating func interpolated(to: Self, _ method: InterpolationMethod) -> Self {
        return Radians(self.rawValue.interpolated(to: to.rawValue, method))
    }
    
    mutating func interpolate(to: Degrees, _ method: InterpolationMethod) {
        self.interpolate(to: Self(to), method)
    }
    
    mutating func interpolated(to: Degrees, _ method: InterpolationMethod) -> Self {
        return self.interpolated(to: Self(to), method)
    }
    
    static var zero: Self {
        return Self(rawValue: 0)
    }
}

extension Radians: AdditiveArithmetic {
    public static func +(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(lhs.rawValue + rhs.rawValue)
    }
    public static func +(_ lhs: Self, _ rhs: Degrees) -> Self {
        return Self(lhs.rawValue + Self(rhs).rawValue)
    }
    public static func +(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(lhs.rawValue + rhs)
    }
    public static func +(_ lhs: RawValue, _ rhs: Self) -> RawValue {
        return lhs + rhs.rawValue
    }
    
    public static func -(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(lhs.rawValue - rhs.rawValue)
    }
    public static func -(_ lhs: Self, _ rhs: Degrees) -> Self {
        return Self(lhs.rawValue - Self(rhs).rawValue)
    }
    public static func -(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(lhs.rawValue - rhs)
    }
    public static func -(_ lhs: RawValue, _ rhs: Self) -> RawValue {
        return lhs - rhs.rawValue
    }
}

extension Radians {
    public static func *(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(lhs.rawValue * rhs.rawValue)
    }
    public static func *=(_ lhs: inout Self, _ rhs: Self) {
        lhs.rawValue *= rhs.rawValue
    }

    public static func *(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(lhs.rawValue * rhs)
    }
    public static func *(_ lhs: RawValue, _ rhs: Self) -> RawValue {
        return lhs * rhs.rawValue
    }
    public static func *=(_ lhs: inout Self, _ rhs: RawValue) {
        lhs.rawValue *= rhs
    }
    
    public static func *(_ lhs: Self, _ rhs: Degrees) -> Self {
        return Self(lhs.rawValue * Self(rhs).rawValue)
    }
    public static func *= (lhs: inout Self, rhs: Degrees) {
        lhs.rawValue *= Self(rhs).rawValue
    }
}

extension Radians {
    public static func /(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(lhs.rawValue / rhs.rawValue)
    }
    public static func /(_ lhs: Self, _ rhs: Degrees) -> Self {
        return Self(lhs.rawValue / Self(rhs).rawValue)
    }
    public static func /(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(lhs.rawValue / rhs)
    }
    public static func /(_ lhs: RawValue, _ rhs: Self) -> RawValue {
        return lhs / rhs.rawValue
    }
}

public func min(_ lhs: Radians, _ rhs: Radians) -> Radians {
    return Radians(min(lhs.rawValue, rhs.rawValue))
}
public func min(_ lhs: Radians, _ rhs: Degrees) -> Radians {
    return Radians(min(lhs.rawValue, Radians(rhs).rawValue))
}
public func min(_ lhs: Radians, _ rhs: Float) -> Radians {
    return Radians(min(lhs.rawValue, rhs))
}
public func min(_ lhs: Float, _ rhs: Radians) -> Radians {
    return Radians(min(lhs, rhs.rawValue))
}

public func max(_ lhs: Radians, _ rhs: Radians) -> Radians {
    return Radians(max(lhs.rawValue, rhs.rawValue))
}
public func max(_ lhs: Radians, _ rhs: Degrees) -> Radians {
    return Radians(max(lhs.rawValue, Radians(rhs).rawValue))
}
public func max(_ lhs: Radians, _ rhs: Float) -> Radians {
    return Radians(max(lhs.rawValue, rhs))
}
public func max(_ lhs: Float, _ rhs: Radians) -> Radians {
    return Radians(max(lhs, rhs.rawValue))
}

public func abs(_ value: Radians) -> Radians {
    return Radians(abs(value.rawValue))
}
public func ceil(_ value: Radians) -> Radians {
    return Radians(ceil(value.rawValue))
}
public func floor(_ value: Radians) -> Radians {
    return Radians(floor(value.rawValue))
}
public func round(_ value: Radians) -> Radians {
    return Radians(round(value.rawValue))
}

extension Radians: Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    public static func <(lhs: Self, rhs: Degrees) -> Bool {
        return lhs.rawValue < Radians(rhs).rawValue
    }
    public static func <(lhs: Self, rhs: Float) -> Bool {
        return lhs.rawValue < rhs
    }
    public static func <(lhs: Float, rhs: Self) -> Bool {
        return lhs < rhs.rawValue
    }
    
    public static func >(lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }
    public static func >(lhs: Self, rhs: Degrees) -> Bool {
        return lhs.rawValue > Radians(rhs).rawValue
    }
    public static func >(lhs: Self, rhs: Float) -> Bool {
        return lhs.rawValue > rhs
    }
    public static func >(lhs: Float, rhs: Self) -> Bool {
        return lhs > rhs.rawValue
    }
}

extension Radians: Equatable {
    public static func ==(lhs: Self, rhs: Float) -> Bool {
        return lhs.rawValue == rhs
    }
    public static func ==(lhs: Float, rhs: Self) -> Bool {
        return lhs == rhs.rawValue
    }
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
extension Radians: Hashable {}
extension Radians: Codable {}


//MARK: Degrees
public struct Degrees: RawRepresentable {
    public typealias RawValue = Float
    /// The degress scalar value
    public var rawValue: RawValue
    
    /// Creates a new angle in degrees
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
    /// Creates a new angle in degrees
    public init(_ rawValue: RawValue) {
        self.rawValue = rawValue
    }
}

public extension Degrees {
    /// Converts radians to degrees
    init(_ value: Radians) {
        self.rawValue = value.rawValue * (180 / RawValue.pi)
    }
    
    var isFinite: Bool {
        return rawValue.isFinite
    }
    
    mutating func interpolate(to: Self, _ method: InterpolationMethod) {
        self.rawValue.interpolate(to: to.rawValue, method)
    }
    
    func interpolated(to: Self, _ method: InterpolationMethod) -> Self {
        if case .linear(_, shortest: true) = method {
            // Shortest distance
            let shortest = self.shortestAngle(to: to)
            return Self(self.rawValue.interpolated(to: (self + shortest).rawValue, method))
        }
        return Self(self.rawValue.interpolated(to: to.rawValue, method))
    }
    
    mutating func interpolate(to: Radians, _ method: InterpolationMethod) {
        self.interpolate(to: Self(to), method)
    }
    
    func interpolated(to: Radians, _ method: InterpolationMethod) -> Self {
        return self.interpolated(to: Self(to), method)
    }
    
    static var zero: Self {
        return Self(0)
    }
}

extension Degrees: AdditiveArithmetic {
    public static func +(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(lhs.rawValue + rhs.rawValue)
    }
    public static func +(_ lhs: Self, _ rhs: Radians) -> Self {
        return Self(lhs.rawValue + Self(rhs).rawValue)
    }
    public static func +(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(lhs.rawValue + rhs)
    }
    public static func +(_ lhs: RawValue, _ rhs: Self) -> RawValue {
        return lhs + rhs.rawValue
    }
    
    public static func -(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(lhs.rawValue - rhs.rawValue)
    }
    public static func -(_ lhs: Self, _ rhs: Radians) -> Self {
        return Self(lhs.rawValue - Self(rhs).rawValue)
    }
    public static func -(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(lhs.rawValue - rhs)
    }
    public static func -(_ lhs: RawValue, _ rhs: Self) -> RawValue {
        return lhs - rhs.rawValue
    }
}

extension Degrees {
    public static func *(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(lhs.rawValue * rhs.rawValue)
    }
    public static func *=(_ lhs: inout Self, _ rhs: Self) {
        lhs.rawValue *= rhs.rawValue
    }

    public static func *(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(lhs.rawValue * rhs)
    }
    public static func *(_ lhs: RawValue, _ rhs: Self) -> RawValue {
        return lhs * rhs.rawValue
    }
    public static func *=(_ lhs: inout Self, _ rhs: RawValue) {
        lhs.rawValue *= rhs
    }
    
    public static func *(_ lhs: Self, _ rhs: Radians) -> Self {
        return Self(lhs.rawValue * Self(rhs).rawValue)
    }
    public static func *= (lhs: inout Self, rhs: Radians) {
        lhs.rawValue *= Self(rhs).rawValue
    }
}

extension Degrees {
    public static func /(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(lhs.rawValue / rhs.rawValue)
    }
    public static func /(_ lhs: Self, _ rhs: Radians) -> Self {
        return Self(lhs.rawValue / Self(rhs).rawValue)
    }
    public static func /(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(lhs.rawValue / rhs)
    }
    public static func /(_ lhs: RawValue, _ rhs: Self) -> RawValue {
        return lhs / rhs.rawValue
    }
}

public func min(_ lhs: Degrees, _ rhs: Degrees) -> Degrees {
    return Degrees(min(lhs.rawValue, rhs.rawValue))
}
public func min(_ lhs: Degrees, _ rhs: Radians) -> Degrees {
    return Degrees(min(lhs.rawValue, Degrees(rhs).rawValue))
}
public func min(_ lhs: Degrees, _ rhs: Float) -> Degrees {
    return Degrees(min(lhs.rawValue, rhs))
}
public func min(_ lhs: Float, _ rhs: Degrees) -> Degrees {
    return Degrees(min(lhs, rhs.rawValue))
}

public func max(_ lhs: Degrees, _ rhs: Degrees) -> Degrees {
    return Degrees(max(lhs.rawValue, rhs.rawValue))
}
public func max(_ lhs: Degrees, _ rhs: Radians) -> Degrees {
    return Degrees(max(lhs.rawValue, Degrees(rhs).rawValue))
}
public func max(_ lhs: Degrees, _ rhs: Float) -> Degrees {
    return Degrees(max(lhs.rawValue, rhs))
}
public func max(_ lhs: Float, _ rhs: Degrees) -> Degrees {
    return Degrees(max(lhs, rhs.rawValue))
}

public func abs(_ value: Degrees) -> Degrees {
    return Degrees(abs(value.rawValue))
}
public func ceil(_ value: Degrees) -> Degrees {
    return Degrees(ceil(value.rawValue))
}
public func floor(_ value: Degrees) -> Degrees {
    return Degrees(floor(value.rawValue))
}
public func round(_ value: Degrees) -> Degrees {
    return Degrees(round(value.rawValue))
}

extension Degrees: Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    public static func <(lhs: Self, rhs: RawValue) -> Bool {
        return lhs.rawValue < rhs
    }
    public static func <(lhs: RawValue, rhs: Self) -> Bool {
        return lhs < rhs.rawValue
    }
    
    public static func >(lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }
    public static func >(lhs: Self, rhs: RawValue) -> Bool {
        return lhs.rawValue > rhs
    }
    public static func >(lhs: RawValue, rhs: Self) -> Bool {
        return lhs > rhs.rawValue
    }
}

extension Degrees: Equatable {
    public static func ==(lhs: Self, rhs: RawValue) -> Bool {
        return lhs.rawValue == rhs
    }
    public static func ==(lhs: RawValue, rhs: Self) -> Bool {
        return lhs == rhs.rawValue
    }
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension Degrees: Hashable {}
extension Degrees: Codable {}

extension Degrees {
    /// Returns an angle equivalent to the current angle if it rolled over when exceeding 360, or rolled back to 360 when less then zero. The value is always within 0 ... 360
    public var normalized: Self {
        let scaler: RawValue = 1000000
        let degrees = ((self * scaler).rawValue.truncatingRemainder(dividingBy: (360 * scaler))) / scaler
        if self.rawValue < 0 {
            return Self(degrees + 360)
        }
        return Self(degrees)
    }
    
    /// Returns the shortest angle, that when added to `self.normalized` will result in `destination.normalized`
    public func shortestAngle(to destination: Self) -> Self {
        var src = self.rawValue
        var dst = destination.rawValue
        
        // If from or to is a negative, we have to recalculate them.
        // For an example, if from = -45 then from(-45) + 360 = 315.
        if dst < 0 || dst >= 360 {
            dst = destination.normalized.rawValue
        }
        
        if src < 0 || src >= 360 {
            src = self.normalized.rawValue
        }
        
        // Do not rotate if from == to.
        if dst == src {
            return Self(0)
        }
        
        // Pre-calculate left and right.
        var left = (360 - dst) + src
        var right = dst - src
        // If from < to, re-calculate left and right.
        if dst < src && src > 0 {
            left = src - dst
            right = (360 - src) + dst
        }
        
        // Determine the shortest direction.
        return Self((left <= right) ? (left * -1) : right)
    }
}
