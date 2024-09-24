//
//  FooterPoweredByViewModel.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import Foundation

struct FooterPoweredByViewModel {
    enum Market {
        case gb
        case es
        case ie
        case it
        
        var id: String {
            switch self {
            case .gb: return "GB"
            case .es: return "ES"
            case .ie: return "IE"
            case .it: return "IT"
            }
        }
    }
    private let market: Market
    
    init(paymentIntent: PaymentIntent) {
        self.market = Market(value: paymentIntent.config?.marketId)
    }

    var privacyURL: URL? {
        URL(string: market.privacyUrl)
    }
    
    var termsURL: URL? {
        URL(string: market.termsUrl)
    }
}

extension FooterPoweredByViewModel.Market {
    init(value: String?) {
        switch value {
        case Self.gb.id:
            self = .gb
        case Self.es.id:
            self = .es
        case Self.ie.id:
            self = .ie
        case Self.it.id:
            self = .it
        case .none, .some(_):
            self = .gb
        }
    }
    
    fileprivate var privacyUrl: String {
        switch self {
        case .gb: return "https://dojo.tech/legal/privacy/"
        case .es: return "https://dojo.tech/es/legal/privacidad/"
        case .ie: return "https://dojo.tech/ie/legal/privacy/"
        case .it: return "https://dojo.tech/it/legal/privacy/"
        }
    }
    
    fileprivate var termsUrl: String {
        switch self {
        case .gb: return "https://dojo.tech/legal/website-terms-conditions/"
        case .es: return "https://dojo.tech/es/legal/terminos-y-condiciones/"
        case .ie: return "https://dojo.tech/ie/legal/website-terms-conditions/"
        case .it: return "https://dojo.tech/it/legal/termini-e-condizioni/"
        }
    }
}
