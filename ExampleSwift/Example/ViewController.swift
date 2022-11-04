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
        let paymentIntentId = "pi_sandbox_jCwQc-JXZ0qus-Mr5lq9FA"
        let customerSecret = "cs_sandbox_E4ZriDsoEXca-a_WBje76ZBDXjB8aUPqUTekiZgF8AYOgPXJazp__YcMldRjLAafzc_uqVBfMOvQ_OCoh7PG022C8RQcJpeY0IL6okng3WeuGakXa2jVc9zEsikE0gSZ6Qvs1-G5jv-6mTRHVi0-NECBaLotcY5Udd7iKsiONPs"
        let applePayConfig = DojoUIApplePayConfig(merchantIdentifier: "merchant.uk.co.paymentsense.sdk.demo.app")
        dojoUI.startPaymentFlow(paymentIntentId: paymentIntentId,
                                controller: self,
                                customerSecret: customerSecret,
                                applePayConfig: applePayConfig) { result in
            print("SDK result code: \(result)")
        }
    }
}

