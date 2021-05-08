/**
 * Copyright (c) 2021 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 * Licensed under Apache License v2.0
 *
 * Find me on https://www.YouTube.com/STREGAsGate, or social media @STREGAsGate
 */

public struct Matrix4x4<T: FloatingPoint & SIMDScalar> {
    public var a: T, b: T, c: T, d: T
    public var e: T, f: T, g: T, h: T
    public var i: T, j: T, k: T, l: T
    public var m: T, n: T, o: T, p: T
    
    public init(_ a: T, _ b: T, _ c: T, _ d: T,
                _ e: T, _ f: T, _ g: T, _ h: T,
                _ i: T, _ j: T, _ k: T, _ l: T,
                _ m: T, _ n: T, _ o: T, _ p: T) {
        self.a = a; self.b = b; self.c = c; self.d = d
        self.e = e; self.f = f; self.g = g; self.h = h
        self.i = i; self.j = j; self.k = k; self.l = l
        self.m = m; self.n = n; self.o = o; self.p = p
    }

    public init(a: T, b: T, c: T, d: T,
                e: T, f: T, g: T, h: T,
                i: T, j: T, k: T, l: T,
                m: T, n: T, o: T, p: T) {
        self.init(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p)
    }
    
    public init(repeating value: T) {
        self.init(a: value, b: value, c: value, d: value,
                  e: value, f: value, g: value, h: value,
                  i: value, j: value, k: value, l: value,
                  m: value, n: value, o: value, p: value)
    }
    
    public init(_ value: [T]) {
        assert(value.count == 16, "Matrix4x4 must be initialized with exactly 16 elements.")
        self.init(a: value[0],  b: value[1],  c: value[2],  d: value[3],
                  e: value[4],  f: value[5],  g: value[6],  h: value[7],
                  i: value[8],  j: value[9],  k: value[10], l: value[11],
                  m: value[12], n: value[13], o: value[14], p: value[15])
    }
}

public extension Matrix4x4 where T: BinaryFloatingPoint {
    init<V: BinaryFloatingPoint>(_ value: Matrix4x4<V>) {
        self.init(T(value.a),
                  T(value.b),
                  T(value.c),
                  T(value.d),
                  T(value.e),
                  T(value.f),
                  T(value.g),
                  T(value.h),
                  T(value.i),
                  T(value.j),
                  T(value.k),
                  T(value.l),
                  T(value.m),
                  T(value.n),
                  T(value.o),
                  T(value.p))
    }
}

public extension Matrix4x4 {
    static var identity: Self {Self(a: 1, b: 0, c: 0, d: 0,
                                    e: 0, f: 1, g: 0, h: 0,
                                    i: 0, j: 0, k: 1, l: 0,
                                    m: 0, n: 0, o: 0, p: 1)}
    
    mutating func becomeIdentity() {
        a = 1; b = 0; c = 0; d = 0
        e = 0; f = 1; g = 0; h = 0
        i = 0; j = 0; k = 1; l = 0
        m = 0; n = 0; o = 0; p = 1
    }
    
