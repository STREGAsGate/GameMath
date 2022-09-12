// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var libraryType: Product.Library.LibraryType? = nil
#if os(Windows)
libraryType = .dynamic
#endif

var settings: [SwiftSetting]? {
    var array: [SwiftSetting] = []
    
    #if true
    // A little bit faster, but less accurate
    array.append(.define("GameMathUseFastInverseSquareRoot"))
    #endif
    
    //Attemts to use SIMD have resulted in significantly slower code.
    //These settings will be turned on in a future commit when using them is benefitical.
    #if false
    array.append(.define("GameMathUseSIMD"))
//    array.append(.define("GameMathUseDispatch"))
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
