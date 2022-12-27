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
}
