//
//  PaymentMethodCheckoutAdditonalItemTableViewCell.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 26/12/2022.
//

import UIKit

class PaymentMethodCheckoutAdditonalItemCell: UITableViewCell {
    public static let cellId = "PaymentMethodCheckoutAdditonalItemCell"

    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelCaption: UILabel!
    var theme: ThemeSettings?
    
    public static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: PaymentMethodCheckoutAdditonalItemCell.cellId,
                                 bundle: Bundle.libResourceBundle),
                           forCellReuseIdentifier: PaymentMethodCheckoutAdditonalItemCell.cellId)
    }
    
    func setTheme(theme: ThemeSettings) {
        self.theme = theme
        labelCaption.textColor = theme.secondaryLabelTextColor
        labelAmount.textColor = theme.secondaryLabelTextColor
        
        labelCaption.font = theme.fontSubtitle1
        labelAmount.font = theme.fontSubtitle1
    }
    
    func setUp(itemLine: ItemLine, currencySymbol: String) {
        labelCaption.text = itemLine.caption
        let amountText = "\(String(format: "%.2f", Double(itemLine.amountTotal.value)/100.0))"
        labelAmount.text = "\(currencySymbol)\(amountText)"
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
