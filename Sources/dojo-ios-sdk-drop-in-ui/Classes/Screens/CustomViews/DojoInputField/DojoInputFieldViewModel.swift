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
    
    case shippingName
    case shippingAddressLine1
    case shippingAddressLine2
    case shippingCity
    case shippingPostcode
    case shippingCountry
    case shippingDeliveryNotes
}

enum DojoInputFieldState {
    case normal
    case activeInput
    case error
}


protocol DojoInputFieldViewModelProtocol {
    init(type: DojoInputFieldType, withSubtitle: Bool)
    var fieldKeyboardType: UIKeyboardType {get}
    var fieldPlaceholder: String {get}
    var fieldName: String {get}
    var fieldError: String {get}
    var fieldErrorEmpty: String {get}
    var fieldMaxLimit: Int {get}
    var subtitle: String? {get}
    var type: DojoInputFieldType {get}
    var isRequired: Bool {get}
    
    func validateField(_ text: String?) -> DojoInputFieldState
    func getCardScheme(_ text: String?) -> CardSchemes?
    
    func getCountriesItems() -> Array<CountryDropdownItem>?
}

class DojoInputFieldViewModel: DojoInputFieldViewModelProtocol {
    
    let type: DojoInputFieldType
    let showSubtitle: Bool
    
    required init(type: DojoInputFieldType, withSubtitle: Bool = false) {
        self.type = type
        self.showSubtitle = withSubtitle
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
            case .shippingName:
                return LocalizedText.CardDetailsCheckout.fieldShippingName
            case .shippingAddressLine1:
                return LocalizedText.CardDetailsCheckout.fieldShippingLine1
            case .shippingAddressLine2:
                return LocalizedText.CardDetailsCheckout.fieldShippingLine2
            case .shippingCity:
                return LocalizedText.CardDetailsCheckout.fieldShippingCity
            case .shippingPostcode:
                return LocalizedText.CardDetailsCheckout.fieldShippingPostcode
            case .shippingCountry:
                return LocalizedText.CardDetailsCheckout.fieldShippingCountry
            case .shippingDeliveryNotes:
                return LocalizedText.CardDetailsCheckout.fieldShippingDeliveryNotes
            }
        }
    }
    
    var subtitle: String? {
        get {
            guard showSubtitle else {
                return nil
            }
            switch type {
            case .email:
                return LocalizedText.CardDetailsCheckout.fieldEmailSubtitleVT
            default:
                return nil
            }
        }
    }
    
    var isRequired: Bool {
        get {
            switch type {
            case .shippingAddressLine2, .shippingDeliveryNotes:
                return false
            default:
                return true
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
            case .shippingName:
                return LocalizedText.CardDetailsCheckout.errorEmptyShippingName
            case .shippingAddressLine1:
                return LocalizedText.CardDetailsCheckout.errorEmptyShippingLine1
            case .shippingCity:
                return LocalizedText.CardDetailsCheckout.errorEmptyShippingCity
            case .shippingPostcode:
                return LocalizedText.CardDetailsCheckout.errorEmptyShippingPostal
            default:
                return "Please fill in this field"
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
            case .shippingDeliveryNotes:
                return 120
            default:
                return 120
            }
        }
    }
    
    func getCountriesItems() -> Array<CountryDropdownItem>? {
        // fetch csv with countries
        
        guard let bundle = Bundle.libResourceBundle,
              let countriesCSV = bundle.url(forResource: "countries", withExtension: "csv") else {
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
