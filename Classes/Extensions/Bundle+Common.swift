//
//
//  Created by Deniss Kaibagarovs on 05/04/2021.
//

import Foundation

extension Bundle {
    static let resourceBundleName = "DojoSDKUIResources"

#if !SPM
    static var libResourceBundle: Bundle? {
        Bundle.getBundle(bundleName: resourceBundleName)
    }
#else
    static var libResourceBundle: Bundle? { Bundle.module }
#endif

    static func getBundle(bundleName: String) -> Bundle? {
        var resourceBundle: Bundle?
        for includedBundles in Bundle.allBundles {
            if let resourceBundlePath = includedBundles.path(forResource: bundleName, ofType: "bundle") {
                resourceBundle = Bundle(path: resourceBundlePath)
                break
            }
        }
        return resourceBundle
    }
}
