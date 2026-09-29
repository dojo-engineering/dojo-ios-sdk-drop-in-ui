//
//  CardDetailsCheckoutViewModel.swift
//  dojo-ios-sdk-drop-in-ui
//
//  Created by Deniss Kaibagarovs on 03/08/2022.
//

import UIKit
import dojo_ios_sdk

class CardDetailsCheckoutViewModel: BaseViewModel {
    var email: String?
    var billingCountry: String?
    var billingPostcode: String?
    var isSaveCardSelected = true
    var isBillingSameAsShippingSelected = true
    var isTermsSelected = false
    var debugConfig: DojoSDKDebugConfig?

    init?(config: ConfigurationManager) {
        guard let paymentIntent = config.paymentIntent else {
            return nil
        }
        self.debugConfig = config.debugConfig
        super.init(paymentIntent: paymentIntent)
    }

    func processPayment(cardDetails: DojoCardDetails,
                        shippingDetails: DojoShippingDetails?,
                        billingDetails: DojoAddressDetails?,
                        metadata: [String: String]?,
                        email: String?,
                        fromViewController: UIViewController,
                        completion: ((Int) -> Void)?) {
        let payload = DojoCardPaymentPayload(cardDetails: cardDetails,
                                             userEmailAddress: email,
                                             billingAddress: billingDetails,
                                             shippingDetails: shippingDetails,
                                             metaData: metadata,
                                             savePaymentMethod: isSaveCardSelected)

        if paymentIntent.isVirtualTerminalPayment {
            DojoSDK.refreshPaymentIntent(intentId: paymentIntent.id, debugConfig: debugConfig) { data, error in
                self.withRefreshedIntent(data: data, error: error) { refreshedIntent in
                    guard let refreshedIntent else {
                        completion?(5)
                        return
                    }
                    DojoSDK.executeVirtualTerminalPayment(token: refreshedIntent.clientSessionSecret,
                                                          payload: payload,
                                                          debugConfig: self.debugConfig ?? DojoSDKDebugConfig(isSandboxIntent: refreshedIntent.isSandbox),
                                                          completion: completion)
                }
            }
        } else if paymentIntent.isSetupIntent {
            DojoSDK.refreshSetupIntent(intentId: paymentIntent.id, debugConfig: debugConfig) { data, error in
                self.executeCardPayment(data: data,
                                         error: error,
                                         payload: payload,
                                         from: fromViewController,
                                         completion: completion)
            }
        } else {
            DojoSDK.refreshPaymentIntent(intentId: paymentIntent.id, debugConfig: debugConfig) { data, error in
                self.executeCardPayment(data: data,
                                         error: error,
                                         payload: payload,
                                         from: fromViewController,
                                         completion: completion)
            }
        }
    }

    private func executeCardPayment(data: String?,
                                    error: Error?,
                                    payload: DojoCardPaymentPayload,
                                    from viewController: UIViewController,
                                    completion: ((Int) -> Void)?) {
        withRefreshedIntent(data: data, error: error) { refreshedIntent in
            guard let refreshedIntent else {
                completion?(5)
                return
            }
            DojoSDK.executeCardPayment(token: refreshedIntent.clientSessionSecret,
                                       payload: payload,
                                       debugConfig: self.debugConfig ?? DojoSDKDebugConfig(isSandboxIntent: refreshedIntent.isSandbox),
                                       fromViewController: viewController,
                                       completion: completion)
        }
    }

    private func withRefreshedIntent(data: String?,
                                     error: Error?,
                                     completion: @escaping (PaymentIntent?) -> Void) {
        CommonUtils.parseResponseToCompletion(stringData: data,
                                              fetchError: error,
                                              objectType: PaymentIntent.self) { result, _ in
            completion(result)
        }
    }

    var showFieldEmail: Bool {
        paymentIntent.config?.customerEmail?.collectionRequired ?? false
    }

    var showFieldBilling: Bool {
        paymentIntent.config?.billingAddress?.collectionRequired ?? false
    }

    var showFieldShipping: Bool {
        paymentIntent.config?.shippingDetails?.collectionRequired ?? false
    }

    var showSaveCardCheckbox: Bool {
        guard !paymentIntent.isSetupIntent else { return false }
        return paymentIntent.customer?.id != nil
    }

    var supportedCardSchemes: [CardSchemes] {
        paymentIntent.merchantConfig?.supportedPaymentMethods?.cardSchemes ?? []
    }

    var tradingName: String {
        paymentIntent.config?.tradingName ?? ""
    }

    var companyName: String? {
        if let title = paymentIntent.config?.title, !title.isEmpty {
            return title
        }
        return paymentIntent.config?.tradingName
    }

    var topTitle: String? {
        paymentIntent.isVirtualTerminalPayment ? paymentIntent.config?.tradingName : LocalizedText.CardDetailsCheckout.youPay
    }

    var navigationTitle: String {
        paymentIntent.isSetupIntent ? LocalizedText.CardDetailsCheckout.titleSetupIntent : LocalizedText.CardDetailsCheckout.title
    }

    func showBillingPostcode(_ countryCode: String) -> Bool {
        ["GB", "US", "CA"].contains(countryCode)
    }
}
