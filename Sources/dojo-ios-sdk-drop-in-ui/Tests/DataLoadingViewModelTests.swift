import XCTest

class DataLoadingViewModelTests: XCTestCase {

    func testPaymentIntentParsing() {
        let promise = expectation(description: "")
        var paymentIntent: PaymentIntent?
        CommonUtils.parseResponseToCompletion(stringData: TestsUtils.paymentIntentString,
                                              fetchError: nil,
                                              objectType: PaymentIntent.self) { result, error in
            paymentIntent = result
            promise.fulfill()
        }
        let result = XCTWaiter.wait(for: [promise], timeout: 1.0)
        if result == XCTWaiter.Result.timedOut {
            XCTFail("timed out")
        } else {
            XCTAssert(paymentIntent?.id == "pi_sandbox_T")
        }
    }
    
    func testPaymentIntentParsingFail() {
        let promise = expectation(description: "")
        var paymentIntent: PaymentIntent?
        CommonUtils.parseResponseToCompletion(stringData: "",
                                              fetchError: nil,
                                              objectType: PaymentIntent.self) { result, error in
            paymentIntent = result
            promise.fulfill()
        }
        let result = XCTWaiter.wait(for: [promise], timeout: 1.0)
        if result == XCTWaiter.Result.timedOut {
            XCTFail("timed out")
        } else {
            XCTAssertNil(paymentIntent)
        }
    }
    
    func testSavedPaymentMethodsParsing() {
        let promise = expectation(description: "")
        var savedPaymentRoot: SavedPaymentRoot?
        CommonUtils.parseResponseToCompletion(stringData: TestsUtils.savedMethodsString,
                                              fetchError: nil,
                                              objectType: SavedPaymentRoot.self) { result, error in
            savedPaymentRoot = result
            promise.fulfill()
        }
        let result = XCTWaiter.wait(for: [promise], timeout: 1.0)
        if result == XCTWaiter.Result.timedOut {
            XCTFail("timed out")
        } else {
            XCTAssert(savedPaymentRoot!.savedPaymentMethods.count > 0)
            XCTAssert(savedPaymentRoot!.savedPaymentMethods.first?.cardDetails.scheme == .mastercard)
        }
    }
    
    func testSavedPaymentMethodsParsingFail() {
        let promise = expectation(description: "")
        var savedPaymentRoot: SavedPaymentRoot?
        CommonUtils.parseResponseToCompletion(stringData: "",
                                              fetchError: nil,
                                              objectType: SavedPaymentRoot.self) { result, error in
            savedPaymentRoot = result
            promise.fulfill()
        }
        let result = XCTWaiter.wait(for: [promise], timeout: 1.0)
        if result == XCTWaiter.Result.timedOut {
            XCTFail("timed out")
        } else {
            XCTAssertNil(savedPaymentRoot)
        }
    }
}
