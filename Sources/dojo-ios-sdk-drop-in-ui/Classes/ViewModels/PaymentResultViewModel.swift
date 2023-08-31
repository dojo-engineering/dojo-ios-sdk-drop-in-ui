//
//  CardDetailsCheckoutView.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

class PaymentResultViewModel: BaseViewModel {
    
    let resultCode: Int
    let demoDelay: Double
    let debugConfig: DojoSDKDebugConfig?
    
    init?(config: ConfigurationManager,
         resultCode: Int) {
        self.resultCode = resultCode
        self.demoDelay = config.demoDelay
        self.debugConfig = config.debugConfig
        if let paymentIntent = config.paymentIntent {
            super.init(paymentIntent: paymentIntent)
        } else {
            // payment intent is required for this screen
            return nil
        }
    }
    
    func refreshToken(completion: ((String?,Error?)-> Void)?) {
        DojoSDK.refreshPaymentIntent(intentId: paymentIntent.id, debugConfig: debugConfig, completion: completion)
    }
    
    var navigationTitle: String {
        switch resultCode {
        case 0:
            return paymentIntent.isSetupIntent ? LocalizedText.PaymentResult.titleSetupIntentSuccess : LocalizedText.PaymentResult.titleSuccess
        default:
            return paymentIntent.isSetupIntent ? LocalizedText.PaymentResult.titleSetupIntentFail : LocalizedText.PaymentResult.mainTitleFail
        }
    }
    
    var mainText: String {
        switch resultCode {
        case 0:
            return paymentIntent.isSetupIntent ? LocalizedText.PaymentResult.mainTitleSetupIntentSucces : LocalizedText.PaymentResult.mainTitleSuccess
        default:
            return paymentIntent.isSetupIntent ? LocalizedText.PaymentResult.mainTitleSetupIntentFail : LocalizedText.PaymentResult.mainTitleFail
        }
    }
    
    var displaySubtitle: Bool {
        paymentIntent.isSetupIntent
    }
}
