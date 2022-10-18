//
//  CardDetailsCheckoutView.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

class CardDetailsCheckoutViewModel: BaseViewModel {
    // for test purposes only
    var cardDetails3DS = DojoCardDetails(cardNumber: "4456530000001096", cardName: "Card Holder", expiryDate: "12 / 24", cv2: "020")
    var cardDetailsNon3DS = DojoCardDetails(cardNumber: "5200000000000056", cardName: "Card Holder", expiryDate: "12 / 24", cv2: "341")
    
    init(config: ConfigurationManager) {
        super.init(paymentIntent: config.paymentIntent)
    }
    
    func processPayment(cardDetails: DojoCardDetails, fromViewControlelr: UIViewController, completion: ((Int) -> Void)?) {
        let cardPaymentPayload = DojoCardPaymentPayload(cardDetails: cardDetails, savePaymentMethod: false)
        DojoSDK.executeCardPayment(token: paymentIntent.clientSessionSecret,
                                    payload: cardPaymentPayload,
                                    fromViewController: fromViewControlelr,
                                    completion: completion)
    }
    
    var showFieldEmail: Bool {
        paymentIntent.config?.customerEmail?.collectionRequired ?? false
    }
    
    var showFieldBilling: Bool {
        paymentIntent.config?.billingAddress?.collectionRequired ?? false
    }
}

// Validators
extension CardDetailsCheckoutViewModel {
    
    func isEmailValid(_ email: String) -> Bool {
        return false
    }
    
}
