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
            checksum: "a0acd80c18f0c0afd0b6cdd768b139fb5e70ffedb6fb49abd77b90acdd771c42"
        ),
        .binaryTarget(
            name: "CardinalMobile",
            url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/CardinalMobile.xcframework.zip",
            checksum: "5a236b43c8457e0e6fc8f03371b13c646d20541d4d3b1d6f633546b2d5b0c3f7"
        ),
        .binaryTarget(
            name: "PPRiskMagnes",
            url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/PPRiskMagnes.xcframework.zip",
            checksum: "a2b1ac14a5610e3747628aa03cfe7c31ac0cb785345165bbdf32465d6d79f9ae"
        ),
        .binaryTarget(
            name: "CorePayments",
            url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/CorePayments.xcframework.zip",
            checksum: "c1d7f17d31e1775862d4c160547054455e9860de9eaf3e0fd1d7ea46dfa04fbf"
        ),
        .binaryTarget(
            name: "PayPalWebPayments",
            url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/PayPalWebPayments.xcframework.zip",
            checksum: "bd05539ede0c3c5295829b5ffc2c1c00136e065ccc27c24d20287b79d2635385"
        ),
        .binaryTarget(
            name: "FraudProtection",
            url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/FraudProtection.xcframework.zip",
            checksum: "b1fba0c5a4da335c0f22c76e33953541b6b84722b706f28bd01e60aa640533f5"
        ),
        .binaryTarget(
            name: "PaymentButtons",
            url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/PaymentButtons.xcframework.zip",
            checksum: "fa80fa1079b74aa53a383533b767f18ac2f236919320c90c9f2969d8a80328ff"
        ),
        .binaryTarget(
            name: "KlarnaExt",
            url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/KlarnaExt.xcframework.zip",
            checksum: "493b67000b70c7a82489ae41728f0a09f3f860af549e1250660ff701c3d3d36d"
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
