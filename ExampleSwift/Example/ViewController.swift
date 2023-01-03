//
//  ViewController.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Den on 08/01/2022.
//  Copyright (c) 2022 Den. All rights reserved.
//

import UIKit
import dojo_ios_sdk_drop_in_ui

class ViewController: UIViewController {
    
    let dojoUI = DojoSDKDropInUI()
    
    @IBAction func onStartPaymentFlowPress(_ sender: Any) {
//        pi_sandbox_twcfjD36GEmQ2JN1rLSO7Q 3 lines
        //        pi_sandbox_Xylzpg-4A0mNnN0xv9ltbg 0 lines
        let paymentIntentId = "pi_sandbox_Xylzpg-4A0mNnN0xv9ltbg"
        let customerSecret = "test"
        let applePayConfig = DojoUIApplePayConfig(merchantIdentifier: "merchant.uk.co.paymentsense.sdk.demo.app")
        let theme = DojoThemeSettings.getDarkTheme()
        dojoUI.startPaymentFlow(paymentIntentId: paymentIntentId,
                                controller: self,
                                customerSecret: customerSecret,
                                applePayConfig: applePayConfig,
                                themeSettings: theme) { result in
            print("SDK result code: \(result)")
        }
    }
}

