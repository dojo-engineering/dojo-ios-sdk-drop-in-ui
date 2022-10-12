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

class DojoInputField: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var labelTop: UILabel!
    @IBOutlet weak var textFieldMain: UITextField!
    @IBOutlet weak var imageViewBottom: UIImageView!
    @IBOutlet weak var labelBottom: UILabel!
    
    var viewModel: DojoInputFieldViewModelProtocol?
    
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
        addSubview(contentView)
    }
    
    func setType(_ type: DojoInputFieldType) {
        self.viewModel = DojoInputFieldViewModel(type: type)
        setState(.normal)
        reloadUI()
    }
    
    func reloadUI() {
        guard let viewModel = viewModel else { return } //TODO: notify about an error
        textFieldMain.keyboardType = viewModel.fieldKeyboardType
        textFieldMain.placeholder = viewModel.fieldPlaceholder
        labelTop.text = viewModel.fieldName
        labelBottom.text = viewModel.fieldError
    }
    
    func setTheme(theme: ThemeSettings) {
        labelTop.font = theme.fontSubtitle1
        labelTop.textColor = theme.primaryLabelTextColor
        
        labelBottom.font = theme.fontSubtitle2
        labelBottom.textColor = theme.errorTextColor
    }
    
    func setState(_ state: DojoInputFieldState) {
        switch state {
        case .normal:
            imageViewBottom.isHidden = true
            labelBottom.isHidden = true
            textFieldMain.layer.borderWidth = 1.0
            textFieldMain.layer.borderColor = UIColor.black.withAlphaComponent(0.6).cgColor
            textFieldMain.layer.cornerRadius = 4
        case .activeInput:
            imageViewBottom.isHidden = true
            labelBottom.isHidden = true
            textFieldMain.layer.borderWidth = 1.0
            textFieldMain.layer.borderColor = UIColor(hex: "#00857DFF")?.cgColor ?? UIColor.systemGreen.cgColor
            textFieldMain.layer.cornerRadius = 4
        case .error:
            imageViewBottom.isHidden = false
            labelBottom.isHidden = false
            textFieldMain.layer.borderWidth = 1.0
            textFieldMain.layer.borderColor = UIColor(hex: "#B00020FF")?.cgColor ?? UIColor.systemRed.cgColor
            textFieldMain.layer.cornerRadius = 4
        }
    }
}

extension DojoInputField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setState(.activeInput)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setState(.normal)
    }
}


protocol DojoInputFieldViewModelProtocol {
    init(type: DojoInputFieldType)
    var fieldKeyboardType: UIKeyboardType {get}
    var fieldPlaceholder: String {get}
    var fieldName: String {get}
    var fieldError: String {get}
}

class DojoInputFieldViewModel: DojoInputFieldViewModelProtocol {
    
    let type: DojoInputFieldType
    
    required init(type: DojoInputFieldType) {
        self.type = type
    }
    
    var fieldKeyboardType: UIKeyboardType {
        get {
            switch type {
            case .email:
                return .emailAddress
            case .cardNumber, .expiry, .cvv:
                return .numberPad
            default:
                return .default
            }
        }
    }
    
    var fieldPlaceholder: String {
        get {
            switch type {
            case .cardNumber:
                return "1234 1234 1234 1234"
            case .cvv:
                return "CVC"
            case .expiry:
                return "MM/YY"
            case .billingPostcode:
                return "Postcode"
            default:
                return ""
            }
        }
    }
    
    var fieldName: String {
        get {
            switch type {
            case .email:
                return "Email" //TODO: move to translations
            case .cardHolderName:
                return "Name on card"
            case .cardNumber:
                return "Debit/Credit Card number"
            case .billingCountry:
                return "Billing Country"
            case .billingPostcode:
                return "Billing Postcode"
            case .expiry:
                return "Expiry"
            case .cvv:
                return "CVC"
            }
        }
    }
    
    var fieldError: String {
        get {
            return "Please enter your name"
        }
    }
}
