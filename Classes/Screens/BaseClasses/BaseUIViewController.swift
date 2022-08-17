//
//  BaseUIViewController.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 05/08/2022.
//

import UIKit

class BaseUIViewController: UIViewController {
    
    // TODO a custom init that will take in delegate
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
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.headerTintColor]
        self.view.backgroundColor = theme.primarySurfaceBackgroundColor
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
        
        // TODO: theme setting
        navigationItem.rightBarButtonItem?.tintColor = theme.headerButtonTintColor
    }
    
    func setUpBackButton() {
        navigationItem.hidesBackButton = !displayBackButton
        
        // TODO: theme setting
        navigationController?.navigationBar.tintColor = UIColor.black
    }
}