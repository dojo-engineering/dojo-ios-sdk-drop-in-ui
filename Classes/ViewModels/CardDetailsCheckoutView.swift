//
//  CardDetailsCheckoutView.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

class CardDetailsCheckoutViewModel {
    // for test purposes only
    var cardDetails3DS = DojoCardDetails(cardNumber: "4456530000001096", cardName: "Card Holder", expiryDate: "12 / 24", cv2: "020")
    var cardDetailsNon3DS = DojoCardDetails(cardNumber: "5200000000000056", cardName: "Card Holder", expiryDate: "12 / 24", cv2: "341")
    
    let token: String
    
    init(config: ConfigurationManager) {
        self.token = config.paymentIntent.clientSessionSecret
    }
    
    func processPayment(cardDetails: DojoCardDetails, fromViewControlelr: UIViewController, completion: ((Int) -> Void)?) {
        let cardPaymentPayload = DojoCardPaymentPayload(cardDetails: cardDetails, isSandbox: false)
        DojoSDK.executeCardPayment(token: token,
                                    payload: cardPaymentPayload,
                                    fromViewController: fromViewControlelr,
                                    completion: completion)
    }
}
