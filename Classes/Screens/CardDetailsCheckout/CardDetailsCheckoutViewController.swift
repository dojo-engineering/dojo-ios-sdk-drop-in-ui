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
    
    let viewModel: CardDetailsCheckoutViewModel
    var cardDetails: DojoCardDetails
    var delegate: CardDetailsCheckoutViewControllerDelegate?
    
    @IBOutlet weak var labelPrimaryAmount: UILabel!
    @IBOutlet weak var labelYouPay: UILabel!
    @IBOutlet weak var tempLoadingIndicator: MaterialLoadingIndicator!
    @IBOutlet weak var buttonPay: UIButton!
    
    @IBOutlet weak var textFieldCardholder: UITextField!
    @IBOutlet weak var textFieldCardNumber: UITextField!
    @IBOutlet weak var textFieldCVV: UITextField!
    @IBOutlet weak var textFieldExpiry: UITextField!
    @IBOutlet weak var textFieldBillingAddress: UITextField!
    @IBOutlet weak var containerEmail: UIStackView!
    @IBOutlet weak var containerBilling: UIStackView!
    
    public init(viewModel: CardDetailsCheckoutViewModel,
                theme: ThemeSettings,
                delegate : CardDetailsCheckoutViewControllerDelegate) {
        self.viewModel = viewModel
        self.cardDetails = viewModel.cardDetailsNon3DS
        self.delegate = delegate
        let nibName = String(describing: type(of: self))
        let podBundle = Bundle(for: type(of: self))
        super.init(nibName: nibName, bundle: podBundle)
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
        
        buttonPay.backgroundColor = theme.primaryCTAButtonActiveBackgroundColor
        buttonPay.layer.cornerRadius = theme.primaryCTAButtonCornerRadius
        buttonPay.setTitleColor(theme.primaryCTAButtonActiveTextColor, for: .normal)
        buttonPay.tintColor = theme.primaryCTAButtonActiveTextColor
        buttonPay.clipsToBounds = true
        
        labelYouPay.textColor = theme.primaryLabelTextColor
        labelYouPay.font = theme.fontSubtitle1Medium
        
        labelPrimaryAmount.textColor = theme.primaryLabelTextColor
        labelPrimaryAmount.font = theme.fontHeading3Medium
        
        tempLoadingIndicator.radius = 40.0
        tempLoadingIndicator.lineWidth = 7
        tempLoadingIndicator.color = theme.loadingIndicatorColor
        tempLoadingIndicator.alpha = 0 // isHidden doesn't work
    }
    
    func setUpData() {
        //TODO: proper formatter
        let amountText = "£\(String(format: "%.2f", Double(viewModel.paymentIntent.amount.value)/100.0))"
        let buttonPayTitle = "Pay \(amountText)"
        buttonPay.setTitle(buttonPayTitle, for: .normal)
        labelPrimaryAmount.text = amountText
    }
    
    func setUpViews() {
        footerPoweredByDojoView?.setStyle(FooterPoweredByDojoStyle.checkoutPage)
        
        containerEmail.isHidden = !viewModel.showFieldEmail
        containerBilling.isHidden = !viewModel.showFieldBilling
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationTitle(LocalizedText.CardDetailsCheckout.title)
    }

    @IBAction func onPayButtonPress(_ sender: Any) {
        tempLoadingIndicator.alpha = 1
        tempLoadingIndicator.startAnimating()
        viewModel.processPayment(cardDetails: cardDetails,
                                 fromViewControlelr: self) { result in
            self.delegate?.navigateToPaymentResult(resultCode: result)
        }
    }
    
    @IBAction func onAutocomplete3DS(_ sender: Any) {
        cardDetails = viewModel.cardDetails3DS
        autofillUI()
    }
    
    @IBAction func onAutocompleteNon3DS(_ sender: Any) {
        cardDetails = viewModel.cardDetailsNon3DS
        autofillUI()
    }
    
    func autofillUI() {
        textFieldCardholder.text = cardDetails.cardName
        textFieldCardNumber.text = cardDetails.cardNumber
        textFieldExpiry.text = cardDetails.expiryDate
        textFieldCVV.text = cardDetails.cv2
    }
}
