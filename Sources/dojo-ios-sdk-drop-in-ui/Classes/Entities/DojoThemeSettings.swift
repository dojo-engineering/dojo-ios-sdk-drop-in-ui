//
//  CardDetailsCheckoutView.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 15/08/2022.
//

import UIKit

@objc
public class DojoThemeSettings: NSObject {
    @objc public var primaryLabelTextColor: UIColor
    @objc public var secondaryLabelTextColor: UIColor
    @objc public var headerButtonTintColor: UIColor
    @objc public var headerTintColor: UIColor
    @objc public var primaryCTAButtonActiveBackgroundColor: UIColor
    @objc public var primarySurfaceBackgroundColor: UIColor
    @objc public var primaryCTAButtonActiveTextColor: UIColor
    @objc public var primaryCTAButtonDisabledBackgroundColor: UIColor
    @objc public var primaryCTAButtonDisableTextColor: UIColor
    @objc public var secondaryCTAButtonActiveBorderColor: UIColor
    @objc public var secondaryCTAButtonActiveTextColor: UIColor
    @objc public var separatorColor: UIColor
    @objc public var loadingIndicatorColor: UIColor
    @objc public var inputElementActiveTintColor: UIColor
    @objc public var inputFieldBackgroundColor: UIColor
    @objc public var inputElementDefaultTintColor: UIColor
    @objc public var inputFieldSelectedBorderColor: UIColor
    @objc public var inputFieldDefaultBorderColor: UIColor
    @objc public var errorTextColor: UIColor
    @objc public var lightStyleForDefaultElements: NSNumber
    @objc public var showBranding: NSNumber
    @objc public var backdropViewColor: UIColor
    @objc public var backdropViewAlpha: NSDecimalNumber
    
    @objc
    public init(primaryLabelTextColor: UIColor? = nil,
                secondaryLabelTextColor: UIColor? = nil,
                headerTintColor: UIColor? = nil,
                headerButtonTintColor: UIColor? = nil,
                primaryCTAButtonActiveBackgroundColor: UIColor? = nil,
                primarySurfaceBackgroundColor: UIColor? = nil,
                primaryCTAButtonActiveTextColor: UIColor? = nil,
                primaryCTAButtonDisabledBackgroundColor: UIColor? = nil,
                primaryCTAButtonDisableTextColor: UIColor? = nil,
                secondaryCTAButtonActiveBorderColor: UIColor? = nil,
                secondaryCTAButtonActiveTextColor: UIColor? = nil,
                separatorColor: UIColor? = nil,
                loadingIndicatorColor: UIColor? = nil,
                inputElementActiveTintColor: UIColor? = nil,
                inputFieldBackgroundColor: UIColor? = nil,
                inputElementDefaultTintColor: UIColor? = nil,
                inputFieldSelectedBorderColor: UIColor? = nil,
                inputFieldDefaultBorderColor: UIColor? = nil,
                errorTextColor: UIColor? = nil,
                lightStyleForDefaultElements: NSNumber? = nil,
                backdropViewColor: UIColor? = nil,
                backdropViewAlpha: NSDecimalNumber? = nil) {
        self.primaryLabelTextColor = primaryLabelTextColor ?? UIColor.init(hexaARGB: "#DD000000") ?? .black
        self.secondaryLabelTextColor = secondaryLabelTextColor ?? UIColor.init(hexaARGB: "#99000000") ?? .gray
        self.headerTintColor = headerTintColor ?? UIColor.init(hexaARGB: "#DD000000") ?? .black
        self.headerButtonTintColor = headerButtonTintColor ?? UIColor.init(hexaARGB: "#99000000") ?? .gray
        self.primaryCTAButtonActiveBackgroundColor = primaryCTAButtonActiveBackgroundColor ?? UIColor.init(hexaARGB: "#FF000000") ?? .black
        self.primarySurfaceBackgroundColor = primarySurfaceBackgroundColor ?? UIColor.init(hexaARGB: "#FFFFFFFF") ?? .white
        self.primaryCTAButtonActiveTextColor = primaryCTAButtonActiveTextColor ?? UIColor.init(hexaARGB: "#FFFFFFFF") ?? .white
        self.primaryCTAButtonDisabledBackgroundColor = primaryCTAButtonDisabledBackgroundColor ?? UIColor.init(hexaARGB: "#FFE5E5E5") ?? .gray
        self.primaryCTAButtonDisableTextColor = primaryCTAButtonDisableTextColor ?? UIColor.init(hexaARGB: "#60000000") ?? .white
        self.secondaryCTAButtonActiveBorderColor = secondaryCTAButtonActiveBorderColor ?? UIColor.init(hexaARGB: "#FF262626") ?? .black
        self.secondaryCTAButtonActiveTextColor = secondaryCTAButtonActiveTextColor ?? UIColor.init(hexaARGB: "#FF262626") ?? .black
        self.separatorColor = separatorColor ?? UIColor.init(hexaARGB: "#33000000") ?? .lightGray
        self.loadingIndicatorColor = loadingIndicatorColor ?? UIColor.init(hexaARGB: "#FF262626") ?? .black
        self.lightStyleForDefaultElements = lightStyleForDefaultElements ?? true
        self.inputElementActiveTintColor = inputElementActiveTintColor ?? UIColor.init(hexaARGB: "#FF00857D") ?? .systemGreen
        self.inputFieldSelectedBorderColor = inputFieldSelectedBorderColor ?? UIColor.init(hexaARGB: "#FF00857D") ?? .systemGreen
        self.inputFieldBackgroundColor = inputFieldBackgroundColor ?? UIColor.init(hexaARGB: "#FFFFFFFF") ?? .white
        self.inputElementDefaultTintColor = inputElementDefaultTintColor ?? UIColor.init(hexaARGB: "#26000000") ?? .gray
        self.inputFieldDefaultBorderColor = inputFieldDefaultBorderColor ?? UIColor.init(hexaARGB: "#26000000") ?? .gray
        self.errorTextColor = errorTextColor ?? UIColor.init(hexaARGB: "#FFB00020") ?? .systemRed
        self.showBranding = true
        self.backdropViewColor = backdropViewColor ?? UIColor.black
        self.backdropViewAlpha = backdropViewAlpha ?? 0.3
    }
    
