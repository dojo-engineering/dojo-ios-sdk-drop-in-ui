//
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

struct CardUtils {
    /// Default check for a card number https://en.wikipedia.org/wiki/Luhn_algorithm
    /// - Parameter number: Card number
    /// - Returns: is valid or not
    static func luhnCheck(_ number: String) -> Bool {
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
    
    static func isExpiryValid(_ expiry: String) -> Bool {
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
    
    static func isCVCValid(_ cvv: String) -> Bool {
       cvv.count > 2 && Int(cvv) != nil
    }
    
    static func getCardScheme(_ text: String?) -> CardSchemes? {
        let amexRegEx = "^3[47].*$"
        let visaRegEx = "^4.*$"
        let masterRegEx = "^5[12345].*$"
        let maestroRegEx = "^(5018|5020|5038|6304|6759|6761|6763).*$"
        
        if CommonUtils.evaluateRegex(regex: amexRegEx, textToVerify: text) {
            return .amex
        }
        
        if CommonUtils.evaluateRegex(regex: visaRegEx, textToVerify: text) {
            return .visa
        }
        
        if CommonUtils.evaluateRegex(regex: masterRegEx, textToVerify: text) {
            return .mastercard
        }
        
        if CommonUtils.evaluateRegex(regex: maestroRegEx, textToVerify: text) {
            return .maestro
        }
        
        return nil
    }
}
