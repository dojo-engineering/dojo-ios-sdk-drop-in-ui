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
    
    func testGetApplePayConfig() {
        let viewModel = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig())!
        XCTAssertNil(viewModel.getApplePayConfig())
        
        let viewModelWithAppleConfig = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig(withApplePayConfig: true))!
        XCTAssertNotNil(viewModelWithAppleConfig.getApplePayConfig())
    }
    
    func testSavedPaymentMethodItems() {
        let viewModel = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig())!
        XCTAssertEqual(viewModel.getSavedPaymentItems(), [])
        
        let viewModelWithApplePay = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig(withApplePayConfig: true, withApplePayPaymentIntent: true, supportedCardSchemas: [.visa]))!
        var savedMethoItemsApplePay = [PaymentMethodItem(id: "", title: "", type: .applePay)]
        XCTAssertEqual(viewModelWithApplePay.getSavedPaymentItems(), savedMethoItemsApplePay)
        
        let savedPaymentMethods = [SavedPaymentMethod(id: "1", cardDetails: SavedPaymentCardDetails(pan: "1234", expiryDate: "12/23", scheme: .visa)), SavedPaymentMethod(id: "2", cardDetails: SavedPaymentCardDetails(pan: "1234", expiryDate: "12/23", scheme: .amex))]
        let savedMethodItems = savedPaymentMethods.compactMap { PaymentMethodItem(id: $0.id, title: $0.cardDetails.pan, type: PaymentMethodType($0.cardDetails.scheme)!)}
        
        let viewModelWithSavedPaymentMethods = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig(savedPaymentMethod: savedPaymentMethods))!
        XCTAssertEqual(viewModelWithSavedPaymentMethods.getSavedPaymentItems(), savedMethodItems)
        
        let viewModelWithSavedPaymentMethodsAndApplePay = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig(withApplePayConfig: true, withApplePayPaymentIntent: true, supportedCardSchemas: [.visa], savedPaymentMethod: savedPaymentMethods))!
        savedMethoItemsApplePay.append(contentsOf: savedMethodItems)
        XCTAssertEqual(viewModelWithSavedPaymentMethodsAndApplePay.getSavedPaymentItems(), savedMethoItemsApplePay)
    }
    
    func testRemoveItemAtIndex() {
        let savedPaymentMethods = [SavedPaymentMethod(id: "1", cardDetails: SavedPaymentCardDetails(pan: "1234", expiryDate: "12/23", scheme: .visa)), SavedPaymentMethod(id: "2", cardDetails: SavedPaymentCardDetails(pan: "1234", expiryDate: "12/23", scheme: .amex))]
        var savedMethodItems = savedPaymentMethods.compactMap { PaymentMethodItem(id: $0.id, title: $0.cardDetails.pan, type: PaymentMethodType($0.cardDetails.scheme)!)}
        
        let viewModelWithSavedPaymentMethods = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig(savedPaymentMethod: savedPaymentMethods))!
        XCTAssertEqual(viewModelWithSavedPaymentMethods.getSavedPaymentItems(), savedMethodItems)
        
        let removedItem = viewModelWithSavedPaymentMethods.removeItemAtIndex(0)
        XCTAssertEqual(removedItem?.id, "1")
        XCTAssertNotEqual(viewModelWithSavedPaymentMethods.getSavedPaymentItems(), savedMethodItems)
        savedMethodItems.remove(at: 0)
        XCTAssertEqual(viewModelWithSavedPaymentMethods.getSavedPaymentItems(), savedMethodItems)
        
        // Test removing of item that doesn't exist
        let removedItemNil = viewModelWithSavedPaymentMethods.removeItemAtIndex(100)
        XCTAssertNil(removedItemNil)
        XCTAssertEqual(viewModelWithSavedPaymentMethods.getSavedPaymentItems(), savedMethodItems)
    }
    
    func testSetItemSelected() {
        let savedPaymentMethods = [SavedPaymentMethod(id: "1", cardDetails: SavedPaymentCardDetails(pan: "1234", expiryDate: "12/23", scheme: .visa)), SavedPaymentMethod(id: "2", cardDetails: SavedPaymentCardDetails(pan: "1234", expiryDate: "12/23", scheme: .amex))]
        let savedMethodItems = savedPaymentMethods.compactMap { PaymentMethodItem(id: $0.id, title: $0.cardDetails.pan, type: PaymentMethodType($0.cardDetails.scheme)!)}
        let viewModelWithSavedPaymentMethods = ManagePaymentMethodsViewModel(config: TestsUtils.getBaseConfig(savedPaymentMethod: savedPaymentMethods))!
        XCTAssertNil(viewModelWithSavedPaymentMethods.getSavedPaymentItems().first(where: {$0.selected}))
        viewModelWithSavedPaymentMethods.setItemSelected(savedMethodItems[1])
        XCTAssertNotNil(viewModelWithSavedPaymentMethods.getSavedPaymentItems().first(where: {$0.selected}))
        XCTAssertEqual(viewModelWithSavedPaymentMethods.getSavedPaymentItems().first(where: {$0.selected}), savedMethodItems[1])
        viewModelWithSavedPaymentMethods.setItemSelected(nil)
        XCTAssertEqual(viewModelWithSavedPaymentMethods.getSavedPaymentItems().first(where: {$0.selected}), savedMethodItems[1])
    }
}
