//
//  DataLoadingViewModel.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

// Not a part of BaseViewModel because it doesn't have a full paymentIntent object.
class DataLoadingViewModel {
    let paymentIntentId: String
    let customerSecret: String?
    let demoDelay: Double
    let isDemo: Bool
    let debugConfig: DojoSDKDebugConfig?
    let isSetupIntent: Bool

    init(paymentIntentId: String,
         customerSecret: String? = nil,
         debugConfig: DojoSDKDebugConfig?,
         demoDelay: Double,
         isDemo: Bool,
         isSetupIntent: Bool = false) {
        self.paymentIntentId = paymentIntentId
        self.debugConfig = debugConfig
        self.customerSecret = customerSecret
        self.demoDelay = demoDelay
        self.isDemo = isDemo
        self.isSetupIntent = isSetupIntent
    }

    func fetchPaymentIntent(refreshBeforeFetch: Bool = false,
                            completion: ((PaymentIntent?, Error?) -> Void)?) {
        let networking = NetworkingSDKFactory.getNetworkingSDK(isMock: isDemo)
        if isSetupIntent {
            networking.fetchSetupIntent(intentId: paymentIntentId, debugConfig: debugConfig) { stringData, error in
                self.parsePaymentIntent(stringData: stringData, error: error, completion: completion)
            }
        } else if refreshBeforeFetch {
            networking.refreshPaymentIntent(intentId: paymentIntentId, debugConfig: debugConfig) { stringData, error in
                self.parsePaymentIntent(stringData: stringData, error: error, completion: completion)
            }
        } else {
            networking.fetchPaymentIntent(intentId: paymentIntentId, debugConfig: debugConfig) { stringData, error in
                self.parsePaymentIntent(stringData: stringData, error: error, completion: completion)
            }
        }
    }

    private func parsePaymentIntent(stringData: String?,
                                    error: Error?,
                                    completion: ((PaymentIntent?, Error?) -> Void)?) {
        CommonUtils.parseResponseToCompletion(stringData: stringData,
                                              fetchError: error,
                                              objectType: PaymentIntent.self) { paymentIntent, parseError in
            var paymentIntent = paymentIntent
            paymentIntent?.isSetupIntent = self.isSetupIntent
            completion?(paymentIntent, parseError)
        }
    }

    func fetchCustomersPaymentMethods(customerId: String,
                                      completion: (([SavedPaymentMethod]?, Error?) -> Void)?) {
        guard let customerSecret else {
            completion?(nil, nil)
            return
        }
        NetworkingSDKFactory.getNetworkingSDK(isMock: isDemo)
            .fetchCustomerPaymentMethods(customerId: customerId,
                                         customerSecret: customerSecret,
                                         debugConfig: debugConfig) { stringData, error in
                CommonUtils.parseResponseToCompletion(stringData: stringData,
                                                      fetchError: error,
                                                      objectType: SavedPaymentRoot.self) { result, _ in
                    completion?(result?.savedPaymentMethods, nil)
                }
            }
    }
}
