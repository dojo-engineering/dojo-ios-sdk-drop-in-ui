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

protocol DojoInputFieldDelegate {
    func onNextField(_ from: DojoInputField)
    func onPreviousField(_ from: DojoInputField)
    func onTextFieldDidFinishEditing(_ from: DojoInputField)
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
    
    func getType() -> DojoInputFieldType? {
        guard let viewModel = viewModel else { return nil } //TODO: notify about an error
        return viewModel.type
    }
    
    func setType(_ type: DojoInputFieldType, delegate: DojoInputFieldDelegate) {
        self.viewModel = DojoInputFieldViewModel(type: type)
        self.delegate = delegate
        if type == .billingCountry {
            let displayingItem = getCSVData()?[selectedPickerPosition] //TODO: make sure it won't crash
            textFieldMain.text = displayingItem
        }
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
        
        //TODO: base on type update bottom label position and text
        // additional text or error constrainLabelBottomLeft
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
            let isTextEmpty = textFieldMain.text?.isEmpty ?? true
            labelBottom.text = isTextEmpty ? viewModel?.fieldErrorEmpty : viewModel?.fieldError
        }
    }
}

extension DojoInputField: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        getCSVData()?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        getCSVData()?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPickerPosition = row
        textFieldMain.text = getCSVData()?[row]
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let viewModel = viewModel else { return } //TODO: notify about an error
        delegate?.onTextFieldDidFinishEditing(self)
        guard viewModel.type != .billingCountry else {
            // country selection is pre-defined and doesn't need to be validated
            setState(.normal)
            return
        }
        let fieldState = viewModel.validateField(textField.text)
        setState(fieldState)
    }
    
    func getTextFieldAccessoryView() -> UIToolbar {
        let toolBar: UIToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        toolBar.barStyle = UIBarStyle.default
        
        let flexsibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil) // flexible space to add left end side
        let doneButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(didPressDoneKeyboardButton))
        let nextButton: UIBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(didPressNextKeybaordButton)) //TODO: add to localisation
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(didPressBackKeybaordButton)) //TODO: add to localisation
        toolBar.items = [backButton, nextButton, flexsibleSpace, doneButton]
        return toolBar
    }
    
    func setupTextFieldsAccessoryView() {
        guard textFieldMain.inputAccessoryView == nil else {
            print("textfields accessory view already set up")
            return
        }
        
        textFieldMain.inputAccessoryView = getTextFieldAccessoryView()
    }
    
    @objc func didPressBackKeybaordButton(button: UIButton) {
        delegate?.onPreviousField(self)
    }
    
    @objc func didPressNextKeybaordButton(button: UIButton) {
        delegate?.onNextField(self)
    }
    
    @objc func didPressDoneKeyboardButton(button: UIButton) {
        // Button has been pressed
        // Process the containment of the textfield or whatever
        
        // Hide keyboard
        textFieldMain.resignFirstResponder()
    }
    
    func getCSVData() -> Array<String>? {
        let bundle = Bundle(for: type(of: self))
        guard let countriesCSV = bundle.url(forResource: "countries", withExtension: "csv") else {
            return nil
        }
        
        do {
            let content = try String(contentsOf: countriesCSV)
            var parsedCSV: [String] = content.components(
                separatedBy: "\n"
            ).map{ $0.components(separatedBy: ",")[0] }
            if parsedCSV.count > 0 {
                parsedCSV.removeFirst()
            }
            return parsedCSV
        }
        catch {
            return []
        }
    }
}


protocol DojoInputFieldViewModelProtocol {
    init(type: DojoInputFieldType)
    var fieldKeyboardType: UIKeyboardType {get}
    var fieldPlaceholder: String {get}
    var fieldName: String {get}
    var fieldError: String {get}
    var fieldErrorEmpty: String {get}
    var type: DojoInputFieldType {get}
    
    func validateField(_ text: String?) -> DojoInputFieldState
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
                return "Card number"
            case .billingCountry:
                return "Billing Country"
            case .billingPostcode:
                return "Postcode"
            case .expiry:
                return "Expiry date"
            case .cvv:
                return "CVC"
            }
        }
    }
    
    var fieldError: String {
        get {
            switch type {
            case .email:
                return "Please fill in a valid email address"
            case .cardHolderName:
                return "Enter your name exactly as it’s written on your card"
            case .cardNumber:
                return "Enter your card number"
            case .billingCountry:
                return ""
            case .billingPostcode:
                return "Please enter a valid postcode"
            case .expiry:
                return "Enter a valid expiry date"
            case .cvv:
                return "Enter a valid security code"
            }
        }
    }
    
    var fieldErrorEmpty: String {
        get {
            switch type {
            case .email:
                return "Please fill in an email address"
            case .cardHolderName:
                return "Enter your name exactly as it’s written on your card"
            case .cardNumber:
                return "Enter your card number"
            case .billingCountry:
                return ""
            case .billingPostcode:
                return "Please enter your billing postcode"
            case .expiry:
                return "Enter expiry date"
            case .cvv:
                return "Enter security code"
            }
        }
    }
}

extension DojoInputFieldViewModel {
    
    func validateField(_ text: String?) -> DojoInputFieldState {
        // can't be empty
        if text?.isEmpty ?? true { return .error }
        return .error
    }
    
    func isEmailValid(_ email: String) -> Bool {
        return false
    }
}