    var inverse: Self {
        var a: T = self.f * self.k * self.p
        a -= self.f * self.l * self.o
        a -= self.j * self.g * self.p
        a += self.j * self.h * self.o
        a += self.n * self.g * self.l
        a -= self.n * self.h * self.k
        var b: T = -self.b * self.k * self.p
        b += self.b * self.l * self.o
        b += self.j * self.c * self.p
        b -= self.j * self.d * self.o
        b -= self.n * self.c * self.l
        b += self.n * self.d * self.k
        var c: T = self.b * self.g * self.p
        c -= self.b * self.h * self.o
        c -= self.f * self.c * self.p
        c += self.f * self.d * self.o
        c += self.n * self.c * self.h
        c -= self.n * self.d * self.g
        var d: T = -self.b * self.g * self.l
        d += self.b * self.h * self.k
        d += self.f * self.c * self.l
        d -= self.f * self.d * self.k
        d -= self.j * self.c * self.h
        d += self.j * self.d * self.g
        
        var e: T = -self.e * self.k * self.p
        e += self.e * self.l * self.o
        e += self.i * self.g * self.p
        e -= self.i * self.h * self.o
        e -= self.m * self.g * self.l
        e += self.m * self.h * self.k
        var f: T = self.a * self.k * self.p
        f -= self.a * self.l * self.o
        f -= self.i * self.c * self.p
        f += self.i * self.d * self.o
        f += self.m * self.c * self.l
        f -= self.m * self.d * self.k
        var g: T = -self.a * self.g * self.p
        g += self.a * self.h * self.o
        g += self.e * self.c * self.p
        g -= self.e * self.d * self.o
        g -= self.m * self.c * self.h
        g += self.m * self.d * self.g
        var h: T = self.a * self.g * self.l
        h -= self.a * self.h * self.k
        h -= self.e * self.c * self.l
        h += self.e * self.d * self.k
        h += self.i * self.c * self.h
        h -= self.i * self.d * self.g
        
        var i: T = self.e * self.j * self.p
        i -= self.e * self.l * self.n
        i -= self.i * self.f * self.p
        i += self.i * self.h * self.n
        i += self.m * self.f * self.l
        i -= self.m * self.h * self.j
        var j: T = -self.a * self.j * self.p
        j += self.a * self.l * self.n
        j += self.i * self.b * self.p
        j -= self.i * self.d * self.n
        j -= self.m * self.b * self.l
        j += self.m * self.d * self.j
        var k: T = self.a * self.f * self.p
        k -= self.a * self.h * self.n
        k -= self.e * self.b * self.p
        k += self.e * self.d * self.n
        k += self.m * self.b * self.h
        k -= self.m * self.d * self.f
        var l: T = -self.a * self.f * self.l
        l += self.a * self.h * self.j
        l += self.e * self.b * self.l
        l -= self.e * self.d * self.j
        l -= self.i * self.b * self.h
        l += self.i * self.d * self.f
        
        var m: T = -self.e * self.j * self.o
        m += self.e * self.k * self.n
        m += self.i * self.f * self.o
        m -= self.i * self.g * self.n
        m -= self.m * self.f * self.k
        m += self.m * self.g * self.j
        var n: T = self.a * self.j * self.o
        n -= self.a * self.k * self.n
        n -= self.i * self.b * self.o
        n += self.i * self.c * self.n
        n += self.m * self.b * self.k
        n -= self.m * self.c * self.j
        var o: T = -self.a * self.f * self.o
        o += self.a * self.g * self.n
        o += self.e * self.b * self.o
        o -= self.e * self.c * self.n
        o -= self.m * self.b * self.g
        o += self.m * self.c * self.f
        var p: T = self.a * self.f * self.k
        p -= self.a * self.g * self.j
        p -= self.e * self.b * self.k
        p += self.e * self.c * self.j
        p += self.i * self.b * self.g
        p -= self.i * self.c * self.f
        
        var inv: Matrix4x4<T> = Matrix4x4<T>(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p)
        
        var det: T = self.a * inv.a
        det += self.b * inv.b
        det += self.c * inv.i
        det += self.d * inv.m
        
        assert(det != 0, "If this is a Perspective Matrix check that clippingPlane.near is at least ClippingPlane.minPerspectiveNear")
        
        det = 1 / det
        
        for i in 0 ..< 16 {
            inv[i] *= det
        }
        
        return inv
    }
    
    //MARK: Subscript
    subscript (_ index: Array<T>.Index) -> T {
        get{
            switch index {
            case 0: return a
            case 1: return b
            case 2: return c
            case 3: return d
            case 4: return e
            case 5: return f
            case 6: return g
            case 7: return h
            case 8: return i
            case 9: return j
            case 10: return k
            case 11: return l
            case 12: return m
            case 13: return n
            case 14: return o
            case 15: return p
            default:
                fatalError("Index \(index) out of range \(0 ..< 16) for type \(type(of: self))")
            }
        }
        
        set(val) {
            switch index {
            case 0: a = val
            case 1: b = val
            case 2: c = val
            case 3: d = val
            case 4: e = val
            case 5: f = val
            case 6: g = val
            case 7: h = val
            case 8: i = val
            case 9: j = val
            case 10: k = val
            case 11: l = val
            case 12: m = val
            case 13: n = val
            case 14: o = val
            case 15: p = val
            default:
                fatalError("Index \(index) out of range \(0 ..< 16) for type \(type(of: self))")
            }
        }
    }
    
    subscript (_ column: Array<T>.Index) -> Array<T> {
        get{
            assert(column < 4, "Index \(column) out of range \(0 ..< 4) for type \(type(of: self))")
            switch column {
            case 0: return [a, e, i, m]
            case 1: return [b, f, j, n]
            case 2: return [c, g, k, o]
            case 3: return [m, n, o, p]
            default:
                fatalError()
            }
        }
        set{
            assert(column < 4, "Index \(column) out of range \(0 ..< 4) for type \(type(of: self))")
            assert(newValue.count == 4, "NewValue count must be exactly 4.")
            switch column {
            case 0:
                a = newValue[0]
                e = newValue[1]
                i = newValue[2]
                m = newValue[3]
            case 1:
                b = newValue[0]
                f = newValue[1]
                j = newValue[2]
                n = newValue[3]
            case 2:
                c = newValue[0]
                g = newValue[1]
                k = newValue[2]
                o = newValue[3]
            case 3:
                m = newValue[0]
                n = newValue[1]
                o = newValue[2]
                p = newValue[3]
            default:
                fatalError()
            }
        }
    }
}



