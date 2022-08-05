
import dojo_ios_sdk

public class DojoSDKDropInUI {
    
    var configurationManager: ConfigurationManager
    var rootCoordinator: RootCoordinatorProtocol? //TODO: optional?
    
    public init() {
        configurationManager = ConfigurationManager(token: "", isSandbox: false) // TODO: move to a different place
    }
    
    public func startPaymentFlow(token: String,
                                 isSandbox: Bool,
                                 controller: UIViewController) {
        DispatchQueue.main.async {
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
     // TODO: notify app about payment result (failed)
    }
    
    func userFinishedFlow(resultCode: Int) {
        var a = 0
    // TODO: notify app about payment result (resultCode)
    }
}
