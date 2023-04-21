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
    var paymentIntent: PaymentIntent?
    var savedPaymentMethods: [SavedPaymentMethod]?
    var themeSettings: ThemeSettings
    var applePayConfig: DojoUIApplePayConfig?
    var debugConfig: DojoSDKDebugConfig?
    var isDemo: Bool = false
    
    var demoDelay: Double {
        isDemo ? 0 : 0
    }
}
