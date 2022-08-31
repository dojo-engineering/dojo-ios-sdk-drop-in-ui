//
//  String+Common.swift
//
//  Created by Deniss Kaibagarovs on 05/04/2021.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, bundle: Bundle(for: BaseUIViewController.self), comment: "")
    }
}
