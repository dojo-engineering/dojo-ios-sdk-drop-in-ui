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
    
    let isSandbox: Bool
    let token: String
    
    init(config: ConfigurationManager) {
        self.isSandbox = config.isSandbox
        self.token = config.token
    }
    
    func processPayment(cardDetails: DojoCardDetails, fromViewControlelr: UIViewController) {
        let cardPaymentPayload = DojoCardPaymentPayload(cardDetails: cardDetails, isSandbox: isSandbox)
        DojoSDK.executeCardPayment(token: token,
                                    payload: cardPaymentPayload,
                                    fromViewController: fromViewControlelr) { [weak self] result in
            print(result)
        }
    }
}
