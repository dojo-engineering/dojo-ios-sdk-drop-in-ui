//
//  FooterPoweredByDojo.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 18/08/2022.
//

import UIKit

class FooterPoweredByDojo: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var labelPoweredBy: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func setTheme(theme: ThemeSettings) {
        labelPoweredBy.textColor = theme.colorPoweredByDojo
        labelPoweredBy.font = theme.fontPoweredByDojo
        labelPoweredBy.setTextSpacingBy(value: 0.5)
        imageLogo.tintColor = theme.colorPoweredByDojo
    }
    
    func initSubviews() {
        let nib = UINib(nibName: String(describing: type(of: self)),
                        bundle: Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
}
