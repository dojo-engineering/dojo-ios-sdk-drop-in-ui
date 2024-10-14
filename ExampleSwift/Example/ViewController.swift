//
//  ViewController.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Den on 08/01/2022.
//  Copyright (c) 2022 Den. All rights reserved.
//

import UIKit
import dojo_ios_sdk_drop_in_ui
import dojo_ios_sdk

class ViewController: UIViewController {
    
    let dojoUI = DojoSDKDropInUI()
    
    @IBAction func onStartPaymentFlowPress(_ sender: Any) {
        let paymentIntentId = "pi_sandbox_mDvzElFkoU2QH440cwoOEg"
        let customerSecret = ""
        let applePayConfig = DojoUIApplePayConfig(merchantIdentifier: "merchant.uk.co.paymentsense.sdk.demo.app")
        dojoUI.startPaymentFlow(paymentIntentId: paymentIntentId,
                                controller: self,
                                customerSecret: customerSecret,
                                applePayConfig: applePayConfig) { result in
            print("SDK result code: \(result)")
        }
    }
}

