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

    @inlinable
    public init(_ red: Float, _ green: Float, _ blue: Float, _ alpha: Float = 1) {
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    @inlinable
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

    @inlinable
    public init(white: Float, alpha: Float = 1) {
        self.init(red: white, green: white, blue: white, alpha: alpha)
    }

    @inlinable
    public func withAlpha(_ alpha: Float) -> Color {
        return Self(self.red, self.green, self.blue, alpha)
    }
}

public extension Color {
    @inlinable
    var simd: SIMD4<Float> {
        return SIMD4<Float>(red, green, blue, alpha)
    }

    @inlinable
    func valuesArray() -> [Float] {
        return [red, green, blue, alpha]
    }
}

public extension Color {
    static func +(lhs: Color, rhs: Color) -> Color {
        return Color(lhs.red + rhs.red, lhs.green + rhs.green, lhs.blue + rhs.blue, lhs.alpha + rhs.alpha)
    }
    static func +=(lhs: inout Color, rhs: Color) {
        lhs.red += rhs.red
        lhs.green += rhs.green
        lhs.blue += rhs.blue
        lhs.alpha += rhs.alpha
    }
    
    static func -(lhs: Color, rhs: Color) -> Color {
        return Color(lhs.red - rhs.red, lhs.green - rhs.green, lhs.blue - rhs.blue, lhs.alpha - rhs.alpha)
    }
    static func -=(lhs: inout Color, rhs: Color) {
        lhs.red -= rhs.red
        lhs.green -= rhs.green
        lhs.blue -= rhs.blue
        lhs.alpha -= rhs.alpha
    }
    
    static func *(lhs: Color, rhs: Color) -> Color {
        return Color(lhs.red * rhs.red, lhs.green * rhs.green, lhs.blue * rhs.blue, lhs.alpha * rhs.alpha)
    }
    static func *=(lhs: inout Color, rhs: Color) {
        lhs.red *= rhs.red
        lhs.green *= rhs.green
        lhs.blue *= rhs.blue
        lhs.alpha *= rhs.alpha
    }
    
    static func /(lhs: Color, rhs: Color) -> Color {
        return Color(lhs.red / rhs.red, lhs.green / rhs.green, lhs.blue / rhs.blue, lhs.alpha / rhs.alpha)
    }
    static func /=(lhs: inout Color, rhs: Color) {
        lhs.red /= rhs.red
        lhs.green /= rhs.green
        lhs.blue /= rhs.blue
        lhs.alpha /= rhs.alpha
    }
}

public extension Color {
    static func +(lhs: Color, rhs: Float) -> Color {
        return Color(lhs.red + rhs, lhs.green + rhs, lhs.blue + rhs, lhs.alpha + rhs)
    }
    static func +=(lhs: inout Color, rhs: Float) {
        lhs.red += rhs
        lhs.green += rhs
        lhs.blue += rhs
        lhs.alpha += rhs
    }

    static func -(lhs: Color, rhs: Float) -> Color {
        return Color(lhs.red - rhs, lhs.green - rhs, lhs.blue - rhs, lhs.alpha - rhs)
    }
    static func -=(lhs: inout Color, rhs: Float) {
        lhs.red -= rhs
        lhs.green -= rhs
        lhs.blue -= rhs
        lhs.alpha -= rhs
    }

    static func *(lhs: Color, rhs: Float) -> Color {
        return Color(lhs.red * rhs, lhs.green * rhs, lhs.blue * rhs, lhs.alpha * rhs)
    }
    static func *=(lhs: inout Color, rhs: Float) {
        lhs.red *= rhs
        lhs.green *= rhs
        lhs.blue *= rhs
        lhs.alpha *= rhs
    }

    static func /(lhs: Color, rhs: Float) -> Color {
        return Color(lhs.red / rhs, lhs.green / rhs, lhs.blue / rhs, lhs.alpha / rhs)
    }
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
    @inlinable
    static var clear: Color {
        return Color(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    }
    
    @inlinable
    static var white: Color {
        return Color(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    @inlinable
    static var lightGray: Color {
        return Color(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
    }
    @inlinable
    static var gray: Color {
        return Color(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    }
    @inlinable
    static var darkGray: Color {
        return Color(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0)
    }
    @inlinable
    static var black: Color {
        return Color(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    
    @inlinable
    static var lightRed: Color {
        return Color(red: 1.0, green: 0.25, blue: 0.25, alpha: 1.0)
    }
    @inlinable
    static var lightGreen: Color {
        return Color(red: 0.25, green: 1.0, blue: 0.25, alpha: 1.0)
    }
    @inlinable
    static var lightBlue: Color {
        return Color(red: 0.25, green: 0.25, blue: 1.0, alpha: 1.0)
    }

    @inlinable
    static var red: Color {
        return Color(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    @inlinable
    static var green: Color {
        return Color(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
    }
    @inlinable
    static var blue: Color {
        return Color(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
    }
    
    @inlinable
    static var darRed: Color {
        return Color(red: 0.25, green: 0.05, blue: 0.05, alpha: 1.0)
    }
    @inlinable
    static var darkGreen: Color {
        return Color(red: 0.05, green: 0.25, blue: 0.05, alpha: 1.0)
    }
    @inlinable
    static var darkBlue: Color {
        return Color(red: 0.05, green: 0.05, blue: 0.25, alpha: 1.0)
    }
    
    @inlinable
    static var defaultDiffuseMapColor: Color {
        return Color(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    }
    @inlinable
    static var defaultNormalMapColor: Color {
        return Color(red: 0.5, green: 0.5, blue: 1.0, alpha: 1.0)
    }
    @inlinable
    static var defaultRoughnessMapColor: Color {
        return Color(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    @inlinable
    static var vertexColors: Color {
        return Color(red: -1001, green: -2002, blue: -3003, alpha: -4004)
    }
    
    @inlinable
    static var defaultPointLightColor: Color {
        return Color(red: 1.0, green: 1.0, blue: 0.9, alpha: 1.0)
    }
    @inlinable
    static var defaultSpotLightColor: Color {
        return Color(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
    }
    @inlinable
    static var defaultDirectionalLightColor: Color {
        return Color(red: 0.7, green: 0.7, blue: 1.0, alpha: 1.0)
    }
    
    @inlinable
    static var cyan: Color {
        return Color(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    @inlinable
    static var magenta: Color {
        return Color(red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0)
    }
    @inlinable
    static var yellow: Color {
        return Color(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
    }
    
    @inlinable
    static var orange: Color {
        return Color(red: 1.0, green: 0.64453125, blue: 0.0, alpha: 1.0)
    }
    @inlinable
    static var purple: Color {
        return Color(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0)
    }
    

}

public extension Color {
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
