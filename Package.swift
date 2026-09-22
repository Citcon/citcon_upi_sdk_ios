// swift-tools-version: 5.8
//
// CPaySDK v2.8.1
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
        .binaryTarget(name: "CPaySDK",           url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.8.1/CPaySDK.xcframework.zip",           checksum: "4d0c0f48e53e4e1cbf1c2bee737471215ca91e8548817b92de4f0e240bf638f7"),
        .binaryTarget(name: "CardinalMobile",    url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.8.1/CardinalMobile.xcframework.zip",    checksum: "ccc7169fea8cb07e07dd1a1a5ac9ee3f9f44b77fb9d854e0472732b0188b86f5"),
        .binaryTarget(name: "PPRiskMagnes",      url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.8.1/PPRiskMagnes.xcframework.zip",      checksum: "c015baefb8c068f8df5585188d1e54ddd5ce99d4950b4a1fcae175973b303226"),
        .binaryTarget(name: "CorePayments",      url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.8.1/CorePayments.xcframework.zip",      checksum: "24bc2e742cd46417cb9799a328609bd18df5d447f9267fbc78afb53df7160e79"),
        .binaryTarget(name: "PayPalWebPayments", url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.8.1/PayPalWebPayments.xcframework.zip", checksum: "8949a92f867142c27573badc1a066ce747fe0732ee4a3dbe13d43177e83d1364"),
        .binaryTarget(name: "FraudProtection",   url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.8.1/FraudProtection.xcframework.zip",   checksum: "924da72741dece8a74dc964814511d58dca7eab6cbb376df89fccb49b803ecba"),
        .binaryTarget(name: "PaymentButtons",    url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.8.1/PaymentButtons.xcframework.zip",    checksum: "a79c983d8dbf79c32689e6c816d734c7fd2249f5414b2c7dd33515bc912ac367"),
        .binaryTarget(name: "KlarnaExt",         url: "https://github.com/Citcon/citcon_upi_sdk_ios/releases/download/v2.8.1/KlarnaExt.xcframework.zip",         checksum: "2681c8fcdb800d833c9d551d20fba03818ca0ad42dc4310b1d18d81902acc5c6"),
        .target(
            name: "KlarnaExtWrapper",
            dependencies: [
                "KlarnaExt",
                .product(name: "KlarnaMobileSDK", package: "klarna-mobile-sdk-ios"),
            ]
        ),
    ]
)
