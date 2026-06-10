#!/usr/bin/env bash
# Usage: ./scripts/release.sh <version>
# Example: ./scripts/release.sh 2.8.0
#
# Prerequisites:
#   - gh auth login (GitHub CLI authenticated)
#   - swift installed
#   - xcframeworks built and placed into CPaySDK/ in this repo
#
# Run from the root of citcon_upi_sdk_ios repo.

set -euo pipefail

VERSION="${1:?Usage: $0 <version>}"
REPO="Citcon/citcon_upi_sdk_ios"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CAYSDK_DIR="$REPO_ROOT/CPaySDK"

echo "==> Releasing CPaySDK v${VERSION}"

# ── Step 1: Verify source xcframeworks are present ──────────────────────────
echo "==> Verifying xcframeworks..."
REQUIRED=(
  "Core/CPaySDK.xcframework"
  "Ext/PPRiskMagnes.xcframework"
  "Ext/CardinalMobile.xcframework"
  "Payment/PayPal/Ext/CorePayments.xcframework"
  "Payment/PayPal/Ext/PayPalWebPayments.xcframework"
  "Payment/PayPal/Ext/FraudProtection.xcframework"
  "Payment/PayPal/Ext/PaymentButtons.xcframework"
  "Payment/Klarna/KlarnaExt.xcframework"
)
for fw in "${REQUIRED[@]}"; do
  if [ ! -d "$CAYSDK_DIR/$fw" ]; then
    echo "ERROR: Missing required xcframework: CPaySDK/$fw"
    exit 1
  fi
done
echo "    All required xcframeworks present ✓"

# ── Step 2: Assemble CocoaPods zip ──────────────────────────────────────────
echo "==> Assembling CocoaPods zip..."
TMP_POD=$(mktemp -d)
mkdir -p "$TMP_POD/CPaySDK/Core"
mkdir -p "$TMP_POD/CPaySDK/Ext"
mkdir -p "$TMP_POD/CPaySDK/Payment/PayPal/Ext"
mkdir -p "$TMP_POD/CPaySDK/Payment/CashApp/Ext"
mkdir -p "$TMP_POD/CPaySDK/Payment/Klarna"

cp -r "$CAYSDK_DIR/Core/CPaySDK.xcframework"                         "$TMP_POD/CPaySDK/Core/"
cp -r "$CAYSDK_DIR/Ext/PPRiskMagnes.xcframework"                     "$TMP_POD/CPaySDK/Ext/"
cp -r "$CAYSDK_DIR/Ext/CardinalMobile.xcframework"                   "$TMP_POD/CPaySDK/Ext/"
[ -d "$CAYSDK_DIR/Ext/KountDataCollector.xcframework" ] && \
  cp -r "$CAYSDK_DIR/Ext/KountDataCollector.xcframework"             "$TMP_POD/CPaySDK/Ext/"
cp -r "$CAYSDK_DIR/Payment/PayPal/Ext/CorePayments.xcframework"      "$TMP_POD/CPaySDK/Payment/PayPal/Ext/"
cp -r "$CAYSDK_DIR/Payment/PayPal/Ext/PayPalWebPayments.xcframework" "$TMP_POD/CPaySDK/Payment/PayPal/Ext/"
cp -r "$CAYSDK_DIR/Payment/PayPal/Ext/FraudProtection.xcframework"   "$TMP_POD/CPaySDK/Payment/PayPal/Ext/"
cp -r "$CAYSDK_DIR/Payment/PayPal/Ext/PaymentButtons.xcframework"    "$TMP_POD/CPaySDK/Payment/PayPal/Ext/"
[ -d "$CAYSDK_DIR/Payment/CashApp/Ext/PayKit.xcframework" ] && \
  cp -r "$CAYSDK_DIR/Payment/CashApp/Ext/PayKit.xcframework"         "$TMP_POD/CPaySDK/Payment/CashApp/Ext/"
[ -d "$CAYSDK_DIR/Payment/CashApp/Ext/PayKitUI.xcframework" ] && \
  cp -r "$CAYSDK_DIR/Payment/CashApp/Ext/PayKitUI.xcframework"       "$TMP_POD/CPaySDK/Payment/CashApp/Ext/"
cp -r "$CAYSDK_DIR/Payment/Klarna/KlarnaExt.xcframework"             "$TMP_POD/CPaySDK/Payment/Klarna/"

POD_ZIP="$TMP_POD/CPaySDK-v${VERSION}.zip"
(cd "$TMP_POD" && zip -ry "$POD_ZIP" CPaySDK/ > /dev/null)
echo "    CocoaPods zip: $(du -sh "$POD_ZIP" | cut -f1)"

# ── Step 3: Build individual SPM xcframework zips ───────────────────────────
echo "==> Building SPM xcframework zips..."
TMP_SPM=$(mktemp -d)

zip_fw() {
  local name="$1"
  local src="$2"
  if [ ! -d "$src" ]; then
    echo "    SKIP: $name (not found)"
    return
  fi
  local tmp=$(mktemp -d)
  cp -r "$src" "$tmp/"
  (cd "$tmp" && zip -ry "$TMP_SPM/${name}.xcframework.zip" "${name}.xcframework" > /dev/null)
  rm -rf "$tmp"
  echo "    ${name}.xcframework.zip: $(du -sh "$TMP_SPM/${name}.xcframework.zip" | cut -f1)"
}

