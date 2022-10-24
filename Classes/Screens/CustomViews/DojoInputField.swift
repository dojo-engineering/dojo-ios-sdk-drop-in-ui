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
    func onTextFieldBeginEditing(_ from: DojoInputField)
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
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        textFieldMain.leftView = paddingView
        textFieldMain.leftViewMode = .always
        
        if type == .billingCountry { //TODO: switch
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
            textFieldMain.layer.borderColor = UIColor.black.withAlphaComponent(0.15).cgColor
            textFieldMain.layer.cornerRadius = 4
        case .activeInput:
            imageViewBottom.isHidden = true
            labelBottom.isHidden = true
            textFieldMain.layer.borderWidth = 2.0
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
    
    func isValid() -> Bool {
        if viewModel?.validateField(textFieldMain.text) == .normal {
            return true
        } else {
            return false
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
            return false
        }
        
        if getType() == .cardNumber {
            // only allow numerical characters
            guard string.compactMap({ Int(String($0)) }).count ==
                    string.count else { return false }
            if let cardScheme = viewModel?.getCardScheme(updatedString) {
                let image = UIImage.getCardIcon(icon: cardScheme)
                textFieldMain.rightImage(image, imageWidth: 25, padding: 10)
            } else {
                textFieldMain.rightImage(nil, imageWidth: 0, padding: 10)
            }
            
            let maxNumberOfCharacters = 20
            
            let text = textField.text ?? ""
            if string.count == 0 {
                textField.text = String(text.dropLast()).chunkFormatted()
            }
            else {
                let newText = String((text + string).filter({ $0 != " " }).prefix(maxNumberOfCharacters))
                textField.text = newText.chunkFormatted()
            }
            return false
        }
        
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= viewModel?.fieldMaxLimit ?? 120 //Todo
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
    var fieldMaxLimit: Int {get}
    var type: DojoInputFieldType {get}
    
    func validateField(_ text: String?) -> DojoInputFieldState
    func getCardScheme(_ text: String?) -> UIImageCardIcon?
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
                return LocalizedText.CardDetailsCheckout.placeholderPan
            case .cvv:
                return LocalizedText.CardDetailsCheckout.placeholderCVV
            case .expiry:
                return LocalizedText.CardDetailsCheckout.placeholderExpiry
            case .billingPostcode:
                return "Postcode" //TODO: move to translations
            default:
                return ""
            }
        }
    }
    
    var fieldName: String {
        get {
            switch type {
            case .email:
                return LocalizedText.CardDetailsCheckout.fieldEmail
            case .cardHolderName:
                return LocalizedText.CardDetailsCheckout.fieldCardName
            case .cardNumber:
                return LocalizedText.CardDetailsCheckout.fieldPan
            case .billingCountry:
                return LocalizedText.CardDetailsCheckout.fieldBillingCountry
            case .billingPostcode:
                return LocalizedText.CardDetailsCheckout.fieldBillingPostcode
            case .expiry:
                return LocalizedText.CardDetailsCheckout.fieldExpiryDate
            case .cvv:
                return LocalizedText.CardDetailsCheckout.fieldCVV
            }
        }
    }
    
    var fieldError: String {
        get {
            switch type {
            case .email:
                return LocalizedText.CardDetailsCheckout.errorInvalidEmail
            case .cardNumber:
                return LocalizedText.CardDetailsCheckout.errorInvalidPan
            case .expiry:
                return LocalizedText.CardDetailsCheckout.errorInvalidExpiry
            case .cvv:
                return LocalizedText.CardDetailsCheckout.errorInvalidCVV
            default:
                return ""
            }
        }
    }
    
    var fieldErrorEmpty: String {
        get {
            switch type {
            case .email:
                return LocalizedText.CardDetailsCheckout.errorEmptyEmail
            case .cardHolderName:
                return LocalizedText.CardDetailsCheckout.errorEmptyCardHolder
            case .cardNumber:
                return LocalizedText.CardDetailsCheckout.errorEmptyPan
            case .billingCountry:
                return ""
            case .billingPostcode:
                return LocalizedText.CardDetailsCheckout.errorEmptyBillingPostcode
            case .expiry:
                return LocalizedText.CardDetailsCheckout.errorEmptyExpiry
            case .cvv:
                return LocalizedText.CardDetailsCheckout.errorEmptyCvv
            }
        }
    }
    
    var fieldMaxLimit: Int {
        get {
            switch type {
            case .cardNumber:
                return 20
            case .cvv:
                return 4
            case .billingPostcode:
                return 50
            default:
                return 120
            }
        }
    }
}

