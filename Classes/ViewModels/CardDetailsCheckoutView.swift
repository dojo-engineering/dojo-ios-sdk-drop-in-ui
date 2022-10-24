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
    var email: String?
    var billingCountry: String?
    var billingPostcode: String? //TODO:
    var isSaveCardSelected = true
    
    init(config: ConfigurationManager) {
        super.init(paymentIntent: config.paymentIntent)
    }
    
    func processPayment(cardDetails: DojoCardDetails, fromViewController: UIViewController, completion: ((Int) -> Void)?) {
        let cardPaymentPayload = DojoCardPaymentPayload(cardDetails: cardDetails,
                                                        userEmailAddress: email,
                                                        billingAddress: DojoAddressDetails(postcode: billingPostcode, countryCode: billingPostcode),
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
}
