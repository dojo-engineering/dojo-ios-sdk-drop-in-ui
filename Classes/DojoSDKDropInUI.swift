
import dojo_ios_sdk

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
                                 completion: ((Int) -> Void)?) {
        DispatchQueue.main.async {
            let theme = ThemeSettings(dojoTheme: themeSettings ?? DojoThemeSettings.getLightTheme())
            self.completionCallback = completion
            self.configurationManager = ConfigurationManager(paymentIntentId: paymentIntentId,
                                                             customerSecret: customerSecret,
                                                             paymentIntent: nil,
                                                             themeSettings: theme,
                                                             applePayConfig: applePayConfig)
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
        completionCallback?(5) // 5 for decline
        completionCallback = nil
    }
    
    func userFinishedFlow(resultCode: Int) {
        completionCallback?(resultCode)
        completionCallback = nil
    }
}
