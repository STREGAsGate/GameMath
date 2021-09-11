/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

public struct Circle {
    public var center: Position2
    public var radius: Float

    public init(center: Position2, radius: Float) {
        self.center = center
        self.radius = radius
    }
}

extension Circle: Equatable {}
extension Circle: Hashable {}
extension Circle: Codable {}
