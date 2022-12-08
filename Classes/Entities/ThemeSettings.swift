//
//  ThemeSettings.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 15/08/2022.
//

import Foundation
import UIKit
import PassKit

/// Private object for a wider theme set up
class ThemeSettings {
    // Colors
    var primaryLabelTextColor: UIColor
    var secondaryLabelTextColor: UIColor
    var errorTextColor: UIColor
    var headerTintColor: UIColor
    var headerButtonTintColor: UIColor
    var primarySurfaceBackgroundColor: UIColor
    var primaryCTAButtonActiveBackgroundColor: UIColor
    var primaryCTAButtonDisabledBackgroundColor: UIColor
    var primaryCTAButtonActiveTextColor: UIColor
    var primaryCTAButtonDisableTextColor: UIColor
    var separatorColor: UIColor
    var loadingIndicatorColor: UIColor
    var colorPoweredByDojo: UIColor
    var colorPoweredBySeparator: UIColor
    var colorPoweredByButtons: UIColor
    
    // Fonts
    var fontBody1: UIFont
    var fontBody2: UIFont
    var fontSubtitle1: UIFont
    var fontSubtitle1Medium: UIFont
    var fontSubtitle2: UIFont
    var fontHeading3Medium: UIFont
    var fontHeading4: UIFont
    var fontHeading5: UIFont
    var fontHeading5Bold: UIFont //TODO: speak with Designers
    var fontHeading5Medium: UIFont //TODO: speak with Designers
    var fontPrimaryCTAButtonActive: UIFont
    var fontPoweredByDojo: UIFont
    
    // Other
    var primaryCTAButtonCornerRadius: CGFloat
    var applePayButtonStyle: PKPaymentButtonStyle
    
    init (dojoTheme: DojoThemeSettings) {
        // Colors
        primaryLabelTextColor = dojoTheme.primaryLabelTextColor
        secondaryLabelTextColor = dojoTheme.secondaryLabelTextColor
        headerTintColor = dojoTheme.headerTintColor
        headerButtonTintColor = dojoTheme.headerButtonTintColor
        primaryCTAButtonActiveBackgroundColor = dojoTheme.primaryCTAButtonActiveBackgroundColor
        primarySurfaceBackgroundColor = dojoTheme.primarySurfaceBackgroundColor
        primaryCTAButtonActiveTextColor = dojoTheme.primaryCTAButtonActiveTextColor
        colorPoweredByDojo = .black
        separatorColor = dojoTheme.separatorColor
        colorPoweredBySeparator = UIColor(hex: "#A5A5A5FF") ?? separatorColor
        colorPoweredByButtons = .black.withAlphaComponent(0.6)
        errorTextColor = UIColor(hex: "#B00020FF") ?? .systemRed
        
        // Other
        primaryCTAButtonCornerRadius = 21
        loadingIndicatorColor = .black
        applePayButtonStyle = .black
        
        primaryCTAButtonDisabledBackgroundColor = dojoTheme.primaryCTAButtonDisabledBackgroundColor
        primaryCTAButtonDisableTextColor = dojoTheme.primaryCTAButtonDisableTextColor
        
        // Fonts
        // Set fall-back fonts if custom fonts are not available
        fontBody1 = UIFont.systemFont(ofSize: 16, weight: .regular)
        fontBody2 = UIFont.systemFont(ofSize: 14, weight: .regular)
        fontSubtitle1 = UIFont.systemFont(ofSize: 16, weight: .regular)
        fontSubtitle1Medium = UIFont.systemFont(ofSize: 16, weight: .medium)
        fontSubtitle2 = UIFont.systemFont(ofSize: 14, weight: .regular)
        fontHeading3Medium = UIFont.systemFont(ofSize: 32, weight: .medium)
        fontHeading4 = UIFont.systemFont(ofSize: 24, weight: .bold)
        fontHeading5 = UIFont.systemFont(ofSize: 20, weight: .regular)
        fontHeading5Bold = UIFont.systemFont(ofSize: 20, weight: .bold)
        fontHeading5Medium = UIFont.systemFont(ofSize: 20, weight: .medium)
        fontPrimaryCTAButtonActive = UIFont.systemFont(ofSize: 16, weight: .regular)
        fontPoweredByDojo = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        // Custom fonts
        registerFonts() // register custom fonts to use inside the SDK
        
        if let customFontBody1 = UIFont(name: RobotoFont.regular.rawValue, size: 16) { fontBody1 = customFontBody1 }
        if let customFontBody2 = UIFont(name: RobotoFont.regular.rawValue, size: 14) { fontBody2 = customFontBody2 }
        if let customfontSubtitle1 = UIFont(name: RobotoFont.regular.rawValue, size: 16) { fontSubtitle1 = customfontSubtitle1 }
        if let customfontSubtitle1Medium = UIFont(name: RobotoFont.medium.rawValue, size: 16) { fontSubtitle1Medium = customfontSubtitle1Medium }
        if let customFontSubtitle2 = UIFont(name: RobotoFont.regular.rawValue, size: 14) { fontSubtitle2 = customFontSubtitle2 }
        if let customFontHeading3Medium = UIFont(name: RobotoFont.medium.rawValue, size: 32) { fontHeading3Medium = customFontHeading3Medium }
        if let customFontHeading4 = UIFont(name: RobotoFont.bold.rawValue, size: 24) { fontHeading4 = customFontHeading4 }
        if let customFontHeading5 = UIFont(name: RobotoFont.regular.rawValue, size: 20) { fontHeading5 = customFontHeading5 }
        if let customFontHeading5Bold = UIFont(name: RobotoFont.bold.rawValue, size: 20) { fontHeading5Bold = customFontHeading5Bold }
        if let customFontHeading5Medium = UIFont(name: RobotoFont.medium.rawValue, size: 20) { fontHeading5Medium = customFontHeading5Medium }
        if let customFontPrimaryCTAButtonActive = UIFont(name: RobotoFont.regular.rawValue, size: 16) { fontPrimaryCTAButtonActive = customFontPrimaryCTAButtonActive }
        if let customFontPoweredByDojo = UIFont(name: RobotoFont.regular.rawValue, size: 14) { fontPoweredByDojo = customFontPoweredByDojo }
    }
}

