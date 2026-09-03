# Apple Pay

## Prerequisites

- Citcon must enable Apple Pay for your merchant account and issue you a merchant identifier. Once that's done, the backend `/config` response includes the `applepay_direct` gateway.
- You need an Apple Developer Program account (to create the Merchant ID and enable the capability below).
- Minimum iOS version is 13.0, matching the SDK's podspec (`s.platform = :ios, "13.0"`).
- Apple Pay requires **CPaySDK 2.8.0 or later**. Pin your Podfile to that version or newer.
- Apple Pay must be tested on a real device. The simulator never presents the payment sheet, regardless of how your code is configured.

## Merchant ID onboarding

Getting Apple Pay working end to end requires an exchange of certificates between you and Citcon before any code runs. Follow this sequence:

1. Citcon generates a Certificate Signing Request (CSR) and sends it to you. **The private key stays on Citcon's side and is never shared** — do not generate your own CSR for this flow.
2. You create a Merchant ID in the Apple Developer Portal.
3. You upload Citcon's CSR to that Merchant ID to generate a Payment Processing Certificate.
4. You download the resulting `.cer` file and send it back to Citcon.
5. Citcon installs the certificate and finishes the merchant-side configuration.
6. You enable the Apple Pay capability in Xcode with this Merchant ID (see the next section).

The private key that decrypts the payment token lives on Citcon's side, so only Citcon can open it — that's what makes Smart Routing possible. This flow is specific to iOS apps: you do **not** need a Merchant Identity Certificate here, since that certificate is only used for Apple Pay on the Web.

## Xcode setup

- In your target's Signing & Capabilities tab, add the Apple Pay capability and check the Merchant ID created in the previous step.
- The entitlement key behind this is `com.apple.developer.in-app-payments`.
- The capability is required for the payment sheet to present at all. The SDK calls `PKPaymentAuthorizationController.present(completion: nil)` with no completion handler, so if presentation fails (e.g. because the entitlement is missing) it fails silently: no error, no crash, and no delegate callback fires. In practice this looks like `requestOrder` never calling your `CPayRequestCallback` — nothing happens after you tap the Apple Pay button. If you hit that, check the entitlement first.

> **Bundled demo note:** `CPayDemoOC/CPayDemoOC/CPayDemoOC.entitlements` in this repo is signed with Citcon's own Apple Pay merchant ID (`merchant.applepay.citconpay.com.ecc`). Running that demo on your own device will fail provisioning. To run it yourself, edit `CPayDemoOC/CPayDemoOC/CPayDemoOC.entitlements` to use your own merchant ID and sign the target with your own team.

## Installation

No extra subspec is required:

```ruby
pod 'CPaySDK/Core'
```

PassKit is a system framework, and the Apple Pay gateway is compiled directly into the `Core` target.

## Checking availability

Before showing an Apple Pay button, call `PKPaymentAuthorizationController.canMakePayments(usingNetworks:)`.

The SDK hardcodes the supported card networks: Visa, Mastercard, American Express, Discover, JCB, China UnionPay.

The merchant capabilities the SDK requests are: 3D Secure, EMV, debit, credit. `EMV` is required for China UnionPay.

## Making a payment

- `transaction.amount` is in the **minor currency unit** — `1199` means `$11.99`.
  The exponent follows ISO 4217 and is not always 2: zero-decimal currencies take the
  whole unit (`100` is `¥100` for JPY, not `¥1`), and three-decimal currencies take
  thousandths (`1234` is `1.234 KWD`). The SDK scales the sheet total by the currency's
  own exponent, so the amount you send is the amount the customer sees and is charged.
- `transaction.currency` and `transaction.country` are required.
- `payment.method` must be `"applepay"`.
- `order.controller` is **not needed** for Apple Pay — the gateway presents the payment sheet itself.
- `ext.device.ip` is **required** for Apple Pay. Send the public IP your own backend observed for
  the customer: an app can only see its device's LAN address, which is useless for risk scoring.
  Maximum length 45 characters, so IPv6 fits.
- In production, create the charge on **your own server** and have the client only confirm it. The `generateOrder` call below is for demonstration convenience only.

Objective-C:

