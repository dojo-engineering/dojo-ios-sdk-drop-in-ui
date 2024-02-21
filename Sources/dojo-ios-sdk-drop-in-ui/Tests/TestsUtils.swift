import dojo_ios_sdk

class TestsUtils {
    
    static let paymentIntentString = """
    {"clientSessionSecret":"secret","id":"pi_sandbox_T","metadata":{"location-id":"1112"},"customer":{"id":"cust_1XiOxLGIS02SkCF9nJ_1ww"},"amount":{"value":10,"currencyCode":"GBP"},"description":"Demo payment intent","totalAmount":{"value":10,"currencyCode":"GBP"},"merchantConfig":{"supportedPaymentMethods":{"wallets":["APPLE_PAY","GOOGLE_PAY"],"cardSchemes":["VISA","MASTERCARD","MAESTRO"]}},"itemLines":[],"taxLines":[],"paymentMethods":["Card"],"config":{"tradingName":"Office","billingAddress":{"collectionRequired":true},"customerEmail":{"collectionRequired":true},"branding":{"logoUrl":"https://example.com/logo.svg","faviconUrl":"https://example.com/favicon.ico"}},"reference":"Order 234","refundedAmount":0,"createdAt":"2022-12-14T12:39:51.848Z","clientSessionSecretExpirationDate":"2022-12-22T15:35:46Z","updatedAt":"2022-12-22T15:05:46.268Z","captureMode":"Auto","status":"Created","paymentEvents":[]}
    """
    
    static let paymentIntentWithoutApplePay = """
    {"clientSessionSecret":"secret","id":"pi_sandbox_T","metadata":{"location-id":"1112"},"customer":{"id":"cust_1XiOxLGIS02SkCF9nJ_1ww"},"amount":{"value":10,"currencyCode":"GBP"},"description":"Demo payment intent","totalAmount":{"value":10,"currencyCode":"GBP"},"merchantConfig":{"supportedPaymentMethods":{"wallets":["GOOGLE_PAY"],"cardSchemes":["VISA","MASTERCARD","MAESTRO"]}},"itemLines":[],"taxLines":[],"paymentMethods":["Card"],"config":{"tradingName":"Office","billingAddress":{"collectionRequired":true},"customerEmail":{"collectionRequired":true},"branding":{"logoUrl":"https://example.com/logo.svg","faviconUrl":"https://example.com/favicon.ico"}},"reference":"Order 234","refundedAmount":0,"createdAt":"2022-12-14T12:39:51.848Z","clientSessionSecretExpirationDate":"2022-12-22T15:35:46Z","updatedAt":"2022-12-22T15:05:46.268Z","captureMode":"Auto","status":"Created","paymentEvents":[]}
    """
    
    static let paymentIntentWithItemLines = """
    {"clientSessionSecret":"secret","id":"pi_sandbox_T","metadata":{"location-id":"1112"},"customer":{"id":"cust_1XiOxLGIS02SkCF9nJ_1ww"},"amount":{"value":10,"currencyCode":"GBP"},"description":"Demo payment intent","totalAmount":{"value":10,"currencyCode":"GBP"},"merchantConfig":{"supportedPaymentMethods":{"wallets":["APPLE_PAY","GOOGLE_PAY"],"cardSchemes":["VISA","MASTERCARD","MAESTRO"]}},"itemLines":[{"caption":"item1","amountTotal":{"value":12,"currencyCode":"GBP"}},{"caption":"item1","amountTotal":{"value":12,"currencyCode":"GBP"}},{"caption":"item1","amountTotal":{"value":12,"currencyCode":"GBP"}}],"taxLines":[],"paymentMethods":["Card"],"config":{"tradingName":"Office","billingAddress":{"collectionRequired":true},"customerEmail":{"collectionRequired":true},"branding":{"logoUrl":"https://example.com/logo.svg","faviconUrl":"https://example.com/favicon.ico"}},"reference":"Order 234","refundedAmount":0,"createdAt":"2022-12-14T12:39:51.848Z","clientSessionSecretExpirationDate":"2022-12-22T15:35:46Z","updatedAt":"2022-12-22T15:05:46.268Z","captureMode":"Auto","status":"Created","paymentEvents":[]}
    """
    
