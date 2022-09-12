//
//  SelectedPaymentMethodView.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 12/09/2022.
//

import UIKit

enum SelectedPaymentMethodViewStyle {
    case applePay
}

protocol SelectedPaymentMethodViewDelegate {
    func onPress()
}

class SelectedPaymentMethodView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var imgArrowRight: UIImageView!
    @IBOutlet weak var labelMainTitle: UILabel!
    
    public var delegate: SelectedPaymentMethodViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: String(describing: type(of: self)),
                        bundle: Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        contentView.addGestureRecognizer(tap)
        
        // Additional setup
        setStyle()
    }
    
    func setTheme(theme: ThemeSettings) {
        imgArrowRight.tintColor = theme.headerButtonTintColor
        labelMainTitle.font = theme.fontSubtitle1
        labelMainTitle.textColor = theme.primaryLabelTextColor
    }
    
    func setStyle(_ style: SelectedPaymentMethodViewStyle = .applePay) {
        
       
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.onPress()
    }
}
