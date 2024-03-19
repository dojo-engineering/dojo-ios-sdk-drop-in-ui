//
//  PaymentMethodCheckoutViewController.swift
//  dojo-ios-sdk
//
//  Created by Deniss Kaibagarovs on 04/08/2022.
//

import UIKit
import PassKit

protocol PaymentMethodCheckoutViewControllerDelegate: BaseViewControllerDelegate {
    func navigateToManagePaymentMethods(_ selectedPaymentMethod: PaymentMethodItem?)
    func navigateToCardCheckout()
}

class PaymentMethodCheckoutViewController: BaseUIViewController {
    
    var delegate: PaymentMethodCheckoutViewControllerDelegate?
    
    @IBOutlet weak var labelTotalDue: UILabel!
    @IBOutlet weak var labelTotalAmount: UILabel!
    @IBOutlet weak var labelAdditionalLegal: UILabel!
    @IBOutlet weak var paymentButton: PKPaymentButton!
    @IBOutlet weak var buttonPayCard: LoadingButton!
    @IBOutlet weak var additionalItemsTableView: UITableView!
    @IBOutlet weak var selectedPaymentMethodView: SelectedPaymentMethodView!
    
    @IBOutlet weak var constraintPayButtonCardBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintPayButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintAdditionalItemsHeight: NSLayoutConstraint!
    public init(viewModel: PaymentMethodCheckoutViewModel,
                theme: ThemeSettings,
                delegate: PaymentMethodCheckoutViewControllerDelegate) {
        self.delegate = delegate
        let nibName = String(describing: type(of: self))
        super.init(nibName: nibName, bundle: Bundle.libResourceBundle)
        self.viewModel = viewModel
        self.baseDelegate = delegate
        self.theme = theme
        self.displayBackButton = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpKeyboard()
        setNavigationTitle(LocalizedText.PaymentMethodCheckout.title)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        removeKeyboardObservers()
    }
    
    override func setUpDesign() {
        super.setUpDesign()
        labelTotalDue.textColor = theme.primaryLabelTextColor
        labelTotalDue.font = theme.fontHeading5Medium
        
        labelTotalAmount.textColor = theme.primaryLabelTextColor
        labelTotalAmount.font = theme.fontHeading5Medium
        
        paymentButton.setValue(theme.applePayButtonStyle.rawValue, forKey: "style")
        paymentButton.layer.cornerRadius = theme.primaryCTAButtonCornerRadius
        paymentButton.clipsToBounds = true
        
        selectedPaymentMethodView.setTheme(theme: theme)
        
        buttonPayCard.setTheme(theme)
        
        labelAdditionalLegal.text = theme.additionalLegalText
        labelAdditionalLegal.numberOfLines = 0
        labelAdditionalLegal.font = theme.fontSubtitle2
        labelAdditionalLegal.textColor = theme.secondaryLabelTextColor
    }
    
    override func updateData(config: ConfigurationManager) {
        super.updateData(config: config)
        getViewModel()?.savedPaymentMethods = config.savedPaymentMethods
        
        if !(getViewModel()?.savedPaymentMethods?.contains(where: {$0.id == selectedPaymentMethodView.paymentMethod?.id}) ?? false) {
            // if selected payment method was removed remove it from the UI
            setupViews()
        }
    }
   
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            if let navigation = (navigationController as? BaseNavigationController) {
                navigation.heightConstraint?.constant = keyboardHeight + 286 - 15 + getHeightOfAdditionalLineItemsTable() + getHeightOfAdditionalLegalText()
            }
            
            constraintPayButtonBottom.constant = keyboardHeight - (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) - 15
            constraintPayButtonCardBottom.constant = constraintPayButtonBottom.constant
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        if let navigation = (navigationController as? BaseNavigationController) {
            navigation.heightConstraint?.constant = 286 + navigation.safeAreaBottomHeight + getHeightOfAdditionalLineItemsTable()//TODO: move to base
        }
        
        constraintPayButtonBottom.constant = 9
        constraintPayButtonCardBottom.constant = constraintPayButtonBottom.constant
    }
}

extension PaymentMethodCheckoutViewController {
    @IBAction func onPayUsingApplePayPress(_ sender: Any) {
        guard getViewModel()?.isApplePayAvailable() ?? false else {
            print("Apple pay is not available")
            return
        }
        
        getViewModel()?.processApplePayPayment(fromViewControlelr: self) { result in
            self.delegate?.navigateToPaymentResult(resultCode: result)
        }
    }
    
