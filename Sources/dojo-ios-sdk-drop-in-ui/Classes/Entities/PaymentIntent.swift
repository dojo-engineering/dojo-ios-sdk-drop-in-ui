//
//  PaymentIntent.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 05/09/2022.
//

import Foundation
import dojo_ios_sdk

struct PaymentIntent: Codable {
    let id: String
    let clientSessionSecret: String
    let totalAmount: DojoPaymentIntentAmount?
    var config: PaymentIntentConfig? = nil
    var merchantConfig: MerchantConfig? = nil
    var customer: CustomerConfig? = nil
    var paymentSource: String?
    var itemLines: [ItemLine]?
    var status: String?
    var reference: String?
    var merchantInitiatedTransactionType: String? = nil
    var billingAddress: BillingAddress?
    
    var isCaptured: Bool {
        status != "Created"
    }
    
    var isSandbox: Bool {
        id.contains("_sandbox_")
    }
    
    var isVirtualTerminalPayment: Bool {
        paymentSource == "virtual-terminal"
    }
    
    var isSetupIntent: Bool {
        merchantInitiatedTransactionType != nil && paymentSource != nil
    }
}

enum CardSchemes: String, Codable {
    case visa = "VISA"
    case mastercard = "MASTERCARD"
    case maestro = "MAESTRO"
    case amex = "AMEX"
    case other
    
    public init(rawValue: String) {
        switch rawValue.lowercased() {
        case CardSchemes.visa.rawValue.lowercased():
            self = .visa
        case CardSchemes.mastercard.rawValue.lowercased():
            self = .mastercard
        case CardSchemes.maestro.rawValue.lowercased():
            self = .maestro
        case CardSchemes.amex.rawValue.lowercased():
            self = .amex
        default:
            self = .other
        }
    }
}

enum Wallets: String, Codable {
    case applePay = "APPLE_PAY"
    case other
    
    public init(rawValue: String) {
        switch rawValue.lowercased() {
        case Wallets.applePay.rawValue.lowercased():
            self = .applePay
        default:
            self = .other
        }
    }
}

struct PaymentIntentConfig: Codable {
    var customerEmail: ConfigurationRequired?
    var billingAddress: ConfigurationRequired?
    var tradingName: String?
}

struct BillingAddress: Codable {
    let postcode: String?
    let countryCode: String?
}

struct CustomerConfig: Codable {
    let id: String?
    let emailAddress: String?
}

struct ItemLine: Codable {
    let caption: String?
    let amountTotal: DojoPaymentIntentAmount
}

struct MerchantConfig: Codable {
    var supportedPaymentMethods: SupportedPaymentMethods?
}

struct SupportedPaymentMethods: Codable {
    var cardSchemes: [CardSchemes]?
    var wallets: [Wallets]?
}

struct ConfigurationRequired: Codable {
    var collectionRequired: Bool
}