    @objc
    public static func getLightTheme() -> DojoThemeSettings {
        return DojoThemeSettings() // Light by default
    }
    
    @objc
    public static func getDarkTheme() -> DojoThemeSettings {
        let theme = DojoThemeSettings()
        theme.primaryLabelTextColor = UIColor.init(hexaARGB: "#FFFFFFFF") ?? .white
        theme.secondaryLabelTextColor = UIColor.init(hexaARGB: "#FFFFFFFF") ?? .gray
        theme.headerTintColor = UIColor.init(hexaARGB: "#FFFFFFFF") ?? .white
        theme.headerButtonTintColor = UIColor.init(hexaARGB: "#FFFFFFFF") ?? .white
        theme.primarySurfaceBackgroundColor = UIColor.init(hexaARGB: "#FF1B1B1B") ?? .black
        theme.primaryCTAButtonActiveBackgroundColor = UIColor.init(hexaARGB: "#FFFFFFFF") ?? .white
        theme.primaryCTAButtonActiveTextColor = UIColor.init(hexaARGB: "#DD000000") ?? .black
        theme.primaryCTAButtonDisabledBackgroundColor = UIColor.init(hexaARGB: "#FFC3C3C3") ?? .gray
        theme.primaryCTAButtonDisableTextColor = UIColor.init(hexaARGB: "#60000000") ?? .white
        theme.secondaryCTAButtonActiveBorderColor = UIColor.init(hexaARGB: "#FFFFFFFF") ?? .white
        theme.secondaryCTAButtonActiveTextColor = UIColor.init(hexaARGB: "#FFFFFFFF") ?? .white
        theme.separatorColor = UIColor.init(hexaARGB: "#33000000") ?? .lightGray
        theme.loadingIndicatorColor = UIColor.init(hexaARGB: "#FFFFFFFF") ?? .white
        theme.lightStyleForDefaultElements = false
        theme.inputElementActiveTintColor = UIColor.init(hexaARGB: "#FFFFFFFF") ?? .systemGreen
        theme.inputFieldSelectedBorderColor = UIColor.init(hexaARGB: "#FFFFFFFF") ?? .systemGreen
        theme.inputFieldBackgroundColor = UIColor.init(hexaARGB: "#FF313131") ?? .black
        theme.inputElementDefaultTintColor = UIColor.init(hexaARGB: "#FFFFFFFF") ?? .gray
        theme.inputFieldDefaultBorderColor = UIColor.init(hexaARGB: "#26FFFFFF") ?? .gray
        theme.errorTextColor = UIColor.init(hexaARGB: "#FFED5645") ?? .systemRed
        return theme
    }
}
