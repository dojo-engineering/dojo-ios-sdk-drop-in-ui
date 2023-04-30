//
//  UIImage+Common.swift
//
//  Created by Deniss Kaibagarovs on 05/04/2021.
//

import UIKit

enum UIImageCardIcon: String {
    case amex = "icon-card-amex"
    case amexDark = "icon-card-amex-dark"
    case diner = "icon-card-diner"
    case discover = "icon-card-discover"
    case maestro = "icon-card-maestro"
    case maestroDark = "icon-card-maestro-dark"
    case mastercard = "icon-card-mastercard"
    case mastercardDark = "icon-card-mastercard-dark"
    case visa = "icon-card-visa"
    case visaDark = "icon-card-visa-dark"
}

extension UIImage {
    static func getCardIcon(icon: UIImageCardIcon) -> UIImage? {
        getImage(named: icon.rawValue)
    }
    
    private static func getImage(named: String) -> UIImage? {
        UIImage(named: named,
                in: Bundle.libResourceBundle,
                compatibleWith: nil)
    }
    
    static func getCardIcon(type: CardSchemes, lightVersion: Bool = true) -> UIImage? {
        switch type {
        case.visa:
            return getCardIcon(icon: lightVersion ? .visa : .visaDark)
        case .mastercard:
            return getCardIcon(icon: lightVersion ? .mastercard : .mastercardDark)
        case .maestro:
            return getCardIcon(icon: lightVersion ? .maestro : .maestroDark)
        case .amex:
            return getCardIcon(icon: lightVersion ? .amex : .amexDark)
        default:
            return nil
        }
    }
    
    static func getFieldErrorIcon(lightVersion: Bool = true) -> UIImage? {
        lightVersion ? getImage(named: "icon-field-error") : getImage(named: "icon-field-error-dark")
    }
}