//MARK: - Transform

public extension Matrix4x4 where T: BinaryFloatingPoint {
    var transform: Transform3<T> {
        var transform: Transform3<T> = .empty
        transform.position = position
        transform.rotation = rotation
        transform.scale = scale
        return transform
    }
}

//MARK: Translate
public extension Matrix4x4 where T: BinaryFloatingPoint {
    init(position: Position3<T>) {
        self.init(1, 0, 0, position.x,
                  0, 1, 0, position.y,
                  0, 0, 1, position.z,
                  0, 0, 0, 1)
    }
    
    var position: Position3<T> {
        get {
            return Position3(x: d, y: h, z: l)
        }
        set {
            d = newValue.x
            h = newValue.y
            l = newValue.z
        }
    }
}

//MARK: Rotate
public extension Matrix4x4 where T: BinaryFloatingPoint {
    init(rotation quaternion: Quaternion<T>) {
        let w: T = quaternion.w
        let x: T = quaternion.x
        let y: T = quaternion.y
        let z: T = quaternion.z


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

        a = rx; b = ry; c = rz; d = 0
        e = ux; f = uy; g = uz; h = 0
        i = fx; j = fy; k = fz; l = 0
        m = 0;  n = 0;  o = 0;  p = 1
    }
    
    init(rotationWithForward forward: Direction3<T>, up: Direction3<T> = .up, right: Direction3<T> = .right) {
        self.init(right.x,     right.y,    right.z,    0,
                  up.x,        up.y,       up.z,       0,
                  forward.x,   forward.y,  forward.z,  0,
                  0,           0,          0,          1)
    }
    
