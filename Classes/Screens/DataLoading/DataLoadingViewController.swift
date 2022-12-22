//
//  DataLoadingViewController.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 01/09/2022.
//

import UIKit

protocol DataLoadingViewControllerDelegate: BaseViewControllerDelegate {
    func initialDataDownloaded(_ paymentIntent: PaymentIntent, savedPaymentMethods: [SavedPaymentMethod]?)
    func errorLoadingPaymentIntent(error: Error)
}

class DataLoadingViewController: BaseUIViewController {
    
    var delegate: DataLoadingViewControllerDelegate
    var dataLoadingViewModel: DataLoadingViewModel
    @IBOutlet weak var materialLoadingIndicator: MaterialLoadingIndicator!
    
    public init(viewModel: DataLoadingViewModel,
                theme: ThemeSettings,
                delegate: DataLoadingViewControllerDelegate) {
        self.delegate = delegate
        let nibName = String(describing: type(of: self))
        let podBundle = Bundle(for: type(of: self))
        self.dataLoadingViewModel = viewModel
        super.init(nibName: nibName, bundle: podBundle)
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
        let delay = dataLoadingViewModel.demoDelay
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.loadData()
        }
    }
}

extension DataLoadingViewController {
    
    func setupLoadingIndicator() {
        materialLoadingIndicator.radius = 15.0
        materialLoadingIndicator.color = theme.loadingIndicatorColor
        materialLoadingIndicator.startAnimating()
    }
    
    func loadData() {
        dataLoadingViewModel.fetchPaymentIntent() { paymentIntent, error in
            // error, do not proceed next
            if let error = error {
                self.delegate.errorLoadingPaymentIntent(error: error)
                return
            }
            // check if payment intent exists
            guard let paymentIntent = paymentIntent else {
                self.delegate.errorLoadingPaymentIntent(error: NSError(domain: "DataLoadingViewController-loadData", code: 7770, userInfo: nil))
                return
            }
            // payment inent exists but there is no customer so we don't need to fetch saved payment methods
            guard let customerId = paymentIntent.customer?.id else {
                self.delegate.initialDataDownloaded(paymentIntent, savedPaymentMethods: nil)
                return
            }
            // fetch saved payment methods
            self.dataLoadingViewModel.fetchCustomersPaymentMethods(customerId: customerId) { savedMethods, error in
                // optional call, do not fail if error, send empty saved methods
                self.delegate.initialDataDownloaded(paymentIntent, savedPaymentMethods: savedMethods)
            }
        }
    }
}

