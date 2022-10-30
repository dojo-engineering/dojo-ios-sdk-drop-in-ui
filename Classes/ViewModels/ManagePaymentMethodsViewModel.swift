//
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

class ManagePaymentMethodsViewModel: BaseViewModel {
    var items: [PaymentMethodItem] = []
    
    let applePayConfig: DojoUIApplePayConfig?
    
    init(config: ConfigurationManager, selectedPaymentMethod: PaymentMethodItem? = nil) {
        self.applePayConfig = config.applePayConfig
        super.init(paymentIntent: config.paymentIntent)
        items.append(PaymentMethodItem(id: "", title: "ApplePay", type: .applePay))
        if let selectedPaymentMethod = selectedPaymentMethod {
            items.forEach({
                if $0.id == selectedPaymentMethod.id {
                    $0.selected = true
                }
            })
        }
    }
    
    func removeItemAtIndex(_ index: Int) {
        if items.count > index,
           index > -1 {
            items.remove(at: index)
        }
    }
    
    //TODO: duplication of the method
    func isApplePayAvailable() -> Bool {
        // ApplePay config was not passed
        guard let appleConfig = getApplePayConfig() else { return false }
        // ApplePay is not configured for the merchant
        guard paymentIntent.merchantConfig?.supportedPaymentMethods?.wallets?.contains(.applePay) == true else { return false }
        return DojoSDK.isApplePayAvailable(config: appleConfig)
    }
    
    func getApplePayConfig() -> DojoApplePayConfig? {
        guard let merchantIdentifier = applePayConfig?.merchantIdentifier else { return nil }
        return DojoApplePayConfig(merchantIdentifier: merchantIdentifier,
                                  supportedCards: getSupportedApplePayCards())
    }
    
    func getSupportedApplePayCards() -> [String] {
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
}

enum PaymentMethodType {
    case applePay
    case mastercard
    case maestro
    case visa
    case amex
}

class PaymentMethodItem {
    let id: String
    let title: String
    let type: PaymentMethodType
    var selected: Bool = false
    
    init(id: String, title: String, type: PaymentMethodType, selected: Bool = false) {
        self.id = id
        self.title = title
        self.type = type
        self.selected = selected
    }
}
