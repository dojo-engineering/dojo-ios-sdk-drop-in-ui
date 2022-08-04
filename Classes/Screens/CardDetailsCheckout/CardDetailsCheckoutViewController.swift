//
//  CardDetailsViewController.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 02/08/2022.
//

import UIKit
import dojo_ios_sdk

class CardDetailsCheckoutViewController: UIViewController {
    
    let viewModel: CardDetailsCheckoutViewModel
    var cardDetails: DojoCardDetails
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    public init(viewModel: CardDetailsCheckoutViewModel) {
        self.viewModel = viewModel
        self.cardDetails = viewModel.cardDetails3DS
        let nibName = String(describing: type(of: self))
        let podBundle = Bundle(for: type(of: self))
        super.init(nibName: nibName, bundle: podBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
    }

    @IBAction func onPayButtonPress(_ sender: Any) {
        activityIndicator.isHidden = false
        viewModel.processPayment(cardDetails: cardDetails,
                                 fromViewControlelr: self)
    }
    
    @IBAction func onAutocomplete3DS(_ sender: Any) {
        cardDetails = viewModel.cardDetails3DS
    }
    
    @IBAction func onAutocompleteNon3DS(_ sender: Any) {
        cardDetails = viewModel.cardDetailsNon3DS
    }
}
