//
//  CardDetailsViewController.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 02/08/2022.
//

import UIKit
import dojo_ios_sdk

protocol CardDetailsCheckoutViewControllerDelegate: BaseViewControllerDelegate {
}

class CardDetailsCheckoutViewController: BaseUIViewController {
    
    var delegate: CardDetailsCheckoutViewControllerDelegate?
    var inputFields: [DojoInputField] = []
    
    @IBOutlet weak var constraintPayButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var labelPrimaryAmount: UILabel!
    @IBOutlet weak var labelYouPay: UILabel!
    @IBOutlet weak var labelSaveCardForFutureUse: UILabel!
    @IBOutlet weak var buttonPay: LoadingButton!
    
    @IBOutlet weak var imageViewSaveCardCheckbox: UIImageView!
    @IBOutlet weak var fieldEmail: DojoInputField!
    @IBOutlet weak var fieldCardholder: DojoInputField!
    @IBOutlet weak var fieldCardNumber: DojoInputField!
    @IBOutlet weak var fieldExpiry: DojoInputField!
    @IBOutlet weak var fieldCVV: DojoInputField!
    @IBOutlet weak var fieldBillingCountry: DojoInputField!
    @IBOutlet weak var fieldBillingPostcode: DojoInputField!
    @IBOutlet weak var mainContentScrollView: UIScrollView!
    @IBOutlet weak var containerSavedCard: UIView!
    @IBOutlet weak var containerCardsStrip: UIStackView!
    
    public init(viewModel: CardDetailsCheckoutViewModel,
                theme: ThemeSettings,
                delegate : CardDetailsCheckoutViewControllerDelegate) {
        self.delegate = delegate
        let nibName = String(describing: type(of: self))
        let podBundle = Bundle(for: type(of: self))
        super.init(nibName: nibName, bundle: podBundle)
        self.viewModel = viewModel
        self.baseDelegate = delegate
        self.theme = theme
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        setUpViews()
    }
    
    override func setUpDesign() {
        super.setUpDesign()
        
        buttonPay.setTheme(theme)
        
        labelYouPay.textColor = theme.primaryLabelTextColor
        labelYouPay.font = theme.fontSubtitle1Medium
        
        labelPrimaryAmount.textColor = theme.primaryLabelTextColor
        labelPrimaryAmount.font = theme.fontHeading3Medium
        
        labelSaveCardForFutureUse.font = theme.fontSubtitle1
        labelSaveCardForFutureUse.textColor = UIColor.black.withAlphaComponent(0.6) //TODO
        
        fieldEmail.setTheme(theme: theme)
        fieldCardholder.setTheme(theme: theme)
        fieldCardNumber.setTheme(theme: theme) // TODO refactor
        
        fieldBillingCountry.setTheme(theme: theme)
        fieldBillingPostcode.setTheme(theme: theme)
        fieldExpiry.setTheme(theme: theme)
        fieldCVV.setTheme(theme: theme)
    }
    
    func getViewModel() -> CardDetailsCheckoutViewModel? {
        viewModel as? CardDetailsCheckoutViewModel
    }
    
