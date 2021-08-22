// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var settings: [SwiftSetting]? {
    
    //Attemts to use SIMD have resulted in significantly slower code.
    //These settings will be turned on in a future commit when using them is benefitical.
    #if false
    var array: [SwiftSetting] = []
    array.append(.define("GameMathUseSIMD"))
    array.append(.define("GameMathUseDispatch"))
    return array.isEmpty ? nil : array
    #else
    return nil
    #endif
}

let package = Package(
    name: "GameMath",
    products: [
        .library(name: "GameMath", targets: ["GameMath"]),
    ],
    targets: [
        .target(name: "GameMath", swiftSettings: settings),
        .testTarget(name: "GameMathTests", dependencies: ["GameMath"]),
    ],
    swiftLanguageVersions: [.v5]
)
