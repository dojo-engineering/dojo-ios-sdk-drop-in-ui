//
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 06/10/2022.
//

import UIKit

extension DojoInputFieldViewModel {
    
    func validateField(_ text: String?) -> DojoInputFieldState {
        guard let text = text, !text.isEmpty else { return .error}
        switch type {
        case .email:
            if !isEmailValid(text) {
                return .error
            }
        case .cardNumber:
            let cardNumber = text.replacingOccurrences(of: " ", with: "")
            if !isCardNumberValid(cardNumber) || !isCardSchemaSupported(getCardScheme(cardNumber)) {
                return .error
            }
        case .expiry:
            if !isExpiryValid(text) {
                return .error
            }
        case .cvv:
            if !isCVCValid(text) {
                return .error
            }
        default:
            return .normal
        }
        
        return .normal
    }
    
    func isEmailValid(_ email: String) -> Bool {
        FieldUtils.isEmailValid(email)
    }
    
    func isCardNumberValid(_ cardNumber: String) -> Bool {
        CardUtils.luhnCheck(cardNumber)
    }
    
    func isCardSchemaSupported(_ cardSchema: CardSchemes?) -> Bool {
        guard let cardSchema = cardSchema else { return false }
        return supportedCardSchemas.contains(cardSchema)
    }
    
    func isExpiryValid(_ expiry: String) -> Bool {
        CardUtils.isExpiryValid(expiry)
    }
    
    func isCVCValid(_ cvv: String) -> Bool {
        CardUtils.isCVCValid(cvv)
    }
    
    func getCardScheme(_ text: String?) -> CardSchemes? {
        CardUtils.getCardScheme(text)
    }
}
