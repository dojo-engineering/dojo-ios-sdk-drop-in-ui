//
//  DojoInputField.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 06/10/2022.
//

import UIKit

extension DojoInputField {
    func addLeftPaddingView() {
        let leftPadding = 8
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: 0))
        textFieldMain.leftView = paddingView
        textFieldMain.leftViewMode = .always
    }
    
    func getTextFieldAccessoryView() -> UIToolbar {
        let toolBar: UIToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        toolBar.barStyle = UIBarStyle.default
        
        let flexsibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil) // flexible space to add left end side
        let doneButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(didPressDoneKeyboardButton))
        let nextButton: UIBarButtonItem = UIBarButtonItem(title: LocalizedText.Buttons.next, style: .plain, target: self, action: #selector(didPressNextKeybaordButton))
        let backButton: UIBarButtonItem = UIBarButtonItem(title: LocalizedText.Buttons.previous, style: .plain, target: self, action: #selector(didPressBackKeybaordButton))
        toolBar.items = [backButton, nextButton, flexsibleSpace, doneButton]
        return toolBar
    }
    
    @objc func didPressBackKeybaordButton(button: UIButton) {
        delegate?.onPreviousField(self)
    }
    
    @objc func didPressNextKeybaordButton(button: UIButton) {
        delegate?.onNextField(self)
    }
    
    func setupTextFieldsAccessoryView() {
        guard textFieldMain.inputAccessoryView == nil else {
            print("textfields accessory view already set up")
            return
        }
        textFieldMain.inputAccessoryView = getTextFieldAccessoryView()
    }
    
    @objc func didPressDoneKeyboardButton(button: UIButton) {
        // Hide keyboard
        textFieldMain.resignFirstResponder()
    }
}
