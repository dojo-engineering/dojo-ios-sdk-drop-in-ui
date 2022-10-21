
import dojo_ios_sdk

public class DojoSDKDropInUI {
    
    var configurationManager: ConfigurationManager
    var rootCoordinator: RootCoordinatorProtocol?
    var completionCallback: ((Int) -> Void)?
    
    public init() {
        // TODO refactor
        configurationManager = ConfigurationManager(paymentIntentId: "", //TODO: should not be set like this
                                                    paymentIntent: PaymentIntent(id: "", clientSessionSecret: "", amount: DojoPaymentIntentAmount(value: 0, currencyCode: "")),
                                                    themeSettings: ThemeSettings(dojoTheme: DojoThemeSettings.getLightTheme())) // TODO: move to a different place
    }
    
    public func startPaymentFlow(paymentIntentId: String,
                                 controller: UIViewController,
                                 applePayConfig: DojoUIApplePayConfig? = nil,
                                 themeSettings: DojoThemeSettings? = nil,
                                 completion: ((Int) -> Void)?) {
        DispatchQueue.main.async {
//            let theme = ThemeSettings(dojoTheme: themeSettings ?? DojoThemeSettings.getLightTheme())
            let theme = ThemeSettings.getLightTheme()
            self.completionCallback = completion
            self.configurationManager = ConfigurationManager(paymentIntentId: paymentIntentId,
                                                             paymentIntent: PaymentIntent(id: "", clientSessionSecret: "", amount: DojoPaymentIntentAmount(value: 0, currencyCode: "")), //TODO: shouldn't be here
                                                             themeSettings: theme,
                                                             applePayConfig: applePayConfig)
            self.rootCoordinator = RootCoordinator(presentationViewController: controller,
                                                   config: self.configurationManager,
                                                   delegate: self)
            self.rootCoordinator?.beginFlow()
        }
    }
}

public struct DojoUIApplePayConfig {
    let merchantIdentifier: String
}

extension DojoSDKDropInUI: RootCoordinatorDelegate {
    func userForceClosedFlow() {
        completionCallback?(5) // 5 for decline
    }
    
    func userFinishedFlow(resultCode: Int) {
        completionCallback?(resultCode)
    }
}
