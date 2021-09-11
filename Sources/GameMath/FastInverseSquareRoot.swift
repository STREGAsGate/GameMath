/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */
#if GameMathUseFastInverseSquareRoot

import Foundation

public extension Float {
    @_transparent
    func fastInverseSquareRoot() -> Self {
        var x = self
        let xhalf = 0.5 * x
        var i = x.bitPattern
        i = 0x5f3759df - (i >> 1)
        x = Self(bitPattern: i)
        x *= (1.5 - xhalf * x * x)
        return x;
    }
}

extension Vector2 {
    @_transparent
    public var normalized: Self  {
        let x = pow(x, 2)
        let y = pow(y, 2)
        let squaredMagnitude = x + y
        return self * squaredMagnitude.fastInverseSquareRoot()
    }
    
    @_transparent
    public mutating func normalize() {
        let x = pow(x, 2)
        let y = pow(y, 2)
        let squaredMagnitude = x + y
        self *= squaredMagnitude.fastInverseSquareRoot()
    }
}

extension Vector3 {
    @_transparent
    public var normalized: Self  {
        let x = pow(x, 2)
        let y = pow(y, 2)
        let z = pow(z, 2)
        let squaredMagnitude = x + y + z
        return self * squaredMagnitude.fastInverseSquareRoot()
    }
    
    @_transparent
    public mutating func normalize() {
        let x = pow(x, 2)
        let y = pow(y, 2)
        let z = pow(z, 2)
        let squaredMagnitude = x + y + z
        self *= squaredMagnitude.fastInverseSquareRoot()
    }
}

#endif
