import XCTest

class ExtensionsTests: XCTestCase {
    
    func testAmountFormatting() {
        XCTAssertEqual(CommonUtils.getFormattedAmount(value: 12), "£0.12")
        XCTAssertEqual(CommonUtils.getFormattedAmount(value: 12111), "£121.11")
        XCTAssertEqual(CommonUtils.getFormattedAmount(value: 0), "£0.00")
        XCTAssertEqual(CommonUtils.getFormattedAmount(value: 0, currencySymbol: "$"), "$0.00")
    }
}
