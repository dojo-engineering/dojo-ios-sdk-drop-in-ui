//
//
//  Created by Deniss Kaibagarovs on 05/04/2021.
//

import Foundation
import dojo_ios_sdk

extension DojoPaymentIntentAmount {
    func getFormattedAmount() -> String {
        CommonUtils.getFormattedAmount(value: value)
    }
}