zip_fw "CPaySDK"            "$CAYSDK_DIR/Core/CPaySDK.xcframework"
zip_fw "CardinalMobile"     "$CAYSDK_DIR/Ext/CardinalMobile.xcframework"
zip_fw "PPRiskMagnes"       "$CAYSDK_DIR/Ext/PPRiskMagnes.xcframework"
zip_fw "CorePayments"       "$CAYSDK_DIR/Payment/PayPal/Ext/CorePayments.xcframework"
zip_fw "PayPalWebPayments"  "$CAYSDK_DIR/Payment/PayPal/Ext/PayPalWebPayments.xcframework"
zip_fw "FraudProtection"    "$CAYSDK_DIR/Payment/PayPal/Ext/FraudProtection.xcframework"
zip_fw "PaymentButtons"     "$CAYSDK_DIR/Payment/PayPal/Ext/PaymentButtons.xcframework"
zip_fw "KlarnaExt"          "$CAYSDK_DIR/Payment/Klarna/KlarnaExt.xcframework"

# ── Step 4: Create GitHub Release ───────────────────────────────────────────
echo "==> Creating GitHub Release v${VERSION}..."
ASSETS=("$POD_ZIP")
for f in "$TMP_SPM"/*.xcframework.zip; do
  [ -f "$f" ] && ASSETS+=("$f")
done

gh release create "v${VERSION}" \
  "${ASSETS[@]}" \
  --repo "$REPO" \
  --title "v${VERSION}" \
  --notes "CPaySDK v${VERSION}"

echo "    Release created: https://github.com/${REPO}/releases/tag/v${VERSION}"

# ── Step 5: Compute SPM checksums ───────────────────────────────────────────
echo "==> Computing checksums..."
cs() { swift package compute-checksum "$TMP_SPM/${1}.xcframework.zip" 2>/dev/null || echo ""; }

CS_CPAYSDK=$(cs "CPaySDK")
CS_CARDINAL=$(cs "CardinalMobile")
CS_PPRISK=$(cs "PPRiskMagnes")
CS_CORE=$(cs "CorePayments")
CS_WEB=$(cs "PayPalWebPayments")
CS_FRAUD=$(cs "FraudProtection")
CS_BTN=$(cs "PaymentButtons")
CS_KLARNA=$(cs "KlarnaExt")

BASE_URL="https://github.com/${REPO}/releases/download/v${VERSION}"

# ── Step 6: Update podspec version and source URL ────────────────────────────
echo "==> Updating CPaySDK.podspec..."
sed -i '' "s/s\.version[[:space:]]*=[[:space:]]*'[^']*'/s.version          = '${VERSION}'/" \
  "$REPO_ROOT/CPaySDK.podspec"

# ── Step 7: Rewrite Package.swift with new version and checksums ─────────────
echo "==> Updating Package.swift..."
cat > "$REPO_ROOT/Package.swift" << SWIFT
// swift-tools-version: 5.8
//
// CPaySDK v${VERSION}
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
        .binaryTarget(name: "CPaySDK",           url: "${BASE_URL}/CPaySDK.xcframework.zip",           checksum: "${CS_CPAYSDK}"),
        .binaryTarget(name: "CardinalMobile",    url: "${BASE_URL}/CardinalMobile.xcframework.zip",    checksum: "${CS_CARDINAL}"),
        .binaryTarget(name: "PPRiskMagnes",      url: "${BASE_URL}/PPRiskMagnes.xcframework.zip",      checksum: "${CS_PPRISK}"),
        .binaryTarget(name: "CorePayments",      url: "${BASE_URL}/CorePayments.xcframework.zip",      checksum: "${CS_CORE}"),
        .binaryTarget(name: "PayPalWebPayments", url: "${BASE_URL}/PayPalWebPayments.xcframework.zip", checksum: "${CS_WEB}"),
        .binaryTarget(name: "FraudProtection",   url: "${BASE_URL}/FraudProtection.xcframework.zip",   checksum: "${CS_FRAUD}"),
        .binaryTarget(name: "PaymentButtons",    url: "${BASE_URL}/PaymentButtons.xcframework.zip",    checksum: "${CS_BTN}"),
        .binaryTarget(name: "KlarnaExt",         url: "${BASE_URL}/KlarnaExt.xcframework.zip",         checksum: "${CS_KLARNA}"),
        .target(
            name: "KlarnaExtWrapper",
            dependencies: [
                "KlarnaExt",
                .product(name: "KlarnaMobileSDK", package: "klarna-mobile-sdk-ios"),
            ]
        ),
    ]
)
SWIFT

# ── Step 8: Commit, tag, push ────────────────────────────────────────────────
echo "==> Committing release v${VERSION}..."
git -C "$REPO_ROOT" add CPaySDK.podspec Package.swift
git -C "$REPO_ROOT" commit -m "release: v${VERSION}"
git -C "$REPO_ROOT" tag "v${VERSION}"
git -C "$REPO_ROOT" push origin HEAD
git -C "$REPO_ROOT" push origin "v${VERSION}"

# ── Cleanup ──────────────────────────────────────────────────────────────────
rm -rf "$TMP_POD" "$TMP_SPM"

echo ""
echo "==> Released CPaySDK v${VERSION} ✓"
echo "    GitHub: https://github.com/${REPO}/releases/tag/v${VERSION}"
echo "    CocoaPods: pod update CPaySDK"
