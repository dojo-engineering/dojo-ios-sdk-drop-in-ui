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
    
    var cardDetails: DojoCardDetails
    var delegate: CardDetailsCheckoutViewControllerDelegate?
    
    @IBOutlet weak var constraintPayButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var labelPrimaryAmount: UILabel!
    @IBOutlet weak var labelYouPay: UILabel!
    @IBOutlet weak var labelSaveCardForFutureUse: UILabel!
    @IBOutlet weak var buttonPay: LoadingButton!
    
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
        self.cardDetails = viewModel.cardDetails3DS
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
        setUpKeyboard()
    }
    
    override func setUpDesign() {
        super.setUpDesign()
        
        buttonPay.backgroundColor = theme.primaryCTAButtonActiveBackgroundColor
        buttonPay.layer.cornerRadius = theme.primaryCTAButtonCornerRadius
        buttonPay.setTitleColor(theme.primaryCTAButtonActiveTextColor, for: .normal)
        buttonPay.tintColor = theme.primaryCTAButtonActiveTextColor
        buttonPay.clipsToBounds = true
        
        labelYouPay.textColor = theme.primaryLabelTextColor
        labelYouPay.font = theme.fontSubtitle1Medium
        
        labelPrimaryAmount.textColor = theme.primaryLabelTextColor
        labelPrimaryAmount.font = theme.fontHeading3Medium
        
        labelSaveCardForFutureUse.font = theme.fontSubtitle1
        labelSaveCardForFutureUse.textColor = theme.secondaryLabelTextColor
        
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
        let amountText = "£\(String(format: "%.2f", Double(getViewModel()?.paymentIntent.amount.value ?? 0)/100.0))"
        let buttonPayTitle = "Pay \(amountText)"
        buttonPay.setTitle(buttonPayTitle, for: .normal)
        labelPrimaryAmount.text = amountText
    }
    
    func setUpKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        //TODO: get cards from backend
        //TODO: a better function for that
        let cardItems: [UIImageCardIcon] = [.visa, .mastercard, .amex, .diner, .discover, .maestro]
        cardItems.forEach({
            let imageView = UIImageView(frame: CGRectMake(0, 0, 40, 20))
            imageView.image = UIImage.getCardIcon($0)
            imageView.contentMode = .scaleAspectFit
            containerCardsStrip.addArrangedSubview(imageView)
        })
    }
    
    @objc func handleOnSaveCardCheckboxPress() {
        print("On saved card pressed")
    }
    
    func setUpViews() {
        footerPoweredByDojoView?.setStyle(FooterPoweredByDojoStyle.checkoutPage)
        
        fieldEmail.setType(.email)
        fieldCardholder.setType(.cardHolderName)
        fieldCardNumber.setType(.cardNumber)
        fieldBillingCountry.setType(.billingCountry)
        fieldBillingPostcode.setType(.billingPostcode)
        fieldExpiry.setType(.expiry)
        fieldCVV.setType(.cvv)
        
        let billingIsHidden = !(getViewModel()?.showFieldBilling ?? false)
        let emailIsHidden = !(getViewModel()?.showFieldEmail ?? false)
        fieldEmail.isHidden = emailIsHidden
        fieldBillingCountry.isHidden = billingIsHidden
        fieldBillingPostcode.isHidden = billingIsHidden
        
        setUpSaveCardCheckbox()
        setUpCardsStrip()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationTitle(LocalizedText.CardDetailsCheckout.title)
    }

    @IBAction func onPayButtonPress(_ sender: Any) {
        setStateLoading()
        getViewModel()?.processPayment(cardDetails: cardDetails,
                                 fromViewControlelr: self) { result in //TODO: force unwrap
            self.delegate?.navigateToPaymentResult(resultCode: result)
            self.setStateNormal()
        }
    }
    
    func setStateLoading() {
        buttonPay.showLoading(LocalizedText.CardDetailsCheckout.buttonProcessing)
        mainContentScrollView.isUserInteractionEnabled = false
        mainContentScrollView.alpha = 0.4
    }
    
    func setStateNormal() {
        buttonPay.hideLoading()
        mainContentScrollView.isUserInteractionEnabled = true
        mainContentScrollView.alpha = 1
    }
    
    @IBAction func onAutocomplete3DS(_ sender: Any) {
        guard let viewModel = getViewModel() else { return }
        cardDetails = viewModel.cardDetails3DS
        autofillUI()
    }
    
    @IBAction func onAutocompleteNon3DS(_ sender: Any) {
        guard let viewModel = getViewModel() else { return }
        cardDetails = viewModel.cardDetailsNon3DS
        autofillUI()
    }
    
    func autofillUI() {
//        textFieldCardholder.text = cardDetails.cardName
//        textFieldCardNumber.text = cardDetails.cardNumber
//        textFieldExpiry.text = cardDetails.expiryDate
//        textFieldCVV.text = cardDetails.cv2
    }
}

extension CardDetailsCheckoutViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}



