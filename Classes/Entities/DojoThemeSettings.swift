//
//  CardDetailsCheckoutView.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 15/08/2022.
//

import UIKit

@objc
public class DojoThemeSettings: NSObject {
    public var primaryLabelTextColor: UIColor
    public var secondaryLabelTextColor: UIColor
    public var headerButtonTintColor: UIColor
    public var headerTintColor: UIColor
    public var primaryCTAButtonActiveBackgroundColor: UIColor
    
    @objc
    public init(primaryLabelTextColor: UIColor? = nil,
                secondaryLabelTextColor: UIColor? = nil,
                headerTintColor: UIColor? = nil,
                headerButtonTintColor: UIColor? = nil,
                primaryCTAButtonActiveBackgroundColor: UIColor? = nil) {
        self.primaryLabelTextColor = primaryLabelTextColor ?? UIColor.black
        self.secondaryLabelTextColor = secondaryLabelTextColor ?? UIColor.gray
        self.headerTintColor = headerTintColor ?? UIColor.black
        self.headerButtonTintColor = headerButtonTintColor ?? UIColor.black
        self.primaryCTAButtonActiveBackgroundColor = primaryCTAButtonActiveBackgroundColor ?? UIColor.black
    }
    
    public static func getLightTheme() -> DojoThemeSettings {
        return DojoThemeSettings() // Light by default
    }
}
