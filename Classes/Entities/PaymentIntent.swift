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
}

struct PaymentIntentConfig: Codable {
    let customerEmail: ConfigurationRequired?
    let billingAddress: ConfigurationRequired?
}

struct ConfigurationRequired: Codable {
    let collectionRequired: Bool
}
