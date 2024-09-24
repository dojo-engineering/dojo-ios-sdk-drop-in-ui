//
//  FooterPoweredByViewModel.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import Foundation

struct FooterPoweredByViewModel {
    private let paymentIntent: PaymentIntent
    
    init(paymentIntent: PaymentIntent) {
        self.paymentIntent = paymentIntent
    }

    var privacyURL: URL? {
        URL(string: paymentIntent.market.privacyUrl)
    }
    
    var termsURL: URL? {
        URL(string: paymentIntent.market.termsUrl)
    }
}
