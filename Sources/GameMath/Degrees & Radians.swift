/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

import Foundation

#if GameMathUseSIMD
/// Represents an angle in radians
public struct Radians<RawValue: BinaryFloatingPoint & SIMDScalar>: RawRepresentable {
    /// The radians as a scalar value
    public let rawValue: RawValue
    
    /// Creates a new angle with an intial value in radians
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}
#else
public struct Radians<RawValue: BinaryFloatingPoint>: RawRepresentable {
    /// The radians as a scalar value
    public let rawValue: RawValue
    
    /// Creates a new angle with an intial value in radians
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}
#endif

public extension Radians {
    /// Creates a new angle with an intial value in radians
    init(_ rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
    /// Converts degrees to radians
    init<T: BinaryFloatingPoint>(_ value: Degrees<T>) {
        self.rawValue = RawValue(value.rawValue) * (RawValue.pi / 180)
    }
    /// Converts degrees to radians
    init(_ value: Degrees<RawValue>) {
        self.rawValue = value.rawValue * (RawValue.pi / 180)
    }
    
    static func +(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(lhs.rawValue + rhs.rawValue)
    }
    static func +(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(lhs.rawValue + rhs)
    }
    static func +(_ lhs: RawValue, _ rhs: Self) -> RawValue {
        return lhs + rhs.rawValue
    }
    
    static func -(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(lhs.rawValue - rhs.rawValue)
    }
    static func -(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(lhs.rawValue - rhs)
    }
    static func -(_ lhs: RawValue, _ rhs: Self) -> RawValue {
        return lhs - rhs.rawValue
    }
    
    static func *(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(lhs.rawValue * rhs.rawValue)
    }
    static func *(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(lhs.rawValue * rhs)
    }
    static func *(_ lhs: RawValue, _ rhs: Self) -> RawValue {
        return lhs * rhs.rawValue
    }
    
    static func /(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(lhs.rawValue / rhs.rawValue)
    }
    static func /(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(lhs.rawValue / rhs)
    }
    static func /(_ lhs: RawValue, _ rhs: Self) -> RawValue {
        return lhs / rhs.rawValue
    }
}

public func min<T: BinaryFloatingPoint>(_ lhs: Radians<T>, _ rhs: Radians<T>) -> Radians<T> {
    return Radians(min(lhs.rawValue, rhs.rawValue))
}
public func min<T: BinaryFloatingPoint>(_ lhs: Radians<T>, _ rhs: T) -> Radians<T> {
    return Radians(min(lhs.rawValue, rhs))
}
public func min<T: BinaryFloatingPoint>(_ lhs: T, _ rhs: Radians<T>) -> Radians<T> {
    return Radians(min(lhs, rhs.rawValue))
}

public func max<T: BinaryFloatingPoint>(_ lhs: Radians<T>, _ rhs: Radians<T>) -> Radians<T> {
    return Radians(max(lhs.rawValue, rhs.rawValue))
}
public func max<T: BinaryFloatingPoint>(_ lhs: Radians<T>, _ rhs: T) -> Radians<T> {
    return Radians(max(lhs.rawValue, rhs))
}
public func max<T: BinaryFloatingPoint>(_ lhs: T, _ rhs: Radians<T>) -> Radians<T> {
    return Radians(max(lhs, rhs.rawValue))
}

public func abs<T: BinaryFloatingPoint>(_ value: Radians<T>) -> Radians<T> {
    return Radians(abs(value.rawValue))
}
public func ceil<T: BinaryFloatingPoint>(_ value: Radians<T>) -> Radians<T> {
    return Radians(ceil(value.rawValue))
}
public func floor<T: BinaryFloatingPoint>(_ value: Radians<T>) -> Radians<T> {
    return Radians(floor(value.rawValue))
}
public func round<T: BinaryFloatingPoint>(_ value: Radians<T>) -> Radians<T> {
    return Radians(round(value.rawValue))
}

extension Radians: Comparable where RawValue: Comparable {
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

extension Radians: Equatable where RawValue: Equatable {
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
extension Radians: Hashable where RawValue: Hashable {}
extension Radians: Codable where RawValue: Codable {}


//MARK: Degrees
#if GameMathUseSIMD
public struct Degrees<RawValue: BinaryFloatingPoint & SIMDScalar>: RawRepresentable {
    /// The degress scalar value
    public let rawValue: RawValue
    /// Creates a new angle in degrees
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}
#else
public struct Degrees<RawValue: BinaryFloatingPoint>: RawRepresentable {
    /// The degress scalar value
    public let rawValue: RawValue
    /// Creates a new angle in degrees
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}
#endif

public extension Degrees {
    /// Creates a new angle in degrees
    init(_ rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
    /// Converts radians to degrees
    init<T: BinaryFloatingPoint>(_ value: Radians<T>) {
        self.rawValue = RawValue(value.rawValue) * (180 / RawValue.pi)
    }
    /// Converts radians to degrees
    init(_ value: Radians<RawValue>) {
        self.rawValue = value.rawValue * (180 / RawValue.pi)
    }
    
    static func +(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(lhs.rawValue + rhs.rawValue)
    }
    static func +(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(lhs.rawValue + rhs)
    }
    static func +(_ lhs: RawValue, _ rhs: Self) -> RawValue {
        return lhs + rhs.rawValue
    }
    
    static func -(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(lhs.rawValue - rhs.rawValue)
    }
    static func -(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(lhs.rawValue - rhs)
    }
    static func -(_ lhs: RawValue, _ rhs: Self) -> RawValue {
        return lhs - rhs.rawValue
    }
    
    static func *(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(lhs.rawValue * rhs.rawValue)
    }
    static func *(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(lhs.rawValue * rhs)
    }
    static func *(_ lhs: RawValue, _ rhs: Self) -> RawValue {
        return lhs * rhs.rawValue
    }
    
    static func /(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(lhs.rawValue / rhs.rawValue)
    }
    static func /(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(lhs.rawValue / rhs)
    }
    static func /(_ lhs: RawValue, _ rhs: Self) -> RawValue {
        return lhs / rhs.rawValue
    }
}

public func min<T: BinaryFloatingPoint>(_ lhs: Degrees<T>, _ rhs: Degrees<T>) -> Degrees<T> {
    return Degrees(min(lhs.rawValue, rhs.rawValue))
}
public func min<T: BinaryFloatingPoint>(_ lhs: Degrees<T>, _ rhs: T) -> Degrees<T> {
    return Degrees(min(lhs.rawValue, rhs))
}
public func min<T: BinaryFloatingPoint>(_ lhs: T, _ rhs: Degrees<T>) -> Degrees<T> {
    return Degrees(min(lhs, rhs.rawValue))
}

public func max<T: BinaryFloatingPoint>(_ lhs: Degrees<T>, _ rhs: Degrees<T>) -> Degrees<T> {
    return Degrees(max(lhs.rawValue, rhs.rawValue))
}
public func max<T: BinaryFloatingPoint>(_ lhs: Degrees<T>, _ rhs: T) -> Degrees<T> {
    return Degrees(max(lhs.rawValue, rhs))
}
public func max<T: BinaryFloatingPoint>(_ lhs: T, _ rhs: Degrees<T>) -> Degrees<T> {
    return Degrees(max(lhs, rhs.rawValue))
}

public func abs<T: BinaryFloatingPoint>(_ value: Degrees<T>) -> Degrees<T> {
    return Degrees(abs(value.rawValue))
}
public func ceil<T: BinaryFloatingPoint>(_ value: Degrees<T>) -> Degrees<T> {
    return Degrees(ceil(value.rawValue))
}
public func floor<T: BinaryFloatingPoint>(_ value: Degrees<T>) -> Degrees<T> {
    return Degrees(floor(value.rawValue))
}
public func round<T: BinaryFloatingPoint>(_ value: Degrees<T>) -> Degrees<T> {
    return Degrees(round(value.rawValue))
}

extension Degrees: Comparable where RawValue: Comparable {
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

extension Degrees: Equatable where RawValue: Equatable {
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

extension Degrees: Hashable where RawValue: Hashable {}
extension Degrees: Codable where RawValue: Codable {}

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
