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
    @IBOutlet weak var textFieldCustomerSecret: UITextField!
    @IBOutlet weak var switchShowAdditionalLegal: UISwitch!
    let dojoUI = DojoSDKDropInUI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldPaymentIntent.delegate = self
    }
    
    @IBAction func onStartSetupFlowPress(_ sender: Any) {
        var paymentIntentId = ""
        if let paymentIntent = textFieldPaymentIntent.text,
           !paymentIntent.isEmpty {
            paymentIntentId = paymentIntent
        }
        dojoUI.startSetupFlow(setupIntentId: paymentIntentId,
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
        
        let theme = DojoThemeSettings.getLightTheme()
        let customerSecret = textFieldCustomerSecret.text
        if switchShowAdditionalLegal.isOn {
            theme.additionalLegalText = "Dojo is a trading name of Paymentsense Limited. Copyright ©2024 Paymentsense Limited. All rights reserved. Paymentsense Limited is authorised and regulated by the Financial Conduct Authority (FCA FRN 738728) and under the Electronic Money Regulations 2011 (FCA FRN 900925) for the issuing of electronic money and provision of payment services. Our company number is 06730690 and our registered office address is The Brunel Building, 2 Canalside Walk, London W2 1DG"
        }
        let applePayConfig = DojoUIApplePayConfig(merchantIdentifier: "merchant.uk.co.paymentsense.sdk.demo.app")
        dojoUI.startPaymentFlow(paymentIntentId: paymentIntentId,
                                controller: self,
                                customerSecret: customerSecret,
                                applePayConfig: applePayConfig,
                                themeSettings: theme) { result in
            self.displayResult(resultCode: result)
        }
    }
    
    func displayResult(resultCode: Int) {
        let dialogMessage = UIAlertController(title: "Finish", message:"SDK result code: \(resultCode)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

