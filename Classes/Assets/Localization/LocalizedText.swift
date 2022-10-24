//
//  LocalizedText.swift
//

import Foundation

enum LocalizedText {
    enum PaymentMethodCheckout {
        static let title = "dojo_ui_sdk_payment_method_checkout_title".localized
    }
    
    enum ManagePaymentMethods {
        static let title = "dojo_ui_sdk_manage_payment_methods_title".localized
        static let addNewCard = "dojo_ui_sdk_manage_payment_methods_button_add_new_card".localized
    }
    
    enum CardDetailsCheckout {
        static let title = "dojo_ui_sdk_card_details_checkout_title".localized
        static let fieldCardName = "dojo_ui_sdk_card_details_checkout_field_card_name".localized
        static let fieldEmail = "dojo_ui_sdk_card_details_checkout_field_email".localized
        static let fieldPan = "dojo_ui_sdk_card_details_checkout_field_pan".localized
        static let fieldBillingCountry = "dojo_ui_sdk_card_details_checkout_billing_country".localized
        static let fieldBillingPostcode = "dojo_ui_sdk_card_details_checkout_billing_postcode".localized
        static let fieldBillingZipcode = "dojo_ui_sdk_card_details_checkout_billing_zipcode".localized
        static let fieldExpiryDate = "dojo_ui_sdk_card_details_checkout_expiry_date".localized
        static let fieldCVV = "dojo_ui_sdk_card_details_checkout_cvv".localized
        static let placeholderPan = "dojo_ui_sdk_card_details_checkout_placeholder_pan".localized
        static let placeholderExpiry = "dojo_ui_sdk_card_details_checkout_placeholder_expiry".localized
        static let placeholderCVV = "dojo_ui_sdk_card_details_checkout_placeholder_cvv".localized
        static let youPay = "dojo_ui_sdk_card_details_checkout_you_pay".localized
        static let buttonPay = "dojo_ui_sdk_card_details_checkout_button_pay".localized
        static let buttonProcessing = "dojo_ui_sdk_card_details_checkout_button_processing".localized
        static let errorEmptyEmail = "dojo_ui_sdk_card_details_checkout_error_empty_email".localized
        static let errorEmptyCardHolder = "dojo_ui_sdk_card_details_checkout_error_empty_card_holder".localized
        static let errorEmptyPan = "dojo_ui_sdk_card_details_checkout_error_empty_card_number".localized
        static let errorEmptyBillingPostcode = "dojo_ui_sdk_card_details_checkout_error_empty_billing_postcode".localized
        static let errorEmptyExpiry = "dojo_ui_sdk_card_details_checkout_error_empty_expiry".localized
        static let errorEmptyCvv = "dojo_ui_sdk_card_details_checkout_error_empty_cvv".localized
        static let errorInvalidEmail = "dojo_ui_sdk_card_details_checkout_error_invalid_email".localized
        static let errorInvalidPan = "dojo_ui_sdk_card_details_checkout_error_invalid_card_number".localized
        static let errorInvalidExpiry = "dojo_ui_sdk_card_details_checkout_error_invalid_expiry".localized
        static let errorInvalidCVV = "dojo_ui_sdk_card_details_checkout_error_invalid_cvv".localized
        static let saveCardForFutureUse = "dojo_ui_sdk_card_details_checkout_save_card".localized
    }
    
    enum PaymentResult {
        static let titleSuccess = "dojo_ui_sdk_payment_result_title_success".localized
        static let titleFail = "dojo_ui_sdk_payment_result_title_fail".localized
        static let mainTitleSuccess = "dojo_ui_sdk_payment_result_main_title_success".localized
        static let mainTitleFail = "dojo_ui_sdk_payment_result_main_title_fail".localized
        static let buttonDone = "dojo_ui_sdk_payment_result_button_done".localized
        static let buttonPleaseWait = "dojo_ui_sdk_payment_ressult_button_please_wait".localized
        static let orderId = "dojo_ui_sdk_payment_result_order_info".localized
        static let mainErrorMessage = "dojo_ui_sdk_payment_result_failed_description".localized
    }
    
    enum PoweredBy {
        static let title = "dojo_ui_sdk_footer_powered_by_title".localized
        static let terms = "dojo_ui_sdk_footer_powered_by_terms".localized
        static let privacy = "dojo_ui_sdk_footer_powered_by_privacy".localized
    }
}
