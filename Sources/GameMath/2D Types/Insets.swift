/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

public struct Insets<T: Numeric & SIMDScalar>{
    public var top: T
    public var leading: T
    public var bottom: T
    public var trailing: T
    
    public init(top: T, leading: T, bottom: T, trailing: T) {
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
    }
}

extension Insets: Equatable where T: Equatable {}
extension Insets: Hashable where T: Hashable {}
extension Insets: Codable where T: Codable {}

public extension Insets {
    static var zero: Self {
        return Insets(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
}

public extension Insets {
    static func *(lhs: Self, rhs: T) -> Self {
        return Insets(top: lhs.top * rhs, leading: lhs.leading * rhs, bottom: lhs.bottom * rhs, trailing: lhs.trailing * rhs)
    }
    static func *=(lhs: inout Self, rhs: T) {
        lhs = lhs * rhs
    }
}

public extension Insets where T: BinaryInteger {
    static func /(lhs: Self, rhs: T) -> Self {
        return Insets(top: lhs.top / rhs, leading: lhs.leading / rhs, bottom: lhs.bottom / rhs, trailing: lhs.trailing / rhs)
    }
    static func /=(lhs: inout Self, rhs: T) {
        lhs = lhs / rhs
    }
}

public extension Insets where T: FloatingPoint {
    static func /(lhs: Self, rhs: T) -> Self {
        return Insets(top: lhs.top / rhs, leading: lhs.leading / rhs, bottom: lhs.bottom / rhs, trailing: lhs.trailing / rhs)
    }
    static func /=(lhs: inout Self, rhs: T) {
        lhs = lhs / rhs
    }
}
