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
    
    func fetchCustomersPaymentMethods(customerId: String, completion: (([SavedPaymentMethod]?, Error?) -> Void)?) {
        if let customerSecret = customerSecret {
            DojoSDK.fetchCustomerPaymentMethods(customerId: customerId, customerSecret: customerSecret, completion: { stringData, error in
                let resultDemo = """
                {"customerId":"cust_0FgzjLELaku4ZBKJpIXkXg","merchantId":"66666","savedPaymentMethods":[{"id":"pm_otRL98WURbaAKs0sdy7_5w","cardDetails":{"pan":"52000000****0056","expiryDate":"2024-12-31","scheme":"MASTERCARD"}},{"id":"pm_otRL98WURbaAKs0sdy7_5","cardDetails":{"pan":"52000000****0056","expiryDate":"2024-12-31","scheme":"AMEX"}}],"supportedPaymentMethods":{"cardSchemes":["VISA","MASTERCARD","MAESTRO","AMEX"],"wallets":["APPLE_PAY","GOOGLE_PAY"]}}
                """
                    if let data = resultDemo.data(using: .utf8) {
                    do {
                        let decoder = JSONDecoder()
                        let decodedResponse = try decoder.decode(SavedPaymentRoot.self, from: data)
                        completion?(decodedResponse.savedPaymentMethods, nil)
                    } catch {
                        completion?(nil, error)
                    }
                } else {
                    completion?(nil, error)
                }
                
//                if let error = error {
//                    completion?(nil, error)
//                } else if let data = stringData?.data(using: .utf8) {
//                    do {
//                        let decoder = JSONDecoder()
//                        let decodedResponse = try decoder.decode(SavedPaymentRoot.self, from: data)
//                        completion?(decodedResponse.savedPaymentMethods, nil)
//                    } catch {
//                        completion?(nil, error)
//                    }
//                } else {
//                    completion?(nil, error)
//                }
            })
        } else {
            completion?(nil, nil)
        }
    }
}
