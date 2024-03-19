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
    
    @IBAction func onStartSetupFlowPress(_ sender: Any) {
        var setupIntentId = ""
        if let setupIntent = textFieldPaymentIntent.text,
           !setupIntent.isEmpty {
            setupIntentId = setupIntent
        }
        guard !setupIntentId.isEmpty else {
            self.displayMessage(message: "SI is not supplied")
            return
        }
        
        dojoUI.startSetupFlow(setupIntentId: setupIntentId,
                              controller: self) { result in
            self.displayResult(resultCode: result)
        }
    }
    
    @IBAction func onStartPaymentFlowPress(_ sender: Any) {
        var paymentIntentId = ""
        if let paymentIntent = textFieldPaymentIntent.text,
           !paymentIntent.isEmpty {
            paymentIntentId = paymentIntent
        }
        guard !paymentIntentId.isEmpty else {
            self.displayMessage(message: "PI is not supplied")
            return
        }
        
        let applePayConfig = DojoUIApplePayConfig(merchantIdentifier: "merchant.uk.co.paymentsense.sdk.demo.app")
        dojoUI.startPaymentFlow(paymentIntentId: paymentIntentId,
                                controller: self,
                                applePayConfig: applePayConfig) { result in
            self.displayResult(resultCode: result)
        }
    }
    
    func displayResult(resultCode: Int) {
        displayMessage(message: "SDK result code: \(resultCode)")
    }
    
    func displayMessage(message: String) {
        let dialogMessage = UIAlertController(title: "Finish", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

