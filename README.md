# Dojo SDK Drop in UI

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 11+

## Installation

dojo-ios-sdk-drop-in-ui is available through [CocoaPods](https://cocoapods.org). To install
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

You need to creat a payment intent and pass it into the SDK. More on how to create it: 

### Start checkout process:
Swift
```
import dojo_ios_sdk_drop_in_ui

let dojoUI = DojoSDKDropInUI()

dojoUI.startPaymentFlow(paymentIntentId: "payment-intent-id",
                        controller: self) { result in
    print(result)
}
```
Objective-C
```
#import <dojo_ios_sdk_drop_in_ui-Swift.h>

@property DojoSDKDropInUI *dojoUI;

self.dojoUI = [[DojoSDKDropInUI alloc] init];

self.dojoUI = [[DojoSDKDropInUI alloc] init];
[self.dojoUI startPaymentFlowWithPaymentIntentId:@"payment-intent-id"
                                      controller: self
                                  customerSecret: nil
                                  applePayConfig: nil
                                   themeSettings: nil
                                      completion:^(NSInteger result) {
    NSLog(@"%ld", (long)result);
}];
```

To use ApplePay you first need to generate a merchnat certificate and send it to us. For more information on that process contact us at:
After that, you'll need to pass your merchant identifier to the SDK

### Configure ApplePay
Swift
```
dojoUI.startPaymentFlow(paymentIntentId: "payment-intent-id",
                        controller: self,
                        applePayConfig: DojoUIApplePayConfig(merchantIdentifier: "merchant-identifier")) { result in
    print(result)
}
```
Objective-C
```
[self.dojoUI startPaymentFlowWithPaymentIntentId:@"payment-intent-id"
                                      controller: self
                                  customerSecret: nil
                                  applePayConfig: [[DojoUIApplePayConfig alloc] initWithMerchantIdentifier: @"merchant-identifier"]
                                   themeSettings: nil
                                      completion:^(NSInteger result) {
    NSLog(@"%ld", (long)result);
}];
```

In order for user to be able to pay or save a card, you need to:
- Create a customer on your backend. Reference
- Pass customerId during the creation of payment intent. Reference 
- Generate CustomerSecret and pass it into the SDK. Reference

### Configure Saved Cards
Swift
```
dojoUI.startPaymentFlow(paymentIntentId: "payment-intent-id",
                        controller: self,
                        customerSecret: "customer-secret") { result in
    print(result)
}
```
Objective-C
```
[self.dojoUI startPaymentFlowWithPaymentIntentId:@"payment-intent-id"
                                      controller: self
                                  customerSecret: @"customer-secret"
                                  applePayConfig: nil
                                   themeSettings: nil
                                      completion:^(NSInteger result) {
    NSLog(@"%ld", (long)result);
}];
```
It's possible to customise the look of the sdk. For the full set of available UI customisations refer to: 

### Customise UI
Swift
```
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
```
DojoThemeSettings *theme = [[DojoThemeSettings alloc] initWithPrimaryLabelTextColor: UIColor.redColor
                                                            secondaryLabelTextColor:UIColor.greenColor
                                                                    headerTintColor:UIColor.greenColor
                                                              headerButtonTintColor:UIColor.orangeColor
                                              primaryCTAButtonActiveBackgroundColor: UIColor.blueColor];
[self.dojoUI startPaymentFlowWithPaymentIntentId:@"payment-intent-id"
                                      controller: self
                                  customerSecret: nil
                                  applePayConfig: nil
                                   themeSettings: theme
                                      completion:^(NSInteger result) {
    NSLog(@"%ld", (long)result);
}];
```

## License

dojo-ios-sdk-drop-in-ui is available under the MIT license. See the LICENSE file for more info.