```objc
#import <CPaySDK/CPaySDK-Swift.h>
#import <PassKit/PassKit.h>

// 0. Configure the SDK once at startup. `yourAccessToken` comes from your own backend.
[[CPayManager sharedInst] setMode:CPayENVModeUAT];   // or CPayENVModePROD in production
[[CPayManager sharedInst] setAccessToken:yourAccessToken];

// 1. Only offer Apple Pay when the device can actually use it.
NSArray<PKPaymentNetwork> *networks = @[PKPaymentNetworkVisa,
                                        PKPaymentNetworkMasterCard,
                                        PKPaymentNetworkAmex,
                                        PKPaymentNetworkDiscover,
                                        PKPaymentNetworkJCB,
                                        PKPaymentNetworkChinaUnionPay];
if (![PKPaymentAuthorizationController canMakePaymentsUsingNetworks:networks]) {
    return;   // hide the Apple Pay button
}

// 2. Build the order. Amount is in minor units: 1199 == $11.99
CPayRequest *order = [CPayRequest new];
order.transaction.reference = @"YOUR-ORDER-REFERENCE";
order.transaction.amount    = @(1199);
order.transaction.currency  = @"USD";
order.transaction.country   = @"US";

order.payment        = [CPayPayment new];
order.payment.method = @"applepay";

// Required. Use the public IP your backend saw for this customer, not a device-local one.
order.ext            = [CPayExt new];
order.ext.device     = [CPayExtDevice new];
order.ext.device.ip  = @"203.0.113.42";

// 3. Create the charge. In production, do this on your own server.
[[CPayManager sharedInst] generateOrder:order callback:^(CPayResult * _Nullable resp) {
    if (resp == nil || [resp.status isEqualToString:@"fail"]) {
        NSLog(@"create charge failed: %@", resp.data.message);
        return;
    }
    order.chargeToken = resp.data.chargeToken;

    // 4. Confirm. The SDK presents the Apple Pay sheet itself.
    [[CPayManager sharedInst] requestOrder:order callback:^(CPayResult * _Nullable result) {
        NSLog(@"status=%@ code=%@ message=%@",
              result.status, result.data.code, result.data.message);
    }];
}];
```

Swift:

```swift
import CPaySDK
import PassKit

// 0. Configure the SDK once at startup. `yourAccessToken` comes from your own backend.
CPayManager.sharedInst().setMode(.UAT)   // or .PROD in production
CPayManager.sharedInst().setAccessToken(yourAccessToken)

// 1. Only offer Apple Pay when the device can actually use it.
let networks: [PKPaymentNetwork] = [.visa, .masterCard, .amex, .discover, .JCB, .chinaUnionPay]
guard PKPaymentAuthorizationController.canMakePayments(usingNetworks: networks) else {
    return   // hide the Apple Pay button
}

// 2. Build the order. Amount is in minor units: 1199 == $11.99
let order = CPayRequest()
order.transaction.reference = "YOUR-ORDER-REFERENCE"
order.transaction.amount    = NSNumber(value: 1199)
order.transaction.currency  = "USD"
order.transaction.country   = "US"

order.payment        = CPayPayment()
order.payment?.method = "applepay"

// Required. Use the public IP your backend saw for this customer, not a device-local one.
order.ext            = CPayExt()
order.ext?.device    = CPayExtDevice()
order.ext?.device?.ip = "203.0.113.42"

// 3. Create the charge. In production, do this on your own server.
CPayManager.sharedInst().generateOrder(order) { resp in
    guard let resp = resp, resp.status != "fail" else {
        print("create charge failed")
        return
    }
    order.chargeToken = resp.data.chargeToken

    // 4. Confirm. The SDK presents the Apple Pay sheet itself.
    CPayManager.sharedInst().requestOrder(order) { result in
        print("status=\(result?.status ?? "") code=\(result?.data.code ?? "")")
    }
}
```

## Billing address

Depending on which gateway your transaction routes to, the backend may require
`payment.billing_address` with `email`, `first_name` and `last_name` present. There are two
ways that gets filled, and **the SDK picks one before the sheet appears** — they are never
mixed:

| You supply | What the SDK does |
|---|---|
| `payment.billingAddress` with any of `street`, `city`, `state`, `zip`, `country` set | Asks Apple Pay for nothing. Your address is used as-is. |
| None of those five fields | Asks Apple Pay for the customer's name, email, phone and postal address, and fills `payment.billing_address` from what the sheet returns. |

