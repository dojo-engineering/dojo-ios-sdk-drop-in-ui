//
//  SavedPaymentMethod.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 05/09/2022.
//

import Foundation

struct SavedPaymentRoot: Codable {
    let savedPaymentMethods: [SavedPaymentMethod]
}

struct SavedPaymentMethod: Codable {
    let id: String
    let cardDetails: SavedPaymentCardDetails
}

struct SavedPaymentCardDetails: Codable {
    let pan: String
    let expiryDate: String
    let scheme: CardSchemes
}
