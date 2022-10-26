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
```
import dojo_ios_sdk_drop_in_ui

let dojoUI = DojoSDKDropInUI()

dojoUI.startPaymentFlow(paymentIntentId: "payment-intent-id",
                        controller: self) { result in
    print(result)
}
```

To use ApplePay you first need to generate a merchnat certificate and send it to us. For more information on that process contact us at:
After that, you'll need to pass your merchant identifier to the SDK

### Configure ApplePay
```
dojoUI.startPaymentFlow(paymentIntentId: "payment-intent-id",
                        controller: self,
                        applePayConfig: DojoUIApplePayConfig(merchantIdentifier: "merchant-identifier")) { result in
    print(result)
}
```

In order for user to be able to pay or save a card, you need to:
- Create a customer on your backend. Reference
- Pass customerId during the creation of payment intent. Reference 
- Generate CustomerSecret and pass it into the SDK. Reference

### Configure Saved Cards
```
dojoUI.startPaymentFlow(paymentIntentId: "payment-intent-id",
                        controller: self,
                        customerSecret: "customer-secret") { result in
    print(result)
}
```

It's possible to customise the look of the sdk. For the full set of available UI customisations refer to: 

### Customise UI
```
dojoUI.startPaymentFlow(paymentIntentId: "payment-intent-id",
                        controller: self,
                        customerSecret: "customer-secret") { result in
    print(result)
}
```

## License

dojo-ios-sdk-drop-in-ui is available under the MIT license. See the LICENSE file for more info.