extension DojoInputFieldViewModel {
    
    func validateField(_ text: String?) -> DojoInputFieldState {
        guard let text = text else { return .error}
        if text.isEmpty { return .error }
        switch type {
        case .email:
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if !emailPred.evaluate(with: text) {
                return .error
            }
        case .cardNumber:
            if !luhnCheck(text.replacingOccurrences(of: " ", with: "")) {
                return .error
            }
        case .expiry:
            let textItems = text.split(separator: "/")
            if let month = textItems.first,
               let year = textItems.last,
               let monthInt = Int(month),
            let yearInt = Int(year),
            monthInt > 0 && monthInt < 13,
            yearInt > 21 && yearInt < 99 {
                return .normal
            } else {
                return .error
            }
        case .cvv:
            if text.count > 2 { //TODO: add amex check 
                return .normal
            } else {
                return  .error
            }
        default:
            return .normal
        }
        
        return .normal
    }
    
    func isEmailValid(_ email: String) -> Bool {
        return false
    }
    
    func luhnCheck(_ number: String) -> Bool {
        var sum = 0
        let digitStrings = number.reversed().map { String($0) }

        for tuple in digitStrings.enumerated() {
            if let digit = Int(tuple.element) {
                let odd = tuple.offset % 2 == 1

                switch (odd, digit) {
                case (true, 9):
                    sum += 9
                case (true, 0...8):
                    sum += (digit * 2) % 9
                default:
                    sum += digit
                }
            } else {
                return false
            }
        }
        return sum % 10 == 0
    }
    
    func getCardScheme(_ text: String?) -> UIImageCardIcon? {
        let amexRegEx = "^3[47].*$"
        let amexPred = NSPredicate(format:"SELF MATCHES %@", amexRegEx)
        if amexPred.evaluate(with: text) {
            return .amex
        }
        
        let visaRegEx = "^4.*$"
        let visaPred = NSPredicate(format:"SELF MATCHES %@", visaRegEx)
        if visaPred.evaluate(with: text) {
            return .visa
        }
        
        let masterRegEx = "^5[12345].*$"
        let masterPred = NSPredicate(format:"SELF MATCHES %@", masterRegEx)
        if masterPred.evaluate(with: text) {
            return .mastercard
        }
        
        let maestroRegEx = "^(5018|5020|5038|6304|6759|6761|6763).*$"
        let maestroPred = NSPredicate(format:"SELF MATCHES %@", maestroRegEx)
        if maestroPred.evaluate(with: text) {
            return .maestro
        }
        
        return nil
    }
}


extension NSLayoutDimension {

@discardableResult
func set(
        to constant: CGFloat,
        priority: UILayoutPriority = .required
        ) -> NSLayoutConstraint {

        let cons = constraint(equalToConstant: constant)
        cons.priority = priority
        cons.isActive = true
        return cons
    }
}

extension UITextField {
    func leftImage(_ image: UIImage?, imageWidth: CGFloat, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: padding, y: 0, width: imageWidth, height: frame.height)
        imageView.contentMode = .center
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth + 2 * padding, height: frame.height))
        containerView.addSubview(imageView)
        leftView = containerView
        leftViewMode = .always
    }
    
    func rightImage(_ image: UIImage?, imageWidth: CGFloat, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: padding, y: 0, width: imageWidth, height: frame.height)
        imageView.contentMode = .scaleAspectFit
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth + 2 * padding, height: frame.height))
        containerView.addSubview(imageView)
        rightView = containerView
        rightViewMode = .always
    }
}


extension Collection {
    public func chunk(n: IndexDistance) -> [SubSequence] {
        var res: [SubSequence] = []
        var i = startIndex
        var j: Index
        while i != endIndex {
            j = index(i, offsetBy: n, limitedBy: endIndex) ?? endIndex
            res.append(self[i..<j])
            i = j
        }
        return res
    }
}

extension String {
    func chunkFormatted(withChunkSize chunkSize: Int = 4,
        withSeparator separator: Character = " ") -> String {
        return filter { $0 != separator }.chunk(n: chunkSize)
            .map{ String($0) }.joined(separator: String(separator))
    }
}
