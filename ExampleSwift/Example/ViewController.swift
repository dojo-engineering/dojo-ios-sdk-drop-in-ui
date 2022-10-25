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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onStartPaymentFlowPress(_ sender: Any) {
//        requestPaymentToken { token in
        let paymentIntentId = "pi_xLYwwgIg50efBKXRzlLQxg"
        let customerSecret = "cs_prod_J3WQuKuz-pxQ9z9YeKDb9bt7giEOC6YakDprEHyclrPFlYWANqqYCu4B7zL6WPTkSkyFKYb10Ec7EKMvAfHVKRlgdHISsNrnJWxNd5V28t0"
        let theme = DojoThemeSettings(primaryLabelTextColor: UIColor.red,
                                      secondaryLabelTextColor: .green,
                                      headerTintColor: .green,
                                      headerButtonTintColor: .orange)
            self.dojoUI.startPaymentFlow(paymentIntentId: paymentIntentId,
                                         controller: self,
                                         customerSecret: customerSecret,
                                         applePayConfig: DojoUIApplePayConfig(merchantIdentifier: "merchant.uk.co.paymentsense.sdk.demo.app"),
                                         themeSettings: theme) { result in
                print("SDK result code: \(result)")
            }
//        }
    }
    
    func requestPaymentToken(completion: ((String) -> Void)?) {
        let url = URL(string: "http://localhost:3000/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let token = String(decoding: data, as: UTF8.self)
                completion?(token)
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
    }

}

