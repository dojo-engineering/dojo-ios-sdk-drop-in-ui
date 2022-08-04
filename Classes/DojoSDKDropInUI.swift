
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
            self.rootCoordinator = RootCoordinator(presentationViewController: controller, config: self.configurationManager)
            self.rootCoordinator?.showPaymentMethodCheckout()
        }
//        DispatchQueue.main.async {
//            let cardDetailsController = CardDetailsCheckoutViewController(token: token,
//                                                                          isSandbox: isSandbox)
//            controller.present(cardDetailsController, animated: true)
//        }
    }
}
