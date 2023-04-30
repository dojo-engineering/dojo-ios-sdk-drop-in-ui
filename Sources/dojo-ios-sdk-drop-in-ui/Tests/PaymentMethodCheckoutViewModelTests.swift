import XCTest
import dojo_ios_sdk

class PaymentMethodCheckoutViewModelTests: XCTestCase {
    
    func testIsApplePayAvailable() {
        let viewModel = PaymentMethodCheckoutViewModel(config: TestsUtils.getBaseConfig())!
        XCTAssertFalse(viewModel.isApplePayAvailable())
        
        let viewModelWithMerchantConfig = PaymentMethodCheckoutViewModel(config: TestsUtils.getBaseConfig(withApplePayConfig: true))!
        XCTAssertFalse(viewModelWithMerchantConfig.isApplePayAvailable())
        
        let viewModelWithPaymentIntentConfig = PaymentMethodCheckoutViewModel(config: TestsUtils.getBaseConfig(withApplePayPaymentIntent: true))!
        XCTAssertFalse(viewModelWithPaymentIntentConfig.isApplePayAvailable())
        
        let viewModelWithPaymentIntentConfigandMerchantConfig = PaymentMethodCheckoutViewModel(config: TestsUtils.getBaseConfig(withApplePayConfig: true,
                                                                                                                                withApplePayPaymentIntent: true))!
        XCTAssertFalse(viewModelWithPaymentIntentConfigandMerchantConfig.isApplePayAvailable())
        
        
        let viewModelWithPaymentIntentConfigandMerchantConfigAndSupportedCards = PaymentMethodCheckoutViewModel(config: TestsUtils.getBaseConfig(withApplePayConfig: true,
                                                                                                                                                 withApplePayPaymentIntent: true,
                                                                                                                                                 supportedCardSchemas: [.maestro, .visa, .amex]))!
        XCTAssertTrue(viewModelWithPaymentIntentConfigandMerchantConfigAndSupportedCards.isApplePayAvailable())
    }
    
    func testIsSavedPaymentMethodsAvailable() {
        let viewModel = PaymentMethodCheckoutViewModel(config: TestsUtils.getBaseConfig())!
        XCTAssertFalse(viewModel.isSavedPaymentMethodsAvailable())
        
        let viewModelWithCustomerId = PaymentMethodCheckoutViewModel(config: TestsUtils.getBaseConfig(customerId: "test-customer-id"))!
        XCTAssertFalse(viewModelWithCustomerId.isSavedPaymentMethodsAvailable())
        
        let viewModelWithSavedPaymentMethods = PaymentMethodCheckoutViewModel(config: TestsUtils.getBaseConfig(savedPaymentMethod: [SavedPaymentMethod(id: "test", cardDetails: SavedPaymentCardDetails(pan: "123", expiryDate: "123", scheme: .visa))]))!
        XCTAssertFalse(viewModelWithSavedPaymentMethods.isSavedPaymentMethodsAvailable())
        
        let viewModelWithSavedPaymentMethodsAndCustomerId = PaymentMethodCheckoutViewModel(config: TestsUtils.getBaseConfig(customerId:"test", savedPaymentMethod: [SavedPaymentMethod(id: "test", cardDetails: SavedPaymentCardDetails(pan: "123", expiryDate: "123", scheme: .visa))]))!
        XCTAssertTrue(viewModelWithSavedPaymentMethodsAndCustomerId.isSavedPaymentMethodsAvailable())
    }
    
    func testShowAdditionalItemsLine() {
        let viewModel = PaymentMethodCheckoutViewModel(config: TestsUtils.getBaseConfig())!
        XCTAssertFalse(viewModel.showAdditionalItemsLine())
        
        let viewModelAdditionalItem = PaymentMethodCheckoutViewModel(config: TestsUtils.getBaseConfig(additionalItemsLine: [ItemLine(caption: "test", amountTotal: DojoPaymentIntentAmount(value: 100, currencyCode: "GBP"))]))!
        XCTAssertTrue(viewModelAdditionalItem.showAdditionalItemsLine())
    }
    
    func testGetSupportedApplePayCards() {
        let viewModel = PaymentMethodCheckoutViewModel(config: TestsUtils.getBaseConfig())!
        XCTAssertEqual(viewModel.getSupportedApplePayCards(), [])
        
        let viewModelWithSupportedNetworks = PaymentMethodCheckoutViewModel(config: TestsUtils.getBaseConfig(supportedCardSchemas: [.visa, .amex, .maestro]))!
        XCTAssertEqual(viewModelWithSupportedNetworks.getSupportedApplePayCards(), [ApplePaySupportedCards.visa.rawValue, ApplePaySupportedCards.amex.rawValue, ApplePaySupportedCards.maestro.rawValue])
    }
    
    func testGetApplePayConfig() {
        let viewModel = PaymentMethodCheckoutViewModel(config: TestsUtils.getBaseConfig())!
        XCTAssertNil(viewModel.getApplePayConfig())
        
        let viewModelWithAppleConfig = PaymentMethodCheckoutViewModel(config: TestsUtils.getBaseConfig(withApplePayConfig: true))!
        XCTAssertNotNil(viewModelWithAppleConfig.getApplePayConfig())
    }
}
