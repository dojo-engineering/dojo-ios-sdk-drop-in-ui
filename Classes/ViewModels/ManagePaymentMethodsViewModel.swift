//
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

class ManagePaymentMethodsViewModel: BaseViewModel {
    var items: [PaymentMethodItem] = [PaymentMethodItem(id: "", title: "Apple Pay", type: .applePay, selected: true),
                                      PaymentMethodItem(id: "123", title: "****0043", type: .mastercard),
                                      PaymentMethodItem(id: "1234", title: "****0043", type: .maestro),
                                      PaymentMethodItem(id: "12345", title: "****0043", type: .visa),
                                      PaymentMethodItem(id: "123456", title: "****0043", type: .amex)]
    
    init(config: ConfigurationManager) {
        super.init(paymentIntent: config.paymentIntent)
    }
    
    func removeItemAtIndex(_ index: Int) {
        if items.count > index,
           index > -1 {
            items.remove(at: index)
        }
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
