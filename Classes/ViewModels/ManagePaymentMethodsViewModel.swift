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
    let customerSecret: String?
    
    init(config: ConfigurationManager,
         selectedPaymentMethod: PaymentMethodItem? = nil) {
        self.applePayConfig = config.applePayConfig
        self.customerSecret = config.customerSecret
        super.init(paymentIntent: config.paymentIntent)
        if isApplePayAvailable() {
            items.append(PaymentMethodItem(id: "", title: "ApplePay", type: .applePay))
        }
        config.savedPaymentMethods?.forEach({
            if let paymentMethodType = PaymentMethodType($0.cardDetails.scheme) {
                items.append(PaymentMethodItem(id: $0.id,
                                               title: String($0.cardDetails.pan.suffix(8)),
                                               type: paymentMethodType))
            }
        })
        
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
            let item = items[index]
            if let customerId = paymentIntent.customer?.id,
               let customerSecret = customerSecret {
                DojoSDK.deleteCustomerPaymentMethod(customerId: customerId,
                                                    paymentMethodId: item.id,
                                                    customerSecret: customerSecret,
                                                    completion: nil)
            }
               
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
    
    init?(_ cardShema: CardSchemes) {
        switch cardShema {
        case .amex:
            self = .amex
        case .visa:
            self = .visa
        case .mastercard:
            self = .mastercard
        case .maestro:
            self = .maestro
        case .other:
            return nil
        }
    }
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
