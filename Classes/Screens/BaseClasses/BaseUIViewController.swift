//
//  BaseUIViewController.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 05/08/2022.
//

import UIKit

class BaseUIViewController: UIViewController {
    
    @IBOutlet weak var footerPoweredByDojoView: FooterPoweredByDojo?
    @IBOutlet weak var topNavigationSeparatorView: UIView?
    var baseDelegate: BaseViewControllerDelegate?
    var viewModel: BaseViewModel?
    
    // Per screen settings with defaul values
    // overwrite them during init of any subclass
    var displayCloseButton: Bool = true // display 'X' (close button) in the header
    var displayBackButton: Bool = true // display '<' (back button) in the header
    var diableCloseButton: Bool = false
    var theme: ThemeSettings = ThemeSettings(dojoTheme: DojoThemeSettings.getLightTheme()) // Light theme by default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCloseButton()
        setUpBackButton()
        setUpDesign()
    }
    
    @objc func onClosePress() {
        guard diableCloseButton == false else { return }
        baseDelegate?.onForceClosePress()
    }
    
    func setUpDesign() {
        self.view.backgroundColor = theme.primarySurfaceBackgroundColor
        
        footerPoweredByDojoView?.setTheme(theme: theme)
        footerPoweredByDojoView?.setStyle()
        topNavigationSeparatorView?.backgroundColor = theme.separatorColor
        navigationController?.navigationBar.tintColor = theme.headerTintColor
        navigationItem.rightBarButtonItem?.tintColor = theme.headerButtonTintColor
    }
    
    func updateData(config: ConfigurationManager) { }
    
    func disableScreen() {
        view.isUserInteractionEnabled = false
    }
    
    func enableScreen() {
        view.isUserInteractionEnabled = true
    }
}

extension BaseUIViewController {
    
    func setUpCloseButton() {
        let buttonTag = 88884
        if let buttonClose = self.navigationController?.navigationBar.subviews.first(where: {$0.tag == buttonTag}) as? UIButton{
            // old button already exists, don't need to add a new one
            buttonClose.addTarget(self, action: #selector(onClosePress), for: .touchUpInside)
            return
        }
        // if don't need to display, exit
        guard displayCloseButton == true else { return }
        
        if let navigationBar = self.navigationController?.navigationBar {
            let buttonClose = UIButton(frame: CGRect(x: navigationBar.frame.width - 55, y: -5, width: 50, height: 50))
            buttonClose.addTarget(self, action: #selector(onClosePress), for: .touchUpInside)
            buttonClose.setImage(UIImage(named: "icon-button-cross-close", in: Bundle.libResourceBundle, compatibleWith: nil), for: .normal)
            buttonClose.tintColor = theme.headerButtonTintColor
            buttonClose.tag = buttonTag
            navigationBar.addSubview(buttonClose)
        }
    }
    
    func setUpBackButton() {
        navigationItem.hidesBackButton = !displayBackButton
    }
    
    func setNavigationTitle(_ title: String) {
        if let navigationBar = self.navigationController?.navigationBar {
            let backButtonIsHidden = navigationController?.viewControllers.count == 1 || displayBackButton == false
            let xPosition: CGFloat = backButtonIsHidden ? 16 : 42
            let labelTag = 88883
            let titleLabelFrame = CGRect(x: xPosition,
                                         y: 0,
                                         width: navigationBar.frame.width * 0.7,
                                         height: navigationBar.frame.height)
            // Set up
            let customTitleLabel = UILabel(frame: titleLabelFrame)
            customTitleLabel.font = theme.fontHeading5Medium
            customTitleLabel.textColor = theme.headerTintColor
            customTitleLabel.text = title
            customTitleLabel.tag = labelTag
            // Remove old title if exists
            navigationBar.subviews.first(where: {$0.tag == labelTag})?.removeFromSuperview()
            // Add to view
            navigationBar.addSubview(customTitleLabel)
        }
    }
}
