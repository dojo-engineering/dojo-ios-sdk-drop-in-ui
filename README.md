# Dojo SDK Drop in UI

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 11+

## Installation

Dojo SDK Drop in UI is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'dojo-ios-sdk-drop-in-ui' :git => 'git@github.com:dojo-engineering/dojo-ios-sdk-drop-in-ui.git', :tag => '1.0.0'
```

## SDK Capabilities
- Take ApplePay
- Take card payments (Visa, Mastercard, Maestro, Amex)
- Remember card details for future use
- Pay using saved card details
- Manage saved cards 
- UI customisation

## How to use

You need to creat a payment intent and pass it into the SDK. More on how to [Create Payment Intent](https://docs.dojo.tech/api#tag/Payment-intents/operation/PaymentIntents_CreatePaymentIntent)

### Start checkout process:
Swift
```swift
import dojo_ios_sdk_drop_in_ui

let dojoUI = DojoSDKDropInUI()

dojoUI.startPaymentFlow(paymentIntentId: "payment-intent-id",
                        controller: self) { result in
    print(result)
}
```
Objective-C
```objc
#import <dojo_ios_sdk_drop_in_ui-Swift.h>

@property DojoSDKDropInUI *dojoUI;

self.dojoUI = [[DojoSDKDropInUI alloc] init];
[self.dojoUI startPaymentFlowWithPaymentIntentId: @"payment-intent-id"
                                      controller: self
                                  customerSecret: nil
                                  applePayConfig: nil
                                   themeSettings: nil
                                      completion: ^(NSInteger result) {
    NSLog(@"%ld", (long)result);
}];
```

### Configure ApplePay
To use ApplePay you first need to generate a merchnat certificate and send it to us. For more information on that process [contact us](https://support.dojo.tech/hc/en-gb/requests/new) 
After that, you'll need to pass your merchant identifier to the SDK

Swift
```swift
dojoUI.startPaymentFlow(paymentIntentId: "payment-intent-id",
                        controller: self,
                        applePayConfig: DojoUIApplePayConfig(merchantIdentifier: "merchant-identifier")) { result in
    print(result)
}
```
Objective-C
```objc
[self.dojoUI startPaymentFlowWithPaymentIntentId: @"payment-intent-id"
                                      controller: self
                                  customerSecret: nil
                                  applePayConfig: [[DojoUIApplePayConfig alloc] initWithMerchantIdentifier: @"merchant-identifier"]
                                   themeSettings: nil
                                      completion: ^(NSInteger result) {
    NSLog(@"%ld", (long)result);
}];
```

### Configure Saved Cards
In order for user to be able to pay or save a card, you need to:
- [Create a customer on your backend](https://docs.dojo.tech/api#tag/Customers/operation/Customers_Create)
- Pass customerId during the [creation of payment intent](https://docs.dojo.tech/api#tag/Payment-intents/operation/PaymentIntents_CreatePaymentIntent)
- [Generate CustomerSecret](https://docs.dojo.tech/api#tag/Customers/operation/Customers_CreateCustomerSecret) and pass it into the SDK

Swift
```swift
dojoUI.startPaymentFlow(paymentIntentId: "payment-intent-id",
                        controller: self,
                        customerSecret: "customer-secret") { result in
    print(result)
}
```
Objective-C
```objc
[self.dojoUI startPaymentFlowWithPaymentIntentId: @"payment-intent-id"
                                      controller: self
                                  customerSecret: @"customer-secret"
                                  applePayConfig: nil
                                   themeSettings: nil
                                      completion: ^(NSInteger result) {
    NSLog(@"%ld", (long)result);
}];
```

### Customise UI
It's possible to customise the look of the sdk by providing DojoThemeSettings object

Swift
```swift
let theme = DojoThemeSettings(primaryLabelTextColor: .red,
                              secondaryLabelTextColor: .green,
                              headerTintColor: .green,
                              headerButtonTintColor: .orange,
                              primaryCTAButtonActiveBackgroundColor: .blue)
dojoUI.startPaymentFlow(paymentIntentId: "payment-intent-id",
                        controller: self,
                        themeSettings: theme) { result in
    print(result)
}
```
Objective-C
```objc
DojoThemeSettings *theme = [[DojoThemeSettings alloc] initWithPrimaryLabelTextColor: UIColor.redColor
                                                            secondaryLabelTextColor: UIColor.greenColor
                                                                    headerTintColor: UIColor.greenColor
                                                              headerButtonTintColor: UIColor.orangeColor
                                              primaryCTAButtonActiveBackgroundColor: UIColor.blueColor];
[self.dojoUI startPaymentFlowWithPaymentIntentId: @"payment-intent-id"
                                      controller: self
                                  customerSecret: nil
                                  applePayConfig: nil
                                   themeSettings: theme
                                      completion: ^(NSInteger result) {
    NSLog(@"%ld", (long)result);
}];
```

## Result codes

```
successful = 0
authorizing = 3
referred = 4
declined = 5
duplicateTransaction = 20
failed = 30
waitingPreExecute = 99
invalidRequest = 400
issueWithAccessToken = 401
noAccessTokenSupplied = 404
internalServerError = 500
            
sdkInternalError = 7770
```

## License

Dojo SDK Drop in UI is available under the MIT license. See the LICENSE file for more info.
