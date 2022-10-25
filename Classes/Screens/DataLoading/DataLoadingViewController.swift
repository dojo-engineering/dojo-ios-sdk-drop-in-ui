//
//  DataLoadingViewController.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 01/09/2022.
//

import UIKit

protocol DataLoadingViewControllerDelegate: BaseViewControllerDelegate {
    func paymentIntentDownloaded(_ paymentIntent: PaymentIntent)
    func errorLoadingPaymentIntent(error: Error)
}

class DataLoadingViewController: BaseUIViewController {
    
    var delegate: DataLoadingViewControllerDelegate
    @IBOutlet weak var materialLoadingIndicator: MaterialLoadingIndicator!
    
    public init(viewModel: DataLoadingViewModel,
                theme: ThemeSettings,
                delegate: DataLoadingViewControllerDelegate) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationTitle(LocalizedText.PaymentMethodCheckout.title)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingIndicator()
    }
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let delay = getViewModel()?.demoDelay ?? 0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.loadData()
        }
    }
    
    func getViewModel() -> DataLoadingViewModel? {
        viewModel as? DataLoadingViewModel
    }
    
    func setupLoadingIndicator() {
        materialLoadingIndicator.radius = 15.0
        materialLoadingIndicator.color = theme.loadingIndicatorColor
        materialLoadingIndicator.startAnimating()
    }
    
    func loadData() {
        getViewModel()?.fetchPaymentIntent() { paymentIntent, error in
            if let error = error {
                self.delegate.errorLoadingPaymentIntent(error: error)
            } else if let paymentIntent = paymentIntent {
//                if let customerId = paymentIntent.customer?.id {
//                    self.getViewModel()?.fetchCustomersPaymentMethods(customerId: customerId)
//                } else {
                    self.delegate.paymentIntentDownloaded(paymentIntent)
//                }
            } else {
                // TODO error?
//                self.delegate.errorLoadingPaymentIntent(error: )
            }
        }
    }
}

