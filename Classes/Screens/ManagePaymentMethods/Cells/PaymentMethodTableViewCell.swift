//
//  PaymentMethodTableViewCell.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 12/09/2022.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {
    
    public static let cellId = "PaymentMethodTableViewCell"
    
    @IBOutlet weak var labelMainTitle: UILabel!
    
    public static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: PaymentMethodTableViewCell.cellId,
                                 bundle: Bundle(for: PaymentMethodTableViewCell.self)),
                           forCellReuseIdentifier: PaymentMethodTableViewCell.cellId)
    }
    
    func setTheme(theme: ThemeSettings) {
        labelMainTitle.font = theme.fontSubtitle1
        labelMainTitle.textColor = theme.primaryLabelTextColor
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
