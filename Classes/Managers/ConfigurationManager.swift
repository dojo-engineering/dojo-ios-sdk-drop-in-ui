//
//  CardDetailsCheckoutView.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

struct ConfigurationManager {
    var token: String // var because it can be refreshed
    let isSandbox: Bool
    var themeSettings: ThemeSettings
}