    var rotation: Quaternion<T> {
        get {
            return Quaternion(rotationMatrix: self.rotationMatrix)
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
    
    var rotationMatrix: Self {
        let scale = self.scale
        return Matrix4x4<T>(a: a/scale.x, b: b/scale.y, c: c/scale.z, d: 0,
                            e: e/scale.x, f: f/scale.y, g: g/scale.z, h: 0,
                            i: i/scale.x, j: j/scale.y, k: k/scale.z, l: 0,
                            m: 0,         n: 0,         o: 0,         p: 0)
    }
    
    func lookingAt(_ position: Position3<T>) -> Self {
        let eye = self.position
        let zaxis = Direction3<T>(eye - position).normalized// The "forward" vector.
        let xaxis = self.rotation.up.cross(zaxis)           // The "right" vector.
        let yaxis = zaxis.cross(xaxis)                      // The "up" vector.
        
        return Matrix4x4<T>(a: xaxis.x, b: xaxis.y, c: xaxis.z, d: -xaxis.dot(eye),
                            e: yaxis.x, f: yaxis.y, g: yaxis.z, h: -yaxis.dot(eye),
                            i: zaxis.x, j: zaxis.y, k: zaxis.z, l: -zaxis.dot(eye),
                            m: 0,       n: 0,       o: 0,       p: 1)
    }
}

//MARK: Scale
public extension Matrix4x4 {
    init(scale size: Size3<T>) {
        self.init(size.x,  0,      0,      0,
                  0,       size.y, 0,      0,
                  0,       0,      size.z, 0,
                  0,       0,      0,      1)
    }
    
    var scale: Size3<T> {
        get {
            var w: T = a * a
            w += e * e
            w += i * i
            var h: T = b * b
            h += f * f
            h += j * j
            var d: T = c * c
            d += g * g
            d += k * k
            return Size3<T>(width: w.squareRoot(),
                            height: h.squareRoot(),
                            depth: d.squareRoot())
        }
        set {
            a = newValue.width
            f = newValue.height
            k = newValue.depth
        }
    }
}

//MARK: - Projection
public extension Matrix4x4 where T: BinaryFloatingPoint {
    init(perspectiveWithFOV fov: T, aspect: T, near: T, far: T) {
        let tanHalfFOV: T = tan(fov / 2);
        let zRange: T = near - far;
        
        var a: T = tanHalfFOV * aspect
        a = 1 / a
        let f: T = 1 / tanHalfFOV
        var k: T = -near - far
        k /= zRange
        var l: T = far * near
        l *= 2
        l /= zRange
        
        self.init(a, 0, 0, 0,
                  0, f, 0, 0,
                  0, 0, k, l,
                  0, 0, 1, 0)
    }
    
    init(orthographicWithTop top: T, left: T, bottom: T, right: T, near: T, far: T) {
        let width = right - left;
        let height = top - bottom;
        let depth = -(far - near);
        
        self.init(2 / width,   0,          0,          -(right + left) / width,
                  0,           2 / height, 0,          -(top + bottom) / height,
                  0,           0,          2 / depth,  -(far + near) / depth,
                  0,           0,          0,          1)
    }
}

//MARK: - Graphics
extension Matrix4x4 {
    public var simd: SIMD16<T> {
        return SIMD16<T>(a, b, c, d,
                         e, f, g, h,
                         i, j, k, l,
                         m, n, o, p)
    }
    public var transposedSIMD: SIMD16<T>  {
        return SIMD16<T>(a, e, i, m,
                         b, f, j, n,
                         c, g, k, o,
                         d, h, l, p)
    }
}

extension Matrix4x4 {
    public func transposedArray() -> [T] {
        return [a, e, i, m,
                b, f, j, n,
                c, g, k, o,
                d, h, l, p]
    }
    
    public func array() -> [T] {
        return [a, b, c, d,
                e, f, g, h,
                i, j, k, l,
                m, n, o, p]
    }
    
    internal init(transposedArray value: [T]) {
        assert(value.count == 16, "Matrix4x4 must be initialized with exactly 16 elements.")
        self.init(a: value[0], b: value[4], c: value[8],  d: value[12],
                  e: value[1], f: value[5], g: value[9],  h: value[13],
                  i: value[2], j: value[6], k: value[10], l: value[14],
                  m: value[3], n: value[7], o: value[11], p: value[15])
    }
    
    public func transposed() -> Self {
        return Self(self.transposedArray())
    }
}

extension Matrix4x4 where T: BinaryFloatingPoint {
    public var isFinite: Bool {
        for value in self.array() {
            guard value.isFinite else {return false}
        }
        return true
    }
}

//MARK: - Operators
public extension Matrix4x4 {
    static func *=(lhs: inout Self, rhs: Self) {
        var a: T = lhs.a * rhs.a
        a += lhs.b * rhs.e
        a += lhs.c * rhs.i
        a += lhs.d * rhs.m
        var b: T = lhs.a * rhs.b
        b += lhs.b * rhs.f
        b += lhs.c * rhs.j
        b += lhs.d * rhs.n
        var c: T = lhs.a * rhs.c
        c += lhs.b * rhs.g
        c += lhs.c * rhs.k
        c += lhs.d * rhs.o
        var d: T = lhs.a * rhs.d
        d += lhs.b * rhs.h
        d += lhs.c * rhs.l
        d += lhs.d * rhs.p
        
        var e: T = lhs.e * rhs.a
        e += lhs.f * rhs.e
        e += lhs.g * rhs.i
        e += lhs.h * rhs.m
        var f: T = lhs.e * rhs.b
        f += lhs.f * rhs.f
        f += lhs.g * rhs.j
        f += lhs.h * rhs.n
        var g: T = lhs.e * rhs.c
        g += lhs.f * rhs.g
        g += lhs.g * rhs.k
        g += lhs.h * rhs.o
        var h: T = lhs.e * rhs.d
        h += lhs.f * rhs.h
        h += lhs.g * rhs.l
        h += lhs.h * rhs.p
        
        var i: T = lhs.i * rhs.a
        i += lhs.j * rhs.e
        i += lhs.k * rhs.i
        i += lhs.l * rhs.m
        var j: T = lhs.i * rhs.b
        j += lhs.j * rhs.f
        j += lhs.k * rhs.j
        j += lhs.l * rhs.n
        var k: T = lhs.i * rhs.c
        k += lhs.j * rhs.g
        k += lhs.k * rhs.k
        k += lhs.l * rhs.o
        var l: T = lhs.i * rhs.d
        l += lhs.j * rhs.h
        l += lhs.k * rhs.l
        l += lhs.l * rhs.p
        
        var m: T = lhs.m * rhs.a
        m += lhs.n * rhs.e
        m += lhs.o * rhs.i
        m += lhs.p * rhs.m
        var n: T = lhs.m * rhs.b
        n += lhs.n * rhs.f
        n += lhs.o * rhs.j
        n += lhs.p * rhs.n
        var o: T = lhs.m * rhs.c
        o += lhs.n * rhs.g
        o += lhs.o * rhs.k
        o += lhs.p * rhs.o
        var p: T = lhs.m * rhs.d
        p += lhs.n * rhs.h
        p += lhs.o * rhs.l
        p += lhs.p * rhs.p
        
        lhs.a = a
        lhs.b = b
        lhs.c = c
        lhs.d = d
        lhs.e = e
        lhs.f = f
        lhs.g = g
        lhs.h = h
        lhs.i = i
        lhs.j = j
        lhs.k = k
        lhs.l = l
        lhs.m = m
        lhs.n = n
        lhs.o = o
        lhs.p = p
    }
    
    static func *(lhs: Self, rhs: Self) -> Self {
        var a: T = lhs.a * rhs.a
        a += lhs.b * rhs.e
        a += lhs.c * rhs.i
        a += lhs.d * rhs.m
        var b: T = lhs.a * rhs.b
        b += lhs.b * rhs.f
        b += lhs.c * rhs.j
        b += lhs.d * rhs.n
        var c: T = lhs.a * rhs.c
        c += lhs.b * rhs.g
        c += lhs.c * rhs.k
        c += lhs.d * rhs.o
        var d: T = lhs.a * rhs.d
        d += lhs.b * rhs.h
        d += lhs.c * rhs.l
        d += lhs.d * rhs.p
        
        var e: T = lhs.e * rhs.a
        e += lhs.f * rhs.e
        e += lhs.g * rhs.i
        e += lhs.h * rhs.m
        var f: T = lhs.e * rhs.b
        f += lhs.f * rhs.f
        f += lhs.g * rhs.j
        f += lhs.h * rhs.n
        var g: T = lhs.e * rhs.c
        g += lhs.f * rhs.g
        g += lhs.g * rhs.k
        g += lhs.h * rhs.o
        var h: T = lhs.e * rhs.d
        h += lhs.f * rhs.h
        h += lhs.g * rhs.l
        h += lhs.h * rhs.p
        
        var i: T = lhs.i * rhs.a
        i += lhs.j * rhs.e
        i += lhs.k * rhs.i
        i += lhs.l * rhs.m
        var j: T = lhs.i * rhs.b
        j += lhs.j * rhs.f
        j += lhs.k * rhs.j
        j += lhs.l * rhs.n
        var k: T = lhs.i * rhs.c
        k += lhs.j * rhs.g
        k += lhs.k * rhs.k
        k += lhs.l * rhs.o
        var l: T = lhs.i * rhs.d
        l += lhs.j * rhs.h
        l += lhs.k * rhs.l
        l += lhs.l * rhs.p
        
        var m: T = lhs.m * rhs.a
        m += lhs.n * rhs.e
        m += lhs.o * rhs.i
        m += lhs.p * rhs.m
        var n: T = lhs.m * rhs.b
        n += lhs.n * rhs.f
        n += lhs.o * rhs.j
        n += lhs.p * rhs.n
        var o: T = lhs.m * rhs.c
        o += lhs.n * rhs.g
        o += lhs.o * rhs.k
        o += lhs.p * rhs.o
        var p: T = lhs.m * rhs.d
        p += lhs.n * rhs.h
        p += lhs.o * rhs.l
        p += lhs.p * rhs.p
        return Self(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p)
    }
}

extension Matrix4x4: Equatable where T: Equatable {}
extension Matrix4x4: Hashable where T: Hashable {}
extension Matrix4x4: Codable where T: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(a)
        try container.encode(b)
        try container.encode(c)
        try container.encode(d)
        try container.encode(e)
        try container.encode(f)
        try container.encode(g)
        try container.encode(h)
        try container.encode(i)
        try container.encode(j)
        try container.encode(k)
        try container.encode(l)
        try container.encode(m)
        try container.encode(n)
        try container.encode(o)
        try container.encode(p)
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.a = try container.decode(T.self)
        self.b = try container.decode(T.self)
        self.c = try container.decode(T.self)
        self.d = try container.decode(T.self)
        self.e = try container.decode(T.self)
        self.f = try container.decode(T.self)
        self.g = try container.decode(T.self)
        self.h = try container.decode(T.self)
        self.i = try container.decode(T.self)
        self.j = try container.decode(T.self)
        self.k = try container.decode(T.self)
        self.l = try container.decode(T.self)
        self.m = try container.decode(T.self)
        self.n = try container.decode(T.self)
        self.o = try container.decode(T.self)
        self.p = try container.decode(T.self)
    }
}
