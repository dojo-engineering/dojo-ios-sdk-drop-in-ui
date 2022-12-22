//
//  PaymentMethodCheckoutViewController.swift
//  dojo-ios-sdk
//
//  Created by Deniss Kaibagarovs on 04/08/2022.
//

import UIKit
import PassKit

protocol PaymentMethodCheckoutViewControllerDelegate: BaseViewControllerDelegate {
    func navigateToManagePaymentMethods(_ selectedPaymentMethod: PaymentMethodItem?)
    func navigateToCardCheckout()
}

class PaymentMethodCheckoutViewController: BaseUIViewController {
    
    var delegate: PaymentMethodCheckoutViewControllerDelegate?
    
    @IBOutlet weak var labelTotalDue: UILabel!
    @IBOutlet weak var labelTotalAmount: UILabel!
    @IBOutlet weak var paymentButton: PKPaymentButton!
    @IBOutlet weak var buttonPayCard: LoadingButton!
    @IBOutlet weak var selectedPaymentMethodView: SelectedPaymentMethodView!
    
    @IBOutlet weak var constraintPayButtonCardBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintPayButtonBottom: NSLayoutConstraint!
    public init(viewModel: PaymentMethodCheckoutViewModel,
                theme: ThemeSettings,
                delegate: PaymentMethodCheckoutViewControllerDelegate) {
        self.delegate = delegate
        let nibName = String(describing: type(of: self))
        let podBundle = Bundle(for: type(of: self))
        super.init(nibName: nibName, bundle: podBundle)
        self.viewModel = viewModel
        self.baseDelegate = delegate
        self.theme = theme
        self.displayBackButton = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpKeyboard()
        setNavigationTitle(LocalizedText.PaymentMethodCheckout.title)
    }
    
    func setupViews() {
        selectedPaymentMethodView.paymentMethod = nil
        buttonPayCard.setEnabled(true) //TODO edge case when payment method is removed
        selectedPaymentMethodView.delegate = self
        if getViewModel()?.isSavedPaymentMethodsAvailable() ?? false {
            buttonPayCard.isHidden = true //TODO
            
            if getViewModel()?.isApplePayAvailable() ?? false == false {
                // the same as below?
                paymentButton.isHidden = true
                constraintPayButtonBottom.constant = 9
                buttonPayCard.setTheme(theme)
                if let navigation = (navigationController as? BaseNavigationController) {
                    navigation.defaultHeight = 210
                }
                
                selectedPaymentMethodView.isHidden = true
    //            constraintPayButtonBottom.constant = 70
                buttonPayCard.isHidden = false
    //
                let buttonPayTitle = LocalizedText.PaymentMethodCheckout.payByCard
                buttonPayCard.setTitle(buttonPayTitle, for: .normal)
                buttonPayCard.backgroundColor = theme.primaryCTAButtonActiveBackgroundColor
                buttonPayCard.setTitleColor(theme.primaryCTAButtonActiveTextColor, for: .normal)
                buttonPayCard.layer.borderWidth = 1
                buttonPayCard.layer.borderColor = theme.primaryCTAButtonActiveBackgroundColor.cgColor
                
            } else {
                //TODO
            }
        } else {
            buttonPayCard.isHidden = true //TODO
            
            if getViewModel()?.isApplePayAvailable() ?? false == false {
                // ApplePay is not available
                // No saved cards
                
                paymentButton.isHidden = true
                constraintPayButtonBottom.constant = 9
                buttonPayCard.setTheme(theme)
                if let navigation = (navigationController as? BaseNavigationController) {
                    navigation.defaultHeight = 210
                }
                
                selectedPaymentMethodView.isHidden = true
    //            constraintPayButtonBottom.constant = 70
                buttonPayCard.isHidden = false
    //
                let buttonPayTitle = LocalizedText.PaymentMethodCheckout.payByCard
                buttonPayCard.setTitle(buttonPayTitle, for: .normal)
                buttonPayCard.backgroundColor = theme.primaryCTAButtonActiveBackgroundColor
                buttonPayCard.setTitleColor(theme.primaryCTAButtonActiveTextColor, for: .normal)
                buttonPayCard.layer.borderWidth = 1
                buttonPayCard.layer.borderColor = theme.primaryCTAButtonActiveBackgroundColor.cgColor
            } else if getViewModel()?.isApplePayAvailable() ?? false {
                // ApplePay is available
                selectedPaymentMethodView.isHidden = false
                selectedPaymentMethodView.delegate = self
                selectedPaymentMethodView.setStyle(.applePay)
                
                selectedPaymentMethodView.isHidden = true
                constraintPayButtonBottom.constant = 70
                buttonPayCard.isHidden = false

                let buttonPayTitle = LocalizedText.PaymentMethodCheckout.payByCard
                buttonPayCard.setTitle(buttonPayTitle, for: .normal)
                buttonPayCard.backgroundColor = theme.primarySurfaceBackgroundColor
                buttonPayCard.setTitleColor(theme.primaryLabelTextColor, for: .normal)
                buttonPayCard.layer.borderWidth = 1
                buttonPayCard.layer.borderColor = theme.primaryLabelTextColor.cgColor
            }
        }
    }
    
