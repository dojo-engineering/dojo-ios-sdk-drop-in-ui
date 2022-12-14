//
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 06/10/2022.
//

import UIKit

protocol DojoInputFieldViewModelProtocol {
    init(type: DojoInputFieldType)
    var fieldKeyboardType: UIKeyboardType {get}
    var fieldPlaceholder: String {get}
    var fieldName: String {get}
    var fieldError: String {get}
    var fieldErrorEmpty: String {get}
    var fieldMaxLimit: Int {get}
    var type: DojoInputFieldType {get}
    
    func validateField(_ text: String?) -> DojoInputFieldState
    func getCardScheme(_ text: String?) -> CardSchemes?
}

class DojoInputFieldViewModel: DojoInputFieldViewModelProtocol {
    
    let type: DojoInputFieldType
    
    required init(type: DojoInputFieldType) {
        self.type = type
    }
    
    var fieldKeyboardType: UIKeyboardType {
        get {
            switch type {
            case .email:
                return .emailAddress
            case .cardNumber, .expiry, .cvv:
                return .numberPad
            default:
                return .default
            }
        }
    }
    
    var fieldPlaceholder: String {
        get {
            switch type {
            case .cardNumber:
                return LocalizedText.CardDetailsCheckout.placeholderPan
            case .cvv:
                return LocalizedText.CardDetailsCheckout.placeholderCVV
            case .expiry:
                return LocalizedText.CardDetailsCheckout.placeholderExpiry
            default:
                return ""
            }
        }
    }
    
    var fieldName: String {
        get {
            switch type {
            case .email:
                return LocalizedText.CardDetailsCheckout.fieldEmail
            case .cardHolderName:
                return LocalizedText.CardDetailsCheckout.fieldCardName
            case .cardNumber:
                return LocalizedText.CardDetailsCheckout.fieldPan
            case .billingCountry:
                return LocalizedText.CardDetailsCheckout.fieldBillingCountry
            case .billingPostcode:
                return LocalizedText.CardDetailsCheckout.fieldBillingPostcode
            case .expiry:
                return LocalizedText.CardDetailsCheckout.fieldExpiryDate
            case .cvv:
                return LocalizedText.CardDetailsCheckout.fieldCVV
            }
        }
    }
    
    var fieldError: String {
        get {
            switch type {
            case .email:
                return LocalizedText.CardDetailsCheckout.errorInvalidEmail
            case .cardNumber:
                return LocalizedText.CardDetailsCheckout.errorInvalidPan
            case .expiry:
                return LocalizedText.CardDetailsCheckout.errorInvalidExpiry
            case .cvv:
                return LocalizedText.CardDetailsCheckout.errorInvalidCVV
            default:
                return ""
            }
        }
    }
    
    var fieldErrorEmpty: String {
        get {
            switch type {
            case .email:
                return LocalizedText.CardDetailsCheckout.errorEmptyEmail
            case .cardHolderName:
                return LocalizedText.CardDetailsCheckout.errorEmptyCardHolder
            case .cardNumber:
                return LocalizedText.CardDetailsCheckout.errorEmptyPan
            case .billingPostcode:
                return LocalizedText.CardDetailsCheckout.errorEmptyBillingPostcode
            case .expiry:
                return LocalizedText.CardDetailsCheckout.errorEmptyExpiry
            case .cvv:
                return LocalizedText.CardDetailsCheckout.errorEmptyCvv
            default:
                return ""
            }
        }
    }
    
    var fieldMaxLimit: Int {
        get {
            switch type {
            case .cardNumber:
                return 16 //TOOD: not relevant
            case .cvv:
                return 4 //TOOD: not relevant
            case .billingPostcode:
                return 50
            default:
                return 120
            }
        }
    }
    
    func getCardScheme(_ text: String?) -> CardSchemes? {
        let amexRegEx = "^3[47].*$"
        let visaRegEx = "^4.*$"
        let masterRegEx = "^5[12345].*$"
        let maestroRegEx = "^(5018|5020|5038|6304|6759|6761|6763).*$"
        
        if evaluateRegex(regex: amexRegEx, textToVerify: text) {
            return .amex
        }
        
        if evaluateRegex(regex: visaRegEx, textToVerify: text) {
            return .visa
        }
        
        if evaluateRegex(regex: masterRegEx, textToVerify: text) {
            return .mastercard
        }
        
        if evaluateRegex(regex: maestroRegEx, textToVerify: text) {
            return .maestro
        }
        
        return nil
    }
    
    private func evaluateRegex(regex: String, textToVerify: String?) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: textToVerify)
    }
}
