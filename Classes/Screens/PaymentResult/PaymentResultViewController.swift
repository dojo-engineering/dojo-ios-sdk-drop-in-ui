//
//  PaymentResultViewController.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 05/08/2022.
//

import UIKit

protocol PaymentResultViewControllerDelegate {
    func onDonePress()
}

class PaymentResultViewController: UIViewController {

    @IBOutlet weak var labelMainText: UILabel!
    
    var viewModel: PaymentResultViewModel
    var delegate: PaymentResultViewControllerDelegate?
    
    public init(viewModel: PaymentResultViewModel,
                delegate: PaymentResultViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        let nibName = String(describing: type(of: self))
        let podBundle = Bundle(for: type(of: self))
        super.init(nibName: nibName, bundle: podBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMainText()
    }
    
    func updateMainText() {
        labelMainText.text = "Result code: \(viewModel.resultCode)"
    }

    @IBAction func onDoneButtonPress(_ sender: Any) {
        delegate?.onDonePress()
    }
}
