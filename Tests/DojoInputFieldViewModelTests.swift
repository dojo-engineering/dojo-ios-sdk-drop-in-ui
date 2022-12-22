import XCTest

class DojoInputFieldViewModelTests: XCTestCase {
    
    func testFieldValidation() {
        let inputFieldViewModelEmail = DojoInputFieldViewModel(type: .email)
        XCTAssert(inputFieldViewModelEmail.validateField("") == .error)
        XCTAssert(inputFieldViewModelEmail.validateField("test@rd.c") == .error)
        XCTAssert(inputFieldViewModelEmail.validateField("test@test.com") != .error)
        XCTAssert(inputFieldViewModelEmail.validateField("test998@test.com") != .error)
        XCTAssert(inputFieldViewModelEmail.validateField("test+work@test.com") != .error)
        
        let inputFieldViewModelCardNumber = DojoInputFieldViewModel(type: .cardNumber)
        XCTAssert(inputFieldViewModelCardNumber.validateField("4234234234") == .error)
        XCTAssert(inputFieldViewModelCardNumber.validateField("abc") == .error)
        XCTAssert(inputFieldViewModelCardNumber.validateField("4976000000003436") != .error)
        XCTAssert(inputFieldViewModelCardNumber.validateField("497 60000 00003 436") != .error)
        XCTAssert(inputFieldViewModelCardNumber.validateField("371449635398431") != .error)
        
        let inputFieldViewModelExpiry = DojoInputFieldViewModel(type: .expiry)
        XCTAssert(inputFieldViewModelExpiry.validateField("12/20") == .error)
        XCTAssert(inputFieldViewModelExpiry.validateField("") == .error)
        XCTAssert(inputFieldViewModelExpiry.validateField("asfsafsdaf") == .error)
        XCTAssert(inputFieldViewModelExpiry.validateField("15/22") == .error)
        XCTAssert(inputFieldViewModelExpiry.validateField("12/23") != .error)
        XCTAssert(inputFieldViewModelExpiry.validateField("02/24") != .error)
        XCTAssert(inputFieldViewModelExpiry.validateField("12/56") != .error)
        
        let inputFieldViewModelCVV = DojoInputFieldViewModel(type: .cvv)
        XCTAssert(inputFieldViewModelCVV.validateField("") == .error)
        XCTAssert(inputFieldViewModelCVV.validateField("13") == .error)
        XCTAssert(inputFieldViewModelCVV.validateField("asdasd") == .error)
        XCTAssert(inputFieldViewModelCVV.validateField("123") != .error)
        XCTAssert(inputFieldViewModelCVV.validateField("1234") != .error)
    }
    
    func testCardSchemeIdentification() {
        let inputFieldViewModelCardNumber = DojoInputFieldViewModel(type: .cardNumber)
        XCTAssert(inputFieldViewModelCardNumber.getCardScheme("6759649826438453") == .maestro)
        XCTAssert(inputFieldViewModelCardNumber.getCardScheme("5555555555554444") == .mastercard)
        XCTAssert(inputFieldViewModelCardNumber.getCardScheme("4444333322221111") == .visa)
        XCTAssert(inputFieldViewModelCardNumber.getCardScheme("34343434343434") == .amex)
        XCTAssert(inputFieldViewModelCardNumber.getCardScheme("") == nil)
        XCTAssert(inputFieldViewModelCardNumber.getCardScheme("1112") == nil)
    }
    
    func testCountriedPicker() {
        let inputFieldViewBillingCountry = DojoInputFieldViewModel(type: .billingCountry)
        guard let countries = inputFieldViewBillingCountry.getCountriesItems() else {
            XCTFail("Can't get country items")
            return
        }
        XCTAssert(countries.count > 10)
        XCTAssert(countries[0].title == "United Kingdom")
        XCTAssert(countries[0].isoCode == "GB")
    }
}
