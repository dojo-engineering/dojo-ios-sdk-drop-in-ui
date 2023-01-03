//
//  DataLoadingViewModel.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

// Not a part of BaseViewModel because it doesn't have a full paymentIntent object
// That's the viewModel that actually gets that object that other viewModels are required to have
class DataLoadingViewModel {
    
    let paymentIntentId: String
    let customerSecret: String?
    let demoDelay: Double
    
    init(paymentIntentId: String, customerSecret: String? = nil, demoDelay: Double) {
        self.paymentIntentId = paymentIntentId
        self.customerSecret = customerSecret
        self.demoDelay = demoDelay
    }
    
    func fetchPaymentIntent(completion: ((PaymentIntent?, Error?) -> Void)?) {
        DojoSDK.fetchPaymentIntent(intentId: paymentIntentId) { stringData, fetchError in
            CommonUtils.parseResponseToCompletion(stringData: stringData,
                                                  fetchError: fetchError,
                                                  objectType: PaymentIntent.self,
                                                  completion: completion)
        }
    }
    
//    func fetchCustomersPaymentMethods(customerId: String, completion: (([SavedPaymentMethod]?, Error?) -> Void)?) {
//        guard let customerSecret = customerSecret else {
//            completion?(nil, nil)
//            return
//        }
//        DojoSDK.fetchCustomerPaymentMethods(customerId: customerId, customerSecret: customerSecret, completion: { stringData, error in
//            CommonUtils.parseResponseToCompletion(stringData: stringData,
//                                                  fetchError: error,
//                                                  objectType: SavedPaymentRoot.self) { result, error in
//                completion?(result?.savedPaymentMethods, nil)
//            }
//        })
//    }
    
    //DEMO
    func fetchCustomersPaymentMethods(customerId: String, completion: (([SavedPaymentMethod]?, Error?) -> Void)?) {
        guard let customerSecret = customerSecret else {
            completion?(nil, nil)
            return
        }
        DojoSDK.fetchCustomerPaymentMethods(customerId: customerId, customerSecret: customerSecret, completion: { stringData, error in
            let resultDemo = """
            {"customerId":"cust_0FgzjLELaku4ZBKJpIXkXg","merchantId":"66666","savedPaymentMethods":[{"id":"pm_REvXpOXlQPa1SCXoxhAghg","cardDetails":{"pan":"52000000****0056","expiryDate":"2024-12-31","scheme":"MASTERCARD"}},{"id":"pm_otRL98WURbaAKs0sdy7_5","cardDetails":{"pan":"52000000****0056","expiryDate":"2024-12-31","scheme":"AMEX"}}],"supportedPaymentMethods":{"cardSchemes":["VISA","MASTERCARD","MAESTRO","AMEX"],"wallets":["APPLE_PAY","GOOGLE_PAY"]}}
            """
            CommonUtils.parseResponseToCompletion(stringData: resultDemo,
                                                  fetchError: nil,
                                                  objectType: SavedPaymentRoot.self) { result, error in
                completion?(result?.savedPaymentMethods, nil)
            }
        })
    }
}
