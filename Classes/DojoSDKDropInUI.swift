
import dojo_ios_sdk

public class DojoSDKDropInUI {
    
    var configurationManager: ConfigurationManager
    var rootCoordinator: RootCoordinatorProtocol?
    var completionCallback: ((Int) -> Void)?
    
    public init() {
        // TODO refactor
        configurationManager = ConfigurationManager(token: "", isSandbox: false, themeSettings: ThemeSettings(dojoTheme: DojoThemeSettings.getLightTheme())) // TODO: move to a different place
    }
    
    public func startPaymentFlow(paymentIntentId: String,
                                 controller: UIViewController,
                                 themeSettings: DojoThemeSettings? = nil,
                                 completion: ((Int) -> Void)?) {
        DispatchQueue.main.async {
//            let theme = ThemeSettings(dojoTheme: themeSettings ?? DojoThemeSettings.getLightTheme())
            let theme = ThemeSettings.getLightTheme()
            self.completionCallback = completion
            self.configurationManager = ConfigurationManager(token: paymentIntentId,
                                                             isSandbox: false,
                                                             themeSettings: theme)
            self.rootCoordinator = RootCoordinator(presentationViewController: controller,
                                                   config: self.configurationManager,
                                                   delegate: self)
            self.rootCoordinator?.beginFlow()
        }
    }
}

extension DojoSDKDropInUI: RootCoordinatorDelegate {
    func userForceClosedFlow() {
        completionCallback?(5) // 5 for decline
    }
    
    func userFinishedFlow(resultCode: Int) {
        completionCallback?(resultCode)
    }
}
