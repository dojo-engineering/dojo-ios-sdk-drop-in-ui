//
//  DojoInputField.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 06/10/2022.
//

import UIKit

enum DojoInputFieldType {
    case email
    case cardHolderName
    case cardNumber
    case billingCountry
    case billingPostcode
    case expiry
    case cvv
}

enum DojoInputFieldState {
    case normal
    case activeInput
    case error
}

struct CountryDropdownItem {
    let title: String
    let isoCode: String
}

protocol DojoInputFieldDelegate {
    func onNextField(_ from: DojoInputField)
    func onPreviousField(_ from: DojoInputField)
    func onTextFieldDidFinishEditing(_ from: DojoInputField)
    func onTextFieldBeginEditing(_ from: DojoInputField)
    func onTextChange(_ from: DojoInputField)
}

class DojoInputField: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var labelTop: UILabel!
    @IBOutlet weak var textFieldMain: UITextField!
    @IBOutlet weak var imageViewBottom: UIImageView!
    @IBOutlet weak var labelBottom: UILabel!
    @IBOutlet weak var constrainLabelBottomLeft: NSLayoutConstraint!
    var viewModel: DojoInputFieldViewModelProtocol?
    var delegate: DojoInputFieldDelegate?
    var picker: UIPickerView?
    var selectedPickerPosition: Int = 0
    var currentCardSchema: CardSchemes = .visa
    var theme: ThemeSettings?
    var dropDownCountries: [CountryDropdownItem] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: String(describing: type(of: self)),
                        bundle: Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        textFieldMain.delegate = self
        textFieldMain.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        addSubview(contentView)
        addLeftPaddingView()
    }
    
    func getType() -> DojoInputFieldType? {
        guard let viewModel = viewModel else { return nil } //TODO: notify about an error
        return viewModel.type
    }
    
    func setType(_ type: DojoInputFieldType, delegate: DojoInputFieldDelegate) {
        self.viewModel = DojoInputFieldViewModel(type: type)
        self.delegate = delegate
        setUpFieldForCurrentType()
        setState(.normal)
        reloadUI()
    }
    
    override func becomeFirstResponder() -> Bool {
        textFieldMain.becomeFirstResponder()
    }
    
    func reloadUI() {
        guard let viewModel = viewModel else { return } //TODO: notify about an error
        textFieldMain.keyboardType = viewModel.fieldKeyboardType
        textFieldMain.placeholder = viewModel.fieldPlaceholder
        labelTop.text = viewModel.fieldName
        labelBottom.text = viewModel.fieldError
    }
    
    func setTheme(theme: ThemeSettings) {
        self.theme = theme
        labelTop.font = theme.fontSubtitle1
        labelTop.textColor = theme.primaryLabelTextColor
        
        labelBottom.font = theme.fontSubtitle2
        labelBottom.textColor = theme.errorTextColor
        
        textFieldMain.backgroundColor = theme.inputFieldBackgroundColor
        textFieldMain.textColor = theme.primaryLabelTextColor
        textFieldMain.keyboardAppearance = theme.lightStyleForDefaultElements ? .light : .dark
        
        imageViewBottom.image = UIImage.getFieldErrorIcon(lightVersion: theme.lightStyleForDefaultElements)
    }
    
    func setUpFieldForCurrentType() {
        switch viewModel?.type {
        case .billingCountry:
            setUpFieldForCountriesDropDown()
        default:
            break
        }
    }
    
    func setState(_ state: DojoInputFieldState) {
        switch state {
        case .normal:
            imageViewBottom.isHidden = true
            labelBottom.isHidden = true
            textFieldMain.layer.borderWidth = 1.0
            textFieldMain.layer.borderColor = self.theme?.inputFieldDefaultBorderColor.cgColor ?? UIColor.black.withAlphaComponent(0.15).cgColor
            textFieldMain.layer.cornerRadius = 4
        case .activeInput:
            imageViewBottom.isHidden = true
            labelBottom.isHidden = true
            textFieldMain.layer.borderWidth = 2.0
            textFieldMain.layer.borderColor = self.theme?.inputFieldSelectedBorderColor.cgColor ?? UIColor.systemGreen.cgColor
            textFieldMain.layer.cornerRadius = 4
        case .error:
            imageViewBottom.isHidden = false
            labelBottom.isHidden = false
            textFieldMain.layer.borderWidth = 1.0
            textFieldMain.layer.borderColor = self.theme?.errorTextColor.cgColor ?? UIColor.systemRed.cgColor
            textFieldMain.layer.cornerRadius = 4
            let isTextEmpty = textFieldMain.text?.isEmpty ?? true
            labelBottom.text = isTextEmpty ? viewModel?.fieldErrorEmpty : viewModel?.fieldError
        }
    }
    
    func isValid() -> Bool {
        if viewModel?.validateField(textFieldMain.text) == .normal {
            return true
        } else {
            return false
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.onTextChange(self)
    }
}

extension DojoInputField: UITextFieldDelegate {
    
//    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        guard let viewModel = viewModel else { return true } //TODO: notify about an error
//        if viewModel.type == .billingCountry, // disable paste for billing field
//           action == #selector(UIResponderStandardEditActions.paste(_:))  {
//            return false
//        }
//        return super.canPerformAction(action, withSender: sender)
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.onTextFieldBeginEditing(self)
        guard let viewModel = viewModel else { return } //TODO: notify about an error
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
            if let cardScheme = viewModel?.getCardScheme(updatedString) {
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
