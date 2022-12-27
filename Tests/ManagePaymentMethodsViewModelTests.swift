import XCTest
import dojo_ios_sdk

class ManagePaymentMethodsViewModelTests: XCTestCase {
    
    func testIsApplePayAvailable() {
        let viewModel = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig())!
        XCTAssertFalse(viewModel.isApplePayAvailable())
        
        let viewModelWithMerchantConfig = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig(withApplePayConfig: true))!
        XCTAssertFalse(viewModelWithMerchantConfig.isApplePayAvailable())
        
        let viewModelWithPaymentIntentConfig = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig(withApplePayPaymentIntent: true))!
        XCTAssertFalse(viewModelWithPaymentIntentConfig.isApplePayAvailable())
        
        let viewModelWithPaymentIntentConfigandMerchantConfig = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig(withApplePayConfig: true,
                                                                                                                                withApplePayPaymentIntent: true))!
        XCTAssertFalse(viewModelWithPaymentIntentConfigandMerchantConfig.isApplePayAvailable())
        
        
        let viewModelWithPaymentIntentConfigandMerchantConfigAndSupportedCards = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig(withApplePayConfig: true,
                                                                                                                                                 withApplePayPaymentIntent: true,
                                                                                                                                                 supportedCardSchemas: [.maestro, .visa, .amex]))!
        XCTAssertTrue(viewModelWithPaymentIntentConfigandMerchantConfigAndSupportedCards.isApplePayAvailable())
    }
    
    func testGetSupportedApplePayCards() {
        let viewModel = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig())!
        XCTAssertEqual(viewModel.getSupportedApplePayCards(), [])
        
        let viewModelWithSupportedNetworks = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig(supportedCardSchemas: [.visa, .amex, .maestro]))!
        XCTAssertEqual(viewModelWithSupportedNetworks.getSupportedApplePayCards(), [ApplePaySupportedCards.visa.rawValue, ApplePaySupportedCards.amex.rawValue, ApplePaySupportedCards.maestro.rawValue])
    }
    
    func testGetApplePayConfig() {
        let viewModel = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig())!
        XCTAssertNil(viewModel.getApplePayConfig())
        
        let viewModelWithAppleConfig = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig(withApplePayConfig: true))!
        XCTAssertNotNil(viewModelWithAppleConfig.getApplePayConfig())
    }
    
    func testSavedPaymentMethodItems() {
        let viewModel = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig())!
        XCTAssertEqual(viewModel.items, [])
        
        let viewModelWithApplePay = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig(withApplePayConfig: true, withApplePayPaymentIntent: true, supportedCardSchemas: [.visa]))!
        var savedMethoItemsApplePay = [PaymentMethodItem(id: "", title: "ApplePay", type: .applePay)]
        XCTAssertEqual(viewModelWithApplePay.items, savedMethoItemsApplePay)
        
        let savedPaymentMethods = [SavedPaymentMethod(id: "1", cardDetails: SavedPaymentCardDetails(pan: "1234", expiryDate: "12/23", scheme: .visa)), SavedPaymentMethod(id: "2", cardDetails: SavedPaymentCardDetails(pan: "1234", expiryDate: "12/23", scheme: .amex))]
        let savedMethodItems = savedPaymentMethods.compactMap { PaymentMethodItem(id: $0.id, title: $0.cardDetails.pan, type: PaymentMethodType($0.cardDetails.scheme)!)}
        
        let viewModelWithSavedPaymentMethods = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig(savedPaymentMethod: savedPaymentMethods))!
        XCTAssertEqual(viewModelWithSavedPaymentMethods.items, savedMethodItems)
        
        let viewModelWithSavedPaymentMethodsAndApplePay = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig(withApplePayConfig: true, withApplePayPaymentIntent: true, supportedCardSchemas: [.visa], savedPaymentMethod: savedPaymentMethods))!
        savedMethoItemsApplePay.append(contentsOf: savedMethodItems)
        XCTAssertEqual(viewModelWithSavedPaymentMethodsAndApplePay.items, savedMethoItemsApplePay)
    }
    
    func testRemoveItemAtIndex() {
        let savedPaymentMethods = [SavedPaymentMethod(id: "1", cardDetails: SavedPaymentCardDetails(pan: "1234", expiryDate: "12/23", scheme: .visa)), SavedPaymentMethod(id: "2", cardDetails: SavedPaymentCardDetails(pan: "1234", expiryDate: "12/23", scheme: .amex))]
        var savedMethodItems = savedPaymentMethods.compactMap { PaymentMethodItem(id: $0.id, title: $0.cardDetails.pan, type: PaymentMethodType($0.cardDetails.scheme)!)}
        
        let viewModelWithSavedPaymentMethods = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig(savedPaymentMethod: savedPaymentMethods))!
        XCTAssertEqual(viewModelWithSavedPaymentMethods.items, savedMethodItems)
        
        var removedItem = viewModelWithSavedPaymentMethods.removeItemAtIndex(0)
        XCTAssertEqual(removedItem?.id, "1")
        XCTAssertNotEqual(viewModelWithSavedPaymentMethods.items, savedMethodItems)
        savedMethodItems.remove(at: 0)
        XCTAssertEqual(viewModelWithSavedPaymentMethods.items, savedMethodItems)
        
        // Test removing of item that doesn't exist
        var removedItemNil = viewModelWithSavedPaymentMethods.removeItemAtIndex(100)
        XCTAssertNil(removedItemNil)
        XCTAssertEqual(viewModelWithSavedPaymentMethods.items, savedMethodItems)
    }
}