    @IBAction func onPayUsingSavedCard(_ sender: Any) {
        
        guard let selectedPaymentMethodId = selectedPaymentMethodView.paymentMethod?.id else {
            print("paymentMethod is not selected")
            
            if let isSavedPaymentMethodsAvailable = getViewModel()?.isSavedPaymentMethodsAvailable(),
                isSavedPaymentMethodsAvailable == false {
                delegate?.navigateToCardCheckout()
            } else {
                delegate?.navigateToManagePaymentMethods(nil)
            }
            return
        }
        guard let cvv = selectedPaymentMethodView.mainTextField.text else {
            print("cvv is empty")
            return
        }
        
        self.view.isUserInteractionEnabled = false
        buttonPayCard.showLoading(LocalizedText.CardDetailsCheckout.buttonProcessing)
        getViewModel()?.processSavedCardPayment(fromViewControlelr: self,
                                                paymentId: selectedPaymentMethodId,
                                                cvv: cvv) { result in
            self.buttonPayCard.hideLoading()
            self.view.isUserInteractionEnabled = true
            self.delegate?.navigateToPaymentResult(resultCode: result)
        }
    }
}

extension PaymentMethodCheckoutViewController {
    func getViewModel() -> PaymentMethodCheckoutViewModel? {
        viewModel as? PaymentMethodCheckoutViewModel
    }
    
    func paymentMethodSelected(_ item: PaymentMethodItem) {
        selectedPaymentMethodView.setPaymentMethod(item)
        switch item.type {
        case .applePay:
            buttonPayCard.isHidden = true
            paymentButton.isHidden = false
        default:
            buttonPayCard.isHidden = false
            paymentButton.isHidden = true
            buttonPayCard.setEnabled(false)
            setupViewHeightWithAdditionaLines(baseContentHeight: 286)
            selectedPaymentMethodView.isHidden = false
        }
        buttonPayCard.setTitle(getViewModel()?.paymentIntent.payButtonFormatted, for: .normal)
    }
}

extension PaymentMethodCheckoutViewController {
    
    func setUpKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func setUpTableView() {
        let showAdditinalItemsLine = getViewModel()?.showAdditionalItemsLine() ?? false
        additionalItemsTableView.isHidden = !showAdditinalItemsLine
        additionalItemsTableView.delegate = self
        additionalItemsTableView.dataSource = self
        PaymentMethodCheckoutAdditonalItemCell.register(tableView: additionalItemsTableView)
        
        additionalItemsTableView.rowHeight = CGFloat(getHeightOfAdditonalLineItem())
        constraintAdditionalItemsHeight.constant = getHeightOfAdditionalLineItemsTable()
    }
    
    func setupData() {
        if let value = getViewModel()?.paymentIntent.totalAmount?.getFormattedAmount() {
            labelTotalAmount.text = value
        } else {
            print("Error - can't format amount")
        }
    }
    
    func setUpViewStateApplePayNotAvailableWithSavedCards() {
        paymentButton.isHidden = true
        constraintPayButtonBottom.constant = 9
        buttonPayCard.setTheme(theme)
        setupViewHeightWithAdditionaLines(baseContentHeight: 218)
        
        selectedPaymentMethodView.isHidden = true
        buttonPayCard.isHidden = false
        let buttonPayTitle = LocalizedText.PaymentMethodCheckout.payByCard
        buttonPayCard.setTitle(buttonPayTitle, for: .normal)
        buttonPayCard.backgroundColor = theme.primaryCTAButtonActiveBackgroundColor
        buttonPayCard.setTitleColor(theme.primaryCTAButtonActiveTextColor, for: .normal)
        buttonPayCard.layer.borderWidth = 1
        buttonPayCard.layer.borderColor = theme.primaryCTAButtonActiveBackgroundColor.cgColor
    }
    
    func setUpViewStateApplePayNotAvailableWithoutSavedCard() {
        paymentButton.isHidden = true
        constraintPayButtonBottom.constant = 9
        buttonPayCard.setTheme(theme)
        setupViewHeightWithAdditionaLines(baseContentHeight: 210)
        
        selectedPaymentMethodView.isHidden = true
        buttonPayCard.isHidden = false
        
        let buttonPayTitle = LocalizedText.PaymentMethodCheckout.payByCard
        buttonPayCard.setTitle(buttonPayTitle, for: .normal)
        buttonPayCard.backgroundColor = theme.primaryCTAButtonActiveBackgroundColor
        buttonPayCard.setTitleColor(theme.primaryCTAButtonActiveTextColor, for: .normal)
        buttonPayCard.layer.borderWidth = 1
        buttonPayCard.layer.borderColor = theme.primaryCTAButtonActiveBackgroundColor.cgColor
    }
    
