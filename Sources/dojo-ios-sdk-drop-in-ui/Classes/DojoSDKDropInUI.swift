
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
    public func getVTCheckout(paymentIntentId: String,
                              debugConfig: DojoSDKDebugConfig? = nil,
                              completion: ((UIViewController?) -> Void)?) {
        let dataLoadingModel = DataLoadingViewModel(paymentIntentId: paymentIntentId,
                                                    debugConfig: debugConfig,
                                                    demoDelay: 0,
                                                    isDemo: false)
        dataLoadingModel.fetchPaymentIntent() { pi, error in
            if let pi = pi {
                var themeSettings = DojoThemeSettings.getLightTheme()
                themeSettings.showBranding = false
                let configManager = ConfigurationManager(paymentIntentId: paymentIntentId, paymentIntent: pi, themeSettings: ThemeSettings(dojoTheme: themeSettings))
                if let viewModel = CardDetailsCheckoutViewModel(config: configManager) {
                    let checkoutController = CardDetailsCheckoutViewController(viewModel: viewModel, theme: configManager.themeSettings, delegate: self)
                    completion?(checkoutController)
                } else {
                    completion?(nil)
                    // TODO return
                }
            } else {
                // TODO return
                completion?(nil)
            }
        }
    }
}

extension DojoSDKDropInUI: CardDetailsCheckoutViewControllerDelegate {
    func onForceClosePress() {
        
    }
    
    func navigateToPaymentResult(resultCode: Int) {
        
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
        completionCallback?(5) // 5 for decline
        completionCallback = nil
    }
    
    func userFinishedFlow(resultCode: Int) {
        completionCallback?(resultCode)
        completionCallback = nil
    }
}
