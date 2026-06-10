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
        .binaryTarget(name: "CPaySDK",           url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/CPaySDK.xcframework.zip",           checksum: "197aaf4bf68a79543b4147c1212f128357052e2890e78b501c7cc01630316e94"),
        .binaryTarget(name: "CardinalMobile",    url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/CardinalMobile.xcframework.zip",    checksum: "e94133551ef3a3bea6c9214984bd9c81eabc3054d1c7a2ea5857e5eb31a6c0a6"),
        .binaryTarget(name: "PPRiskMagnes",      url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/PPRiskMagnes.xcframework.zip",      checksum: "4c70126ee3a77808a386439a85bea0a29862ef39fdd2bce733c1f408e4db3dba"),
        .binaryTarget(name: "CorePayments",      url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/CorePayments.xcframework.zip",      checksum: "bdf6843fe33051144f949b34628bee8969b754bdfeef2c3075bac25cd577e2d6"),
        .binaryTarget(name: "PayPalWebPayments", url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/PayPalWebPayments.xcframework.zip", checksum: "648ec7e5dc0d11addd61fce14f4781e20d6bb38b30967fc2069da8acc067ddb6"),
        .binaryTarget(name: "FraudProtection",   url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/FraudProtection.xcframework.zip",   checksum: "33237e08bcf2d2de47e7d270f687f86263b0206ab45992805c2b1e639c9a8387"),
        .binaryTarget(name: "PaymentButtons",    url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/PaymentButtons.xcframework.zip",    checksum: "de9f250be660f64a22fc440bef12e8fff178a46e4b17a51b6796a38fe879c39f"),
        .binaryTarget(name: "KlarnaExt",         url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.7.0/KlarnaExt.xcframework.zip",         checksum: "ce901ff6c8a53ecfc3fc9ee60c22d72740a34a285f5b51bf3fa581ef59c4f52a"),
        .target(
            name: "KlarnaExtWrapper",
            dependencies: [
                "KlarnaExt",
                .product(name: "KlarnaMobileSDK", package: "klarna-mobile-sdk-ios"),
            ]
        ),
    ]
)