    func setUpData() {
        //TODO: proper formatter
        let amountText = "\(String(format: "%.2f", Double(getViewModel()?.paymentIntent.amount.value ?? 0)/100.0))"
        let buttonPayTitle = "Pay £\(amountText)"
        buttonPay.setTitle(buttonPayTitle, for: .normal)
        
        
        let fontCurrency = [NSAttributedString.Key.font : theme.fontBody1] // TODO: correct font
        let fontAmount = [NSAttributedString.Key.font : theme.fontHeading3Medium]
        let gbpString = NSMutableAttributedString(string:"£", attributes: fontCurrency)
        let attributedString = NSMutableAttributedString(string: amountText, attributes: fontAmount)
        gbpString.append(attributedString)
        labelPrimaryAmount.attributedText = gbpString
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
    
    @objc func keyboardWillHide(_ notification: Notification) {
        constraintPayButtonBottom.constant = 52
    }
    
    func setUpSaveCardCheckbox() {
//        containerSavedCard.isHidden = true // TODO: get from BE
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleOnSaveCardCheckboxPress))
        containerSavedCard.addGestureRecognizer(tap)
    }
    
    func setUpCardsStrip() {
        //TODO: a better function for that
        guard let viewModel = getViewModel() else { return }
        viewModel.supportedCardSchemes.forEach({
            if let image = UIImage.getCardIcon(type: $0) {
                let imageView = UIImageView(frame: CGRectMake(0, 0, 40, 20))
                imageView.image = image
                imageView.contentMode = .scaleAspectFit
                containerCardsStrip.addArrangedSubview(imageView)
            }
        })
    }
    
    @objc func handleOnSaveCardCheckboxPress() {
        //TODO: hide the save card view at all if needed
        guard let viewModel = getViewModel() else { return }
        viewModel.isSaveCardSelected = !viewModel.isSaveCardSelected
        if viewModel.isSaveCardSelected {
            imageViewSaveCardCheckbox.image = UIImage(named: "icon-checkbox-checked", in: Bundle(for: type(of: self)), compatibleWith: nil)
        } else {
            imageViewSaveCardCheckbox.image = UIImage(named: "icon-checkbox-unchecked", in: Bundle(for: type(of: self)), compatibleWith: nil)
        }
        print("On saved card pressed")
    }
    
    func setUpViews() {
        footerPoweredByDojoView?.setStyle(FooterPoweredByDojoStyle.checkoutPage)
        
        fieldEmail.setType(.email, delegate: self)
        fieldCardholder.setType(.cardHolderName, delegate: self)
        fieldCardNumber.setType(.cardNumber, delegate: self)
        fieldBillingCountry.setType(.billingCountry, delegate: self)
        fieldBillingPostcode.setType(.billingPostcode, delegate: self)
        fieldExpiry.setType(.expiry, delegate: self)
        fieldCVV.setType(.cvv, delegate: self)
        
        let billingIsHidden = !(getViewModel()?.showFieldBilling ?? false)
        let emailIsHidden = !(getViewModel()?.showFieldEmail ?? false)
        let saveCardCheckboxIsHidden = !(getViewModel()?.showSaveCardCheckbox ?? false)
        fieldEmail.isHidden = emailIsHidden
        fieldBillingCountry.isHidden = billingIsHidden
        fieldBillingPostcode.isHidden = billingIsHidden
        containerSavedCard.isHidden = saveCardCheckboxIsHidden
        getViewModel()?.isSaveCardSelected = !saveCardCheckboxIsHidden
        
        if !emailIsHidden { inputFields.append(fieldEmail) }
        if !billingIsHidden { inputFields.append(contentsOf: [fieldBillingCountry, fieldBillingPostcode]) }
        //TODO: next navigation for billing fields
        inputFields.append(contentsOf: [fieldCardholder, fieldCardNumber, fieldExpiry, fieldCVV])
        
        setUpSaveCardCheckbox()
        setUpCardsStrip()
        buttonPay.setEnabled(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationTitle(LocalizedText.CardDetailsCheckout.title)
        setUpKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }

    @IBAction func onPayButtonPress(_ sender: Any) {
        setStateLoading()
        let cardDetails = fetchDataFromFields()
        if let selectedCountry = fieldBillingCountry.getSelectedCountry() {
            getViewModel()?.billingCountry = selectedCountry.isoCode
        }
        getViewModel()?.email = fieldEmail.textFieldMain.text
        getViewModel()?.billingPostcode = fieldBillingPostcode.textFieldMain.text
        getViewModel()?.processPayment(cardDetails: cardDetails,
                                       fromViewController: self) { result in
            self.delegate?.navigateToPaymentResult(resultCode: result)
            self.setStateNormal()
        }
    }
    
    func setStateLoading() {
        buttonPay.showLoading(LocalizedText.CardDetailsCheckout.buttonProcessing)
        mainContentScrollView.isUserInteractionEnabled = false
        mainContentScrollView.alpha = 0.4
        diableCloseButton = true
        
    }
    
    func setStateNormal() {
        buttonPay.hideLoading()
        mainContentScrollView.isUserInteractionEnabled = true
        mainContentScrollView.alpha = 1
        diableCloseButton = false
    }
}

extension CardDetailsCheckoutViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //TODO: move to fields file
        self.view.endEditing(true)
        return false
    }
}

//TODO: make safer
extension CardDetailsCheckoutViewController: DojoInputFieldDelegate {
    
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
    
    func onTextChange(_ from: DojoInputField) {
        var isValid = true
        inputFields.forEach({
            if !$0.isValid() {
                isValid = false
            }
        })
       buttonPay.setEnabled(isValid)
    }
    
    func onTextFieldDidFinishEditing(_ from: DojoInputField) {
//        var isValid = true
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
    
    func onTextFieldBeginEditing(_ from: DojoInputField) {
        
    }
    
    func fetchDataFromFields() -> DojoCardDetails {
        //TODO:
        let cardNumber = fieldCardNumber.textFieldMain.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let cardName = fieldCardholder.textFieldMain.text
        let expiryDate = fieldExpiry.textFieldMain.text?.replacingOccurrences(of: "/", with: " / ")
        let cvv = fieldCVV.textFieldMain.text
        let cardDetails = DojoCardDetails(cardNumber: cardNumber, cardName: cardName, expiryDate: expiryDate, cv2: cvv)
        return cardDetails
    }
}



