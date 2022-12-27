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
    var savedPaymentMethods: [SavedPaymentMethod]?
    
    init?(config: ConfigurationManager) {
        self.applePayConfig = config.applePayConfig
        self.savedPaymentMethods = config.savedPaymentMethods
        if let paymentIntent = config.paymentIntent {
            super.init(paymentIntent: paymentIntent)
        } else {
            // payment intent is required for this screen
            return nil
        }
    }
    
    func isSavedPaymentMethodsAvailable() -> Bool {
        paymentIntent.customer?.id != nil &&
        savedPaymentMethods?.count ?? 0 > 0
    }
    
    func showAdditionalItemsLine() -> Bool {
        paymentIntent.itemLines?.count ?? 0 > 0
    }
    
    func processSavedCardPayment(fromViewControlelr: UIViewController,
                                 paymentId: String,
                                 cvv: String,
                                 completion: ((Int) -> Void)?) {
        let savedCardPaymentPayload = DojoSavedCardPaymentPayload(cvv: cvv,
                                                                  paymentMethodId: paymentId)
        DojoSDK.executeSavedCardPayment(token: paymentIntent.clientSessionSecret,
                                        payload: savedCardPaymentPayload,
                                        fromViewController: fromViewControlelr,
                                        completion: completion)
    }
    
    func processApplePayPayment(fromViewControlelr: UIViewController, completion: ((Int) -> Void)?) {
        guard let merchantIdentifier = applePayConfig?.merchantIdentifier else {
            completion?(5)
            return
        }
        let paymentIntent = DojoPaymentIntent(id:paymentIntent.id, totalAmount: paymentIntent.amount)
        let applePayload = DojoApplePayPayload(applePayConfig: DojoApplePayConfig(merchantIdentifier: merchantIdentifier,
                                                                                  supportedCards: getSupportedApplePayCards(),
                                                                                  collectBillingAddress: self.paymentIntent.config?.billingAddress?.collectionRequired ?? false,
                                                                                  collectEmail: self.paymentIntent.config?.customerEmail?.collectionRequired ?? false))
        DojoSDK.executeApplePayPayment(paymentIntent: paymentIntent,
                                       payload: applePayload,
                                       fromViewController: fromViewControlelr) { result in
                guard result == 0 else { return }
                completion?(result)
            }
    }
    
    func isApplePayAvailable() -> Bool {
        CommonUtils.isApplePayAvailable(appleConfig: getApplePayConfig(), paymentIntent: paymentIntent)
    }
  
    func getApplePayConfig() -> DojoApplePayConfig? {
        CommonUtils.getApplePayConfig(applePayConfig: applePayConfig, paymentIntent: paymentIntent)
    }
    
    func getSupportedApplePayCards() -> [String] {
        CommonUtils.getSupportedApplePayCards(paymentIntent: paymentIntent)
    }
}
