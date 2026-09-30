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
    case expiry
    case cvv
    case shippingName
    case shippingAddressLine1
    case shippingAddressLine2
    case shippingCity
    case shippingPostcode
    case shippingCountry
    case shippingDeliveryNotes
    case billingAddressLine1
    case billingAddressLine2
    case billingCity
    case billingPostcode
    case billingCountry
}

enum DojoInputFieldState {
    case normal
    case activeInput
    case error
}

protocol DojoInputFieldViewModelProtocol {
    init(type: DojoInputFieldType, withSubtitle: Bool)
    init(type: DojoInputFieldType, supportedCardSchemas: [CardSchemes])
    var fieldKeyboardType: UIKeyboardType { get }
    var fieldPlaceholder: String { get }
    var fieldName: String { get }
    var fieldError: String { get }
    var fieldErrorEmpty: String { get }
    var fieldMaxLimit: Int { get }
    var subtitle: String? { get }
    var supportedCardSchemas: [CardSchemes] { get set }
    var type: DojoInputFieldType { get }
    var isRequired: Bool { get }

    func validateField(_ text: String?) -> DojoInputFieldState
    func getCardScheme(_ text: String?) -> CardSchemes?
    func getCountriesItems() -> [CountryDropdownItem]?
}

class DojoInputFieldViewModel: DojoInputFieldViewModelProtocol {
    var supportedCardSchemas: [CardSchemes]
    let type: DojoInputFieldType
    private let showSubtitle: Bool

    required init(type: DojoInputFieldType, withSubtitle: Bool) {
        self.type = type
        self.showSubtitle = withSubtitle
        self.supportedCardSchemas = []
    }

    required init(type: DojoInputFieldType, supportedCardSchemas: [CardSchemes]) {
        self.type = type
        self.showSubtitle = false
        self.supportedCardSchemas = supportedCardSchemas
    }

    var fieldKeyboardType: UIKeyboardType {
        switch type {
        case .email:
            return .emailAddress
        case .cardNumber, .expiry, .cvv:
            return .numberPad
        default:
            return .default
        }
    }

    var fieldPlaceholder: String {
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

    var fieldName: String {
        switch type {
        case .email:
            return LocalizedText.CardDetailsCheckout.fieldEmail
        case .cardHolderName:
            return LocalizedText.CardDetailsCheckout.fieldCardName
        case .cardNumber:
            return LocalizedText.CardDetailsCheckout.fieldPan
        case .expiry:
            return LocalizedText.CardDetailsCheckout.fieldExpiryDate
        case .cvv:
            return LocalizedText.CardDetailsCheckout.fieldCVV
        case .billingCountry:
            return LocalizedText.CardDetailsCheckout.fieldBillingCountry
        case .billingPostcode:
            return LocalizedText.CardDetailsCheckout.fieldBillingPostcode
        case .shippingName:
            return LocalizedText.CardDetailsCheckout.fieldShippingName
        case .shippingAddressLine1, .billingAddressLine1:
            return LocalizedText.CardDetailsCheckout.fieldShippingLine1
        case .shippingAddressLine2, .billingAddressLine2:
            return LocalizedText.CardDetailsCheckout.fieldShippingLine2
        case .shippingCity, .billingCity:
            return LocalizedText.CardDetailsCheckout.fieldShippingCity
        case .shippingPostcode:
            return LocalizedText.CardDetailsCheckout.fieldShippingPostcode
        case .shippingCountry:
            return LocalizedText.CardDetailsCheckout.fieldShippingCountry
        case .shippingDeliveryNotes:
            return LocalizedText.CardDetailsCheckout.fieldShippingDeliveryNotes
        }
    }

    var subtitle: String? {
        guard showSubtitle, type == .email else { return nil }
        return LocalizedText.CardDetailsCheckout.fieldEmailSubtitleVT
    }

    var isRequired: Bool {
        switch type {
        case .shippingAddressLine2, .billingAddressLine2, .shippingDeliveryNotes:
            return false
        default:
            return true
        }
    }

    var fieldError: String {
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

    var fieldErrorEmpty: String {
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

    var fieldMaxLimit: Int {
        switch type {
        case .cardNumber:
            return 16
        case .cvv:
            return 4
        case .billingPostcode:
            return 50
        case .shippingDeliveryNotes:
            return 120
        default:
            return 120
        }
    }

    func getCountriesItems() -> [CountryDropdownItem]? {
        guard let bundle = Bundle.libResourceBundle,
              let countriesCSV = bundle.url(forResource: "countries", withExtension: "csv"),
              let content = try? String(contentsOf: countriesCSV) else {
            return nil
        }
        var items = content.components(separatedBy: "\n").compactMap { row -> CountryDropdownItem? in
            let columns = row.components(separatedBy: ",")
            guard columns.count >= 2 else { return nil }
            return CountryDropdownItem(title: columns[0], isoCode: columns[1])
        }
        if !items.isEmpty {
            items.removeFirst()
        }
        return items
    }
}
