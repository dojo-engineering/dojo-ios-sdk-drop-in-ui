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
    
    @IBOutlet weak var tableViewPaymentMethods: UITableView!
    
    @IBOutlet weak var buttonUseSelectedPaymentMethod: UIButton!
    @IBOutlet weak var buttonPayUsingNewCard: UIButton!
    
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
        setupTableView()

        // Do any additional setup after loading the view.
    }
    
    override func setUpDesign() {
        super.setUpDesign()
        
        //TODO: common style
        buttonUseSelectedPaymentMethod.backgroundColor = theme.primaryCTAButtonActiveBackgroundColor
        buttonUseSelectedPaymentMethod.setTitleColor(theme.primaryCTAButtonActiveTextColor, for: .normal)
        buttonUseSelectedPaymentMethod.tintColor = theme.primaryCTAButtonActiveTextColor
        buttonUseSelectedPaymentMethod.layer.cornerRadius = theme.primaryCTAButtonCornerRadius
        
        //TODO: for demo only
        buttonPayUsingNewCard.backgroundColor = .white
        buttonPayUsingNewCard.setTitleColor(theme.primaryLabelTextColor, for: .normal)
        buttonPayUsingNewCard.tintColor = theme.primaryLabelTextColor
        buttonPayUsingNewCard.layer.cornerRadius = theme.primaryCTAButtonCornerRadius
        buttonPayUsingNewCard.layer.cornerRadius = theme.primaryCTAButtonCornerRadius
        
        buttonPayUsingNewCard.layer.borderWidth = 1
        buttonPayUsingNewCard.layer.borderColor = theme.primaryCTAButtonActiveBackgroundColor.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationTitle(LocalizedText.ManagePaymentMethods.title)
    }
    
    func setupTableView() {
        tableViewPaymentMethods.delegate = self
        tableViewPaymentMethods.dataSource = self
        PaymentMethodTableViewCell.register(tableView: tableViewPaymentMethods)
        
        tableViewPaymentMethods.contentInset = UIEdgeInsets(top: 16,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
    }
    
    @IBAction func onPayUsingNewCardPress(_ sender: Any) {
        delegate?.onPayUsingNewCardPress()
    }
    
    @IBAction func onUseThisPaymentMethodPress(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
}

extension ManagePaymentMethodsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodTableViewCell.cellId) as?
            PaymentMethodTableViewCell {
            cell.setTheme(theme: theme)
            return cell
        }
        return UITableViewCell.init(style: .default, reuseIdentifier: "")
    }
}
