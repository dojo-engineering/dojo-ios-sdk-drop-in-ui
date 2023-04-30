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
    let isDemo: Bool
    let debugConfig: DojoSDKDebugConfig?
    
    init(paymentIntentId: String,
         customerSecret: String? = nil,
         debugConfig: DojoSDKDebugConfig?,
         demoDelay: Double,
         isDemo: Bool) {
        self.paymentIntentId = paymentIntentId
        self.debugConfig = debugConfig
        self.customerSecret = customerSecret
        self.demoDelay = demoDelay
        self.isDemo = isDemo
    }
    
    func fetchPaymentIntent(completion: ((PaymentIntent?, Error?) -> Void)?) {
        NetworkingSDKFactory.getNetworkingSDK(isMock: self.isDemo)
            .fetchPaymentIntent(intentId: paymentIntentId, debugConfig: debugConfig) { stringData, fetchError in
            CommonUtils.parseResponseToCompletion(stringData: stringData,
                                                  fetchError: fetchError,
                                                  objectType: PaymentIntent.self,
                                                  completion: completion)
        }
    }
    
    func fetchCustomersPaymentMethods(customerId: String, completion: (([SavedPaymentMethod]?, Error?) -> Void)?) {
        guard let customerSecret = customerSecret else {
            completion?(nil, nil)
            return
        }
        NetworkingSDKFactory.getNetworkingSDK(isMock: self.isDemo)
            .fetchCustomerPaymentMethods(customerId: customerId, customerSecret: customerSecret, debugConfig: debugConfig, completion: { stringData, error in
            CommonUtils.parseResponseToCompletion(stringData: stringData,
                                                  fetchError: error,
                                                  objectType: SavedPaymentRoot.self) { result, error in
                completion?(result?.savedPaymentMethods, nil)
            }
        })
    }
}
