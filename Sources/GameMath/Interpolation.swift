/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

public enum InterpolationMethod<T: FloatingPoint> {
    /** Interpolates at a constant rate
     `factor` is progress of interpolation. 0 being the source and 1 being destination.
     `shortest` is true if the interpolation direction is the shortest physical distance, otherwise it's the scalar numerical distance. Usful for rotations.
     */
    case linear(_ factor: T, shortest: Bool = true)
}

public extension FloatingPoint {
    /// Interpolates toward `to` by using `method `
    func interpolated(to: Self, _ method: InterpolationMethod<Self>) -> Self {
        switch method {
        case let .linear(factor, _):
            return self.lerped(to: to, factor: factor)
        }
    }
    
    /// Interpolates toward `to` by using `method `
    mutating func interpolate(to: Self, _ method: InterpolationMethod<Self>) {
        switch method {
        case let .linear(factor, _):
            return self.lerp(to: to, factor: factor)
        }
    }
}

fileprivate extension FloatingPoint {
    func lerped(to: Self, factor: Self) -> Self {
        return self + (to - self) * factor
    }
    mutating func lerp(to: Self, factor: Self) {
        self = self.lerped(to: to, factor: factor)
    }
}
