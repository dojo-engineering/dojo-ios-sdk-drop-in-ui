//
//  DataLoadingViewModel.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

class DataLoadingViewModel: BaseViewModel {
    
    let paymentIntentId: String
    let demoDelay: Double
    
    init(paymentIntentId: String, demoDelay: Double) {
        self.paymentIntentId = paymentIntentId
        self.demoDelay = demoDelay
        let emptyPaymentIntent = PaymentIntent(id: paymentIntentId,
                                               clientSessionSecret: "",
                                               amount: DojoPaymentIntentAmount(value: 0, currencyCode: ""))
        super.init(paymentIntent: emptyPaymentIntent)
    }
    
    func fetchPaymentIntent(completion: ((PaymentIntent?, Error?) -> Void)?) {
        DojoSDK.fetchPaymentIntent(intentId: paymentIntentId) { stringData, error in
            if let error = error {
                completion?(nil, error) // error
            } else if let data = stringData?.data(using: .utf8) {
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(PaymentIntent.self, from: data)
                    completion?(decodedResponse, nil) // decoded payment intent
                } catch {
                    completion?(nil, error) //TODO: decoding error
                }
            } else {
                // TODO: shouldn't happen
                completion?(nil, error)
            }
        }
    }
}
