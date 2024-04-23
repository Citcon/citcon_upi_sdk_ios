// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CPaySDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "CPaySDK", targets: ["CPaySDK"]),
        .library(name: "CardinalMobile", targets: ["CardinalMobile"]),
        .library(name: "PPRiskMagnes", targets: ["PPRiskMagnes"])
    ],
    dependencies:[

    ],
    targets: [
        .binaryTarget(name: "CPaySDK", path: "./CPaySDK/Core/CPaySDK.xcframework"),
        .binaryTarget(name: "CardinalMobile", path: "./CPaySDK/Ext/CardinalMobile.xcframework"),
        .binaryTarget(name: "PPRiskMagnes", path: "./CPaySDK/Ext/PPRiskMagnes.xcframework")
    ]
)
