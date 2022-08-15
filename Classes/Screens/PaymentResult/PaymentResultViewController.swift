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
    @IBOutlet weak var labelPoweredBy: UILabel!
    
    var viewModel: PaymentResultViewModel
    var delegate: PaymentResultViewControllerDelegate?
    
    public init(viewModel: PaymentResultViewModel,
                delegate: PaymentResultViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        let nibName = String(describing: type(of: self))
        let podBundle = Bundle(for: type(of: self))
        super.init(nibName: nibName, bundle: podBundle)
        self.displayCloseButton = true
        self.displayBackButton = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        //TODO: move from here to the base class
        self.closeButtonTintColor = viewModel.theme.headerButtonTintColor
        super.viewDidLoad()
        updateMainText()
        setupTheme()
    }
    
    func setupTheme() {
        self.view.backgroundColor = viewModel.theme.primarySurfaceBackgroundColor
        labelMainText.textColor = viewModel.theme.primaryLabelTextColor
        labelSubtitle.textColor = viewModel.theme.primaryLabelTextColor
        labelSubtitle2.textColor = viewModel.theme.secondaryLabelTextColor
        
        //TODO: common style
        buttonDone.backgroundColor = viewModel.theme.primaryCTAButtonActiveBackgroundColor
        buttonDone.setTitleColor(viewModel.theme.primaryCTAButtonActiveTextColor, for: .normal)
        buttonDone.layer.cornerRadius = viewModel.theme.primaryCTAButtonCornerRadius
        
        labelPoweredBy.textColor = viewModel.theme.primaryCTAButtonActiveBackgroundColor
        imgViewPoweredBy.tintColor = viewModel.theme.primaryCTAButtonActiveBackgroundColor //TODO: specific property
    }
    
    func updateMainText() {
        if viewModel.resultCode == 0 {
            labelMainText.text = "Payment successful"
        } else {
            labelMainText.text = "Result code: \(viewModel.resultCode)"
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
