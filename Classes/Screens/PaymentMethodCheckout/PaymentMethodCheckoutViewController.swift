//
//  PaymentMethodCheckoutViewController.swift
//  dojo-ios-sdk
//
//  Created by Deniss Kaibagarovs on 04/08/2022.
//

import UIKit
import PassKit

protocol PaymentMethodCheckoutViewControllerDelegate: BaseViewControllerDelegate {
    func navigateToManagePaymentMethods()
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
        setNavigationTitle(LocalizedText.PaymentMethodCheckout.title)
    }
    
    
    func setupViews() {
        selectedPaymentMethodView.delegate = self
        selectedPaymentMethodView.setStyle(.applePay)
        setUpKeyboard()
        buttonPayCard.isHidden = true //TODO
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
    
    func getViewModel() -> PaymentMethodCheckoutViewModel? {
        viewModel as? PaymentMethodCheckoutViewModel
    }
    
    func setUpKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    func onPress() {
        delegate?.navigateToManagePaymentMethods()
    }
}
