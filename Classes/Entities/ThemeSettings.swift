//
//  ThemeSettings.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 15/08/2022.
//

import Foundation
import UIKit

/// Private object for a wider theme set up
struct ThemeSettings {
    var primaryLabelTextColor: UIColor
    var secondaryLabelTextColor: UIColor
    var headerButtonTintColor: UIColor
    var primarySurfaceBackgroundColor: UIColor
    var primaryCTAButtonActiveBackgroundColor: UIColor
    var primaryCTAButtonCornerRadius: CGFloat
    var primaryCTAButtonActiveTextColor: UIColor
    
    init (dojoTheme: DojoThemeSettings) {
        primaryLabelTextColor = dojoTheme.primaryLabelTextColor
        secondaryLabelTextColor = dojoTheme.secondaryLabelTextColor
        headerButtonTintColor = dojoTheme.headerButtonTintColor
        primaryCTAButtonActiveBackgroundColor = dojoTheme.primaryCTAButtonActiveBackgroundColor
        
        primarySurfaceBackgroundColor = UIColor.white
        primaryCTAButtonActiveTextColor = UIColor.white
        
        primaryCTAButtonCornerRadius = 21
    }
    
    static func getLightTheme() -> ThemeSettings {
        return ThemeSettings(dojoTheme: DojoThemeSettings.getLightTheme())
    }
    
    static func getDarkTheme() -> ThemeSettings {
        // get initial dojoTheme object and update properties
        var dojoTheme = DojoThemeSettings.getLightTheme()
        dojoTheme.primaryLabelTextColor = UIColor.white
        dojoTheme.secondaryLabelTextColor = UIColor.white
        dojoTheme.headerButtonTintColor = UIColor.white
        dojoTheme.primaryCTAButtonActiveBackgroundColor = UIColor.white
        // create internal theme
        var theme = ThemeSettings(dojoTheme: dojoTheme)
        // modify items that are inaccessible by public API
        theme.primarySurfaceBackgroundColor = UIColor.black
        theme.primaryCTAButtonActiveTextColor = UIColor.black
        return theme
    }
}
