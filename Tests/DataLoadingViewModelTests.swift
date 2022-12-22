import XCTest

class DataLoadingViewModelTests: XCTestCase {

    let paymentIntentString = """
    {"clientSessionSecret":"secret","id":"pi_sandbox_T","metadata":{"location-id":"1112"},"customer":{"id":"cust_1XiOxLGIS02SkCF9nJ_1ww"},"amount":{"value":10,"currencyCode":"GBP"},"description":"Demo payment intent","totalAmount":{"value":10,"currencyCode":"GBP"},"merchantConfig":{"supportedPaymentMethods":{"wallets":["APPLE_PAY","GOOGLE_PAY"],"cardSchemes":["VISA","MASTERCARD","MAESTRO"]}},"itemLines":[],"taxLines":[],"paymentMethods":["Card"],"config":{"tradingName":"Office","billingAddress":{"collectionRequired":true},"customerEmail":{"collectionRequired":true},"branding":{"logoUrl":"https://example.com/logo.svg","faviconUrl":"https://example.com/favicon.ico"}},"reference":"Order 234","refundedAmount":0,"createdAt":"2022-12-14T12:39:51.848Z","clientSessionSecretExpirationDate":"2022-12-22T15:35:46Z","updatedAt":"2022-12-22T15:05:46.268Z","captureMode":"Auto","status":"Created","paymentEvents":[]}
    """
    
    let savedMethodsString = """
            {"customerId":"cust_0FgzjLELaku4ZBKJpIXkXg","merchantId":"66666","savedPaymentMethods":[{"id":"pm_REvXpOXlQPa1SCXoxhAghg","cardDetails":{"pan":"52000000****0056","expiryDate":"2024-12-31","scheme":"MASTERCARD"}},{"id":"pm_otRL98WURbaAKs0sdy7_5","cardDetails":{"pan":"52000000****0056","expiryDate":"2024-12-31","scheme":"AMEX"}}],"supportedPaymentMethods":{"cardSchemes":["VISA","MASTERCARD","MAESTRO","AMEX"],"wallets":["APPLE_PAY","GOOGLE_PAY"]}}
            """
    
    func testPaymentIntentParsing() {
        let promise = expectation(description: "")
        var paymentIntent: PaymentIntent?
        CommonUtils.parseResponseToCompletion(stringData: paymentIntentString,
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
