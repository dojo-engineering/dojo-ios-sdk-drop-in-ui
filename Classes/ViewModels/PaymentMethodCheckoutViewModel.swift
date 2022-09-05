//
//  CardDetailsCheckoutView.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

class PaymentMethodCheckoutViewModel {
    
    let isSandbox: Bool
    let token: String
    
    init(config: ConfigurationManager) {
        self.isSandbox = config.isSandbox
        self.token = config.token
    }
    
    func processApplePayPayment(fromViewControlelr: UIViewController, completion: ((Int) -> Void)?) {
        let paymentIntent = DojoPaymentIntent(clientSessionSecret: token, totalAmount: DojoPaymentIntentAmount(value: 10, currencyCode: "GBP"))
        let applePayload = DojoApplePayPayload(applePayConfig: DojoApplePayConfig(merchantIdentifier: "merchant.com.something"))
        DojoSDK.executeApplePayPayment(paymentIntent: paymentIntent,
                                       payload: applePayload,
                                       fromViewController: fromViewControlelr,
                                       completion: completion)
    }
}
