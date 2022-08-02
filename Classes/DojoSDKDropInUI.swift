
import dojo_ios_sdk

public class DojoSDKDropInUI {
    
    public init() {}
    
    let cardDetailsController = CardDetailsCheckoutViewController()
    
    public func startPaymentFlow(controller: UIViewController) {
        controller.present(cardDetailsController, animated: true)
    }
}
