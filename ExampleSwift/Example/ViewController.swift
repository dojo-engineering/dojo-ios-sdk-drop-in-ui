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
        requestPaymentToken { token in
            self.dojoUI.startPaymentFlow(token: token,
                                         isSandbox: false,
                                         controller: self) { result in
                print("SDK result code: \(result)")
            }
        }
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

