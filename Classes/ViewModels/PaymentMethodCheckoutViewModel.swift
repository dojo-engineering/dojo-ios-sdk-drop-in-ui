//
//  CardDetailsCheckoutView.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

class PaymentMethodCheckoutViewModel: BaseViewModel {
    
    init(config: ConfigurationManager) {
        super.init(paymentIntent: config.paymentIntent)
    }
    
    func processApplePayPayment(fromViewControlelr: UIViewController, completion: ((Int) -> Void)?) {
        let paymentIntent = DojoPaymentIntent(id:paymentIntent.id, totalAmount: paymentIntent.amount)
        let applePayload = DojoApplePayPayload(applePayConfig: DojoApplePayConfig(merchantIdentifier: "merchant.uk.co.paymentsense.sdk.demo.app",
                                                                                  supportedCards: getSupportedApplePayCards()))
        DojoSDK.executeApplePayPayment(paymentIntent: paymentIntent,
                                       payload: applePayload,
                                       fromViewController: fromViewControlelr) { result in
                guard result == 0 else { return }
                completion?(result)
            }
    }
    
    func getSupportedApplePayCards() -> [String] {
        paymentIntent.merchantConfig?.supportedPaymentMethods?.cardSchemes?.compactMap({
            switch $0 {
            case .visa:
                return ApplePaySupportedCards.visa.rawValue
            case .mastercard:
                return ApplePaySupportedCards.mastercard.rawValue
            case .maestro:
                return ApplePaySupportedCards.maestro.rawValue
            case .amex:
                return ApplePaySupportedCards.amex.rawValue
            case .other:
                return nil
            }
        }) ?? []
    }
}
