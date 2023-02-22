//
//  FooterPoweredByViewModel.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import Foundation

class FooterPoweredByViewModel {
    private let urlPrivacy: String = "https://dojo.tech/legal/privacy"
    private let urlTerms: String = "https://pay.dojo.tech/terms"
    
    var privacyURL: URL? {
        URL(string: urlPrivacy)
    }
    
    var termsURL: URL? {
        URL(string: urlTerms)
    }
    
    var showBranding: Bool = true
}
