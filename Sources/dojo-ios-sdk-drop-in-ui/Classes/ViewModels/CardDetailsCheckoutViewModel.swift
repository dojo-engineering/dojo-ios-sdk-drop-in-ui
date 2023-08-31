//
//  CardDetailsCheckoutViewModel.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

class CardDetailsCheckoutViewModel: BaseViewModel {
    var email: String?
    var billingCountry: String?
    var billingPostcode: String?
    var isSaveCardSelected = true
    var isTermsSelected = false
    var debugConfig: DojoSDKDebugConfig?
    
    init?(config: ConfigurationManager) {
        if let paymentIntent = config.paymentIntent {
            self.debugConfig = config.debugConfig
            super.init(paymentIntent: paymentIntent)
        } else {
            // payment intent is required for this screen
            return nil
        }
    }
    
    func processPayment(cardDetails: DojoCardDetails, fromViewController: UIViewController, completion: ((Int) -> Void)?) {
        let cardPaymentPayload = DojoCardPaymentPayload(cardDetails: cardDetails,
                                                        userEmailAddress: email,
                                                        billingAddress: DojoAddressDetails(postcode: billingPostcode, countryCode: billingCountry),
                                                        savePaymentMethod: isSaveCardSelected)
        if paymentIntent.isVirtualTerminalPayment {
            DojoSDK.executeVirtualTerminalPayment(token: paymentIntent.clientSessionSecret,
                                                  payload: cardPaymentPayload,
                                                  debugConfig: debugConfig ?? DojoSDKDebugConfig(isSandboxIntent: paymentIntent.isSandbox),
                                                  completion: completion)
        } else if paymentIntent.isSetupIntent {
            DojoSDK.refreshSetupIntent(intentId: paymentIntent.id, debugConfig: debugConfig) { stringData, fetchError in
                self.performPayment(stringData: stringData,
                                    error: fetchError,
                                    cardPaymentPayload: cardPaymentPayload,
                                    fromViewController: fromViewController,
                                    completion: completion)
            }
        }  else {
            DojoSDK.refreshPaymentIntent(intentId: paymentIntent.id, debugConfig: debugConfig) { stringData, fetchError in
                self.performPayment(stringData: stringData,
                                    error: fetchError,
                                    cardPaymentPayload: cardPaymentPayload,
                                    fromViewController: fromViewController,
                                    completion: completion)
            }
        }
    }
    
    private func performPayment(stringData: String?,
                                error: Error?,
                                cardPaymentPayload: DojoCardPaymentPayload,
                                fromViewController: UIViewController,
                                completion: ((Int) -> Void)?) {
        CommonUtils.parseResponseToCompletion(stringData: stringData,
                                              fetchError: error,
                                              objectType: PaymentIntent.self) { result, error in
            if let paymentIntent = result {
                DojoSDK.executeCardPayment(token: paymentIntent.clientSessionSecret,
                                           payload: cardPaymentPayload,
                                           debugConfig: self.debugConfig ?? DojoSDKDebugConfig(isSandboxIntent: paymentIntent.isSandbox),
                                           fromViewController: fromViewController,
                                           completion: completion)
            } else {
                completion?(5)
            }
        }
    }
    
    var showFieldEmail: Bool {
        paymentIntent.config?.customerEmail?.collectionRequired ?? false
    }
    
    var showFieldBilling: Bool {
        paymentIntent.config?.billingAddress?.collectionRequired ?? false
    }
    
    var showSaveCardCheckbox: Bool {
        guard !paymentIntent.isSetupIntent else { return false }
        return paymentIntent.customer?.id != nil
    }
    
    var supportedCardSchemes: [CardSchemes] {
        paymentIntent.merchantConfig?.supportedPaymentMethods?.cardSchemes ?? []
    }
    
    var tradingName: String {
        paymentIntent.config?.tradingName ?? ""
    }
    
    var navigationTitle: String {
        paymentIntent.isSetupIntent ? LocalizedText.CardDetailsCheckout.titleSetupIntent : LocalizedText.CardDetailsCheckout.title
    }
    
    func showBillingPostcode(_ countryCode: String) -> Bool {
        ["GB", "US", "CA"].contains(countryCode)
    }
}
