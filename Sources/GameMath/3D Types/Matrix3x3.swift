/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

public struct Matrix3x3<T: FloatingPoint & SIMDScalar> {
    public var a, b, c: T
    public var e, f, g: T
    public var i, j, k: T
    
    public init(a: T, b: T, c: T,
                e: T, f: T, g: T,
                i: T, j: T, k: T) {
        self.init(a, b, c, e, f, g, i, j, k)
    }
    
    public init(_ a: T, _ b: T, _ c: T,
                _ e: T, _ f: T, _ g: T,
                _ i: T, _ j: T, _ k: T) {
        self.a = a; self.b = b; self.c = c;
        self.e = e; self.f = f; self.g = g;
        self.i = i; self.j = j; self.k = k;
    }
    
    public init(_ matrix4: Matrix4x4<T>) {
        self.a = matrix4.a; self.b = matrix4.b; self.c = matrix4.c;
        self.e = matrix4.e; self.f = matrix4.f; self.g = matrix4.g;
        self.i = matrix4.i; self.j = matrix4.j; self.k = matrix4.k;
    }
    
    public init() {
        self.a = 0; self.b = 0; self.c = 0;
        self.e = 0; self.f = 0; self.g = 0;
        self.i = 0; self.j = 0; self.k = 0;
    }
    
    //MARK: Subscript
    public subscript (_ index: Array<T>.Index) -> T {
        get{
            switch index {
            case 0: return a
            case 1: return b
            case 2: return c
            case 3: return e
            case 4: return f
            case 5: return g
            case 6: return i
            case 7: return j
            case 8: return k
            default:
                fatalError("Index \(index) out of range \(0 ..< 9) for type \(type(of: self))")
            }
        }
        
        set(val) {
            switch index {
            case 0: a = val
            case 1: b = val
            case 2: c = val
            case 3: e = val
            case 4: f = val
            case 5: g = val
            case 6: i = val
            case 7: j = val
            case 8: k = val
            default:
                fatalError("Index \(index) out of range \(0 ..< 9) for type \(type(of: self))")
            }
        }
    }
    
    public subscript (_ column: Array<T>.Index) -> Array<T> {
        get {
            switch column {
            case 0: return [a, e, i]
            case 1: return [b, f, j]
            case 2: return [c, g, k]
            default:
                fatalError("Column \(column) out of range \(0 ..< 3) for type \(type(of: self))")
            }
        }
        set {
            switch column {
            case 0:
                a = newValue[0]
                e = newValue[1]
                i = newValue[2]
            case 1:
                b = newValue[0]
                f = newValue[1]
                j = newValue[2]
            case 2:
                c = newValue[0]
                g = newValue[1]
                k = newValue[2]
            default:
                fatalError("Column \(column) out of range \(0 ..< 3) for type \(type(of: self))")
            }
        }
    }

    public subscript <V: Vector3>(_ index: Array<T>.Index) -> V where V.T == T {
        get {
            switch index {
            case 0: return V(a, b, c)
            case 1: return V(e, f, g)
            case 2: return V(i, j, k)
            default:
                fatalError("Index \(index) out of range \(0 ..< 3) for type \(type(of: self))")
            }
        }
        set {
            switch index {
            case 0:
                a = newValue.x
                b = newValue.y
                c = newValue.z
            case 1:
                e = newValue.x
                f = newValue.y
                g = newValue.z
            case 2:
                i = newValue.x
                j = newValue.y
                k = newValue.z
            default:
                fatalError("Index \(index) out of range \(0 ..< 3) for type \(type(of: self))")
            }
        }
    }
}

public extension Matrix3x3 where T: BinaryFloatingPoint {
    init(direction: Direction3<T>, up: Direction3<T> = .up, right: Direction3<T> = .right) {
        var xaxis: Direction3<T>
        if direction == up {
            xaxis = right
        }else{
            xaxis = up.cross(direction).normalized
            if xaxis.isFinite == false {
                xaxis = direction
            }
        }
        
        var yaxis = direction.cross(xaxis).normalized
        if yaxis.isFinite == false {
            yaxis = up
        }
        
        a = xaxis.x
        e = yaxis.x
        i = direction.x
        
        b = xaxis.y
        f = yaxis.y
        j = direction.y
        
        c = xaxis.z
        g = yaxis.z
        k = direction.z
    }
    
    var rotation: Quaternion<T> {
        get {
            return Quaternion(rotationMatrix: self)
        }
        set {
            let w: T = newValue.w
            let x: T = newValue.x
            let y: T = newValue.y
            let z: T = newValue.z
            
            var fx: T = x * z
            fx -= w * y
            fx *= 2
            
            var fy: T = y * z
            fy += w * x
            fy *= 2
            
            var fz: T = x * x
            fz += y * y
            fz *= 2
            fz = 1 - fz
            
            
            var ux: T = x * y
            ux += w * z
            ux *= 2
            
            var uy: T = x * x
            uy += z * z
            uy *= 2
            uy = 1 - uy
            
            var uz: T = y * z
            uz -= w * x
            uz *= 2
            
            
            var rx: T = y * y
            rx += z * z
            rx *= 2
            rx = 1 - rx
            
            var ry: T = x * y
            ry -= w * z
            ry *= 2
            
            var rz: T = x * z
            rz += w * y
            rz *= 2
            
            a = rx; b = ry; c = rz
            e = ux; f = uy; g = uz
            i = fx; j = fy; k = fz
        }
    }
}

public extension Matrix3x3 {
    func transposedArray() -> [T] {
        return [a, e, i,
                b, f, j,
                c, g, k]
    }
    func array() -> [T] {
        return [a, b, c,
                e, f, g,
                i, j, k]
    }
}

extension Matrix3x3: Equatable where T: Equatable {}
extension Matrix3x3: Hashable where T: Hashable {}
extension Matrix3x3: Codable where T: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(a)
        try container.encode(b)
        try container.encode(c)
        try container.encode(e)
        try container.encode(f)
        try container.encode(g)
        try container.encode(i)
        try container.encode(j)
        try container.encode(k)
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.a = try container.decode(T.self)
        self.b = try container.decode(T.self)
        self.c = try container.decode(T.self)
        self.e = try container.decode(T.self)
        self.f = try container.decode(T.self)
        self.g = try container.decode(T.self)
        self.i = try container.decode(T.self)
        self.j = try container.decode(T.self)
        self.k = try container.decode(T.self)
    }
}
