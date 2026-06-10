// swift-tools-version: 5.8
//
// CPaySDK v2.7.0
// Citcon UPI Mobile SDK for iOS

import PackageDescription

let package = Package(
    name: "CPaySDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "CPaySDK",          targets: ["CPaySDK"]),
        .library(name: "CardinalMobile",   targets: ["CardinalMobile"]),
        .library(name: "PPRiskMagnes",     targets: ["PPRiskMagnes"]),
        .library(name: "CorePayments",     targets: ["CorePayments"]),
        .library(name: "PayPalWebPayments",targets: ["PayPalWebPayments", "CorePayments"]),
        .library(name: "FraudProtection",  targets: ["FraudProtection", "PPRiskMagnes"]),
        .library(name: "PaymentButtons",   targets: ["PaymentButtons", "CorePayments"]),
        .library(name: "KlarnaExt",        targets: ["KlarnaExt", "KlarnaExtWrapper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/klarna/klarna-mobile-sdk-ios.git", from: "2.10.0"),
    ],
    targets: [
        .binaryTarget(
            name: "CPaySDK",
            url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/CPaySDK.xcframework.zip",
            checksum: "e0b34137d1d5f63fbedd12c7d6c404228ab58a573c64fe46226bbe45f143d158"
        ),
        .binaryTarget(
            name: "CardinalMobile",
            url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/CardinalMobile.xcframework.zip",
            checksum: "4b22271420ae6f61a1cc6044c02ee955e93fbe69d284465cb8935ee25196877e"
        ),
        .binaryTarget(
            name: "PPRiskMagnes",
            url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/PPRiskMagnes.xcframework.zip",
            checksum: "f90cceba506180ef60e899773f1e54c53896a52cce74b75766f24e81a97db16a"
        ),
        .binaryTarget(
            name: "CorePayments",
            url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/CorePayments.xcframework.zip",
            checksum: "ea1ebbb00807dc07ed36dab24d18b04a0026ae511a0b39f5eaa899aeea4bf2c2"
        ),
        .binaryTarget(
            name: "PayPalWebPayments",
            url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/PayPalWebPayments.xcframework.zip",
            checksum: "1b6749ee2da04139c24b32ba88da73d82075d216ceac3131a83bba4c86439684"
        ),
        .binaryTarget(
            name: "FraudProtection",
            url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/FraudProtection.xcframework.zip",
            checksum: "c93c6b82121eafda32111a453e7df82ac457c6debc9c6e04a25ec095ec6682c2"
        ),
        .binaryTarget(
            name: "PaymentButtons",
            url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/PaymentButtons.xcframework.zip",
            checksum: "e53ead3745207c30c7b09ada0b1565693bd0d58f4044839b58e73a23328dbe46"
        ),
        .binaryTarget(
            name: "KlarnaExt",
            url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/KlarnaExt.xcframework.zip",
            checksum: "71e0870b03c11a159d7a61e8017687519493e466c66276ef48302fa96ab1abb6"
        ),
        .target(
            name: "KlarnaExtWrapper",
            dependencies: [
                "KlarnaExt",
                .product(name: "KlarnaMobileSDK", package: "klarna-mobile-sdk-ios"),
            ]
        ),
    ]
)
