//
//  DataLoadingViewModel.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

class DataLoadingViewModel {
    
    let paymentIntentId: String
    
    init(paymentIntentId: String) {
        self.paymentIntentId = paymentIntentId
    }
    
    func fetchPaymentIntent(completion: ((String?, Error?) -> Void)?) {
        DojoSDK.fetchPaymentIntent(intentId: paymentIntentId, completion: completion)
    }
}
