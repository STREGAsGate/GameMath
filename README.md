# GameMath 
[![Windows](https://github.com/STREGAsGate/GameMath/actions/workflows/Windows.yml/badge.svg)](https://github.com/STREGAsGate/GameMath/actions/workflows/Windows.yml) 
[![macOS](https://github.com/STREGAsGate/GameMath/actions/workflows/macOS.yml/badge.svg)](https://github.com/STREGAsGate/GameMath/actions/workflows/macOS.yml) 
[![Linux](https://github.com/STREGAsGate/GameMath/actions/workflows/Linux.yml/badge.svg)](https://github.com/STREGAsGate/GameMath/actions/workflows/Linux.yml) 
[![HTML5](https://github.com/STREGAsGate/GameMath/actions/workflows/SwiftWasm.yml/badge.svg)](https://github.com/STREGAsGate/GameMath/actions/workflows/SwiftWasm.yml)

GameMath provides common types, related functions, and operators commonly used for interactive realtime simulations (games).
You can use this library to create simple games, or use it as a cornerstone for a more complex engine like [GateEngine](https://github.com/STREGAsGate/GateEngine).

## Swift 100% 
GameMath uses protocols and generics to promote clear type intention. Vector types as an example have many variations including `Position3`, `Direction3`, and `Size3` that all conform to`Vector3`, a protocol that provides common functionality to these types.

Operators such as multiplication, division, addition, and subtraction, can be used across types so long as they use the same generic constraint. The type returned will be the logical result of the operation, usually the left side.
```swift
//Success
let pos: Position3 = Position3(0, 1, 0) * Size3(1, 1, 1)

//Error: Size3 cannot be converted to Position3
let pos: Position3 = Size3(1, 1, 1) * Position3(0, 1, 0) 
```

## Easy To Understand
GameMath is intended to make doing gamming math easier for everyone. An example is interpolation.

The functions `lerp()` and `slerp()` are commonly seen in game libraries for linear interpolation. Without advanced knowledge of these functions it's difficult to reason about them and know what they do.
GameMath attempts to improve on this issue by introducing a common syntax for interpolation for all types across the package.
```swift
let halfway = source.interpolated(to: destination, .linear(0.5))
```
This syntax will be expanded with new interpolation methods like easeIn and easeOut in the future.

## Coordinate Space
GameMath uses a *Y Up*, *-Z forward*, coordinate system for 3D and *Y Up*, *X Right* for 2D.

Matrix types are assumed to always be *"left handed"*. Use the `transposedArray` and `transposedSIMD` properties when sending data to Metal, Vulkan, OpenGL, and the `array` and `simd` properties when sending data to DirectX.

# Cross Platform
GameMath is tested to work on Windows 10, macOS, Ubuntu, iOS, tvOS, and HTML5.
Other platforms should also work.

# Support Gate Engine!
This package is seperated for you to enjoy, but it's built for and used by [GateEngine](https://github.com/STREGAsGate/GateEngine).
If you appreciate this project, and want it to continue, then please consider putting some dollars into it.
</br>
Every little bit helps! Support With: [GitHub](https://github.com/sponsors/STREGAsGate), [Ko-fi](https://ko-fi.com/STREGAsGate), [Pateron](https://www.patreon.com/STREGAsGate)

## Community & Followables
[![Discord](https://img.shields.io/discord/641809158051725322?label=Hang%20Out&logo=Discord&style=social)](https://discord.gg/5JdRJhD)
[![Twitter](https://img.shields.io/twitter/follow/stregasgate?style=social)](https://twitter.com/stregasgate)
[![YouTube](https://img.shields.io/youtube/channel/subscribers/UCBXFkK2B4w9856wBJfCGufg?label=Subscribe&style=social)](https://youtube.com/stregasgate)
[![Reddit](https://img.shields.io/reddit/subreddit-subscribers/stregasgate?style=social)](https://www.reddit.com/r/stregasgate/)
