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
    let customerSecret: String?
    let demoDelay: Double
    
    init(paymentIntentId: String, customerSecret: String? = nil, demoDelay: Double) {
        self.paymentIntentId = paymentIntentId
        self.customerSecret = customerSecret
        self.demoDelay = demoDelay
        let emptyPaymentIntent = PaymentIntent(id: paymentIntentId,
                                               clientSessionSecret: "",
                                               amount: DojoPaymentIntentAmount(value: 0, currencyCode: ""))
        super.init(paymentIntent: emptyPaymentIntent)
    }
    
    func fetchPaymentIntent(completion: ((PaymentIntent?, Error?) -> Void)?) {
        DojoSDK.fetchPaymentIntent(intentId: paymentIntentId) { stringData, error in
            if let error = error {
                completion?(nil, error)
            } else if let data = stringData?.data(using: .utf8) {
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(PaymentIntent.self, from: data)
                    completion?(decodedResponse, nil)
                } catch {
                    completion?(nil, error)
                }
            } else {
                completion?(nil, error)
            }
        }
    }
    
    func fetchCustomersPaymentMethods(customerId: String) {
        if let customerSecret = customerSecret {
            DojoSDK.fetchCustomerPaymentMethods(customerId: customerId, customerSecret: customerSecret, completion: {result, error in
                var a = 0
            })
        }//TODO: when not passed
    }
}
