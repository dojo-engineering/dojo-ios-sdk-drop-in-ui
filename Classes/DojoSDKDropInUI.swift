
import dojo_ios_sdk

public class DojoSDKDropInUI {
    
    public init() {}
    
    public func startPaymentFlow(controller: UIViewController) {
        let cardPaymentPayload = DojoCardPaymentPayload(cardDetails: DojoCardDetails(cardNumber: "4456530000001096", cardName: "Card Holder Name", expiryDate: "12 / 24", cv2: "020"), isSandbox: true)
        let token = ""
        DojoSDK.executeCardPayment(token: token,
                                    payload: cardPaymentPayload,
                                    fromViewController: controller) { [weak self] result in
            print(result)
        }
    }
}
