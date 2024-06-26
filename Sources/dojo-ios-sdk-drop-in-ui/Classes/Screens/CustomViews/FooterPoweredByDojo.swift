//
//  FooterPoweredByDojo.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 18/08/2022.
//

import UIKit

enum FooterPoweredByDojoStyle {
    static let `default`: [FooterPoweredByDojoItems] = [.poweredBy]
    static let checkoutPage: [FooterPoweredByDojoItems] = [.poweredBy, .terms, .privacy]
}

enum FooterPoweredByDojoItems {
    case poweredBy
    case privacy
    case terms
}

class FooterPoweredByDojo: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var labelPoweredBy: UILabel!
    @IBOutlet weak var buttonPrivacy: UIButton!
    @IBOutlet weak var buttonTerms: UIButton!
    @IBOutlet weak var viewSeparator: UIView!
    @IBOutlet weak var stackViewRight: UIStackView!
    @IBOutlet weak var stackViewLeft: UIStackView!
    @IBOutlet var constraintPoweredByCenter: NSLayoutConstraint!
    @IBOutlet var constraintPoweredByTailing: NSLayoutConstraint!
    @IBOutlet weak var constraintButtonByCenter: NSLayoutConstraint!
    @IBOutlet weak var constraintButtonByLeft: NSLayoutConstraint!
    let viewModel = FooterPoweredByViewModel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func setTheme(theme: ThemeSettings) {
        labelPoweredBy.textColor = theme.colorPoweredByDojoText
        labelPoweredBy.font = theme.fontPoweredByDojo
        labelPoweredBy.setTextSpacingBy(value: 0.5)
        imageLogo.tintColor = theme.colorPoweredByDojoLogo
        viewSeparator.backgroundColor = theme.colorPoweredBySeparator
        
        buttonTerms.tintColor = theme.colorPoweredByButtons
        buttonPrivacy.tintColor = theme.colorPoweredByButtons
        
        buttonTerms.titleLabel?.font = theme.fontSubtitle2
        buttonPrivacy.titleLabel?.font = theme.fontSubtitle2
        
        viewModel.showBranding = theme.showBranding
    }
    
    func setStyle(_ styleItems: [FooterPoweredByDojoItems] = FooterPoweredByDojoStyle.default) {
        labelPoweredBy.isHidden = true
        buttonTerms.isHidden = true
        buttonPrivacy.isHidden = true
        viewSeparator.isHidden = true
        stackViewRight.isHidden = true
        
        if styleItems.contains(where: {$0 == .poweredBy}) { labelPoweredBy.isHidden = false }
        if styleItems.contains(where: {$0 == .terms}) { buttonTerms.isHidden = false }
        if styleItems.contains(where: {$0 == .privacy}) { buttonPrivacy.isHidden = false }
        
        // if any of the text is visible - show separator
        let termsOrPrivacyIsVisible = (!buttonTerms.isHidden || !buttonPrivacy.isHidden)
        viewSeparator.isHidden = !termsOrPrivacyIsVisible
        stackViewRight.isHidden = !termsOrPrivacyIsVisible
        
        if termsOrPrivacyIsVisible {
            constraintPoweredByTailing.isActive = true
            constraintPoweredByCenter.isActive = false
        } else {
            constraintPoweredByTailing.isActive = false
            constraintPoweredByCenter.isActive = true
        }
        
        if !viewModel.showBranding {
            stackViewLeft.isHidden = true
            viewSeparator.isHidden = true
            constraintButtonByCenter.isActive = true
            constraintButtonByLeft.isActive = false
        }
    }
    
    func initSubviews() {
        let nib = UINib(nibName: String(describing: type(of: self)),
                        bundle: Bundle.libResourceBundle)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        // Additional setup
        setupTranslations()
        setStyle()
    }
    
    func setupTranslations() {
        labelPoweredBy.text = LocalizedText.PoweredBy.title
        buttonTerms.setTitle(LocalizedText.PoweredBy.terms, for: .normal)
        buttonPrivacy.setTitle(LocalizedText.PoweredBy.privacy, for: .normal)
    }
    
    @IBAction func onPrivacyButtonPress(_ sender: Any) {
        openURL(viewModel.privacyURL)
    }
    
    @IBAction func onTermsButtonPress(_ sender: Any) {
        openURL(viewModel.termsURL)
    }
}

extension FooterPoweredByDojo {
    func openURL(_ url: URL?) {
        if let url = url {
            UIApplication.shared.open(url)
        }
    }
}
