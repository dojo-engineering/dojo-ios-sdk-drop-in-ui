//
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

protocol NetworkingSDKProtocol {
    func fetchPaymentIntent(intentId: String, completion: ((String?, Error?) -> Void)?)
    func fetchCustomerPaymentMethods(customerId: String, customerSecret: String, completion: ((String?, Error?) -> Void)?)
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
    func fetchCustomerPaymentMethods(customerId: String, customerSecret: String, completion: ((String?, Error?) -> Void)?) {
//        completion?(TestsUtils.savedMethodsString, nil)
    }
    
    func fetchPaymentIntent(intentId: String, completion: ((String?, Error?) -> Void)?) {
//        completion?(TestsUtils.paymentIntentWithItemLinesWithoutApplePay, nil)
    }
}

extension DojoSDK: NetworkingSDKProtocol {
    func fetchPaymentIntent(intentId: String, completion: ((String?, Error?) -> Void)?) {
        DojoSDK.fetchPaymentIntent(intentId: intentId, completion: completion)
    }
    
    func fetchCustomerPaymentMethods(customerId: String, customerSecret: String, completion: ((String?, Error?) -> Void)?) {
        DojoSDK.fetchCustomerPaymentMethods(customerId: customerId, customerSecret: customerSecret, completion: completion)
    }
}
