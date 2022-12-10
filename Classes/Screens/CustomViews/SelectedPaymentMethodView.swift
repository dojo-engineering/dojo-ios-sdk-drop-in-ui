//
//  SelectedPaymentMethodView.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 12/09/2022.
//

import UIKit

enum SelectedPaymentMethodViewStyle {
    case applePay
    case card
}

protocol SelectedPaymentMethodViewDelegate {
    func onPress(_ item: PaymentMethodItem)
    func onCVVStateChange(_ isValid: Bool)
}

class SelectedPaymentMethodView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var imageViewCardIcon: UIImageView!
    @IBOutlet weak var imgArrowRight: UIImageView!
    @IBOutlet weak var labelMainTitle: UILabel!
    @IBOutlet weak var labelSubtitle1: UILabel!
    @IBOutlet weak var labelSubtitle2: UILabel!
    @IBOutlet weak var mainTextField: UITextField!
    
    public var delegate: SelectedPaymentMethodViewDelegate?
    var paymentMethod: PaymentMethodItem?
    
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
        mainTextField.delegate = self
        addSubview(contentView)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        contentView.addGestureRecognizer(tap)
        
        // Additional setup
        setStyle()
    }
    
    func setTheme(theme: ThemeSettings) {
        imgArrowRight.tintColor = theme.headerButtonTintColor
        labelMainTitle.font = theme.fontSubtitle1
        labelMainTitle.textColor = theme.primaryLabelTextColor
        
        labelSubtitle1.font = theme.fontBody2
        labelSubtitle1.textColor = theme.primaryLabelTextColor
        
        labelSubtitle2.font = theme.fontSubtitle2
        labelSubtitle2.textColor = theme.secondaryLabelTextColor
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 16))
        mainTextField.leftView = paddingView
        mainTextField.leftViewMode = .always
        mainTextField.keyboardAppearance = theme.lightStyleForDefaultElements ? .light : .dark
        mainTextField.textColor = theme.primaryLabelTextColor
        mainTextField.backgroundColor = theme.inputFieldBackgroundColor
        mainTextField.layer.borderColor = theme.inputFieldDefaultBorderColor.cgColor
        mainTextField.layer.borderWidth = 1.0
        mainTextField.layer.cornerRadius = 4
    }
    
    func setStyle(_ style: SelectedPaymentMethodViewStyle = .applePay) {
        mainTextField.isHidden = true
        labelSubtitle1.isHidden = true
        labelSubtitle2.isHidden = true
        labelMainTitle.isHidden = true
        switch style {
        case .applePay:
            mainTextField.isHidden = true
            labelMainTitle.isHidden = false
        case .card:
            mainTextField.isHidden = false
            labelSubtitle1.isHidden = false
            labelSubtitle2.isHidden = false
        }
    }
    
    func setPaymentMethod(_ item: PaymentMethodItem) {
        self.paymentMethod = item
        mainTextField.text = ""
        switch item.type {
        case .applePay:
            setStyle(.applePay) //TODO: refactor
            imageViewCardIcon.image = UIImage(named: "img-apple-pay-logo", in: Bundle(for: type(of: self)), compatibleWith: nil)
        case .visa:
            setStyle(.card)
            labelSubtitle1.text = "Visa"
            labelSubtitle2.text = item.title
            imageViewCardIcon.image = UIImage.getCardIcon(icon: .visa)
        case .mastercard:
            setStyle(.card)
            labelSubtitle1.text = "Mastercard"
            labelSubtitle2.text = item.title
            imageViewCardIcon.image = UIImage.getCardIcon(icon: .mastercard)
        case .maestro:
            setStyle(.card)
            labelSubtitle1.text = "Maestro"
            labelSubtitle2.text = item.title
            imageViewCardIcon.image = UIImage.getCardIcon(icon: .maestro)
        case .amex:
            setStyle(.card)
            labelSubtitle1.text = "Amex"
            labelSubtitle2.text = item.title
            imageViewCardIcon.image = UIImage.getCardIcon(icon: .amex)
        }
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if let paymentMethod = paymentMethod {
            delegate?.onPress(paymentMethod)
        } else {
            delegate?.onPress(PaymentMethodItem(id: "", title: "", type: .applePay))
        }
    }
}

extension SelectedPaymentMethodView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mainTextField.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // only allow numerical characters
        guard string.compactMap({ Int(String($0)) }).count ==
                string.count else { return false }
        
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        let numberOfCharacters = paymentMethod?.type == .amex ? 4 : 3
        let shouldChange = updatedString?.count ?? 0 <= numberOfCharacters
        
        if updatedString?.count ?? 0 >= numberOfCharacters {
            delegate?.onCVVStateChange(true)
        } else {
            delegate?.onCVVStateChange(false)
        }
        return shouldChange
    }
}
