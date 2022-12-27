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
    
    init?(config: ConfigurationManager,
         selectedPaymentMethod: PaymentMethodItem? = nil) {
        self.applePayConfig = config.applePayConfig
        self.customerSecret = config.customerSecret
        if let paymentIntent = config.paymentIntent {
            super.init(paymentIntent: paymentIntent)
        } else {
            // payment intent is required for this screen
            return nil
        }
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
    
    func removeItemAtIndex(_ index: Int) -> PaymentMethodItem? {
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
            return item
        }
        return nil
    }
    
    func isApplePayAvailable() -> Bool {
        CommonUtils.isApplePayAvailable(appleConfig: getApplePayConfig(), paymentIntent: paymentIntent)
    }
    
    func getApplePayConfig() -> DojoApplePayConfig? {
        CommonUtils.getApplePayConfig(applePayConfig: applePayConfig, paymentIntent: paymentIntent)
    }
    
    func getSupportedApplePayCards() -> [String] {
        CommonUtils.getSupportedApplePayCards(paymentIntent: paymentIntent)
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

class PaymentMethodItem: Equatable {
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
    
    static func == (lhs: PaymentMethodItem, rhs: PaymentMethodItem) -> Bool {
        lhs.id == rhs.id
    }
}
