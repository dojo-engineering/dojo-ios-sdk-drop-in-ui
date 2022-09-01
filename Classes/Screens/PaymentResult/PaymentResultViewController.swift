//
//  PaymentResultViewController.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 05/08/2022.
//

import UIKit

protocol PaymentResultViewControllerDelegate: BaseViewControllerDelegate {
    func onDonePress(resultCode: Int)
}

class PaymentResultViewController: BaseUIViewController {

    @IBOutlet weak var labelMainText: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var labelSubtitle2: UILabel!
    @IBOutlet weak var buttonDone: UIButton!
    
    @IBOutlet weak var imgViewResult: UIImageView!
    
    var viewModel: PaymentResultViewModel
    var delegate: PaymentResultViewControllerDelegate?
    
    public init(viewModel: PaymentResultViewModel,
                theme: ThemeSettings,
                delegate: PaymentResultViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        let nibName = String(describing: type(of: self))
        let podBundle = Bundle(for: type(of: self))
        super.init(nibName: nibName, bundle: podBundle)
        self.displayCloseButton = true
        self.displayBackButton = false
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
        //TODO: move to a better place
        if viewModel.resultCode == 0 {
            setNavigationTitle(LocalizedText.PaymentResult.titleSuccess)
        } else {
            setNavigationTitle(LocalizedText.PaymentResult.titleFail)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // TODO: properly document
        buttonDone.titleLabel?.font = theme.fontPrimaryCTAButtonActive
    }
    
    func setupTranslations() {
        buttonDone.setTitle(LocalizedText.PaymentResult.buttonDone, for: .normal)
    }
    
    override func setUpDesign() {
        super.setUpDesign()
        labelMainText.textColor = theme.primaryLabelTextColor
        labelMainText.font = theme.fontHeading4
        labelSubtitle.textColor = theme.primaryLabelTextColor
        labelSubtitle.font = theme.fontHeading5
        labelSubtitle2.textColor = theme.secondaryLabelTextColor
        labelSubtitle2.font = theme.fontBody1
        
        //TODO: common style
        buttonDone.backgroundColor = theme.primaryCTAButtonActiveBackgroundColor
        buttonDone.setTitleColor(theme.primaryCTAButtonActiveTextColor, for: .normal)
        buttonDone.tintColor = theme.primaryCTAButtonActiveTextColor
        buttonDone.layer.cornerRadius = theme.primaryCTAButtonCornerRadius
    }
    
    func updateUIState() {
        if viewModel.resultCode == 0 {
            labelMainText.text = LocalizedText.PaymentResult.mainTitleSuccess
            imgViewResult.image = UIImage(named: "img-result-success-light", in: Bundle(for: type(of: self)), compatibleWith: nil)
        } else {
            labelMainText.text = LocalizedText.PaymentResult.mainTitleFail
            imgViewResult.image = UIImage(named: "img-result-error-light", in: Bundle(for: type(of: self)), compatibleWith: nil)
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
    
    private func exitFromTheScreen() {
        delegate?.onDonePress(resultCode: viewModel.resultCode)
    }
}

extension UILabel {
  func setTextSpacingBy(value: Double) {
    if let textString = self.text {
      let attributedString = NSMutableAttributedString(string: textString)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: value, range: NSRange(location: 0, length: attributedString.length - 1))
      attributedText = attributedString
    }
  }
}
