
import dojo_ios_sdk
import Foundation
import UIKit

@objc
public class DojoSDKDropInUI: NSObject {
    
    var configurationManager: ConfigurationManager?
    var rootCoordinator: RootCoordinatorProtocol?
    var completionCallback: ((Int) -> Void)?
    
    @objc
    public override init() {}
    
    @objc
    public func startPaymentFlow(paymentIntentId: String,
                                 controller: UIViewController,
                                 customerSecret: String? = nil,
                                 applePayConfig: DojoUIApplePayConfig? = nil,
                                 themeSettings: DojoThemeSettings? = nil,
                                 debugConfig: DojoSDKDebugConfig? = nil,
                                 completion: ((Int) -> Void)?) {
        DispatchQueue.main.async {
            let theme = ThemeSettings(dojoTheme: themeSettings ?? DojoThemeSettings.getLightTheme())
            self.completionCallback = completion
            self.configurationManager = ConfigurationManager(paymentIntentId: paymentIntentId,
                                                             customerSecret: customerSecret,
                                                             paymentIntent: nil,
                                                             themeSettings: theme,
                                                             applePayConfig: applePayConfig,
                                                             debugConfig: debugConfig,
                                                             isDemo: false)
            if let configurationManager = self.configurationManager {
                self.rootCoordinator = RootCoordinator(presentationViewController: controller,
                                                       config: configurationManager,
                                                       delegate: self)
                self.rootCoordinator?.beginFlow()
            } else {
                // SDK internal error
                self.completionCallback?(7770)
            }
        }
    }
    
    @objc
    public func startSetupFlow(setupIntentId: String,
                               controller: UIViewController,
                               themeSettings: DojoThemeSettings? = nil,
                               debugConfig: DojoSDKDebugConfig? = nil,
                               completion: ((Int) -> Void)?) {
        DispatchQueue.main.async {
            let theme = ThemeSettings(dojoTheme: themeSettings ?? DojoThemeSettings.getLightTheme())
            self.completionCallback = completion
            self.configurationManager = ConfigurationManager(paymentIntentId: setupIntentId,
                                                             customerSecret: nil,
                                                             paymentIntent: nil,
                                                             themeSettings: theme,
                                                             applePayConfig: nil,
                                                             debugConfig: debugConfig,
                                                             isDemo: false,
                                                             isSetupIntent: true)
            if let configurationManager = self.configurationManager {
                self.rootCoordinator = RootCoordinator(presentationViewController: controller,
                                                       config: configurationManager,
                                                       delegate: self)
                self.rootCoordinator?.beginFlow()
            } else {
                // SDK internal error
                self.completionCallback?(7770)
            }
        }
    }
}

@objc
public class DojoUIApplePayConfig: NSObject {
    let merchantIdentifier: String
    
    @objc
    public init(merchantIdentifier: String) {
        self.merchantIdentifier = merchantIdentifier
    }
}

extension DojoSDKDropInUI: RootCoordinatorDelegate {
    func userForceClosedFlow() {
        completionCallback?(7780) // user force closed payment flow
        completionCallback = nil
    }
    
    func userFinishedFlow(resultCode: Int) {
        completionCallback?(resultCode)
        completionCallback = nil
    }
}
