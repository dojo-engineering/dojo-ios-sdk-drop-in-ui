//
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

struct CommonUtils {
    static func evaluateRegex(regex: String, textToVerify: String?) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: textToVerify)
    }
    
    static func parseResponse<T: Decodable>(_ stringData: String, objectType: T.Type) throws -> T? {
        guard let data = stringData.data(using: .utf8) else {
            // String failed to be converted to data. Very unlikely but just in case.
            return nil
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    static func parseResponseToCompletion<T: Decodable>(stringData: String?,
                                                        fetchError: Error?,
                                                        objectType: T.Type,
                                                        completion: ((T?, Error?) -> Void)?) {
        // check for an error
        if let error = fetchError {
            completion?(nil, error)
            return
        }
        // verify that we have data from backed
        guard let stringData = stringData else {
            completion?(nil, NSError(domain: #function, code: 7770, userInfo: nil))
            return
        }
        // try to parse backend raw data into object
        do {
            completion?(try CommonUtils.parseResponse(stringData,
                                                      objectType: T.self), nil)
        } catch {
            completion?(nil, error)
        }
    }
    
    static func getApplePayConfig(applePayConfig: DojoUIApplePayConfig?, paymentIntent: PaymentIntent) -> DojoApplePayConfig? {
        guard let merchantIdentifier = applePayConfig?.merchantIdentifier else { return nil }
        return DojoApplePayConfig(merchantIdentifier: merchantIdentifier,
                                  supportedCards: getSupportedApplePayCards(paymentIntent: paymentIntent))
    }
    
    static func getSupportedApplePayCards(paymentIntent: PaymentIntent) -> [String] {
        paymentIntent.merchantConfig?.supportedPaymentMethods?.cardSchemes?.compactMap({
            switch $0 {
            case .visa:
                return ApplePaySupportedCards.visa.rawValue
            case .mastercard:
                return ApplePaySupportedCards.mastercard.rawValue
            case .maestro:
                return ApplePaySupportedCards.maestro.rawValue
            case .amex:
                return ApplePaySupportedCards.amex.rawValue
            case .other:
                return nil
            }
        }) ?? []
    }
    
    static func isApplePayAvailable(appleConfig: DojoApplePayConfig?, paymentIntent: PaymentIntent) -> Bool {
        // ApplePay config was not passed
        guard let appleConfig = appleConfig else { return false }
        // ApplePay is not configured for the merchant
        guard paymentIntent.merchantConfig?.supportedPaymentMethods?.wallets?.contains(.applePay) == true else { return false }
        return DojoSDK.isApplePayAvailable(config: appleConfig)
    }
}
