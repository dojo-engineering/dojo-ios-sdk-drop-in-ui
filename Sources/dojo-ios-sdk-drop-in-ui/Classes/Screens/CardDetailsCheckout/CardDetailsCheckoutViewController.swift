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
    
    @IBOutlet weak var labelCompanyName: UILabel!
    @IBOutlet weak var labelPrimaryAmount: UILabel!
    @IBOutlet weak var labelYouPay: UILabel!
    @IBOutlet weak var labelSaveCardForFutureUse: UILabel!
    @IBOutlet weak var buttonPay: LoadingButton!
    @IBOutlet weak var imageViewSaveCardCheckbox: UIImageView!
    @IBOutlet weak var imageViewTermsCheckbox: UIImageView!
    @IBOutlet weak var fieldEmail: DojoInputField!
    @IBOutlet weak var fieldCardholder: DojoInputField!
    @IBOutlet weak var fieldCardNumber: DojoInputField!
    @IBOutlet weak var fieldExpiry: DojoInputField!
    @IBOutlet weak var fieldCVV: DojoInputField!
    @IBOutlet weak var fieldBillingCountry: DojoInputField!
    @IBOutlet weak var fieldBillingPostcode: DojoInputField!
    @IBOutlet weak var mainContentScrollView: UIScrollView!
    @IBOutlet weak var containerSavedCard: UIView!
    @IBOutlet weak var containerTerms: UIStackView!
    @IBOutlet weak var containerCardsStrip: UIStackView!
    @IBOutlet weak var constraintPayButtonBottom: NSLayoutConstraint!
    
    @IBOutlet weak var labelCOFTerms: UILabel!
    public init(viewModel: CardDetailsCheckoutViewModel,
                theme: ThemeSettings,
                delegate : CardDetailsCheckoutViewControllerDelegate) {
        self.delegate = delegate
        let nibName = String(describing: type(of: self))
        super.init(nibName: nibName, bundle: Bundle.libResourceBundle)
        self.displayBackButton = !viewModel.paymentIntent.isSetupIntent
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
        imageViewTermsCheckbox.tintColor = theme.inputElementActiveTintColor
        
        labelYouPay.textColor = theme.primaryLabelTextColor
        
        labelCompanyName.textColor = theme.primaryLabelTextColor
        labelCompanyName.font = theme.fontBody1
        
        if let companyName = getViewModel()?.companyName {
            labelCompanyName.text = companyName
        } else {
            labelCompanyName.isHidden = true
        }
        
        labelCOFTerms.text = "\(getViewModel()?.tradingName ?? "") \(LocalizedText.CardDetailsCheckout.consentTerms)"
        labelCOFTerms.font = theme.fontSubtitle2
        labelCOFTerms.textColor = theme.secondaryLabelTextColor
    
        if getViewModel()?.paymentIntent.isSetupIntent ?? false {
            imageViewSaveCardCheckbox.tintColor = theme.headerButtonTintColor
            imageViewTermsCheckbox.tintColor = theme.headerButtonTintColor
            labelPrimaryAmount.textColor = theme.secondaryLabelTextColor
            labelPrimaryAmount.font = theme.fontSubtitle2
            labelPrimaryAmount.text = getViewModel()?.paymentIntent.reference
            
            // Setup Intent has a bit different UI for company Name label
            labelCompanyName.font = theme.fontHeading5
            labelYouPay.isHidden = true
        } else {
            imageViewSaveCardCheckbox.tintColor = theme.inputElementActiveTintColor
            imageViewTermsCheckbox.tintColor = theme.inputElementActiveTintColor
            labelPrimaryAmount.textColor = theme.primaryLabelTextColor
            labelPrimaryAmount.font = theme.fontHeading3Medium
            labelYouPay.font = theme.fontSubtitle1Medium
        }
        
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
        let title = getViewModel()?.navigationTitle ?? ""
        setNavigationTitle(theme.customCardDetailsNavigationTitle ?? title)
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
        guard let viewModel = getViewModel() else {
            return
        }
        
        if viewModel.paymentIntent.isSetupIntent {
            buttonPay.setTitle(LocalizedText.CardDetailsCheckout.buttonPaySetupIntent, for: .normal)
        } else {
            
            buttonPay.setTitle(getViewModel()?.paymentIntent.payButtonFormatted, for: .normal)
            
            let fontCurrency = [NSAttributedString.Key.font : theme.fontHeading4]
            let fontAmount = [NSAttributedString.Key.font : theme.fontHeading3Medium]
            let gbpString = NSMutableAttributedString(string:"£", attributes: fontCurrency)
            let amountText = getViewModel()?.paymentIntent.amountText ?? ""
            let attributedString = NSMutableAttributedString(string: amountText, attributes: fontAmount)
            gbpString.append(attributedString)
            labelPrimaryAmount.attributedText = gbpString
        }
    }
    
    func setUpSaveCardCheckbox() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleOnSaveCardCheckboxPress))
        containerSavedCard.addGestureRecognizer(tap)
    }
    
    func setUpTermsCardCheckbox() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleOnTermsCheckboxPress))
        containerTerms.addGestureRecognizer(tap)
    }
    
    func setUpCardsStrip() {
        //TODO: a better function for that
        guard let viewModel = getViewModel() else { return }
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        footerPoweredByDojoView?.setStyle(FooterPoweredByDojoStyle.checkoutPage)
    }
    
    func setUpViews() {
        fieldEmail.setType(.email, delegate: self)
        fieldCardholder.setType(.cardHolderName, delegate: self)
        fieldCardNumber.setType(.cardNumber, delegate: self, supportedCardSchemas: getViewModel()?.supportedCardSchemes)
        fieldBillingCountry.setType(.billingCountry, delegate: self)
        fieldBillingPostcode.setType(.billingPostcode, delegate: self)
        fieldExpiry.setType(.expiry, delegate: self)
        fieldCVV.setType(.cvv, delegate: self)
        
        let billingIsHidden = !(getViewModel()?.showFieldBilling ?? false)
        let emailIsHidden = !(getViewModel()?.showFieldEmail ?? false)
        let saveCardCheckboxIsHidden = !(getViewModel()?.showSaveCardCheckbox ?? false)
        fieldEmail.isHidden = emailIsHidden
        if !fieldEmail.isHidden {
            fieldEmail.textFieldMain.text = getViewModel()?.paymentIntent.customer?.emailAddress
        }
        fieldBillingCountry.isHidden = billingIsHidden
        if !fieldBillingCountry.isHidden {
            fieldBillingCountry.setCountryCode(countryCode: getViewModel()?.paymentIntent.billingAddress?.countryCode)
            fieldBillingCountry.setType(.billingCountry, delegate: self)
        }
        fieldBillingPostcode.isHidden = billingIsHidden
        if !fieldBillingPostcode.isHidden {
            fieldBillingPostcode.textFieldMain.text = getViewModel()?.paymentIntent.billingAddress?.postcode
        }
        containerSavedCard.isHidden = saveCardCheckboxIsHidden
        getViewModel()?.isSaveCardSelected = !saveCardCheckboxIsHidden
        containerTerms.isHidden = !(getViewModel()?.paymentIntent.isSetupIntent ?? false)
        
        if !billingIsHidden { inputFields.append(contentsOf: [fieldBillingCountry, fieldBillingPostcode]) }
        //TODO: next navigation for billing fields
        inputFields.append(contentsOf: [fieldCardholder, fieldCardNumber, fieldExpiry, fieldCVV])
        if !emailIsHidden { inputFields.append(fieldEmail) }
        
        setUpSaveCardCheckbox()
        setUpTermsCardCheckbox()
        setUpCardsStrip()
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
        buttonPay.isUserInteractionEnabled = false
        
    }
    
    func setStateNormal() {
        buttonPay.hideLoading()
        mainContentScrollView.isUserInteractionEnabled = true
        mainContentScrollView.alpha = 1
        diableCloseButton = false
        buttonPay.isUserInteractionEnabled = true
    }
    
    func fetchDataFromFields() -> DojoCardDetails {
        //TODO:
        let cardNumber = fieldCardNumber.textFieldMain.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let cardName = fieldCardholder.textFieldMain.text
        let expiryDate = fieldExpiry.textFieldMain.text?.replacingOccurrences(of: "/", with: " / ")
        let cvv = fieldCVV.textFieldMain.text
        let terms = getViewModel()?.isTermsSelected == true ? NSNumber(value: 1) : nil
        let cardDetails = DojoCardDetails(cardNumber: cardNumber,
                                          cardName: cardName,
                                          expiryDate: expiryDate,
                                          cv2: cvv,
                                          mitConsentGiven: terms)
        return cardDetails
    }
    
    @objc func handleOnSaveCardCheckboxPress() {
        //TODO: hide the save card view at all if needed
        guard let viewModel = getViewModel() else { return }
        viewModel.isSaveCardSelected = !viewModel.isSaveCardSelected
        if viewModel.isSaveCardSelected {
            imageViewSaveCardCheckbox.image = UIImage(named: "icon-checkbox-checked", in: Bundle.libResourceBundle, compatibleWith: nil)
            imageViewSaveCardCheckbox.tintColor = theme.inputElementActiveTintColor
        } else {
            imageViewSaveCardCheckbox.image = UIImage(named: "icon-checkbox-unchecked", in: Bundle.libResourceBundle, compatibleWith: nil)
            imageViewSaveCardCheckbox.tintColor = theme.headerButtonTintColor
        }
        print("On saved card pressed")
    }
    
    @objc func handleOnTermsCheckboxPress() {
        guard let viewModel = getViewModel() else { return }
        viewModel.isTermsSelected = !viewModel.isTermsSelected
        if viewModel.isTermsSelected {
            imageViewTermsCheckbox.image = UIImage(named: "icon-checkbox-checked", in: Bundle.libResourceBundle, compatibleWith: nil)
            imageViewTermsCheckbox.tintColor = theme.inputElementActiveTintColor
        } else {
            imageViewTermsCheckbox.image = UIImage(named: "icon-checkbox-unchecked", in: Bundle.libResourceBundle, compatibleWith: nil)
            imageViewTermsCheckbox.tintColor = theme.headerButtonTintColor
        }
        forceValidate()
        print("On terms pressed")
    }
}
