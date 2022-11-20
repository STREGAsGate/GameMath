/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 * 
 * http://stregasgate.com
 */

#if canImport(Foundation)
import Foundation
#endif

public typealias Colour = Color

public struct Color {
    public var red: Float
    public var green: Float
    public var blue: Float
    public var alpha: Float
    
    public init(red: Float, green: Float, blue: Float, alpha: Float = 1) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    @inline(__always)
    public init(_ red: Float, _ green: Float, _ blue: Float, _ alpha: Float = 1) {
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    @inline(__always)
    public init(_ array: [Float]) {
        self.init(array[0], array[1], array[2], array.count > 3 ? array[3] : 1)
    }
    
    public init(eightBitRed red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = .max) {
        let m: Float = 1.0 / Float(UInt8.max)
        self.red = m * Float(red)
        self.green = m * Float(green)
        self.blue = m * Float(blue)
        self.alpha = m * Float(alpha)
    }
    
    public init(eightBitValues array: [UInt8]) {
        let m: Float = 1.0 / Float(UInt8.max)
        self.red = m * Float(array[0])
        self.green = m * Float(array[1])
        self.blue = m * Float(array[2])
        if array.indices.contains(3) {
            self.alpha = m * Float(array[3])
        }else{
            self.alpha = 1
        }
    }
    
    public init(hexValue: UInt32) {
        self.init(eightBitRed: UInt8((hexValue >> 16) & 0xFF),
                  green: UInt8((hexValue >> 8) & 0xFF),
                  blue: UInt8(hexValue & 0xFF))
    }
    
    #if canImport(Foundation)
    public init?(hexValue: String) {
        let hexString = hexValue.replacingOccurrences(of: "0x", with: "").replacingOccurrences(of: "#", with: "")
        guard hexValue.count >= 6 && hexValue.count <= 8 else {return nil}
       
        var hexValue: UInt64 = 0
        let scanner = Scanner(string: hexString)
        guard scanner.scanHexInt64(&hexValue) else {return nil}
        
        self.init(eightBitRed: UInt8((hexValue >> 24) & 0xFF),
                  green: UInt8((hexValue >> 16) & 0xFF),
                  blue: UInt8((hexValue >> 8) & 0xFF),
                  alpha: UInt8(hexValue & 0xFF))
    }
    #endif

    @inline(__always)
    public init(white: Float, alpha: Float = 1) {
        self.init(red: white, green: white, blue: white, alpha: alpha)
    }

    @inline(__always)
    public func withAlpha(_ alpha: Float) -> Color {
        return Self(self.red, self.green, self.blue, alpha)
    }
}

public extension Color {
    @inline(__always)
    var simd: SIMD4<Float> {
        return SIMD4<Float>(red, green, blue, alpha)
    }

    @inline(__always)
    func valuesArray() -> [Float] {
        return [red, green, blue, alpha]
    }
    
    @inline(__always)
    var eightBitRed: UInt8 {
        return UInt8(clamping: Int(Float(UInt8.max) * red))
    }
    @inline(__always)
    var eightBitGreen: UInt8 {
        return UInt8(clamping: Int(Float(UInt8.max) * green))
    }
    @inline(__always)
    var eightBitBlue: UInt8 {
        return UInt8(clamping: Int(Float(UInt8.max) * blue))
    }
    @inline(__always)
    var eightBitAlpha: UInt8 {
        return UInt8(clamping: Int(Float(UInt8.max) * alpha))
    }
    
    @inline(__always)
    func eightBitValuesArray() -> [UInt8] {
        return [eightBitRed, eightBitGreen, eightBitBlue, eightBitAlpha]
    }
    
    @inline(__always)
    var eightBitHexValue: UInt32 {
        let r = UInt32(eightBitRed) << 24
        let g = UInt32(eightBitGreen) << 16
        let b = UInt32(eightBitBlue) << 8
        let a = UInt32(eightBitAlpha) << 0
        return r | g | b | a
    }
}

public extension Color {
    @inline(__always)
    static func +(lhs: Color, rhs: Color) -> Color {
        return Color(lhs.red + rhs.red, lhs.green + rhs.green, lhs.blue + rhs.blue, lhs.alpha + rhs.alpha)
    }
    @inline(__always)
    static func +=(lhs: inout Color, rhs: Color) {
        lhs.red += rhs.red
        lhs.green += rhs.green
        lhs.blue += rhs.blue
        lhs.alpha += rhs.alpha
    }
    
    @inline(__always)
    static func -(lhs: Color, rhs: Color) -> Color {
        return Color(lhs.red - rhs.red, lhs.green - rhs.green, lhs.blue - rhs.blue, lhs.alpha - rhs.alpha)
    }
    @inline(__always)
    static func -=(lhs: inout Color, rhs: Color) {
        lhs.red -= rhs.red
        lhs.green -= rhs.green
        lhs.blue -= rhs.blue
        lhs.alpha -= rhs.alpha
    }
    
    @inline(__always)
    static func *(lhs: Color, rhs: Color) -> Color {
        return Color(lhs.red * rhs.red, lhs.green * rhs.green, lhs.blue * rhs.blue, lhs.alpha * rhs.alpha)
    }
    @inline(__always)
    static func *=(lhs: inout Color, rhs: Color) {
        lhs.red *= rhs.red
        lhs.green *= rhs.green
        lhs.blue *= rhs.blue
        lhs.alpha *= rhs.alpha
    }
    
