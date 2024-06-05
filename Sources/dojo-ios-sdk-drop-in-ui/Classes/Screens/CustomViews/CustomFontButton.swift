//
//  CustomFontButton.swift
//  Pods
//
//  Created by Deniss Kaibagarovs on 22/05/2024.
//

import UIKit

class CustomFontButton: UIButton {
    func setFont(_ font: UIFont) {
        if #available(iOS 15.0, *) {
            self.configuration?.titleTextAttributesTransformer =
            UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = font
                return outgoing
            }
        }
    }
}
