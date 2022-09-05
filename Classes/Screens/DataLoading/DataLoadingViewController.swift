//
//  DataLoadingViewController.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 01/09/2022.
//

import UIKit

protocol DataLoadingViewControllerDelegate: BaseViewControllerDelegate {
    func paymentIntentDownloaded(data: String)
    func errorLoadingPaymentIntent(error: Error)
}

class DataLoadingViewController: BaseUIViewController {
    
    let viewModel: DataLoadingViewModel
    var delegate: DataLoadingViewControllerDelegate
    @IBOutlet weak var materialLoadingIndicator: MaterialLoadingIndicator!
    
    public init(viewModel: DataLoadingViewModel,
                theme: ThemeSettings,
                delegate :DataLoadingViewControllerDelegate) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationTitle(LocalizedText.PaymentMethodCheckout.title)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        loadData()
        // for testing purposes
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.loadData()
        }
        setupLoadingIndicator()
    }
    
    func setupLoadingIndicator() {
        materialLoadingIndicator.radius = 15.0
        materialLoadingIndicator.color = .black
        materialLoadingIndicator.startAnimating()
    }
    
    func loadData() {
        viewModel.fetchPaymentIntent() { intentString, error in
            if let error = error {
                self.delegate.errorLoadingPaymentIntent(error: error)
            } else if let intentString = intentString {
                self.delegate.paymentIntentDownloaded(data: intentString)
            } else {
                // TODO error?
//                self.delegate.errorLoadingPaymentIntent(error: )
            }
        }
    }
}

