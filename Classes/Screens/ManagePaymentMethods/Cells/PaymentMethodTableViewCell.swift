//
//  PaymentMethodTableViewCell.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 12/09/2022.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {
    
    public static let cellId = "PaymentMethodTableViewCell"
    
    @IBOutlet weak var imageViewSelection: UIImageView!
    @IBOutlet weak var imageViewMain: UIImageView!
    @IBOutlet weak var labelMainTitle: UILabel!
    @IBOutlet weak var labelSubtitle1: UILabel!
    @IBOutlet weak var labelSubtitle2: UILabel!
    
    var cellType: PaymentMethodType?
    var paymentMethodId: String?
    var theme: ThemeSettings?
    
    public static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: PaymentMethodTableViewCell.cellId,
                                 bundle: Bundle(for: PaymentMethodTableViewCell.self)),
                           forCellReuseIdentifier: PaymentMethodTableViewCell.cellId)
    }
    
    func setTheme(theme: ThemeSettings) {
        self.theme = theme
        labelMainTitle.font = theme.fontSubtitle1
        labelMainTitle.textColor = theme.primaryLabelTextColor
        
        labelSubtitle1.font = theme.fontBody2
        labelSubtitle1.textColor = theme.secondaryLabelTextColor
        
        labelSubtitle2.font = theme.fontSubtitle2
        labelSubtitle2.textColor = theme.primaryLabelTextColor
        backgroundColor = theme.primarySurfaceBackgroundColor
        imageViewSelection.tintColor = theme.inputElementDefaultTintColor
    }
    
    func setSelected(_ selected: Bool) {
        if selected {
            imageViewSelection.image = UIImage(named: "icon-button-radio-selected", in: Bundle.libResourceBundle, compatibleWith: nil)
            imageViewSelection.tintColor = theme?.inputElementActiveTintColor
        } else {
            imageViewSelection.image = UIImage(named: "icon-button-radio", in: Bundle.libResourceBundle, compatibleWith: nil)
            imageViewSelection.tintColor = theme?.inputElementDefaultTintColor
        }
    }
    
    func setType(_ cellType: PaymentMethodType, additionalText: String) {
        self.cellType = cellType
                
        labelSubtitle1.isHidden = true //TODO: Add themes
        labelSubtitle2.isHidden = true
        labelMainTitle.isHidden = true
        switch cellType {
        case .applePay: //TODO: text to loc
            labelMainTitle.isHidden = false
            labelMainTitle.text = "Apple Pay"
            imageViewMain.image = UIImage(named: "img-apple-pay-logo", in: Bundle.libResourceBundle, compatibleWith: nil)
        case .mastercard:
            labelSubtitle1.isHidden = false
            labelSubtitle2.isHidden = false
            
            labelSubtitle1.text = "Mastercard"
            labelSubtitle2.text = additionalText
            imageViewMain.image = UIImage.getCardIcon(type: .mastercard)
        case .maestro:
            labelSubtitle1.isHidden = false
            labelSubtitle2.isHidden = false
            
            labelSubtitle1.text = "Maestro"
            labelSubtitle2.text = additionalText
            imageViewMain.image = UIImage.getCardIcon(type: .maestro)
        case .visa:
            labelSubtitle1.isHidden = false
            labelSubtitle2.isHidden = false
            
            labelSubtitle1.text = "Visa"
            labelSubtitle2.text = additionalText
            imageViewMain.image = UIImage.getCardIcon(type: .visa)
        case .amex:
            labelSubtitle1.isHidden = false
            labelSubtitle2.isHidden = false
            
            labelSubtitle1.text = "Amex"
            labelSubtitle2.text = additionalText
            imageViewMain.image = UIImage.getCardIcon(type: .amex)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
