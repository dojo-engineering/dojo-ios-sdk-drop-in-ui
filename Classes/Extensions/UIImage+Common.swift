//
//  UIImage+Common.swift
//
//  Created by Deniss Kaibagarovs on 05/04/2021.
//

import UIKit

enum UIImageCardIcon: String {
    case amex = "icon-card-amex"
    case diner = "icon-card-diner"
    case discover = "icon-card-discover"
    case maestro = "icon-card-maestro"
    case mastercard = "icon-card-mastercard"
    case visa = "icon-card-visa"
}

extension UIImage {
    static func getCardIcon(icon: UIImageCardIcon) -> UIImage? {
        UIImage(named: icon.rawValue,
                in: Bundle(for: BaseUIViewController.self),
                compatibleWith: nil)
    }
    
    static func getCardIcon(type: CardSchemes) -> UIImage? {
        switch type {
        case.visa:
            return getCardIcon(icon: .visa)
        case .mastercard:
            return getCardIcon(icon: .mastercard)
        case .maestro:
            return getCardIcon(icon: .maestro)
        case .amex:
            return getCardIcon(icon: .amex)
        default:
            return nil
        }
    }
}
