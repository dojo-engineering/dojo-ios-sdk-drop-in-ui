//
//  CardDetailsCheckoutView.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

class PaymentResultViewModel: BaseViewModel {
    
    let resultCode: Int
    let demoDelay: Double
    
    init?(config: ConfigurationManager,
         resultCode: Int) {
        self.resultCode = resultCode
        self.demoDelay = config.demoDelay
        if let paymentIntent = config.paymentIntent {
            super.init(paymentIntent: paymentIntent)
        } else {
            // payment intent is required for this screen
            return nil
        }
    }
    
    func refreshToken(completion: ((String?,Error?)-> Void)?) {
        DojoSDK.refreshPaymentIntent(intentId: paymentIntent.id, completion: completion)
    }
}
