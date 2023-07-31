//
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 02/08/2022.
//

import UIKit
import dojo_ios_sdk

extension CardDetailsCheckoutViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //TODO: move to fields file
        self.view.endEditing(true)
        return false
    }
}

extension CardDetailsCheckoutViewController: DojoInputFieldDelegate {
    
    // MARK: Keyboard Buttons Actions
    func onNextField(_ from: DojoInputField) {
        if let index = inputFields.firstIndex(of: from) {
            if inputFields.count - 1 > index {
                let _ = inputFields[index + 1].becomeFirstResponder()
            } else if inputFields.count > 0 {
                let _ = inputFields[0].becomeFirstResponder()
            }
        }
    }
    
    func onPreviousField(_ from: DojoInputField) {
        if let index = inputFields.firstIndex(of: from) {
            if inputFields.count > index && index >= 1 {
                let _ = inputFields[index - 1].becomeFirstResponder()
            } else if inputFields.count > 0 {
                let _ = inputFields[inputFields.count - 1].becomeFirstResponder()
            }
        }
    }
    
    func onTextFieldDidFinishEditing(_ from: DojoInputField) {
        if let fieldType = from.getType() {
            switch fieldType {
            case .billingCountry:
                if let selectedCountryCode = from.getSelectedCountry()?.isoCode,
                   getViewModel()?.showBillingPostcode(selectedCountryCode) ?? false {
                    fieldBillingPostcode.isHidden = false
                    inputFields.insert(fieldBillingPostcode, at: 2) //TODO: if email is hidden, that should be a different position
                } else {
                    fieldBillingPostcode.isHidden = true
                    inputFields.removeAll(where: {$0.getType() == .billingPostcode})
                }
            case .cardNumber:
                inputFields.forEach({
                    if $0.getType() == .cvv {
                        $0.currentCardSchema = from.currentCardSchema
                    }
                })
            default:
                break;
            }
        }
        var isValid = true
        inputFields.forEach({
            if !$0.isValid() {
                isValid = false
            }
        })
        buttonPay.setEnabled(isValid)
    }
    
    // MARK: Other
    func onTextChange(_ from: DojoInputField) {
       forceValidate()
    }
    
    func forceValidate() {
        var isValid = true
        inputFields.forEach({
            if !$0.isValid() {
                isValid = false
            }
        })
        if let viewModel = getViewModel(),
           viewModel.paymentIntent.isSetupIntent {
            isValid = isValid && viewModel.isTermsSelected
        }
        buttonPay.setEnabled(isValid)
    }
    
    func onTextFieldBeginEditing(_ from: DojoInputField) { }
}


// MARK: Keyboard Delegate
extension CardDetailsCheckoutViewController {
    @objc func keyboardWillHide(_ notification: Notification) {
        constraintPayButtonBottom.constant = 52
    }
    
    func setUpKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            constraintPayButtonBottom.constant = keyboardHeight - (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) + 12
        }
    }
}
