// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GameMath",
    products: [
        .library(name: "GameMath", targets: ["GameMath"]),
    ],
    targets: [
        .target(name: "GameMath"),
        .testTarget(name: "GameMathTests", dependencies: ["GameMath"]),
    ]
)
