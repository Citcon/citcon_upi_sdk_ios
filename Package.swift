// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// CPaySDK v2.4.0
// Citcon UPI Mobile SDK for iOS

import PackageDescription

let package = Package(
    name: "CPaySDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "CPaySDK", targets: ["CPaySDK"]),
        .library(name: "CardinalMobile", targets: ["CardinalMobile"]),
        .library(name: "PPRiskMagnes", targets: ["PPRiskMagnes"]),

        // PayPal required: CorePayments PayPalWebPayments FraudProtection PaymentButtons
        .library(name: "CorePayments", targets:  ["CorePayments"]),
        .library(name: "PayPalWebPayments", targets:  ["PayPalWebPayments", "CorePayments"]),
//        .library(name: "PayPalNativePayments", targets:  ["PayPalNativePayments", "PayPalCheckout", "CorePayments"]),
//        .library(name: "CardPayments", targets:  ["CorePayments", "CardPayments"]),

        .library(name: "FraudProtection", targets:  ["FraudProtection", "PPRiskMagnes"]),
        .library(name: "PaymentButtons", targets:  ["PaymentButtons", "CorePayments"]),
        
        // Klarna
        .library(name: "KlarnaExt", targets: ["KlarnaExt", "KlarnaExtWrapper"])
    ],
    dependencies: [
        .package(url: "https://github.com/klarna/klarna-mobile-sdk-ios.git", from: "2.10.0")
    ],
    targets: [
        // core
        .binaryTarget(name: "CPaySDK", path: "./CPaySDK/Core/CPaySDK.xcframework"),
        // ext
        .binaryTarget(name: "CardinalMobile", path: "./CPaySDK/Ext/CardinalMobile.xcframework"),
        .binaryTarget(name: "PPRiskMagnes", path: "./CPaySDK/Ext/PPRiskMagnes.xcframework"),
        // paypal
//        .binaryTarget(name: "CardPayments", path: "./CPaySDK/Payment/PayPal/CardPayments.xcframework"),
        
        .binaryTarget(name: "CorePayments", path: "./CPaySDK/Payment/PayPal/Ext/CorePayments.xcframework"),
//        .binaryTarget(name: "PayPalNativePayments", path: "./CPaySDK/Payment/PayPal/Ext/PayPalNativePayments.xcframework"),
        .binaryTarget(name: "PayPalWebPayments", path: "./CPaySDK/Payment/PayPal/Ext/PayPalWebPayments.xcframework"),
        .binaryTarget(name: "FraudProtection", path: "./CPaySDK/Payment/PayPal/Ext/FraudProtection.xcframework"),
        .binaryTarget(name: "PaymentButtons", path: "./CPaySDK/Payment/PayPal/Ext/PaymentButtons.xcframework"),
        
        // klarna
        .binaryTarget(name: "KlarnaExt", path: "./CPaySDK/Payment/Klarna/KlarnaExt.xcframework"),
        .target(
            name: "KlarnaExtWrapper",
            dependencies: [
                "KlarnaExt",
                .product(name: "KlarnaMobileSDK", package: "klarna-mobile-sdk-ios")
            ]
        )
//        .binaryTarget(
//            name: "PayPalCheckout",
//            url: "https://github.com/paypal/paypalcheckout-ios/releases/download/1.3.0/PayPalCheckout.xcframework.zip",
//            checksum: "d65186f38f390cb9ae0431ecacf726774f7f89f5474c48244a07d17b248aa035"
//        )
    ]
)