extension ThemeSettings {
    static func getLightTheme() -> ThemeSettings {
        return ThemeSettings(dojoTheme: DojoThemeSettings.getLightTheme())
    }
    
    static func getDarkTheme() -> ThemeSettings {
        // get initial dojoTheme object and update properties
        var dojoTheme = DojoThemeSettings.getLightTheme()
        dojoTheme.primaryLabelTextColor = UIColor.white
        dojoTheme.secondaryLabelTextColor = UIColor.white
        dojoTheme.headerButtonTintColor = UIColor.white
        dojoTheme.headerTintColor = UIColor.white
        dojoTheme.primaryCTAButtonActiveBackgroundColor = UIColor.white
        // create internal theme
        let theme = ThemeSettings(dojoTheme: dojoTheme)
        // modify items that are inaccessible by public API
        theme.primarySurfaceBackgroundColor = UIColor.black
        theme.primaryCTAButtonActiveTextColor = UIColor.black
        theme.colorPoweredByDojo = .white
        theme.applePayButtonStyle = .white
        theme.separatorColor = .white.withAlphaComponent(0.3)
        theme.loadingIndicatorColor = .white
        theme.colorPoweredBySeparator = .white.withAlphaComponent(0.3)
        theme.colorPoweredByButtons = .white.withAlphaComponent(0.6)
        return theme
    }
    
    private func registerFonts() {
        loadFont(RobotoFont.regular.rawValue)
        loadFont(RobotoFont.bold.rawValue)
        loadFont(RobotoFont.medium.rawValue)
    }
    
    private enum RobotoFont: String {
        case regular = "Roboto-Regular"
        case bold = "Roboto-Bold"
        case medium = "Roboto-Medium"
    }
    
    private func loadFont(_ fontName: String) {
        let bundle = Bundle(for: type(of: self))
        guard
          let fontURL = bundle.url(forResource: fontName, withExtension: "ttf"),
          let fontData = try? Data(contentsOf: fontURL) as CFData,
          let provider = CGDataProvider(data: fontData),
          let font = CGFont(provider) else {
            return
        }
        CTFontManagerRegisterGraphicsFont(font, nil)
      }
}
