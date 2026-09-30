//
//  String+Common.swift
//
//  Created by Deniss Kaibagarovs on 05/04/2021.
//

import Foundation

extension PaymentIntent {
    var payButtonFormatted: String {
        return "Pay \((totalAmount ?? amount)?.getFormattedAmount() ?? "")"
    }

    var amountText: String {
        "\(String(format: "%.2f", Double((totalAmount ?? amount)?.value ?? 0)/100.0))"
    }
}
