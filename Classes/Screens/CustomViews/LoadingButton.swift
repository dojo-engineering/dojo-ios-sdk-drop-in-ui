//
//  SelectedPaymentMethodView.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 12/09/2022.
//

import UIKit

class LoadingButton: UIButton {

    struct ButtonState {
        var state: UIControl.State
        var title: String
        var image: UIImage?
    }

    private (set) var buttonStates: [ButtonState] = []
    private var beforeLoadingTitle: String = ""
    
    var theme: ThemeSettings?
    
    func setTheme(_ theme: ThemeSettings) {
        self.theme = theme
        if isUserInteractionEnabled {
            backgroundColor = theme.primaryCTAButtonActiveBackgroundColor
            layer.borderColor = theme.primaryCTAButtonActiveBackgroundColor.cgColor
            layer.cornerRadius = theme.primaryCTAButtonCornerRadius
            setTitleColor(theme.primaryCTAButtonActiveTextColor, for: .normal)
            tintColor = theme.primaryCTAButtonActiveTextColor
            clipsToBounds = true
        } else {
            backgroundColor = theme.primaryCTAButtonDisabledBackgroundColor
            layer.borderColor = theme.primaryCTAButtonDisabledBackgroundColor.cgColor
            layer.cornerRadius = theme.primaryCTAButtonCornerRadius
            setTitleColor(theme.primaryCTAButtonDisableTextColor, for: .normal)
            tintColor = theme.primaryCTAButtonDisableTextColor
            clipsToBounds = true
        }
    }
    
    func setEnabled(_ isEnabled: Bool) {
        isUserInteractionEnabled = isEnabled
        if let theme = theme {
            setTheme(theme)
        }
    }
    
    private lazy var activityIndicator: MaterialLoadingIndicator = {
        let activityIndicator = MaterialLoadingIndicator(frame: CGRectMake(0, 0, 10, 10))
        activityIndicator.radius = 10.0
        activityIndicator.lineWidth = 2
        activityIndicator.color = .white
        
        self.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: -70)
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraints([xCenterConstraint, yCenterConstraint])

        return activityIndicator
    }()

    func showLoading(_ loadingTitle: String) {
        activityIndicator.startAnimating()
        beforeLoadingTitle = title(for: .normal) ?? ""
        setTitle(loadingTitle, for: .normal)
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        setTitle(beforeLoadingTitle, for: .normal)
        
//        for buttonState in buttonStates {
//            setTitle(buttonState.title, for: buttonState.state)
//            setImage(buttonState.image, for: buttonState.state)
//        }
    }
}
