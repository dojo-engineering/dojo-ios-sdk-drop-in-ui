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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    public init(viewModel: CardDetailsCheckoutViewModel,
                theme: ThemeSettings,
                delegate : CardDetailsCheckoutViewControllerDelegate) {
        self.viewModel = viewModel
        self.cardDetails = viewModel.cardDetails3DS
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
        activityIndicator.isHidden = true
        footerPoweredByDojoView?.setStyle(FooterPoweredByDojoStyle.checkoutPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationTitle("Pay with new card")
    }

    @IBAction func onPayButtonPress(_ sender: Any) {
        activityIndicator.isHidden = false
        viewModel.processPayment(cardDetails: cardDetails,
                                 fromViewControlelr: self) { result in
            self.delegate?.navigateToPaymentResult(resultCode: result)
        }
    }
    
    @IBAction func onAutocomplete3DS(_ sender: Any) {
        cardDetails = viewModel.cardDetails3DS
    }
    
    @IBAction func onAutocompleteNon3DS(_ sender: Any) {
        cardDetails = viewModel.cardDetailsNon3DS
    }
}
