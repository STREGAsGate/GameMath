/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

import Foundation

//TODO: Swift will eventually make this source unnecessary

public func sin<T: BinaryFloatingPoint>(_ value: T) -> T {
    #if !os(macOS) && !targetEnvironment(macCatalyst)
    #if swift(>=5.4)
    if #available(macOS 11, macCatalyst 14.5, iOS 14, tvOS 14, watchOS 7, *) {
        if let value = value as? Float16 {
            return sin(value) as! T
        }
    }
    #else
    if #available(iOS 14, tvOS 14, watchOS 7, *) {
        if let value = value as? Float16 {
            return sin(value) as! T
        }
    }
    #endif
    #endif
    
    switch value {
    case let value as Float32:
        return sin(value) as! T
    case let value as Float64:
        return sin(value) as! T
    #if arch(x86_64) && !os(Windows)
    case let value as Float80:
        return sin(value) as! T
    #endif
    default:
        return T(sin(Double(value)))
    }
}

public func cos<T: BinaryFloatingPoint>(_ value: T) -> T {
    #if !os(macOS) && !targetEnvironment(macCatalyst)
    #if swift(>=5.4)
    if #available(macOS 11, macCatalyst 14.5, iOS 14, tvOS 14, watchOS 7, *) {
        if let value = value as? Float16 {
            return cos(value) as! T
        }
    }
    #else
    if #available(iOS 14, tvOS 14, watchOS 7, *) {
        if let value = value as? Float16 {
            return cos(value) as! T
        }
    }
    #endif
    #endif
    
    switch value {
    case let value as Float:
        return cos(value) as! T
    case let value as Double:
        return cos(value) as! T
    #if arch(x86_64) && !os(Windows)
    case let value as Float80:
        return cos(value) as! T
    #endif
    default:
        return T(cos(Double(value)))
    }
}

public func tan<T: BinaryFloatingPoint>(_ value: T) -> T {
    #if !os(macOS) && !targetEnvironment(macCatalyst)
    #if swift(>=5.4)
    if #available(macOS 11, macCatalyst 14.5, iOS 14, tvOS 14, watchOS 7, *) {
        if let value = value as? Float16 {
            return tan(value) as! T
        }
    }
    #else
    if #available(iOS 14, tvOS 14, watchOS 7, *) {
        if let value = value as? Float16 {
            return tan(value) as! T
        }
    }
    #endif
    #endif
    
    switch value {
    case let value as Float:
        return tan(value) as! T
    case let value as Double:
        return tan(value) as! T
    #if arch(x86_64) && !os(Windows)
    case let value as Float80:
        return tan(value) as! T
    #endif
    default:
        return T(tan(Double(value)))
    }
}


public func asin<T: BinaryFloatingPoint>(_ value: T) -> T {
    #if !os(macOS) && !targetEnvironment(macCatalyst)
    #if swift(>=5.4)
    if #available(macOS 11, macCatalyst 14.5, iOS 14, tvOS 14, watchOS 7, *) {
        if let value = value as? Float16 {
            return asin(value) as! T
        }
    }
    #else
    if #available(iOS 14, tvOS 14, watchOS 7, *) {
        if let value = value as? Float16 {
            return asin(value) as! T
        }
    }
    #endif
    #endif
    
    switch value {
    case let value as Float:
        return asin(value) as! T
    case let value as Double:
        return asin(value) as! T
    #if arch(x86_64) && !os(Windows)
    case let value as Float80:
        return asin(value) as! T
    #endif
    default:
        return T(asin(Double(value)))
    }
}

public func acos<T: BinaryFloatingPoint>(_ value: T) -> T {
    #if !os(macOS) && !targetEnvironment(macCatalyst)
    #if swift(>=5.4)
    if #available(macOS 11, macCatalyst 14.5, iOS 14, tvOS 14, watchOS 7, *) {
        if let value = value as? Float16 {
            return acos(value) as! T
        }
    }
    #else
    if #available(iOS 14, tvOS 14, watchOS 7, *) {
        if let value = value as? Float16 {
            return acos(value) as! T
        }
    }
    #endif
    #endif
    
    switch value {
    case let value as Float:
        return acos(value) as! T
    case let value as Double:
        return acos(value) as! T
    #if arch(x86_64) && !os(Windows)
    case let value as Float80:
        return acos(value) as! T
    #endif
    default:
        return T(acos(Double(value)))
    }
}

public func atan<T: BinaryFloatingPoint>(_ value: T) -> T {
    #if !os(macOS) && !targetEnvironment(macCatalyst)
    #if swift(>=5.4)
    if #available(macOS 11, macCatalyst 14.5, iOS 14, tvOS 14, watchOS 7, *) {
        if let value = value as? Float16 {
            return atan(value) as! T
        }
    }
    #else
    if #available(iOS 14, tvOS 14, watchOS 7, *) {
        if let value = value as? Float16 {
            return atan(value) as! T
        }
    }
    #endif
    #endif
    
    switch value {
    case let value as Float:
        return atan(value) as! T
    case let value as Double:
        return atan(value) as! T
    #if arch(x86_64) && !os(Windows)
    case let value as Float80:
        return atan(value) as! T
    #endif
    default:
        return T(atan(Double(value)))
    }
}


public func atan2<T: BinaryFloatingPoint>(_ value1: T, _ value2: T) -> T {
    #if !os(macOS) && !targetEnvironment(macCatalyst)
    #if swift(>=5.4)
    if #available(macOS 11, macCatalyst 14.5, iOS 14, tvOS 14, watchOS 7, *) {
        if let value1 = value1 as? Float16, let value2 = value2 as? Float16 {
            return atan2(value1, value2) as! T
        }
    }
    #else
    if #available(iOS 14, tvOS 14, watchOS 7, *) {
        if let value1 = value1 as? Float16, let value2 = value2 as? Float16 {
            return atan2(value1, value2) as! T
        }
    }
    #endif
    #endif
    
    if let value1 = value1 as? Float32, let value2 = value2 as? Float32 {
        return atan2(value1, value2) as! T
    }
    
    if let value1 = value1 as? Float64, let value2 = value2 as? Float64 {
        return atan2(value1, value2) as! T
    }
    
    #if arch(x86_64) && !os(Windows)
    if let value1 = value1 as? Float80, let value2 = value2 as? Float80 {
        return atan2(value1, value2) as! T
    }
    #endif
    
    return T(atan2(Double(value1), Double(value2)))
}
