//
//  CardDetailsViewController.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 02/08/2022.
//

import UIKit
import dojo_ios_sdk

protocol CardDetailsCheckoutViewControllerDelegate: BaseViewControllerDelegate {}

class CardDetailsCheckoutViewController: BaseUIViewController {
    
    var delegate: CardDetailsCheckoutViewControllerDelegate?
    var inputFields: [DojoInputField] = []
    
    @IBOutlet weak var labelPrimaryAmount: UILabel!
    @IBOutlet weak var labelYouPay: UILabel!
    @IBOutlet weak var labelOrderReference: UILabel!
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
    @IBOutlet weak var constraintPayButtonBottom: NSLayoutConstraint!
    
    public init(viewModel: CardDetailsCheckoutViewModel,
                theme: ThemeSettings,
                delegate : CardDetailsCheckoutViewControllerDelegate) {
        self.delegate = delegate
        let nibName = String(describing: type(of: self))
        super.init(nibName: nibName, bundle: Bundle.libResourceBundle)
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
        imageViewSaveCardCheckbox.tintColor = theme.inputElementActiveTintColor
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationTitle(LocalizedText.CardDetailsCheckout.title)
        setUpKeyboard()
        
        if let navigation = (navigationController as? BaseNavigationController) {
            //3DS Cardinal Fix
            navigation.bottomSheetTransitioningDelegate.bottomSheetPresentationController?.presentationTransitionWillBegin()
        }
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
}

// MARK: Setups
extension CardDetailsCheckoutViewController {
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
    
    func setUpSaveCardCheckbox() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleOnSaveCardCheckboxPress))
        containerSavedCard.addGestureRecognizer(tap)
    }
    
    func setUpCardsStrip() {
        //TODO: a better function for that
        guard let viewModel = getViewModel(),
            !viewModel.paymentIntent.isVirtualTerminalPayment else {
            containerCardsStrip.isHidden = true
            return
        }
        containerCardsStrip.isHidden = false
        viewModel.supportedCardSchemes.forEach({
            if let image = UIImage.getCardIcon(type: $0,
                                               lightVersion: theme.lightStyleForDefaultElements) {
                let imageView = UIImageView(frame: CGRectMake(0, 0, 40, 20))
                imageView.image = image
                imageView.contentMode = .scaleAspectFit
                containerCardsStrip.addArrangedSubview(imageView)
            }
        })
    }
    
    func setUpOrderReference() {
        guard let viewModel = getViewModel(),
            viewModel.paymentIntent.isVirtualTerminalPayment else {
            labelOrderReference.isHidden = true
            return
        }
        labelOrderReference.isHidden = false
        labelOrderReference.text = "Order \(viewModel.paymentIntent.reference ?? "")" 
    }
    
    func setUpViews() {
        footerPoweredByDojoView?.setStyle(FooterPoweredByDojoStyle.checkoutPage)
        
        labelYouPay.text = getViewModel()?.topTitle
        
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
        setUpOrderReference()
        buttonPay.setEnabled(false)
    }
}

// MARK: Actions
extension CardDetailsCheckoutViewController {
    
    func getViewModel() -> CardDetailsCheckoutViewModel? {
        viewModel as? CardDetailsCheckoutViewModel
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
    
    func fetchDataFromFields() -> DojoCardDetails {
        //TODO:
        let cardNumber = fieldCardNumber.textFieldMain.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let cardName = fieldCardholder.textFieldMain.text
        let expiryDate = fieldExpiry.textFieldMain.text?.replacingOccurrences(of: "/", with: " / ")
        let cvv = fieldCVV.textFieldMain.text
        let cardDetails = DojoCardDetails(cardNumber: cardNumber, cardName: cardName, expiryDate: expiryDate, cv2: cvv)
        return cardDetails
    }
    
    @objc func handleOnSaveCardCheckboxPress() {
        //TODO: hide the save card view at all if needed
        guard let viewModel = getViewModel() else { return }
        viewModel.isSaveCardSelected = !viewModel.isSaveCardSelected
        if viewModel.isSaveCardSelected {
            imageViewSaveCardCheckbox.image = UIImage(named: "icon-checkbox-checked", in: Bundle.libResourceBundle, compatibleWith: nil)
        } else {
            imageViewSaveCardCheckbox.image = UIImage(named: "icon-checkbox-unchecked", in: Bundle.libResourceBundle, compatibleWith: nil)
        }
        print("On saved card pressed")
    }
}
