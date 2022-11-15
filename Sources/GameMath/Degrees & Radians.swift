/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * http://stregasgate.com
 */

import Foundation

public protocol Angle: RawRepresentable, Numeric, Comparable, FloatingPoint where RawValue == Float {
    var rawValue: RawValue {get set}
    
    var rawValueAsDegrees: RawValue {get}
    var rawValueAsRadians: RawValue {get}
    
    mutating func interpolate(to: any Angle, _ method: InterpolationMethod)
    func interpolated(to: any Angle, _ method: InterpolationMethod) -> Self
    
    init(_ rawValue: RawValue)
    init(rawValue: RawValue)
    init(rawValueAsRadians: RawValue)
}

public extension Angle {
    @inline(__always)
    var isFinite: Bool {
        return rawValue.isFinite
    }
    
    @inline(__always)
    mutating func interpolate(to: any Angle, _ method: InterpolationMethod) {
        self.rawValue.interpolate(to: to.rawValue, method)
    }
    
    @inline(__always)
    func interpolated(to: any Angle, _ method: InterpolationMethod) -> Self {
        var copy = self
        copy.interpolate(to: to, method)
        return copy
    }
}

public extension Angle {
    @inline(__always)
    static var zero: Self {
        return Self(rawValue: 0)
    }
    
    @inline(__always)
    static func +(_ lhs: Self, _ rhs: Self) -> Self {
        assert(type(of: lhs) == type(of: rhs))
        return Self(rawValue: lhs.rawValue + rhs.rawValue)
    }
    @inline(__always)
    static func +(_ lhs: Self, _ rhs: any Angle) -> Self {
        return Self(rawValueAsRadians: lhs.rawValueAsRadians + rhs.rawValueAsRadians)
    }
    @inline(__always)
    static func +=(_ lhs: inout Self, _ rhs: any Angle) {
        lhs = lhs + rhs
    }
    @inline(__always)
    static func +(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(rawValue: lhs.rawValue + rhs)
    }
    @inline(__always)
    static func +(_ lhs: RawValue, _ rhs: Self) -> RawValue {
        return lhs + rhs.rawValue
    }
    
    @inline(__always)
    static func -(_ lhs: Self, _ rhs: Self) -> Self {
        assert(type(of: lhs) == type(of: rhs))
        return Self(rawValue: lhs.rawValue - rhs.rawValue)
    }
    @inline(__always)
    static func -(_ lhs: Self, _ rhs: any Angle) -> Self {
        return Self(rawValueAsRadians: lhs.rawValueAsRadians - rhs.rawValueAsRadians)
    }
    @inline(__always)
    static func -=(_ lhs: inout Self, _ rhs: any Angle) {
        lhs = lhs - rhs
    }
    @inline(__always)
    static func -(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(rawValue: lhs.rawValue - rhs)
    }
    @inline(__always)
    static func -(_ lhs: RawValue, _ rhs: Self) -> RawValue {
        return lhs - rhs.rawValue
    }
    
    @inline(__always)
    static prefix func -(_ rhs: Self) -> Self {
        return Self(rawValue: -rhs.rawValue)
    }
    
    @inline(__always)
    static prefix func +(_ rhs: Self) -> Self {
        return Self(rawValue: +rhs.rawValue)
    }
}

extension Angle {
    @inline(__always)
    public static func *(_ lhs: Self, _ rhs: Self) -> Self {
        assert(type(of: lhs) == type(of: rhs))
        return Self(rawValue: lhs.rawValue * rhs.rawValue)
    }
    @inline(__always)
    public static func *(_ lhs: Self, _ rhs: any Angle) -> Self {
        return Self(rawValueAsRadians: lhs.rawValueAsRadians * rhs.rawValueAsRadians)
    }
    @inline(__always)
    public static func *(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(rawValue: lhs.rawValue * rhs)
    }
    @inline(__always)
    public static func *(_ lhs: RawValue, _ rhs: Self) -> RawValue {
        return lhs * rhs.rawValue
    }
    
    @inline(__always)
    public static func *=(_ lhs: inout Self, _ rhs: Self) {
        assert(type(of: lhs) == type(of: rhs))
        lhs.rawValue *= rhs.rawValue
    }
    @inline(__always)
    public static func *=(_ lhs: inout Self, _ rhs: any Angle) {
        lhs.rawValue = Self(rawValueAsRadians: lhs.rawValueAsRadians * rhs.rawValueAsRadians).rawValue
    }
    @inline(__always)
    public static func *=(_ lhs: inout Self, _ rhs: RawValue) {
        lhs.rawValue *= rhs
    }
    @inline(__always)
    public static func *=(_ lhs: inout RawValue, _ rhs: Self) {
        lhs *= rhs.rawValue
    }
}


