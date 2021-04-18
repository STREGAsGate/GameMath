# GameMath [![Windows](https://github.com/STREGAsGate/GameMath/actions/workflows/Windows.yml/badge.svg)](https://github.com/STREGAsGate/GameMath/actions/workflows/Windows.yml) [![macOS](https://github.com/STREGAsGate/GameMath/actions/workflows/macOS.yml/badge.svg)](https://github.com/STREGAsGate/GameMath/actions/workflows/macOS.yml) [![Linux](https://github.com/STREGAsGate/GameMath/actions/workflows/Linux.yml/badge.svg)](https://github.com/STREGAsGate/GameMath/actions/workflows/Linux.yml)

GameMath provides common types, related functions, and operators commonly used for interactive realtime simulations (games).
You can use this library to create simple games, or use it as a cornerstone for a more complex engine.

## <img style="vertical-align:middle" src=https://aws1.discourse-cdn.com/swift/original/1X/0a90dde98a223f5841eeca49d89dc9f57592e8d6.png width="35"> Swift 100% 
GameMath uses protocols and generics to promote clear type intention. Vector types as an example have many variations including `Position3`, `Direction3`, and `Size3` that all conform to`Vector3`, a protocol that provides common functionality to these types.

Operators such as multiplication, division, addition, and subtraction, can be used across types so long as they use the same generic constraint. The type returned will be the logical result of the operation, usually the left side.
```swift
//Success
let pos: Position3<Float> = Position3(0, 1, 0) * Size3(1, 1, 1)

//Error: Size3 cannot be converted to Position3
let pos: Position3<Float> = Size3(1, 1, 1) * Position3(0, 1, 0) 
```
Most types are generic with their functionality being determined by the generic being used.
Some types have restrictions on generics. Using `Size3<Int>` instead of `Size3<Float>` makes sense and could be used for any number of reasons.

However a `Direction3<Int>` does not make sense because a normalized direction vector should have a length of 1. While `Direction3<Int>(0, 1, 0)` is valid it can represnt so few angles that it's usefulness is questionable, so FloatingPoint is a requirement for `Direction3<T: FloatingPoint>`.

## Easy To Understand
GameMath is intended to make doing math-wiz stuff easier for everyone. An example is interpolation.

The functions `lerp()` and `slerp()` are commonly seen in game libraries for linear interpolation. Without advanced knowledge of these functions it's difficult to reason about them and know what they do.
GameMath attempts to improve on this issue by introducing a common syntax for interpolation for all types across the package.
```swift
let halfway = source.interpolated(to: destination, .linear(0.5))
```
This syntax will be expanded with new interpolation methods like easeIn and easeOut in the future.

## Coordinate Space
GameMath uses a *Y Up*, *-Z forward*, coordinate system for 3D and *Y Up*, *X Right* for 2D.

Matrix types are assumed to always be *"left handed"*. Use the `transposedArray` and `transposedSIMD` properties when sending to Metal, Vulkan, OpenGL, and the `array` and `simd` properties when sending to DirectX.

# Cross Platform
GameMath is tested to work on Windows 10, macOS, Ubuntu, iOS, and tvOS; all of which work with Swift's minimum deployment target for each platform.

Any platform not listed above should also work in theory, with the only possible issues being located in `math.swift` where the availability of Float80 and Float16 could result in build errors on a platform not listed above.

# Actively In Use
Check out my [YouTube channel](https://www.youtube.com/STREGAsGate) for devlogs about the games I make using this package.

[![Strega's Gate: Espionage](https://i.ytimg.com/vi/c6XgXY5eM-Y/hqdefault.jpg?sqp=-oaymwEiCKgBEF5IWvKriqkDFQgBFQAAAAAYASUAAMhCPQCAokN4AQ==&rs=AOn4CLAy8Oua6SfAmSn2uwiv6mkFfii-ZQ)](https://www.youtube.com/STREGAsGate)
[![Strega's Gate: Shifter](https://i.ytimg.com/vi/NhO0EPCIciU/hqdefault.jpg?sqp=-oaymwEiCKgBEF5IWvKriqkDFQgBFQAAAAAYASUAAMhCPQCAokN4AQ==&rs=AOn4CLB-DJuYCPzkHrGUuc1NgsFuSm21kA)](https://www.youtube.com/STREGAsGate)

# ToDo
- **Unit Tests**  
    A test suite is currently being implemented to ensure correctness of the API's before effort is put into making them faster.

- **Performance Testing**  
    GameMath is currently un-optimized. Once a unit tests have full code coverage a performance test suite needs to be set up that runs tests for common real world use cases, such as matrix multiplication 

- **2D**  
    GameMath has not been used to create a 2D game and may be missing some necessary functionality. 

- **Remove Foundation**  
    Foundation is currently imported in a few places because of math functions like `sin`, `cos`, and `tan` which will be part of the standard library at some point. It is a goal for GameMath to not require any dependencies, so I'd like to remove Foundation as soon as the math proposal gets merged into Swift.

# Usage Notes
GameMath is under development and the API surface is not locked-in. 

As such please use an explicit commit when adding GameMath to your packages. You may do so like this while replacing the revision hash with the latests passing commit's.
```swift
.package(url: "https://github.com/STREGAsGate/GameMath.git", .revision("f79af538542525514503ae26f5c34c86c56e2614"))
```
Doing this will prevent changes made to GameMath from halting development of your own package. When you are ready to update, use a newer hash and fix any API changes. 

API changes are mostly final so changes should not be too much of a hassle, however please be aware they can and will happen.

A tag will created at some point to mark version 1.0 at which point the `main` branch will become the stable release branch. This will happen once unit tests and a first pass of optimization is done. ETA unknown.

# Game Package Family
This package works great by itself, but it's also included as part of higher level packages that I'm working on.
You can check the availability of these packages on my GitHub profile [@STREGAsGate](https://github.com/STREGAsGate).
