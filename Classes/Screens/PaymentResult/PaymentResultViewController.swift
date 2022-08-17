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
    
    //TODO: move to an external element
    @IBOutlet weak var imgViewPoweredBy: UIImageView!
    @IBOutlet weak var imgViewResult: UIImageView!
    @IBOutlet weak var labelPoweredBy: UILabel!
    
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
        self.title = "Result"
        super.viewDidLoad()
        updateUIState()
    }
    
    override func setUpDesign() {
        super.setUpDesign()
        labelMainText.textColor = theme.primaryLabelTextColor
        labelSubtitle.textColor = theme.primaryLabelTextColor
        labelSubtitle2.textColor = theme.secondaryLabelTextColor
        
        //TODO: common style
        buttonDone.backgroundColor = theme.primaryCTAButtonActiveBackgroundColor
        buttonDone.setTitleColor(theme.primaryCTAButtonActiveTextColor, for: .normal)
        buttonDone.layer.cornerRadius = theme.primaryCTAButtonCornerRadius
        
        labelPoweredBy.textColor = theme.primaryCTAButtonActiveBackgroundColor
        imgViewPoweredBy.tintColor = theme.primaryCTAButtonActiveBackgroundColor //TODO: specific property
    }
    
    func updateUIState() {
        if viewModel.resultCode == 0 {
            labelMainText.text = "Payment successful"
            imgViewResult.image = UIImage(named: "img-result-success-light", in: Bundle(for: type(of: self)), compatibleWith: nil)
        } else {
            labelMainText.text = "Payment failed"
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
