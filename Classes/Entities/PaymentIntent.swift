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
    let amount: DojoPaymentIntentAmount
    var config: PaymentIntentConfig? = nil
    var merchantConfig: MerchantConfig? = nil
    var customer: CustomerConfig? = nil
    var status: String?
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
    let customerEmail: ConfigurationRequired?
    let billingAddress: ConfigurationRequired?
}

struct CustomerConfig: Codable {
    let id: String?
}

struct MerchantConfig: Codable {
    let supportedPaymentMethods: SupportedPaymentMethods?
}

struct SupportedPaymentMethods: Codable {
    let cardSchemes: [CardSchemes]?
    let wallets: [Wallets]?
}

struct ConfigurationRequired: Codable {
    let collectionRequired: Bool
}

