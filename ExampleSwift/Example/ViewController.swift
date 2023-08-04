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

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldPaymentIntent: UITextField!
    let dojoUI = DojoSDKDropInUI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldPaymentIntent.delegate = self
    }
    
    @IBAction func onStartPaymentFlowPress(_ sender: Any) {
        var paymentIntentId = ""
        if let paymentIntent = textFieldPaymentIntent.text,
           !paymentIntent.isEmpty {
            paymentIntentId = paymentIntent
        }
        
        let customerSecret = ""
        let applePayConfig = DojoUIApplePayConfig(merchantIdentifier: "merchant.uk.co.paymentsense.sdk.demo.app")
        dojoUI.startSetupFlow(setupIntentId: paymentIntentId,
                              controller: self) { result in
            print("SDK result code: \(result)")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

