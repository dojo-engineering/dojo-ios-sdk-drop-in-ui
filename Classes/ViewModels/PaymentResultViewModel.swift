//
//  CardDetailsCheckoutView.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

class PaymentResultViewModel {
    
    let resultCode: Int
    let paymentIntentId: String
    
    init(config: ConfigurationManager,
         resultCode: Int) {
        self.resultCode = resultCode
        self.paymentIntentId = config.paymentIntentId
    }
    
    func refreshToken(completion: ((String?,Error?)-> Void)?) {
        DojoSDK.refreshPaymentIntent(intentId: paymentIntentId, completion: completion)
    }
}
