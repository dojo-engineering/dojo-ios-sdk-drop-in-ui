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
    
    public static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: PaymentMethodTableViewCell.cellId,
                                 bundle: Bundle(for: PaymentMethodTableViewCell.self)),
                           forCellReuseIdentifier: PaymentMethodTableViewCell.cellId)
    }
    
    func setTheme(theme: ThemeSettings) {
        labelMainTitle.font = theme.fontSubtitle1
        labelMainTitle.textColor = theme.primaryLabelTextColor
        
        labelSubtitle1.font = theme.fontBody2
        labelSubtitle1.textColor = theme.colorPoweredByButtons //TODO:
        
        labelSubtitle2.font = theme.fontSubtitle2
        labelSubtitle2.textColor = UIColor.black.withAlphaComponent(0.87) //TODO:
        backgroundColor = theme.primarySurfaceBackgroundColor
    }
    
    func setSelected(_ selected: Bool) {
        if selected {
            imageViewSelection.image = UIImage(named: "icon-button-radio-selected", in: Bundle(for: type(of: self)), compatibleWith: nil)
        } else {
            imageViewSelection.image = UIImage(named: "icon-button-radio", in: Bundle(for: type(of: self)), compatibleWith: nil)
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
            imageViewMain.image = UIImage(named: "img-apple-pay-logo", in: Bundle(for: type(of: self)), compatibleWith: nil)
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
