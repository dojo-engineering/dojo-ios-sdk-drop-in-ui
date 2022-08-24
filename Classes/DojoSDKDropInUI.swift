
import dojo_ios_sdk

public class DojoSDKDropInUI {
    
    var configurationManager: ConfigurationManager
    var rootCoordinator: RootCoordinatorProtocol? //TODO: optional?
    var completionCallback: ((Int) -> Void)?
    
    public init() {
        configurationManager = ConfigurationManager(token: "", isSandbox: false) // TODO: move to a different place
    }
    
    public func startPaymentFlow(token: String,
                                 isSandbox: Bool,
                                 controller: UIViewController,
                                 completion: ((Int) -> Void)?) {
        DispatchQueue.main.async {
            self.completionCallback = completion
            self.configurationManager = ConfigurationManager(token: token, isSandbox: isSandbox)
            self.rootCoordinator = RootCoordinator(presentationViewController: controller,
                                                   config: self.configurationManager,
                                                   delegate: self)
            self.rootCoordinator?.showPaymentMethodCheckout()
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
