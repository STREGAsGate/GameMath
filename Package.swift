// swift-tools-version:5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var libraryType: Product.Library.LibraryType? = nil
#if os(Windows)
libraryType = .dynamic
#endif

var settings: [SwiftSetting]? {
    var array: [SwiftSetting] = []
    
    #if false
    // A little bit faster on old hardware, but less accurate.
    // Theres no reason to use this on modern hardware.
    array.append(.define("GameMathUseFastInverseSquareRoot"))
    #endif
    
    //These settings are faster only with optimization.
    #if true
    array.append(.define("GameMathUseSIMD", .when(configuration: .release)))
    array.append(.define("GameMathUseLoopVectorization", .when(configuration: .release)))
    #endif
    
    return array.isEmpty ? nil : array
}

let package = Package(
    name: "GameMath",
    products: [
        .library(name: "GameMath", type: libraryType, targets: ["GameMath"]),
    ],
    targets: [
        .target(name: "GameMath", swiftSettings: settings),
        .testTarget(name: "GameMathTests", dependencies: ["GameMath"]),
    ],
    swiftLanguageVersions: [.v5]
)
