//
//  CardDetailsCheckoutView.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

class PaymentMethodCheckoutViewModel: BaseViewModel {
    
    let applePayConfig: DojoUIApplePayConfig?
    
    init(config: ConfigurationManager) {
        self.applePayConfig = config.applePayConfig
        super.init(paymentIntent: config.paymentIntent)
    }
    
    func isApplePayAvailable() -> Bool {
        guard let appleConfig = getApplePayConfig() else { return false }
        return DojoSDK.isApplePayAvailable(config: appleConfig)
    }
    
    func getApplePayConfig() -> DojoApplePayConfig? {
        guard let merchantIdentifier = applePayConfig?.merchantIdentifier else { return nil }
        return DojoApplePayConfig(merchantIdentifier: merchantIdentifier,
                                  supportedCards: getSupportedApplePayCards())
    }
    
    func processApplePayPayment(fromViewControlelr: UIViewController, completion: ((Int) -> Void)?) {
        guard let merchantIdentifier = applePayConfig?.merchantIdentifier else {
            completion?(5)
            return
        }
        let paymentIntent = DojoPaymentIntent(id:paymentIntent.id, totalAmount: paymentIntent.amount)
        let applePayload = DojoApplePayPayload(applePayConfig: DojoApplePayConfig(merchantIdentifier: merchantIdentifier,
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
