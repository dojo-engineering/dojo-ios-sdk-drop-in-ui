//
//  DojoInputField.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 06/10/2022.
//

import UIKit

enum DojoInputFieldType {
    case email
    case cardHolderName
}

class DojoInputField: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var mainTextField: UITextField!
    
    var viewModel: DojoInputFieldViewModel?
    
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
    }
    
    func setType(_ type: DojoInputFieldType) {
        self.viewModel = DojoInputFieldViewModel(type: type)
        reloadUI()
    }
    
    func reloadUI() {
        guard let viewModel = viewModel else { return } //TODO: notify about an error
        mainTextField.keyboardType = viewModel.getKeyboardType()
    }
}


class DojoInputFieldViewModel {
    
    let type: DojoInputFieldType
    
    init(type: DojoInputFieldType) {
        self.type = type
    }
    
    func getKeyboardType() -> UIKeyboardType {
        switch type {
        case .email:
            return .emailAddress
        case .cardHolderName:
            return .default
        }
    }
}
