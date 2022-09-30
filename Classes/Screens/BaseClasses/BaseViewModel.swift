//
//  BaseViewModel.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 30/09/2022.
//

import Foundation

class BaseViewModel {
    var paymentIntent: PaymentIntent
    
    init(paymentIntent: PaymentIntent) {
        self.paymentIntent = paymentIntent
    }
}
