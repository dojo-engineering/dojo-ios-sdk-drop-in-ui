//
//  CardDetailsCheckoutView.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

struct ConfigurationManager {
    var paymentIntentId: String
    var customerSecret: String?
    var paymentIntent: PaymentIntent
    var savedPaymentMethods: [SavedPaymentMethod]?
    var themeSettings: ThemeSettings
    var applePayConfig: DojoUIApplePayConfig?
    var demoDelay: Double = 0 // add delay to requests for UI demo purposes
}