extension Angle {
    @inline(__always)
    public static func /(_ lhs: Self, _ rhs: Self) -> Self {
        assert(type(of: lhs) == type(of: rhs))
        return Self(rawValue: lhs.rawValue / rhs.rawValue)
    }
    @inline(__always)
    public static func /(_ lhs: Self, _ rhs: any Angle) -> Self {
        return Self(rawValueAsRadians: lhs.rawValueAsRadians / rhs.rawValueAsRadians)
    }
    @inline(__always)
    public static func /(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(rawValue: lhs.rawValue / rhs)
    }
    @inline(__always)
    public static func /(_ lhs: RawValue, _ rhs: Self) -> RawValue {
        return lhs / rhs.rawValue
    }
    
    @inline(__always)
    public static func /=(_ lhs: inout Self, _ rhs: Self) {
        assert(type(of: lhs) == type(of: rhs))
        lhs.rawValue /= rhs.rawValue
    }
    @inline(__always)
    public static func /=(_ lhs: inout Self, _ rhs: any Angle) {
        lhs.rawValue = Self(rawValueAsRadians: lhs.rawValueAsRadians / rhs.rawValueAsRadians).rawValue
    }
    @inline(__always)
    public static func /=(_ lhs: inout Self, _ rhs: RawValue) {
        lhs.rawValue /= rhs
    }
    @inline(__always)
    public static func /=(_ lhs: inout RawValue, _ rhs: Self) {
        lhs /= rhs.rawValue
    }
}

public extension Angle {
    @inline(__always)
    static func minimum(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(.minimum(lhs.rawValue, rhs.rawValue))
    }
    @inline(__always)
    static func minimum(_ lhs: any Angle, _ rhs: any Angle) -> Self {
        return Self(rawValueAsRadians: .minimum(lhs.rawValueAsRadians, rhs.rawValueAsRadians))
    }
    @inline(__always)
    static func minimum(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(.minimum(lhs.rawValue, rhs))
    }
    @inline(__always)
    static func minimum(_ lhs: RawValue, _ rhs: Self) -> Self {
        return Self(.minimum(lhs, rhs.rawValue))
    }
    
    @inline(__always)
    static func maximum(_ lhs: Self, _ rhs: Self) -> Self {
        return Self(.maximum(lhs.rawValue, rhs.rawValue))
    }
    @inline(__always)
    static func maximum(_ lhs: any Angle, _ rhs: any Angle) -> Self {
        return Self(rawValueAsRadians: .maximum(lhs.rawValueAsRadians, rhs.rawValueAsRadians))
    }
    @inline(__always)
    static func maximum(_ lhs: Self, _ rhs: RawValue) -> Self {
        return Self(.maximum(lhs.rawValue, rhs))
    }
    @inline(__always)
    static func maximum(_ lhs: RawValue, _ rhs: Self) -> Self {
        return Self(.maximum(lhs, rhs.rawValue))
    }
}

@inline(__always)
public func min<T: Angle>(_ lhs: T.RawValue, _ rhs: T) -> T {
    return T(Swift.min(lhs, rhs.rawValue))
}

@inline(__always)
public func min<T: Angle>(_ lhs: T, _ rhs: T.RawValue) -> T {
    return T(Swift.min(lhs.rawValue, rhs))
}

@inline(__always)
public func max<T: Angle>(_ lhs: T.RawValue, _ rhs: T) -> T {
    return T(Swift.max(lhs, rhs.rawValue))
}

@inline(__always)
public func max<T: Angle>(_ lhs: T, _ rhs: T.RawValue) -> T {
    return T(Swift.max(lhs.rawValue, rhs))
}

extension Angle {
    @inline(__always)
    public static func <(lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    @inline(__always)
    public static func <(lhs: Self, rhs: any Angle) -> Bool {
        return lhs.rawValueAsRadians < rhs.rawValueAsRadians
    }
    @inline(__always)
    public static func <(lhs: Self, rhs: RawValue) -> Bool {
        return lhs.rawValue < rhs
    }
    @inline(__always)
    public static func <(lhs: RawValue, rhs: Self) -> Bool {
        return lhs < rhs.rawValue
    }
    
    @inline(__always)
    public static func >(lhs: Self, rhs: RawValue) -> Bool {
        return lhs.rawValue > rhs
    }
    @inline(__always)
    public static func >(lhs: RawValue, rhs: Self) -> Bool {
        return lhs > rhs.rawValue
    }
}

extension Angle {
    @inline(__always)
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        assert(type(of: lhs) == type(of: rhs))
        return lhs.rawValue == rhs.rawValue
    }
    
    @inline(__always)
    public static func ==(lhs: Self, rhs: RawValue) -> Bool {
        return lhs.rawValue == rhs
    }
    
    @inline(__always)
    public static func ==(lhs: RawValue, rhs: Self) -> Bool {
        return lhs == rhs.rawValue
    }
}

