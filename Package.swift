// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var settings: [SwiftSetting]? {
    var array: [SwiftSetting] = []

//    array.append(.define("GameMathUseSIMD"))
//    array.append(.define("GameMathUseDispatch"))
    return array.isEmpty ? nil : array
}

let package = Package(
    name: "GameMath",
    products: [
        .library(name: "GameMath", targets: ["GameMath"]),
    ],
    targets: [
        .target(name: "GameMath", swiftSettings: settings),
        .testTarget(name: "GameMathTests", dependencies: ["GameMath"]),
    ]
)
