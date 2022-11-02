/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * http://stregasgate.com
 */
#if GameMathUseFastInverseSquareRoot

import Foundation

public extension Float {
    @inline(__always)
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
    @inline(__always)
    public var normalized: Self  {
        let x = pow(x, 2)
        let y = pow(y, 2)
        let squaredMagnitude = x + y
        return self * squaredMagnitude.fastInverseSquareRoot()
    }
    
    @inline(__always)
    public mutating func normalize() {
        let x = pow(x, 2)
        let y = pow(y, 2)
        let squaredMagnitude = x + y
        self *= squaredMagnitude.fastInverseSquareRoot()
    }
}

extension Vector3 {
    @inline(__always)
    public var normalized: Self  {
        let x = pow(x, 2)
        let y = pow(y, 2)
        let z = pow(z, 2)
        let squaredMagnitude = x + y + z
        return self * squaredMagnitude.fastInverseSquareRoot()
    }
    
    @inline(__always)
    public mutating func normalize() {
        let x = pow(x, 2)
        let y = pow(y, 2)
        let z = pow(z, 2)
        let squaredMagnitude = x + y + z
        self *= squaredMagnitude.fastInverseSquareRoot()
    }
}

#endif
