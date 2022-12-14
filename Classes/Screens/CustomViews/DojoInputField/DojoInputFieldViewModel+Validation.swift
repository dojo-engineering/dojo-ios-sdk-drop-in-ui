//
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 06/10/2022.
//

import UIKit

extension DojoInputFieldViewModel {
    
    /// Default check for a card number https://en.wikipedia.org/wiki/Luhn_algorithm
    /// - Parameter number: Card number
    /// - Returns: is valid or not
    func luhnCheck(_ number: String) -> Bool {
        var sum = 0
        let digitStrings = number.reversed().map { String($0) }

        for tuple in digitStrings.enumerated() {
            if let digit = Int(tuple.element) {
                let odd = tuple.offset % 2 == 1

                switch (odd, digit) {
                case (true, 9):
                    sum += 9
                case (true, 0...8):
                    sum += (digit * 2) % 9
                default:
                    sum += digit
                }
            } else {
                return false
            }
        }
        return sum % 10 == 0
    }
    
    func validateField(_ text: String?) -> DojoInputFieldState {
        guard let text = text, !text.isEmpty else { return .error}
        switch type {
        case .email:
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if !emailPred.evaluate(with: text) {
                return .error
            }
        case .cardNumber:
            if !luhnCheck(text.replacingOccurrences(of: " ", with: "")) {
                return .error
            }
        case .expiry:
            let textItems = text.split(separator: "/")
            if let month = textItems.first,
               let year = textItems.last,
               let monthInt = Int(month),
            let yearInt = Int(year),
            monthInt > 0 && monthInt < 13,
            yearInt > 21 && yearInt < 99 {
                return .normal
            } else {
                return .error
            }
        case .cvv:
            if text.count > 2 { //TODO: add amex check
                return .normal
            } else {
                return  .error
            }
        default:
            return .normal
        }
        
        return .normal
    }
    
    func isEmailValid(_ email: String) -> Bool {
        false
        
    }
}
