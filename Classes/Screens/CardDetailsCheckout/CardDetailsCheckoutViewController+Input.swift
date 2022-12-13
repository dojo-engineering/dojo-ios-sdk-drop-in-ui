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
                if from.textFieldMain.text == "United Kingdom" || //TODO: move to identifiers
                   from.textFieldMain.text == "United States of America" ||
                   from.textFieldMain.text == "Canada" {
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
        var isValid = true
        inputFields.forEach({
            if !$0.isValid() {
                isValid = false
            }
        })
        buttonPay.setEnabled(isValid)
    }
    
    func onTextFieldBeginEditing(_ from: DojoInputField) { }
}
