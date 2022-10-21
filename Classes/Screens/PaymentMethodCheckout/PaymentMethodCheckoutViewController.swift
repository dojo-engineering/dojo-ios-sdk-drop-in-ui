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
    @IBOutlet weak var selectedPaymentMethodView: SelectedPaymentMethodView!
    
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
}

extension PaymentMethodCheckoutViewController: SelectedPaymentMethodViewDelegate {
    func onPress() {
        delegate?.navigateToManagePaymentMethods()
    }
}
