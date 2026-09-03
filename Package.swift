// swift-tools-version: 5.8
//
// CPaySDK v2.8.0
// Citcon UPI Mobile SDK for iOS
//
// Generated file — do not edit by hand.

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
        .binaryTarget(name: "CPaySDK",           url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.8.0/CPaySDK.xcframework.zip",           checksum: "b10d67be74a8091ada4a52070ddc71b38579f59b3972a3ed6b06459ef0b9289b"),
        .binaryTarget(name: "CardinalMobile",    url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.8.0/CardinalMobile.xcframework.zip",    checksum: "52cf95dd8bf988623230c922860c101e505ff14860572661d43f9db876d33b48"),
        .binaryTarget(name: "PPRiskMagnes",      url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.8.0/PPRiskMagnes.xcframework.zip",      checksum: "98cddb73a588307e2020f7bee2d99a9947d5b9a8182efc48f46b5267e5bbe83d"),
        .binaryTarget(name: "CorePayments",      url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.8.0/CorePayments.xcframework.zip",      checksum: "9cb22c22b6cf56be23044f5ac735cfe7f633c75326ac96f3b7b49860ff2efcf6"),
        .binaryTarget(name: "PayPalWebPayments", url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.8.0/PayPalWebPayments.xcframework.zip", checksum: "0d83f346f50bb919145ba127ae98a7ec7e3eb5751d5b0f8ed919e216a5cc543d"),
        .binaryTarget(name: "FraudProtection",   url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.8.0/FraudProtection.xcframework.zip",   checksum: "e62bee04730390b3e0509e2c21b21e7339c8be8866cd3e35274632a2f23ed49b"),
        .binaryTarget(name: "PaymentButtons",    url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.8.0/PaymentButtons.xcframework.zip",    checksum: "a7770c586a53930910e6637db52642a85c689398ad3e9d34b946884e8c2401d1"),
        .binaryTarget(name: "KlarnaExt",         url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.8.0/KlarnaExt.xcframework.zip",         checksum: "a56567164bbfedcfeeb32256c3c88180ad27e5c1421fc3ed95341102ec412bcd"),
        .target(
            name: "KlarnaExtWrapper",
            dependencies: [
                "KlarnaExt",
                .product(name: "KlarnaMobileSDK", package: "klarna-mobile-sdk-ios"),
            ]
        ),
    ]
)