Supplying the address yourself is the better option when you already have it. It keeps the
payment sheet minimal, and it keeps the address consistent with whatever you use for your own
records.

```objc
CPayBillingAddr *billing = [CPayBillingAddr new];
billing.firstName = @"Ada";
billing.lastName  = @"Lovelace";
billing.email     = @"ada@example.com";
billing.street    = @"1 Infinite Loop";
billing.city      = @"Cupertino";
billing.state     = @"CA";
billing.zip       = @"95014";
billing.country   = @"US";        // two-letter ISO code
order.payment.billingAddress = billing;
```

Two things to know if you leave it to Apple Pay:

- **The sheet gains a contact section.** iOS only allows a postal address to be requested as a
  billing contact field, so the name, email and phone have to be requested as *shipping* contact
  fields. A side effect is that the sheet labels that section "Ship To" even for a digital
  purchase. There is no PassKit option for "contact details, no shipping".
- **Fields the customer doesn't have on file come back empty**, and the required ones then fail
  validation. If `email`, `first_name` and `last_name` matter to you, supplying them yourself is
  more reliable than hoping they are present in the customer's Apple account.

Field limits are enforced by the backend and rejected rather than truncated: `email` 100,
`first_name` 30, `last_name` 40, `street` 50, `city` 30, `state` 3, `zip` 10, and `country`
exactly 2. Note the 3-character cap on `state` — pass a code like `CA`, not `California`.

## Handling results

There are three channels that can carry the outcome of an Apple Pay confirm:

| Channel | Fires when | Payload |
|---|---|---|
| `CPayRequestCallback` (the block passed to `requestOrder`) | immediately after confirm returns | `CPayResult` |
| `NSNotification` `CPayUPI.Notification.OrderConfirmed` | when the confirm succeeds | `CPayCheck` |
| `NSNotification` `CPayUPI.Notification.Async` | after the SDK automatically calls `GET /transactions/{id}` to fetch the result | `CPayCheck` |

Get the notification names from `[CPayRuntimeInst ORDER_CONFIRMED]` and `[CPayRuntimeInst NTFY_ASYNC]` rather than hardcoding the strings.

One thing to note: **failure and user-cancellation paths do not trigger that automatic follow-up query.** Your `CPayRequestCallback` still fires in both cases — it's the `GET /transactions/{id}` inquiry (and the resulting delayed `CPayUPI.Notification.Async`) that gets skipped. What you get instead is a single, immediate `CPayUPI.Notification.Async` notification with `status` set to `fail`, posted alongside the callback.

## Errors and testing

The SDK reports these errors through the `code` and `message` fields of `CPayResult`.

Raised on the device, before anything reaches the backend:

| code | message | meaning |
|---|---|---|
| `-1` | `Apple Pay is not available on this device` | the device doesn't support Apple Pay, or the user has disabled it |
| `-1` | `No Apple Pay card available for the supported networks` | the device supports Apple Pay, but the wallet has no card from a supported network |
| `-1` | `Apple Pay merchant identifier not configured` | the backend `/config` response didn't include a merchant identifier |
| `-1` | `.chargeToken can not be empty or nil` | `requestOrder` was called before a charge was created |
| `-3` | `Failed to encode Apple Pay token` | the payment token returned by PassKit could not be serialized |
| `other` | `Canceled` | the user dismissed the payment sheet without authorizing the payment |
| `-1` | `Unsupport Payment: <gateway>` | the installed CPaySDK predates 2.8.0 and has no Apple Pay gateway registered — upgrade the pod |

Returned by the backend when a required field is absent or malformed. These arrive with the
offending field named, so read the `message`:

| code | message | meaning |
|---|---|---|
| `4002` | `missing parameter ext.device.ip` | you did not set `ext.device.ip` |
| `4002` | `missing parameter payment.billing_address.email` | neither you nor the Apple Pay sheet supplied an email |
| `4002` | `missing parameter payment.billing_address.first_name` | same, for the given name |
| `4001` | `invalid parameter payment.billing_address.state` | over the 3-character cap — pass `CA`, not `California` |
| `4001` | `invalid parameter payment.billing_address.country` | not exactly two characters — use the ISO code |

Testing note: always use a real device. The simulator never presents the payment sheet, and
provisioning state is what decides whether presentation succeeds, so neither behaviour can be
reproduced there.
