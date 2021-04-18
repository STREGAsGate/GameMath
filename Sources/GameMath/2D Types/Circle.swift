/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

public struct Circle<T: Numeric> {
    public var center: Position2<T>
    public var radius: T

    public init(center: Position2<T>, radius: T) {
        self.center = center
        self.radius = radius
    }
}

extension Circle: Equatable where T: Equatable {}
extension Circle: Hashable where T: Hashable {}
extension Circle: Codable where T: Codable {}
