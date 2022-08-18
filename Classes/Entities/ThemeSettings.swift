//
//  ThemeSettings.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 15/08/2022.
//

import Foundation
import UIKit

/// Private object for a wider theme set up
class ThemeSettings {
    var primaryLabelTextColor: UIColor
    var secondaryLabelTextColor: UIColor
    var headerTintColor: UIColor
    var headerButtonTintColor: UIColor
    var primarySurfaceBackgroundColor: UIColor
    var primaryCTAButtonActiveBackgroundColor: UIColor
    var primaryCTAButtonCornerRadius: CGFloat
    var primaryCTAButtonActiveTextColor: UIColor
    
    var fontBody1: UIFont
    
    var fontHeading4: UIFont
    var fontHeading5: UIFont
    var fontHeading5Bold: UIFont //TODO: speak with Designers
    
    var fontPrimaryCTAButtonActive: UIFont
    
    var fontPoweredByDojo: UIFont
    
    var colorPoweredByDojo: UIColor //TODO
    
    init (dojoTheme: DojoThemeSettings) {
        
        primaryLabelTextColor = dojoTheme.primaryLabelTextColor
        secondaryLabelTextColor = dojoTheme.secondaryLabelTextColor
        headerTintColor = dojoTheme.headerTintColor
        headerButtonTintColor = dojoTheme.headerButtonTintColor
        primaryCTAButtonActiveBackgroundColor = dojoTheme.primaryCTAButtonActiveBackgroundColor
        
        primarySurfaceBackgroundColor = UIColor.white
        primaryCTAButtonActiveTextColor = UIColor.white
        
        primaryCTAButtonCornerRadius = 21
        
        colorPoweredByDojo = .black
        
        // Set fall-back fonts if custom fonts are not available
        fontBody1 = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        fontHeading4 = UIFont.systemFont(ofSize: 24, weight: .bold)
        fontHeading5 = UIFont.systemFont(ofSize: 20, weight: .regular)
        fontHeading5Bold = UIFont.systemFont(ofSize: 20, weight: .bold)
        fontPrimaryCTAButtonActive = UIFont.systemFont(ofSize: 16, weight: .regular)
        fontPoweredByDojo = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        
        // set custom fonts
        registerFonts() // register custom fonts to use inside the SDK
        
        if let customFontBody1 = UIFont(name: RobotoFont.regular.rawValue, size: 16) { fontBody1 = customFontBody1 }
        if let customFontHeading4 = UIFont(name: RobotoFont.bold.rawValue, size: 24) { fontHeading4 = customFontHeading4 }
        if let customFontHeading5 = UIFont(name: RobotoFont.regular.rawValue, size: 20) { fontHeading5 = customFontHeading5 }
        if let customFontHeading5Bold = UIFont(name: RobotoFont.bold.rawValue, size: 20) { fontHeading5Bold = customFontHeading5Bold }
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
        return theme
    }
    
    private func registerFonts() {
        loadFont(RobotoFont.regular.rawValue)
        loadFont(RobotoFont.bold.rawValue)
    }
    
    private enum RobotoFont: String {
        case regular = "Roboto-Regular"
        case bold = "Roboto-Bold"
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