    func setUpViewStateApplePayAvailableWitoutSavedCard() {
        // ApplePay is available
        selectedPaymentMethodView.isHidden = false
        selectedPaymentMethodView.delegate = self
        selectedPaymentMethodView.setStyle(.applePay)
        
        selectedPaymentMethodView.isHidden = true
        constraintPayButtonBottom.constant = 70
        buttonPayCard.isHidden = false
        
        setupViewHeightWithAdditionaLines(baseContentHeight: 280)

        let buttonPayTitle = LocalizedText.PaymentMethodCheckout.payByCard
        buttonPayCard.setTitle(buttonPayTitle, for: .normal)
        buttonPayCard.backgroundColor = theme.primarySurfaceBackgroundColor
        buttonPayCard.setTitleColor(theme.primaryLabelTextColor, for: .normal)
        buttonPayCard.layer.borderWidth = 1
        buttonPayCard.layer.borderColor = theme.primaryLabelTextColor.cgColor
    }
    
    func setupViewHeightWithAdditionaLines(baseContentHeight: CGFloat) {
        if let navigation = (navigationController as? BaseNavigationController) {
            navigation.defaultHeight = baseContentHeight + getHeightOfAdditionalLineItemsTable() + getHeightOfAdditionalLegalText()
        }
    }
    
    func setUpViewStateDefault() {
        setUpTableView()
        selectedPaymentMethodView.paymentMethod = nil
        buttonPayCard.setEnabled(true)
        selectedPaymentMethodView.delegate = self
        buttonPayCard.isHidden = true
    }
    
    func setupViews() {
        setUpViewStateDefault()
        if getViewModel()?.isSavedPaymentMethodsAvailable() ?? false {
            if getViewModel()?.isApplePayAvailable() ?? false == false {
                setUpViewStateApplePayNotAvailableWithSavedCards()
            } else {
                setupViewHeightWithAdditionaLines(baseContentHeight: 286)
            }
        } else {
            if getViewModel()?.isApplePayAvailable() ?? false == false {
                setUpViewStateApplePayNotAvailableWithoutSavedCard()
            } else if getViewModel()?.isApplePayAvailable() ?? false {
                setUpViewStateApplePayAvailableWitoutSavedCard()
            }
        }
    }
    
}

extension PaymentMethodCheckoutViewController: SelectedPaymentMethodViewDelegate {
    func onCVVStateChange(_ isValid: Bool) {
        buttonPayCard.setEnabled(isValid)
    }
    
    func onPress(_ item: PaymentMethodItem) {
        delegate?.navigateToManagePaymentMethods(item)
    }
}


extension PaymentMethodCheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.paymentIntent.itemLines?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodCheckoutAdditonalItemCell.cellId) as?
            PaymentMethodCheckoutAdditonalItemCell {
            cell.setTheme(theme: theme)
            // TODO move to viewModel
            if let item = viewModel?.paymentIntent.itemLines?[indexPath.row] {
                cell.setUp(itemLine: item)
            }
            return cell
        }
        return UITableViewCell.init(style: .default, reuseIdentifier: "")
    }
    
    func getHeightOfAdditionalLineItemsTable() -> CGFloat {
        let numberOfItems = viewModel?.paymentIntent.itemLines?.count ?? 0
        let maximumNumberOfItemsBeforeScroll = 4
        if numberOfItems > maximumNumberOfItemsBeforeScroll {
            // cap number of lines to the limit, if limit is reached start scrolling
            return CGFloat(maximumNumberOfItemsBeforeScroll * getHeightOfAdditonalLineItem())
        }
        return CGFloat(numberOfItems * getHeightOfAdditonalLineItem())
    }
    
    func getHeightOfAdditionalLegalText() -> CGFloat {
        guard let text = labelAdditionalLegal.text,
              !text.isEmpty else {
            return 0
        }
        // 32 = 16 x 2 which is view's padding from both sides
        return heightOf(text: text, withConstrainedWidth: self.view.frame.width - 32, font: labelAdditionalLegal.font)
    }
    
    func heightOf(text: String, withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func getHeightOfAdditonalLineItem() -> Int {
        26
    }
}
