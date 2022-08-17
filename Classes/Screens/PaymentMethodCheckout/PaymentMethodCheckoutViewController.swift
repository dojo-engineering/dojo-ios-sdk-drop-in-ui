//
//  PaymentMethodCheckoutViewController.swift
//  dojo-ios-sdk
//
//  Created by Deniss Kaibagarovs on 04/08/2022.
//

import UIKit

protocol PaymentMethodCheckoutViewControllerDelegate: BaseViewControllerDelegate {
    func navigateToManagePaymentMethods()
}

class PaymentMethodCheckoutViewController: BaseUIViewController {
    
    let viewModel: PaymentMethodCheckoutViewModel
    var delegate: PaymentMethodCheckoutViewControllerDelegate?

    public init(viewModel: PaymentMethodCheckoutViewModel,
                theme: ThemeSettings,
                delegate: PaymentMethodCheckoutViewControllerDelegate) {
        self.viewModel = viewModel
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
        self.title = "Payment Method"
    }
    
    @IBAction func onManagePaymentMethodsPress(_ sender: Any) {
        delegate?.navigateToManagePaymentMethods()
    }
    
    @IBAction func onPayUsingApplePayPress(_ sender: Any) {
        viewModel.processApplePayPayment(fromViewControlelr: self) { result in
            self.delegate?.navigateToPaymentResult(resultCode: result)
        }
    }
}