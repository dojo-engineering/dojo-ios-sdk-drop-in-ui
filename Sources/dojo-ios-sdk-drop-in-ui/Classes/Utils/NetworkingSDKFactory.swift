//
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

protocol NetworkingSDKProtocol {
    func fetchPaymentIntent(intentId: String, debugConfig: DojoSDKDebugConfig?, completion: ((String?, Error?) -> Void)?)
    func fetchCustomerPaymentMethods(customerId: String, customerSecret: String, debugConfig: DojoSDKDebugConfig?, completion: ((String?, Error?) -> Void)?)
    func refreshPaymetnIntent(intentId: String, debugConfig: DojoSDKDebugConfig?, completion: ((String?, Error?) -> Void)?)
}

class NetworkingSDKFactory {
    static func getNetworkingSDK(isMock: Bool = false) -> NetworkingSDKProtocol {
        if isMock {
            return DojoSDKMock()
        } else {
            return DojoSDK()
        }
    }
}

class DojoSDKMock: NetworkingSDKProtocol {
    func refreshPaymetnIntent(intentId: String, debugConfig: dojo_ios_sdk.DojoSDKDebugConfig?, completion: ((String?, Error?) -> Void)?) {
        
    }
    
    func fetchPaymentIntent(intentId: String, debugConfig: DojoSDKDebugConfig?, completion: ((String?, Error?) -> Void)?) {
//        completion?(TestsUtils.savedMethodsString, nil)
    }
    
    func fetchCustomerPaymentMethods(customerId: String, customerSecret: String, debugConfig: DojoSDKDebugConfig?, completion: ((String?, Error?) -> Void)?) {
//        completion?(TestsUtils.paymentIntentWithItemLinesWithoutApplePay, nil)
    }
}

extension DojoSDK: NetworkingSDKProtocol {
    func refreshPaymetnIntent(intentId: String, debugConfig: dojo_ios_sdk.DojoSDKDebugConfig?, completion: ((String?, Error?) -> Void)?) {
        DojoSDK.refreshPaymentIntent(intentId: intentId, debugConfig: debugConfig, completion: completion)
    }
    
    func fetchPaymentIntent(intentId: String, debugConfig: DojoSDKDebugConfig?, completion: ((String?, Error?) -> Void)?) {
        DojoSDK.fetchPaymentIntent(intentId: intentId, debugConfig: debugConfig, completion: completion)
    }
    
    func fetchCustomerPaymentMethods(customerId: String, customerSecret: String, debugConfig: DojoSDKDebugConfig?, completion: ((String?, Error?) -> Void)?) {
        DojoSDK.fetchCustomerPaymentMethods(customerId: customerId, customerSecret: customerSecret, debugConfig: debugConfig, completion: completion)
    }
}