    @inline(__always)
    static func /(lhs: Color, rhs: Color) -> Color {
        return Color(lhs.red / rhs.red, lhs.green / rhs.green, lhs.blue / rhs.blue, lhs.alpha / rhs.alpha)
    }
    @inline(__always)
    static func /=(lhs: inout Color, rhs: Color) {
        lhs.red /= rhs.red
        lhs.green /= rhs.green
        lhs.blue /= rhs.blue
        lhs.alpha /= rhs.alpha
    }
}

public extension Color {
    @inline(__always)
    static func +(lhs: Color, rhs: Float) -> Color {
        return Color(lhs.red + rhs, lhs.green + rhs, lhs.blue + rhs, lhs.alpha + rhs)
    }
    @inline(__always)
    static func +=(lhs: inout Color, rhs: Float) {
        lhs.red += rhs
        lhs.green += rhs
        lhs.blue += rhs
        lhs.alpha += rhs
    }

    @inline(__always)
    static func -(lhs: Color, rhs: Float) -> Color {
        return Color(lhs.red - rhs, lhs.green - rhs, lhs.blue - rhs, lhs.alpha - rhs)
    }
    @inline(__always)
    static func -=(lhs: inout Color, rhs: Float) {
        lhs.red -= rhs
        lhs.green -= rhs
        lhs.blue -= rhs
        lhs.alpha -= rhs
    }

    @inline(__always)
    static func *(lhs: Color, rhs: Float) -> Color {
        return Color(lhs.red * rhs, lhs.green * rhs, lhs.blue * rhs, lhs.alpha * rhs)
    }
    @inline(__always)
    static func *=(lhs: inout Color, rhs: Float) {
        lhs.red *= rhs
        lhs.green *= rhs
        lhs.blue *= rhs
        lhs.alpha *= rhs
    }
    
    @inline(__always)
    static func /(lhs: Color, rhs: Float) -> Color {
        return Color(lhs.red / rhs, lhs.green / rhs, lhs.blue / rhs, lhs.alpha / rhs)
    }
    @inline(__always)
    static func /=(lhs: inout Color, rhs: Float) {
        lhs.red /= rhs
        lhs.green /= rhs
        lhs.blue /= rhs
        lhs.alpha /= rhs
    }
}

public func min(_ lhs: Color, _ rhs: Color) -> Color {
    return Color(min(lhs.red, rhs.red), min(lhs.green, rhs.green), min(lhs.blue, rhs.blue), min(lhs.alpha, rhs.alpha))
}

public func max(_ lhs: Color, _ rhs: Color) -> Color {
    return Color(max(lhs.red, rhs.red), max(lhs.green, rhs.green), max(lhs.blue, rhs.blue), max(lhs.alpha, rhs.alpha))
}

//UGColor
public extension Color {
    static let clear = Color(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    
    static let white = Color(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let lightGray = Color(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
    static let gray = Color(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    static let darkGray = Color(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0)
    static let black = Color(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
    static let lightRed = Color(red: 1.0, green: 0.25, blue: 0.25, alpha: 1.0)
    static let lightGreen = Color(red: 0.25, green: 1.0, blue: 0.25, alpha: 1.0)
    static let lightBlue = Color(red: 0.25, green: 0.25, blue: 1.0, alpha: 1.0)

    static let red = Color(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    static let green = Color(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
    static let blue = Color(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
    
    static let darRed = Color(red: 0.25, green: 0.05, blue: 0.05, alpha: 1.0)
    static let darkGreen = Color(red: 0.05, green: 0.25, blue: 0.05, alpha: 1.0)
    static let darkBlue = Color(red: 0.05, green: 0.05, blue: 0.25, alpha: 1.0)

    static let defaultDiffuseMapColor = Color(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)

    static let defaultNormalMapColor = Color(red: 0.5, green: 0.5, blue: 1.0, alpha: 1.0)
    static let defaultRoughnessMapColor = Color(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let vertexColors = Color(red: -1001, green: -2002, blue: -3003, alpha: -4004)
    
    static let defaultPointLightColor = Color(red: 1.0, green: 1.0, blue: 0.9, alpha: 1.0)
    static let defaultSpotLightColor = Color(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
    static let defaultDirectionalLightColor = Color(red: 0.7, green: 0.7, blue: 1.0, alpha: 1.0)

    static let cyan = Color(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let magenta = Color(red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0)
    static let yellow = Color(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
    static let orange = Color(red: 1.0, green: 0.64453125, blue: 0.0, alpha: 1.0)
    static let purple = Color(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0)
}

public extension Color {
    @inline(__always)
    mutating func interpolate(to: Self, _ method: InterpolationMethod) {
        self.red.interpolate(to: to.red, method)
        self.green.interpolate(to: to.green, method)
        self.blue.interpolate(to: to.blue, method)
        self.alpha.interpolate(to: to.alpha, method)
    }
    
    @inline(__always)
    func interpolated(to: Self, _ method: InterpolationMethod) -> Self {
        return Self(self.red.interpolated(to: to.red, method),
                    self.green.interpolated(to: to.green, method),
                    self.blue.interpolated(to: to.blue, method),
                    self.alpha.interpolated(to: to.alpha, method))
    }
}

extension Color: Equatable {}
extension Color: Hashable {}
extension Color: Codable {}
