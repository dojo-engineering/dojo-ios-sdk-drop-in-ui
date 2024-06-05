//
//  LocalizedText.swift
//

import Foundation

enum LocalizedText {
    enum PaymentMethodCheckout {
        static let title = "dojo_ui_sdk_payment_method_checkout_title".localized
        static let payByCard = "dojo_ui_sdk_pay_with_card_string".localized
    }
    
    enum ManagePaymentMethods {
        static let title = "dojo_ui_sdk_manage_payment_methods_title".localized
        static let addNewCard = "dojo_ui_sdk_manage_payment_methods_button_add_new_card".localized
        static let alertRemoveTitle = "dojo_ui_sdk_mange_payments_dialog_title".localized
        static let alertRemoveBody = "dojo_ui_sdk_mange_payments_dialog_message".localized
        static let alertRemoveConfirm = "dojo_ui_sdk_mange_payments_dialog_confirm_text".localized
        static let alertRemoveCancel = "dojo_ui_sdk_mange_payments_dialog_cancel_text".localized
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
        static let optionalField = "dojo_ui_sdk_dojo_ui_sdk_card_details_checkout_optional".localized
        static let fieldShippingName = "dojo_ui_sdk_card_details_checkout_field_shipping_name".localized
        static let fieldShippingLine1 = "dojo_ui_sdk_card_details_checkout_field_shipping_line_1".localized
        static let fieldShippingLine2 = "dojo_ui_sdk_card_details_checkout_field_shipping_line_2".localized
        static let fieldShippingCity = "dojo_ui_sdk_card_details_checkout_field_shipping_city".localized
        static let fieldShippingPostcode = "dojo_ui_sdk_card_details_checkout_field_shipping_postcode".localized
        static let fieldShippingCountry = "dojo_ui_sdk_card_details_checkout_field_shipping_country".localized
        static let fieldShippingDeliveryNotes = "dojo_ui_sdk_card_details_checkout_field_shipping_delivery_notes".localized
        static let fieldEmailSubtitleVT = "dojo_ui_sdk_card_details_checkout_field_subtitle_email_vt".localized
        static let titleShippingAddress = "dojo_ui_sdk_card_details_checkout_title_shipping".localized
        static let titleBillingAddress = "dojo_ui_sdk_card_details_checkout_title_billing".localized
        static let titleBillingSameAsShipping = "dojo_ui_sdk_card_details_checkout_billing_same_as_shipping".localized
        static let titlePaymentDetails = "dojo_ui_sdk_card_details_checkout_title_payment_details".localized
        static let titleTransactionsSecure = "dojo_ui_sdk_card_details_checkout_transactions_are_secure".localized
        static let errorEmptyShippingName = "dojo_ui_sdk_card_details_checkout_error_empty_shipping_name".localized
        static let errorEmptyShippingLine1 = "dojo_ui_sdk_card_details_checkout_error_empty_shipping_line_1".localized
        static let errorEmptyShippingCity = "dojo_ui_sdk_card_details_checkout_error_empty_shipping_city".localized
        static let errorEmptyShippingPostal = "dojo_ui_sdk_card_details_checkout_error_empty_shipping_postal".localized
    }
    
    enum PaymentResult {
        static let titleSuccess = "dojo_ui_sdk_payment_result_title_success".localized
        static let titleFail = "dojo_ui_sdk_payment_result_title_fail".localized
        static let mainTitleSuccess = "dojo_ui_sdk_payment_result_main_title_success".localized
        static let mainTitleFail = "dojo_ui_sdk_payment_result_main_title_fail".localized
        static let buttonDone = "dojo_ui_sdk_payment_result_button_done".localized
        static let buttonTryAgain = "dojo_ui_sdk_payment_result_button_try_again".localized
        static let buttonPleaseWait = "dojo_ui_sdk_payment_ressult_button_please_wait".localized
        static let orderId = "dojo_ui_sdk_payment_result_order_info".localized
        static let mainErrorMessage = "dojo_ui_sdk_payment_result_failed_description".localized
    }
    
    enum PoweredBy {
        static let title = "dojo_ui_sdk_footer_powered_by_title".localized
        static let terms = "dojo_ui_sdk_footer_powered_by_terms".localized
        static let privacy = "dojo_ui_sdk_footer_powered_by_privacy".localized
    }
    
    enum Buttons {
        static let next = "dojo_ui_sdk_keyboard_additional_button_next".localized
        static let previous = "dojo_ui_sdk_keyboard_additional_button_previous".localized
    }
}
