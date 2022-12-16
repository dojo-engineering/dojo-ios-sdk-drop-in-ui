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
        guard !number.isEmpty else {return false}
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
            if !isEmailValid(text) {
                return .error
            }
        case .cardNumber:
            if !isCardNumberValid(text.replacingOccurrences(of: " ", with: "")) {
                return .error
            }
        case .expiry:
            if !isExpiryValid(text) {
                return .error
            }
        case .cvv:
            if !isCVVValid(text) {
                return .error
            }
        default:
            return .normal
        }
        
        return .normal
    }
    
    func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return evaluateRegex(regex: emailRegEx, textToVerify: email)
    }
    
    func isCardNumberValid(_ cardNumber: String) -> Bool {
        luhnCheck(cardNumber)
    }
    
    func isExpiryValid(_ expiry: String) -> Bool {
        let textItems = expiry.split(separator: "/")
        if let month = textItems.first,
           let year = textItems.last,
           let monthInt = Int(month),
        let yearInt = Int(year),
        monthInt > 0 && monthInt < 13,
        yearInt > 21 && yearInt < 99 {
            return true
        } else {
            return false
        }
    }
    
    func isCVVValid(_ cvv: String) -> Bool {
       cvv.count > 2 && Int(cvv) != nil
    }
    
    func getCardScheme(_ text: String?) -> CardSchemes? {
        let amexRegEx = "^3[47].*$"
        let visaRegEx = "^4.*$"
        let masterRegEx = "^5[12345].*$"
        let maestroRegEx = "^(5018|5020|5038|6304|6759|6761|6763).*$"
        
        if evaluateRegex(regex: amexRegEx, textToVerify: text) {
            return .amex
        }
        
        if evaluateRegex(regex: visaRegEx, textToVerify: text) {
            return .visa
        }
        
        if evaluateRegex(regex: masterRegEx, textToVerify: text) {
            return .mastercard
        }
        
        if evaluateRegex(regex: maestroRegEx, textToVerify: text) {
            return .maestro
        }
        
        return nil
    }
    
    func evaluateRegex(regex: String, textToVerify: String?) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: textToVerify)
    }
}
