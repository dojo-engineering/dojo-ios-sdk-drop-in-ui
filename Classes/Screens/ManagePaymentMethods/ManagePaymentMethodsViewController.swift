//
//  ManagePaymentMethodsViewController.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 05/08/2022.
//

import UIKit

protocol ManagePaymentMethodsViewControllerDelegate: BaseViewControllerDelegate {
    func onPayUsingNewCardPress()
}

class ManagePaymentMethodsViewController: BaseUIViewController {
    
    var delegate: ManagePaymentMethodsViewControllerDelegate?
    
    public init(theme: ThemeSettings,
                delegate: ManagePaymentMethodsViewControllerDelegate) {
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

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationTitle("Change payment method")
    }
    
    @IBAction func onPayUsingNewCardPress(_ sender: Any) {
        delegate?.onPayUsingNewCardPress()
    }
}