    static let paymentIntentWithItemLinesWithoutApplePay = """
    {"clientSessionSecret":"secret","id":"pi_sandbox_T","metadata":{"location-id":"1112"},"customer":{"id":"cust_1XiOxLGIS02SkCF9nJ_1ww"},"amount":{"value":10,"currencyCode":"GBP"},"description":"Demo payment intent","totalAmount":{"value":10,"currencyCode":"GBP"},"merchantConfig":{"supportedPaymentMethods":{"wallets":["GOOGLE_PAY"],"cardSchemes":["VISA","MASTERCARD","MAESTRO"]}},"itemLines":[{"caption":"item1","amountTotal":{"value":12,"currencyCode":"GBP"}},{"caption":"item1","amountTotal":{"value":12,"currencyCode":"GBP"}},{"caption":"item1","amountTotal":{"value":12,"currencyCode":"GBP"}}],"taxLines":[],"paymentMethods":["Card"],"config":{"tradingName":"Office","billingAddress":{"collectionRequired":true},"customerEmail":{"collectionRequired":true},"branding":{"logoUrl":"https://example.com/logo.svg","faviconUrl":"https://example.com/favicon.ico"}},"reference":"Order 234","refundedAmount":0,"createdAt":"2022-12-14T12:39:51.848Z","clientSessionSecretExpirationDate":"2022-12-22T15:35:46Z","updatedAt":"2022-12-22T15:05:46.268Z","captureMode":"Auto","status":"Created","paymentEvents":[]}
    """
    
    static let savedMethodsString = """
            {"customerId":"cust_0FgzjLELaku4ZBKJpIXkXg","merchantId":"66666","savedPaymentMethods":[{"id":"pm_REvXpOXlQPa1SCXoxhAghg","cardDetails":{"pan":"52000000****0056","expiryDate":"2024-12-31","scheme":"MASTERCARD"}},{"id":"pm_otRL98WURbaAKs0sdy7_5","cardDetails":{"pan":"52000000****0056","expiryDate":"2024-12-31","scheme":"AMEX"}}],"supportedPaymentMethods":{"cardSchemes":["VISA","MASTERCARD","MAESTRO","AMEX"],"wallets":["APPLE_PAY","GOOGLE_PAY"]}}
            """
    
    static func getBaseConfig(withApplePayConfig: Bool = false,
                              withApplePayPaymentIntent: Bool = false,
                              supportedCardSchemas: [CardSchemes] = [],
                              customerId: String? = nil,
                              savedPaymentMethod: [SavedPaymentMethod] = [],
                              additionalItemsLine: [ItemLine] = []) -> ConfigurationManager {
        var config = ConfigurationManager(paymentIntentId: "",
                             paymentIntent: PaymentIntent(id: "",
                                                          clientSessionSecret: "",
                                                          amount: DojoPaymentIntentAmount(value: 10, currencyCode: "GBP")),
                             themeSettings: ThemeSettings(dojoTheme: DojoThemeSettings.getLightTheme()))
        config.paymentIntent?.merchantConfig = MerchantConfig()
        config.paymentIntent?.merchantConfig?.supportedPaymentMethods = SupportedPaymentMethods()
        config.paymentIntent?.customer = CustomerConfig(id: customerId, emailAddress: nil)
        config.savedPaymentMethods = savedPaymentMethod
        config.paymentIntent?.itemLines = additionalItemsLine
        
        if withApplePayConfig {
            config.applePayConfig = DojoUIApplePayConfig(merchantIdentifier: "metch.id.test")
        }
        if withApplePayPaymentIntent {
            config.paymentIntent?.merchantConfig?.supportedPaymentMethods?.wallets = [.applePay]
        }
        config.paymentIntent?.merchantConfig?.supportedPaymentMethods?.cardSchemes = supportedCardSchemas
        return config
    }
}
