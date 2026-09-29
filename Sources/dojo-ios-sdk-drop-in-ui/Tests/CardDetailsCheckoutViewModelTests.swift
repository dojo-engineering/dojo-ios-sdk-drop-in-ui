import XCTest
import dojo_ios_sdk

class CardDetailsCheckoutViewModelTests: XCTestCase {
    
    func testBillingPostcode() {
        let viewModel = CardDetailsCheckoutViewModel(config: ConfigurationManager(paymentIntentId: "",
                                                                                  paymentIntent: PaymentIntent(id: "", clientSessionSecret: "", totalAmount: DojoPaymentIntentAmount(value: 10, currencyCode: "GBP")),
                                                                                  themeSettings: ThemeSettings(dojoTheme: DojoThemeSettings.getLightTheme())))!
        XCTAssertTrue(viewModel.showBillingPostcode("GB"))
    }
}
