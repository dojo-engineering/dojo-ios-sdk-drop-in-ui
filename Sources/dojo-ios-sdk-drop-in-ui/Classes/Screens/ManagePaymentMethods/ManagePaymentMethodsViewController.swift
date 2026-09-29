//
//  ManagePaymentMethodsViewController.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 05/08/2022.
//

import UIKit

protocol ManagePaymentMethodsViewControllerDelegate: BaseViewControllerDelegate {
    func onPayUsingNewCardPress()
    func onPayUsingPaymentMethod(_ item: PaymentMethodItem)
    func onRemoveSavedPaymentMethod(_ id: String)
}

class ManagePaymentMethodsViewController: BaseUIViewController {
    
    var delegate: ManagePaymentMethodsViewControllerDelegate?
    
    @IBOutlet weak var tableViewPaymentMethods: UITableView!
    @IBOutlet weak var buttonUseSelectedPaymentMethod: LoadingButton!
    @IBOutlet weak var buttonPayUsingNewCard: CustomFontButton!
    
    public init(viewModel: ManagePaymentMethodsViewModel,
                theme: ThemeSettings,
                delegate: ManagePaymentMethodsViewControllerDelegate) {
        self.delegate = delegate
        let nibName = String(describing: type(of: self))
        super.init(nibName: nibName, bundle: Bundle.libResourceBundle)
        self.baseDelegate = delegate
        self.viewModel = viewModel
        self.theme = theme
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func setUpDesign() {
        super.setUpDesign()
        
        tableViewPaymentMethods.backgroundColor = theme.primarySurfaceBackgroundColor
        
        //TODO: for demo only
        buttonPayUsingNewCard.backgroundColor = theme.primarySurfaceBackgroundColor
        buttonPayUsingNewCard.setTitleColor(theme.secondaryCTAButtonActiveTextColor, for: .normal)
        buttonPayUsingNewCard.tintColor = theme.secondaryCTAButtonActiveTextColor
        buttonPayUsingNewCard.layer.cornerRadius = theme.primaryCTAButtonCornerRadius
        
        buttonPayUsingNewCard.layer.borderWidth = 1
        buttonPayUsingNewCard.layer.borderColor = theme.secondaryCTAButtonActiveBorderColor.cgColor
        
        if let _ = getViewModel()?.getSavedPaymentItems().first(where: {$0.selected}) {
            //TODO: common style
            buttonUseSelectedPaymentMethod.isUserInteractionEnabled = true
            buttonUseSelectedPaymentMethod.backgroundColor = theme.primaryCTAButtonActiveBackgroundColor
            buttonUseSelectedPaymentMethod.setTitleColor(theme.primaryCTAButtonActiveTextColor, for: .normal)
            buttonUseSelectedPaymentMethod.tintColor = theme.primaryCTAButtonActiveTextColor
            buttonUseSelectedPaymentMethod.layer.cornerRadius = theme.primaryCTAButtonCornerRadius
        } else {
            // if no selected item - disable "Use this payment method" button
            buttonUseSelectedPaymentMethod.setTheme(theme)
            buttonUseSelectedPaymentMethod.setEnabled(false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationTitle(LocalizedText.ManagePaymentMethods.title)
    }
    
    func setupTableView() {
        tableViewPaymentMethods.rowHeight = UITableView.automaticDimension;
        tableViewPaymentMethods.delegate = self
        tableViewPaymentMethods.dataSource = self
        tableViewPaymentMethods.allowsMultipleSelectionDuringEditing = false
        tableViewPaymentMethods.isExclusiveTouch = true
        tableViewPaymentMethods.delaysContentTouches = true
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
        if let viewModel = getViewModel(),
           let paymentMethod = viewModel.getSavedPaymentItems().first(where: {$0.selected}) {
            delegate?.onPayUsingPaymentMethod(paymentMethod)
        }
    }
    
    func getViewModel() -> ManagePaymentMethodsViewModel? {
        viewModel as? ManagePaymentMethodsViewModel
    }
}

extension ManagePaymentMethodsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getViewModel()?.getSavedPaymentItems().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodTableViewCell.cellId) as?
            PaymentMethodTableViewCell {
            cell.setTheme(theme: theme)
            if let item = getViewModel()?.getSavedPaymentItems()[indexPath.row] {
                cell.setType(item.type, additionalText: item.title)
                cell.setSelected(item.selected)
            }
            return cell
        }
        return UITableViewCell.init(style: .default, reuseIdentifier: "")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = getViewModel() {
            viewModel.setItemSelected(viewModel.getSavedPaymentItems()[indexPath.row])
            tableView.reloadData()
         }
        //reload buttons view
        setUpDesign()
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // only handle delete
        guard editingStyle == .delete else {
            return
        }
        showRemovePaymentMethodAlert() {
            if let removedItem = self.getViewModel()?.removeItemAtIndex(indexPath.row) {
                self.delegate?.onRemoveSavedPaymentMethod(removedItem.id)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // we can only remove items that are not WalletPayments and are not selected
        if let item = getViewModel()?.getSavedPaymentItems()[indexPath.row],
           item.type != .applePay,
           item.selected == false {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0,
           let viewModel = getViewModel() {
            if viewModel.getSavedPaymentItems().first?.type == .applePay {
                return 55
            }
        }
        return 79
    }
}

extension ManagePaymentMethodsViewController {
    func showRemovePaymentMethodAlert(onConfrim : @escaping(() -> Void?)) {
        let alert = UIAlertController(title: LocalizedText.ManagePaymentMethods.alertRemoveTitle,
                                      message: LocalizedText.ManagePaymentMethods.alertRemoveBody,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: LocalizedText.ManagePaymentMethods.alertRemoveConfirm, style: .destructive, handler: { _ in
            onConfrim()
        }))
        if #available(iOS 13.0, *) {
            alert.overrideUserInterfaceStyle = theme.lightStyleForDefaultElements == true ? .light : .dark
        }
        alert.addAction(UIAlertAction(title: LocalizedText.ManagePaymentMethods.alertRemoveCancel, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
