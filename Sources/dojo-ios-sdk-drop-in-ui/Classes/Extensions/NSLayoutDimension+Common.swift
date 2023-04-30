//
//
//  Created by Deniss Kaibagarovs on 05/04/2021.
//

import UIKit

extension NSLayoutDimension {

@discardableResult
func set(
        to constant: CGFloat,
        priority: UILayoutPriority = .required
        ) -> NSLayoutConstraint {

        let cons = constraint(equalToConstant: constant)
        cons.priority = priority
        cons.isActive = true
        return cons
    }
}
