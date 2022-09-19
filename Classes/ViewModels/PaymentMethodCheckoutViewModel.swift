//
//  CardDetailsCheckoutView.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

class PaymentMethodCheckoutViewModel {
    
    let paymentIntent: PaymentIntent
    
    init(config: ConfigurationManager) {
        self.paymentIntent = config.paymentIntent
    }
    
    func processApplePayPayment(fromViewControlelr: UIViewController, completion: ((Int) -> Void)?) {
        let paymentIntent = DojoPaymentIntent(clientSessionSecret: self.paymentIntent.clientSessionSecret, totalAmount: paymentIntent.amount)
        let applePayload = DojoApplePayPayload(applePayConfig: DojoApplePayConfig(merchantIdentifier: "merchant.uk.co.paymentsense.sdk.demo.app"))
        DojoSDK.executeApplePayPayment(paymentIntent: paymentIntent,
                                       payload: applePayload,
                                       fromViewController: fromViewControlelr,
                                       completion: completion)
    }
}