public extension Angle {
    @inline(__always)
    static func random<T>(in range: Range<RawValue>, using generator: inout T) -> Self where T : RandomNumberGenerator {
        return Self(RawValue.random(in: range, using: &generator))
    }
    
    @inline(__always)
    static func random(in range: Range<RawValue>) -> Self {
        return Self(RawValue.random(in: range))
    }

    @inline(__always)
    static func random<T>(in range: ClosedRange<RawValue>, using generator: inout T) -> Self where T : RandomNumberGenerator {
        return Self(RawValue.random(in: range, using: &generator))
    }

    @inline(__always)
    static func random(in range: ClosedRange<RawValue>) -> Self {
        return Self(RawValue.random(in: range))
    }
}

public extension Angle {
    @inline(__always)
    mutating func round(_ rule: FloatingPointRoundingRule) {
        rawValue.round(rule)
    }
    @inline(__always)
    init(sign: FloatingPointSign, exponent: RawValue.Exponent, significand: Self) {
        self.init(rawValue: RawValue(sign: sign, exponent: exponent, significand: significand.rawValue.significand))
    }
    @inline(__always)
    var exponent: RawValue.Exponent {
        return rawValue.exponent
    }
    @inline(__always)
    func distance(to other: Self) -> RawValue.Stride {
        return rawValue.distance(to: other.rawValue)
    }
    @inline(__always)
    func advanced(by n: RawValue.Stride) -> Self {
        return Self(rawValue: rawValue.advanced(by: n))
    }
    @inline(__always)
    init(signOf: Self, magnitudeOf: Self) {
        self.init(RawValue(signOf: signOf.rawValue, magnitudeOf: magnitudeOf.rawValue))
    }
    @inline(__always)
    init(_ value: Int) {
        self.init(RawValue(value))
    }
    @inline(__always)
    init<Source>(_ value: Source) where Source : BinaryInteger {
        self.init(RawValue(value))
    }
    @inline(__always)
    static var radix: Int {
        return RawValue.radix
    }
    @inline(__always)
    static var nan: Self {
        return Self(rawValue: .nan)
    }
    @inline(__always)
    static var signalingNaN: Self {
        return Self(rawValue: .signalingNaN)
    }
    @inline(__always)
    static var infinity: Self {
        return Self(rawValue: .infinity)
    }
    @inline(__always)
    static var greatestFiniteMagnitude: Self {
        return Self(rawValue: .greatestFiniteMagnitude)
    }
    @inline(__always)
    static var pi: Self {
        return Self(rawValue: .pi)
    }
    @inline(__always)
    var ulp: Self {
        return Self(rawValue: rawValue.ulp)
    }
    @inline(__always)
    static var leastNormalMagnitude: Self {
        return Self(rawValue: .leastNormalMagnitude)
    }
    @inline(__always)
    static var leastNonzeroMagnitude: Self {
        return Self(rawValue: .leastNonzeroMagnitude)
    }
    @inline(__always)
    var sign: FloatingPointSign {
        return rawValue.sign
    }
    @inline(__always)
    var significand: Self {
        return Self(rawValue: rawValue.significand)
    }
    @inline(__always)
    mutating func formRemainder(dividingBy other: Self) {
        rawValue.formRemainder(dividingBy: other.rawValue)
    }
    @inline(__always)
    mutating func formTruncatingRemainder(dividingBy other: Self) {
        rawValue.formTruncatingRemainder(dividingBy: other.rawValue)
    }
    @inline(__always)
    mutating func formSquareRoot() {
        rawValue.formSquareRoot()
    }
    @inline(__always)
    mutating func addProduct(_ lhs: Self, _ rhs: Self) {
        rawValue.addProduct(lhs.rawValue, rhs.rawValue)
    }
    @inline(__always)
    var nextUp: Self {
        return Self(rawValue: rawValue.nextUp)
    }
    @inline(__always)
    func isEqual(to other: Self) -> Bool {
        return rawValue.isEqual(to: other.rawValue)
    }
    @inline(__always)
    func isLess(than other: Self) -> Bool {
        return rawValue.isLess(than: other.rawValue)
    }
    @inline(__always)
    func isLessThanOrEqualTo(_ other: Self) -> Bool {
        return rawValue.isLessThanOrEqualTo(other.rawValue)
    }
    @inline(__always)
    func isTotallyOrdered(belowOrEqualTo other: Self) -> Bool {
        return rawValue.isTotallyOrdered(belowOrEqualTo: other.rawValue)
    }
    @inline(__always)
    var isNormal: Bool {
        return rawValue.isNormal
    }
    @inline(__always)
    var isZero: Bool {
        return rawValue.isZero
    }
    @inline(__always)
    var isSubnormal: Bool {
        return rawValue.isSubnormal
    }
    @inline(__always)
    var isInfinite: Bool {
        return rawValue.isInfinite
    }
    @inline(__always)
    var isNaN: Bool {
        return rawValue.isNaN
    }
    @inline(__always)
    var isSignalingNaN: Bool {
        rawValue.isSignalingNaN
    }
    @inline(__always)
    var isCanonical: Bool {
        return rawValue.isCanonical
    }
    @inline(__always)
    var magnitude: Magnitude {
        return Self(rawValue: rawValue.magnitude)
    }
}

