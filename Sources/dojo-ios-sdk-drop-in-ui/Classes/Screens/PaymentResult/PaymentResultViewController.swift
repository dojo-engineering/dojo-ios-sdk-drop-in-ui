//
//  PaymentResultViewController.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 05/08/2022.
//

import UIKit
import dojo_ios_sdk

protocol PaymentResultViewControllerDelegate: BaseViewControllerDelegate {
    func onDonePress(resultCode: Int)
    func onPaymentIntentRefreshSucess(paymentIntent: PaymentIntent)
}

class PaymentResultViewController: BaseUIViewController {

    @IBOutlet weak var labelMainText: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var labelSubtitle2: UILabel!
    @IBOutlet weak var buttonDone: CustomFontButton!
    @IBOutlet weak var buttonTryAgain: LoadingButton!
    @IBOutlet weak var imgViewResult: UIImageView!
    
    var delegate: PaymentResultViewControllerDelegate?
    
    public init(viewModel: PaymentResultViewModel,
                theme: ThemeSettings,
                delegate: PaymentResultViewControllerDelegate) {
        self.delegate = delegate
        let nibName = String(describing: type(of: self))
        super.init(nibName: nibName, bundle: Bundle.libResourceBundle)
        self.displayCloseButton = true
        self.displayBackButton = false
        self.viewModel = viewModel
        self.theme = theme
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUIState()
        setupTranslations() // TODO: move to the base class
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let title: String? = {
            let viewModel = getViewModal()
            return viewModel?.resultCode == 0
            ? theme.customResultScreenTitleSuccess ?? viewModel?.navigationTitle
            : theme.customResultScreenTitleFail ?? viewModel?.navigationTitle
        }()
        setNavigationTitle(title ?? "")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // TODO: properly document
        buttonDone.titleLabel?.font = theme.fontPrimaryCTAButtonActive
    }
    
    func getViewModal() -> PaymentResultViewModel? {
        viewModel as? PaymentResultViewModel
    }
    
    func setupTranslations() {
        buttonDone.setTitle(LocalizedText.PaymentResult.buttonDone, for: .normal)
    }
    
    override func setUpDesign() {
        super.setUpDesign()
        labelMainText.textColor = theme.primaryLabelTextColor
        labelMainText.font = theme.fontHeading4Bold
        labelSubtitle.textColor = theme.primaryLabelTextColor
        labelSubtitle.font = theme.fontHeading5
        labelSubtitle2.textColor = theme.secondaryLabelTextColor
        labelSubtitle2.font = theme.fontBody1
    }
    
    func updateUIState() {
        let orderRef = "\(LocalizedText.PaymentResult.orderId) \(viewModel?.paymentIntent.reference ?? "")"
        labelSubtitle.text = theme.customResultScreenOrderIdText ?? orderRef
        if getViewModal()?.resultCode == 0 {
            buttonTryAgain.isHidden = true
            labelMainText.text = theme.customResultScreenMainTextSuccess ?? getViewModal()?.mainText
            labelSubtitle2.text = theme.customResultScreenAdditionalTextSuccess
            imgViewResult.image = UIImage(named: theme.lightStyleForDefaultElements ? "img-result-success-light" : "img-result-success-dark", in: Bundle.libResourceBundle, compatibleWith: nil)
            
            //TODO: common style
            buttonDone.backgroundColor = theme.primaryCTAButtonActiveBackgroundColor
            buttonDone.setTitleColor(theme.primaryCTAButtonActiveTextColor, for: .normal)
            buttonDone.tintColor = theme.primaryCTAButtonActiveTextColor
            buttonDone.layer.cornerRadius = theme.primaryCTAButtonCornerRadius
            
        } else {
            buttonTryAgain.isHidden = false
            buttonTryAgain.setTitle(LocalizedText.PaymentResult.buttonTryAgain, for: .normal)
            labelMainText.text = theme.customResultScreenMainTextFail ?? getViewModal()?.mainText
            if let viewModel = viewModel, viewModel.paymentIntent.isSetupIntent {
                labelSubtitle.text = theme.customResultScreenAdditionalTextFail ?? LocalizedText.PaymentResult.mainSubtitleSetupFail
                labelSubtitle2.isHidden = true
                labelSubtitle.textColor = theme.secondaryLabelTextColor
                labelSubtitle.font = theme.fontBody1
            } else {
                labelSubtitle2.text = theme.customResultScreenAdditionalTextFail ?? LocalizedText.PaymentResult.mainErrorMessage
            }
            
            labelSubtitle.isHidden = false
            imgViewResult.image = UIImage(named: theme.lightStyleForDefaultElements ? "img-result-error-light" : "img-result-error-dark", in: Bundle.libResourceBundle, compatibleWith: nil)
            
            //TODO: common style
            buttonTryAgain.backgroundColor = theme.primaryCTAButtonActiveBackgroundColor
            buttonTryAgain.setTitleColor(theme.primaryCTAButtonActiveTextColor, for: .normal)
            buttonTryAgain.tintColor = theme.primaryCTAButtonActiveTextColor
            buttonTryAgain.layer.cornerRadius = theme.primaryCTAButtonCornerRadius
            
            buttonDone.backgroundColor = theme.primarySurfaceBackgroundColor
            buttonDone.setTitleColor(theme.primaryLabelTextColor, for: .normal)
            buttonDone.tintColor = theme.primaryLabelTextColor
            buttonDone.layer.cornerRadius = theme.primaryCTAButtonCornerRadius
            buttonDone.layer.borderWidth = 1
            buttonDone.layer.borderColor = theme.primaryCTAButtonActiveBackgroundColor.cgColor
        }
    }
    
    @objc override func onClosePress() {
        // close and done button behave the same on this screen (sending the final result to the app)
        exitFromTheScreen()
    }

    @IBAction func onDoneButtonPress(_ sender: Any) {
        // close and done button behave the same on this screen (sending the final result to the app)
        exitFromTheScreen()
    }
    
    @IBAction func onButtonTryAgainPress(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func exitFromTheScreen() {
        let result = getViewModal()?.resultCode ?? DojoSDKResponseCode.declined.rawValue
        delegate?.onDonePress(resultCode: result)
    }
}
