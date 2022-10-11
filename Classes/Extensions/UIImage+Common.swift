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
    static func getCardIcon(_ type: UIImageCardIcon) -> UIImage? {
        UIImage(named: type.rawValue,
                in: Bundle(for: BaseUIViewController.self),
                compatibleWith: nil)
    }
}
