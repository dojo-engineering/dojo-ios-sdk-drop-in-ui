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
    
    // Per screen settings with defaul values
    // overwrite them during init of any subclass
    var displayCloseButton: Bool = true // display 'X' (close button) in the header
    var displayBackButton: Bool = true // display '<' (back button) in the header
    var theme: ThemeSettings = ThemeSettings.getLightTheme() // Light theme by default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCloseButton()
        setUpBackButton()
        setUpDesign()
    }
    
    @objc func onClosePress() {
        baseDelegate?.onForceClosePress()
    }
    
    func setUpDesign() {
        self.view.backgroundColor = theme.primarySurfaceBackgroundColor
        
        footerPoweredByDojoView?.setTheme(theme: theme)
        topNavigationSeparatorView?.backgroundColor = theme.separatorColor
        navigationController?.navigationBar.tintColor = theme.headerTintColor
        navigationItem.rightBarButtonItem?.tintColor = theme.headerButtonTintColor
    }
}

extension BaseUIViewController {
    
    func setUpCloseButton() {
        guard displayCloseButton == true else { return }
        let buttonClose = UIBarButtonItem(title: "",
                                          style: .plain,
                                          target: self, action: #selector(onClosePress))
        buttonClose.image = UIImage(named: "icon-button-cross-close", in: Bundle(for: type(of: self)), compatibleWith: nil)
        navigationItem.rightBarButtonItem = buttonClose
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
