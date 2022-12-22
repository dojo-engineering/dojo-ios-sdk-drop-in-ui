//
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 06/10/2022.
//

import UIKit

enum DojoInputFieldType {
    case email
    case cardHolderName
    case cardNumber
    case billingCountry
    case billingPostcode
    case expiry
    case cvv
}

enum DojoInputFieldState {
    case normal
    case activeInput
    case error
}


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
    
    func getCountriesItems() -> Array<CountryDropdownItem>?
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
    
    func getCountriesItems() -> Array<CountryDropdownItem>? {
        // fetch csv with countries
        let bundle = Bundle(for: Swift.type(of: self))
        guard let countriesCSV = bundle.url(forResource: "countries", withExtension: "csv") else {
            return nil
        }
        // convert data to string
        guard let content = try? String(contentsOf: countriesCSV) else {
            return nil
        }
        // parse string to objects
        var parsedCSV: [CountryDropdownItem] = content.components(
            separatedBy: "\n"
        ).compactMap {
            if $0.components(separatedBy: ",").count >= 2 {
                return CountryDropdownItem(title: $0.components(separatedBy: ",")[0],
                                           isoCode: $0.components(separatedBy: ",")[1])
            } else {
                return nil
            }
        }
        // remove first line (name, isoCode, etc)
        if parsedCSV.count > 0 { parsedCSV.removeFirst() }
        return parsedCSV
    }
}
