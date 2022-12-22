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
    
    init?(config: ConfigurationManager) {
        if let paymentIntent = config.paymentIntent {
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
        DojoSDK.executeCardPayment(token: paymentIntent.clientSessionSecret,
                                    payload: cardPaymentPayload,
                                    fromViewController: fromViewController,
                                    completion: completion)
    }
    
    var showFieldEmail: Bool {
        paymentIntent.config?.customerEmail?.collectionRequired ?? false
    }
    
    var showFieldBilling: Bool {
        paymentIntent.config?.billingAddress?.collectionRequired ?? false
    }
    
    var showSaveCardCheckbox: Bool {
        paymentIntent.customer?.id != nil
    }
    
    var supportedCardSchemes: [CardSchemes] {
        paymentIntent.merchantConfig?.supportedPaymentMethods?.cardSchemes ?? []
    }
    
    func showBillingPostcode(_ countryCode: String) -> Bool {
        ["GB", "US", "CA"].contains(countryCode)
    }
}
