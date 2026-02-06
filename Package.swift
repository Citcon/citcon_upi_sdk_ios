// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// CPaySDK v2.6.1
// Citcon UPI Mobile SDK for iOS

import PackageDescription

let package = Package(
    name: "CPaySDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "CPaySDK", targets: ["CPaySDK"]),

        // cashapp
        .library(name: "CashAppExt", targets: ["PayKit", "PayKitUI", "CashAppExt"]),
        // Klarna
        .library(name: "KlarnaExt", targets: ["KlarnaExt", "KlarnaExtWrapper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/klarna/klarna-mobile-sdk-ios.git", from: "2.10.0")
    ],
    targets: [
        // core
        .binaryTarget(name: "CPaySDK", path: "./CPaySDK/Core/CPaySDK.xcframework"),

        // cashapp
        .binaryTarget(
            name: "CashAppExt", path: "./CPaySDK/Payment/CashApp/CashAppExt.xcframework"),
        .binaryTarget(
            name: "PayKit", path: "./CPaySDK/Payment/CashApp/Ext/PayKit.xcframework"),
        .binaryTarget(
            name: "PayKitUI", path: "./CPaySDK/Payment/CashApp/Ext/PayKitUI.xcframework"),

        // klarna
        .binaryTarget(name: "KlarnaExt", path: "./CPaySDK/Payment/Klarna/KlarnaExt.xcframework"),
        .target(
            name: "KlarnaExtWrapper",
            dependencies: [
                "KlarnaExt",
                .product(name: "KlarnaMobileSDK", package: "klarna-mobile-sdk-ios"),
            ]
        ),
       
    ]
)