/// Represents an angle in radians
public struct Radians: Angle, Hashable, Codable {
    public typealias RawValue = Float
    public typealias Magnitude = Self
    public typealias IntegerLiteralType = RawValue
    public typealias Exponent = RawValue.Exponent
    public typealias Stride = RawValue.Stride

    public var rawValue: RawValue
    
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    @inline(__always)
    public init(_ rawValue: RawValue) {
        self.init(rawValue: rawValue)
    }
    @inline(__always)
    public init?<T>(exactly source: T) where T : BinaryInteger {
        self.init(RawValue(source))
    }
    @inline(__always)
    public init(integerLiteral value: RawValue) {
        self.init(rawValue: value)
    }
    @inline(__always)
    public init(rawValueAsRadians: Float) {
        self.init(rawValue: rawValueAsRadians)
    }
    @inline(__always)
    public init(_ value: any Angle) {
        self.init(rawValue: value.rawValueAsRadians)
    }
    
    @inline(__always)
    public var rawValueAsRadians: Float {
        return rawValue
    }
    @inline(__always)
    public var rawValueAsDegrees: Float {
        return rawValue * (180 / RawValue.pi)
    }
}

public struct Degrees: Angle, Hashable, Codable {
    public typealias RawValue = Float
    public typealias Magnitude = Self
    public typealias IntegerLiteralType = RawValue
    public typealias Exponent = RawValue.Exponent
    public typealias Stride = RawValue.Stride

    public var rawValue: RawValue
    
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    @inline(__always)
    public init(_ rawValue: RawValue) {
        self.init(rawValue: rawValue)
    }
    @inline(__always)
    public init?<T>(exactly source: T) where T : BinaryInteger {
        self.init(RawValue(source))
    }
    @inline(__always)
    public init(integerLiteral value: RawValue) {
        self.init(rawValue: value)
    }
    @inline(__always)
    public init(rawValueAsRadians: Float) {
        self.init(rawValue: rawValueAsRadians * (180 / RawValue.pi))
    }
    @inline(__always)
    public init(_ value: any Angle) {
        self.init(rawValue: value.rawValueAsDegrees)
    }
    
    @inline(__always)
    public var rawValueAsRadians: Float {
        return rawValue * (RawValue.pi / 180)
    }
    @inline(__always)
    public var rawValueAsDegrees: Float {
        return rawValue
    }
}

public extension Degrees {
    @inline(__always)
    mutating func interpolate(to: Self, _ method: InterpolationMethod) {
        self = self.interpolated(to: to, method)
    }
    
    @inline(__always)
    func interpolated(to: Self, _ method: InterpolationMethod) -> Self {
        if case .linear(_, shortest: true) = method {
            // Shortest distance
            let shortest = self.shortestAngle(to: to)
            return Self(self.rawValue.interpolated(to: (self + shortest).rawValue, method))
        }
        return Self(self.rawValue.interpolated(to: to.rawValue, method))
    }
    
    @inline(__always)
    mutating func interpolate(to: Radians, _ method: InterpolationMethod) {
        self.interpolate(to: Self(to), method)
    }
    
    @inline(__always)
    func interpolated(to: Radians, _ method: InterpolationMethod) -> Self {
        return self.interpolated(to: Self(to), method)
    }
    
    @inline(__always)
    static func random() -> Self {
        return .random(in: 0 ..< 360)
    }
}

extension Degrees {
    /// Returns an angle equivalent to the current angle if it rolled over when exceeding 360, or rolled back to 360 when less then zero. The value is always within 0 ... 360
    @inlinable
    public var normalized: Self {
        let scaler: RawValue = 1000000
        let degrees = (self * scaler).truncatingRemainder(dividingBy: 360 * scaler) / scaler
        if self < 0 {
            return degrees + 360°
        }
        return degrees
    }
    
    /// Makes the angle equivalent to the current angle if it rolled over when exceeding 360, or rolled back to 360 when less then zero. The value is always within 0 ... 360
    @inline(__always)
    public mutating func normalize() {
        self = self.normalized
    }
    
    /// Returns the shortest angle, that when added to `self.normalized` will result in `destination.normalized`
    @inlinable
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

postfix operator °
public postfix func °(lhs: Degrees.RawValue) -> Degrees {
    return Degrees(lhs)
}
