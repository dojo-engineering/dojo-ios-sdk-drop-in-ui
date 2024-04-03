//
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 06/10/2022.
//

import UIKit

extension DojoInputField: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.onTextChange(self)
    }
    
    override func becomeFirstResponder() -> Bool {
        textFieldMain.becomeFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.onTextFieldBeginEditing(self)
        guard let viewModel = viewModel else { return } 
        // Handle country selection
        if viewModel.type == .billingCountry {
            self.picker = UIPickerView()
            self.picker?.delegate = self
            self.picker?.dataSource = self
            self.picker?.selectRow(selectedPickerPosition, inComponent: 0, animated: false)
            textFieldMain.inputView = self.picker
        }
        setupTextFieldsAccessoryView()
        setState(.activeInput)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        
        if getType() == .cvv {
            // only allow numerical characters
            guard string.compactMap({ Int(String($0)) }).count ==
                    string.count else { return false }
        }
        
        if getType() == .expiry {
            // only allow numerical characters
            guard string.compactMap({ Int(String($0)) }).count ==
                    string.count else { return false }
            
            let maxNumberOfCharacters = 4
            
            let text = textField.text ?? ""
            if string.count == 0 {
                textField.text = String(text.dropLast()).chunkFormatted(withChunkSize: 2, withSeparator: "/")
            }
            else {
                let newText = String((text + string).filter({ $0 != "/" }).prefix(maxNumberOfCharacters))
                textField.text = newText.chunkFormatted(withChunkSize: 2, withSeparator: "/")
            }
            delegate?.onTextChange(self)
            return false
        }
        
        if getType() == .cardNumber {
            // only allow numerical characters
            var maxNumberOfCharacters = 16
            guard string.compactMap({ Int(String($0)) }).count ==
                    string.count else { return false }
            if let cardScheme = viewModel?.getCardScheme(updatedString),
               viewModel?.supportedCardSchemas.contains(cardScheme) ?? false {
                let image = UIImage.getCardIcon(type: cardScheme, lightVersion: theme?.lightStyleForDefaultElements ?? true)
                textFieldMain.rightImage(image, imageWidth: 25, padding: 10)
                currentCardSchema = cardScheme
                if cardScheme == .amex {
                    maxNumberOfCharacters = 15
                }
            } else {
                textFieldMain.rightImage(nil, imageWidth: 0, padding: 10)
            }
            
            let text = textField.text ?? ""
            if string.count == 0 {
                textField.text = String(text.dropLast()).chunkFormatted()
            }
            else {
                let newText = String((text + string).filter({ $0 != " " }).prefix(maxNumberOfCharacters))
                textField.text = newText.chunkFormatted()
            }
            delegate?.onTextChange(self)
            return false
        }
        
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        if getType() == .cvv {
            let shouldChange = count <= (currentCardSchema == .amex ? 4 : 3)
            return shouldChange
        } else {
            let shouldChange = count <= viewModel?.fieldMaxLimit ?? 120 //Todo
            return shouldChange
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.onTextFieldDidFinishEditing(self)
        guard let viewModel = viewModel else { return } //TODO: notify about an error
        guard viewModel.type != .billingCountry else {
            // country selection is pre-defined and doesn't need to be validated
            setState(.normal)
            return
        }
        let fieldState = viewModel.validateField(textField.text)
        setState(fieldState)
    }
}
