// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
        .library(name: "PayPalNativePayments", targets:  ["PayPalNativePayments", "PayPalCheckout", "CorePayments"]),
//        .library(name: "CardPayments", targets:  ["CorePayments", "CardPayments"]),

        .library(name: "FraudProtection", targets:  ["FraudProtection", "PPRiskMagnes"]),
        .library(name: "PaymentButtons", targets:  ["PaymentButtons", "CorePayments"])
    ],
    dependencies:[
        
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
        .binaryTarget(name: "PayPalNativePayments", path: "./CPaySDK/Payment/PayPal/Ext/PayPalNativePayments.xcframework"),
        .binaryTarget(name: "PayPalWebPayments", path: "./CPaySDK/Payment/PayPal/Ext/PayPalWebPayments.xcframework"),
        .binaryTarget(name: "FraudProtection", path: "./CPaySDK/Payment/PayPal/Ext/FraudProtection.xcframework"),
        .binaryTarget(name: "PaymentButtons", path: "./CPaySDK/Payment/PayPal/Ext/PaymentButtons.xcframework"),
        .binaryTarget(
            name: "PayPalCheckout",
            url: "https://github.com/paypal/paypalcheckout-ios/releases/download/1.3.0/PayPalCheckout.xcframework.zip",
            checksum: "d65186f38f390cb9ae0431ecacf726774f7f89f5474c48244a07d17b248aa035"
        )
    ]
)
