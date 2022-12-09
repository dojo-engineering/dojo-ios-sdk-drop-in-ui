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
    public var primarySurfaceBackgroundColor: UIColor
    public var primaryCTAButtonActiveTextColor: UIColor
    public var primaryCTAButtonDisabledBackgroundColor: UIColor
    public var primaryCTAButtonDisableTextColor: UIColor
    public var secondaryCTAButtonActiveBorderColor: UIColor
    public var secondaryCTAButtonActiveTextColor: UIColor
    public var separatorColor: UIColor
    public var loadingIndicatorColor: UIColor
    public var inputElementActiveTintColor: UIColor
    public var lightStyleForDefaultElements: NSNumber
    
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
                lightStyleForDefaultElements: NSNumber? = nil) {
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
    }
    
    public static func getLightTheme() -> DojoThemeSettings {
        return DojoThemeSettings() // Light by default
    }
    
    public static func getDarkTheme() -> DojoThemeSettings {
        let theme = DojoThemeSettings()
        theme.primaryLabelTextColor = UIColor.init(hexaARGB: "#FFFFFFFF") ?? .white
        theme.secondaryLabelTextColor = UIColor.init(hexaARGB: "#FFFFFFFF") ?? .gray
        theme.headerTintColor = UIColor.init(hexaARGB: "#FFFFFFFF") ?? .white
        theme.headerButtonTintColor = UIColor.init(hexaARGB: "#FFFFFFFF") ?? .white
        theme.primarySurfaceBackgroundColor = UIColor.init(hexaARGB: "#FF1B1B1B") ?? .black
        theme.primaryCTAButtonActiveBackgroundColor = UIColor.init(hexaARGB: "#FF000000") ?? .black
        theme.primaryCTAButtonActiveTextColor = UIColor.init(hexaARGB: "#FFFFFFFF") ?? .white
        theme.primaryCTAButtonDisabledBackgroundColor = UIColor.init(hexaARGB: "#FFE5E5E5") ?? .gray
        theme.primaryCTAButtonDisableTextColor = UIColor.init(hexaARGB: "#60000000") ?? .white
        theme.secondaryCTAButtonActiveBorderColor = UIColor.init(hexaARGB: "#FF262626") ?? .black
        theme.secondaryCTAButtonActiveTextColor = UIColor.init(hexaARGB: "#FF262626") ?? .black
        theme.separatorColor = UIColor.init(hexaARGB: "#33000000") ?? .lightGray
        theme.loadingIndicatorColor = UIColor.init(hexaARGB: "#FFFFFFFF") ?? .white
        theme.lightStyleForDefaultElements = false
        theme.inputElementActiveTintColor = UIColor.init(hexaARGB: "#FFFFFFFF") ?? .systemGreen
        return theme
    }
}
