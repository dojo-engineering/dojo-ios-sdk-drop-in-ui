//
//  DojoInputField.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 06/10/2022.
//

import UIKit

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
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var labelCounter: UILabel!
    @IBOutlet weak var constrainLabelBottomLeft: NSLayoutConstraint!
    @IBOutlet weak var textViewMain: UITextView!
    
    var viewModel: DojoInputFieldViewModelProtocol?
    var delegate: DojoInputFieldDelegate?
    var picker: UIPickerView?
    var selectedPickerPosition: Int = 0
    var currentCardSchema: CardSchemes = .visa
    var theme: ThemeSettings?
    var dropDownCountries: [CountryDropdownItem] = [] //TODO: move to viewModel
    
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
                        bundle: Bundle.libResourceBundle)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        textFieldMain.delegate = self
        textFieldMain.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        textViewMain.delegate = self
        addSubview(contentView)
        addLeftPaddingView()
    }
    
    func getType() -> DojoInputFieldType? {
        guard let viewModel = viewModel else { return nil }
        return viewModel.type
    }
    
    func setType(_ type: DojoInputFieldType,
                 showSubtitle: Bool = false,
                 delegate: DojoInputFieldDelegate) {
        self.viewModel = DojoInputFieldViewModel(type: type, withSubtitle: showSubtitle)
        self.delegate = delegate
        setUpFieldForCurrentType()
        setState(.normal)
        reloadUI()
    }
    
    func reloadUI() {
        guard let viewModel = viewModel else { return }
        textFieldMain.keyboardType = viewModel.fieldKeyboardType
        textFieldMain.placeholder = viewModel.fieldPlaceholder
        labelTop.text = viewModel.fieldName
        labelBottom.text = viewModel.fieldError
        
        if !viewModel.isRequired {
           addOptional(label: labelTop)
        }
        
        textViewMain.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10); 
    }
    
    func setTheme(theme: ThemeSettings) {
        self.theme = theme
        labelTop.font = theme.fontSubtitle1
        labelTop.textColor = theme.primaryLabelTextColor
        
        labelBottom.font = theme.fontSubtitle2
        labelBottom.textColor = theme.errorTextColor
        
        labelSubtitle.font = theme.fontSubtitle2
        labelSubtitle.textColor = theme.secondaryLabelTextColor
        
        labelCounter.font = theme.fontSubtitle2
        labelCounter.textColor = theme.secondaryLabelTextColor
        
        textFieldMain.backgroundColor = theme.inputFieldBackgroundColor
        textFieldMain.textColor = theme.primaryLabelTextColor
        textFieldMain.keyboardAppearance = theme.lightStyleForDefaultElements ? .light : .dark
        
        imageViewBottom.image = UIImage.getFieldErrorIcon(lightVersion: theme.lightStyleForDefaultElements)
    }
    
    func setUpFieldForCurrentType() {
        switch viewModel?.type {
        case .billingCountry, .shippingCountry:
            setUpFieldForCountriesDropDown()
        default:
            break
        }
    }
    
    func setState(_ state: DojoInputFieldState) {
        switch state {
        case .normal:
            imageViewBottom.isHidden = true
            textViewMain.isHidden = !isTextViewField()
            textFieldMain.isHidden = !textViewMain.isHidden
            labelSubtitle.isHidden = !showSubtitle()
            labelCounter.isHidden = !showSymolsCounter()
            labelBottom.isHidden = true
            textFieldMain.layer.borderWidth = 1.0
            textFieldMain.layer.borderColor = self.theme?.inputFieldDefaultBorderColor.cgColor ?? UIColor.black.withAlphaComponent(0.15).cgColor
            textFieldMain.layer.cornerRadius = 4
            
            textViewMain.layer.borderWidth = 1.0
            textViewMain.layer.borderColor = self.theme?.inputFieldDefaultBorderColor.cgColor ?? UIColor.black.withAlphaComponent(0.15).cgColor
            textViewMain.layer.cornerRadius = 4
        case .activeInput:
            imageViewBottom.isHidden = true
            labelSubtitle.isHidden = !showSubtitle()
            labelCounter.isHidden = !showSymolsCounter()
            textViewMain.isHidden = !isTextViewField()
            textFieldMain.isHidden = !textViewMain.isHidden
            labelBottom.isHidden = true
            textFieldMain.layer.borderWidth = 2.0
            textFieldMain.layer.borderColor = self.theme?.inputFieldSelectedBorderColor.cgColor ?? UIColor.systemGreen.cgColor
            textFieldMain.layer.cornerRadius = 4
            
            textViewMain.layer.borderWidth = 2.0
            textViewMain.layer.borderColor = self.theme?.inputFieldSelectedBorderColor.cgColor ?? UIColor.systemGreen.cgColor
            textViewMain.layer.cornerRadius = 4
        case .error:
            imageViewBottom.isHidden = false
            labelBottom.isHidden = false
            labelSubtitle.isHidden = true
            labelCounter.isHidden = true
            textViewMain.isHidden = !isTextViewField()
            textFieldMain.isHidden = !textViewMain.isHidden
            textFieldMain.layer.borderWidth = 1.0
            textFieldMain.layer.borderColor = self.theme?.errorTextColor.cgColor ?? UIColor.systemRed.cgColor
            textFieldMain.layer.cornerRadius = 4
            
            textViewMain.layer.borderWidth = 1.0
            textViewMain.layer.borderColor = self.theme?.errorTextColor.cgColor ?? UIColor.systemRed.cgColor
            textViewMain.layer.cornerRadius = 4
            
            let isTextEmpty = textFieldMain.text?.isEmpty ?? true
            labelBottom.text = isTextEmpty ? viewModel?.fieldErrorEmpty : viewModel?.fieldError
        }
    }
    
    func isValid() -> Bool {
        viewModel?.validateField(textFieldMain.text) == .normal
    }
    
    func showSubtitle() -> Bool {
        viewModel?.subtitle != nil
    }
    
    func showSymolsCounter() -> Bool {
        viewModel?.type == .shippingDeliveryNotes
    }
    
    func updateSymbolsCounter(symbols: Int, max: Int) {
        labelCounter.text = "\(symbols)/\(max)"
    }
    
    func isTextViewField() -> Bool {
        viewModel?.type == .shippingDeliveryNotes
    }
    
    func addOptional(label: UILabel) {
        label.text?.append(" (optional)")
        if let range = (label.text as? NSString)?.range(of: "(optional)"),
        let mainString = label.text {
            let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
            mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: theme?.secondaryLabelTextColor ?? .lightGray, range: range)
            label.attributedText = mutableAttributedString
        }
    }
}
