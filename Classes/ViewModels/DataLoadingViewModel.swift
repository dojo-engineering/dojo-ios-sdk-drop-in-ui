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
    let demoDelay: Double
    
    init(paymentIntentId: String, demoDelay: Double) {
        self.paymentIntentId = paymentIntentId
        self.demoDelay = demoDelay
    }
    
    func fetchPaymentIntent(completion: ((PaymentIntent?, Error?) -> Void)?) {
        DojoSDK.fetchPaymentIntent(intentId: paymentIntentId) { stringData, error in
            if let error = error {
                completion?(nil, error) // error
            } else if let data = stringData?.data(using: .utf8) {
                let decoder = JSONDecoder()
                if let decodedResponse = try? decoder.decode(PaymentIntent.self, from: data) {
                    completion?(decodedResponse, nil) // decoded payment intent
                } else {
                    completion?(nil, error) //TODO: decoding error
                }
            } else {
                // TODO: shouldn't happen
                completion?(nil, error)
            }
        }
    }
}