    override func setUpDesign() {
        super.setUpDesign()
        labelTotalDue.textColor = theme.primaryLabelTextColor
        labelTotalDue.font = theme.fontHeading5Medium
        
        labelTotalAmount.textColor = theme.primaryLabelTextColor
        labelTotalAmount.font = theme.fontHeading5Medium
        
        paymentButton.setValue(theme.applePayButtonStyle.rawValue, forKey: "style")
        paymentButton.layer.cornerRadius = theme.primaryCTAButtonCornerRadius
        paymentButton.clipsToBounds = true
        
        selectedPaymentMethodView.setTheme(theme: theme)
        
        buttonPayCard.setTheme(theme)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        removeKeyboardObservers()
    }
    
    func setupData() {
        //TODO: proper amount formatter
        let value = Double(getViewModel()?.paymentIntent.amount.value ?? 0)
        labelTotalAmount.text = "£\(String(format: "%.2f", value/100.0))"
    }
    
    @IBAction func onPayUsingApplePayPress(_ sender: Any) {
        guard getViewModel()?.isApplePayAvailable() ?? false else {
            print("Apple pay is not available")
            return
        }
        
        getViewModel()?.processApplePayPayment(fromViewControlelr: self) { result in
            self.delegate?.navigateToPaymentResult(resultCode: result)
        }
    }
    
    @IBAction func onPayUsingSavedCard(_ sender: Any) {
        
        guard let selectedPaymentMethodId = selectedPaymentMethodView.paymentMethod?.id else {
            print("paymentMethod is not selected")
            
            if let isSavedPaymentMethodsAvailable = getViewModel()?.isSavedPaymentMethodsAvailable(),
                isSavedPaymentMethodsAvailable == false {
                delegate?.navigateToCardCheckout()
            } else {
                delegate?.navigateToManagePaymentMethods(nil)
            }
            return
        }
        guard let cvv = selectedPaymentMethodView.mainTextField.text else {
            print("cvv is empty")
            return
        }
        
        self.view.isUserInteractionEnabled = false
        buttonPayCard.showLoading(LocalizedText.CardDetailsCheckout.buttonProcessing)
        getViewModel()?.processSavedCardPayment(fromViewControlelr: self,
                                                paymentId: selectedPaymentMethodId,
                                                cvv: cvv) { result in
            self.buttonPayCard.hideLoading()
            self.view.isUserInteractionEnabled = true
            self.delegate?.navigateToPaymentResult(resultCode: result)
        }
    }
    
    func getViewModel() -> PaymentMethodCheckoutViewModel? {
        viewModel as? PaymentMethodCheckoutViewModel
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
            
            if let navigation = (navigationController as? BaseNavigationController) {
                navigation.heightConstraint?.constant = keyboardHeight + 286 - 15
            }
            
            constraintPayButtonBottom.constant = keyboardHeight - (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) - 15
            constraintPayButtonCardBottom.constant = constraintPayButtonBottom.constant
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        if let navigation = (navigationController as? BaseNavigationController) {
            navigation.heightConstraint?.constant = 286 + navigation.safeAreaBottomHeight //TODO: move to base
        }
        
        constraintPayButtonBottom.constant = 9
        constraintPayButtonCardBottom.constant = constraintPayButtonBottom.constant
    }
    
    override func updateData(config: ConfigurationManager) {
        super.updateData(config: config)
        getViewModel()?.savedPaymentMethods = config.savedPaymentMethods
        
        if !(getViewModel()?.savedPaymentMethods?.contains(where: {$0.id == selectedPaymentMethodView.paymentMethod?.id}) ?? false) {
            // if selected payment method was removed remove it from the UI
            setupViews()
        }
    }
    
    func paymentMethodSelected(_ item: PaymentMethodItem) {
        selectedPaymentMethodView.setPaymentMethod(item)
        switch item.type {
        case .applePay:
            buttonPayCard.isHidden = true
            paymentButton.isHidden = false
        default:
            buttonPayCard.isHidden = false
            paymentButton.isHidden = true
            buttonPayCard.setEnabled(false)
            if let navigation = (navigationController as? BaseNavigationController) {
                navigation.defaultHeight = 286
            }
            selectedPaymentMethodView.isHidden = false
        }
        
        let amountText = "\(String(format: "%.2f", Double(getViewModel()?.paymentIntent.amount.value ?? 0)/100.0))"
        let buttonPayTitle = "Pay £\(amountText)"
        buttonPayCard.setTitle(buttonPayTitle, for: .normal)
    }
}

extension PaymentMethodCheckoutViewController: SelectedPaymentMethodViewDelegate {
    func onCVVStateChange(_ isValid: Bool) {
        buttonPayCard.setEnabled(isValid)
    }
    
    func onPress(_ item: PaymentMethodItem) {
        delegate?.navigateToManagePaymentMethods(item)
    }
}
