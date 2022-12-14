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
    
    func chunkFormatted(withChunkSize chunkSize: Int = 4,
        withSeparator separator: Character = " ") -> String {
        return filter { $0 != separator }.chunk(n: chunkSize)
            .map{ String($0) }.joined(separator: String(separator))
    }
}
