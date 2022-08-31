//
//  LocalizedText.swift
//  EcomUI
//
//  Created by Deniss Kaibagarovs on 24/11/2020.
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
        static let fieldPan = "dojo_ui_sdk_card_details_checkout_field_pan".localized
        static let placeholderPan = "dojo_ui_sdk_card_details_checkout_placeholder_pan".localized
        static let placeholderExpiry = "dojo_ui_sdk_card_details_checkout_placeholder_expiry".localized
        static let placeholderCVV = "dojo_ui_sdk_card_details_checkout_placeholder_cvv".localized
        static let youPay = "dojo_ui_sdk_card_details_checkout_you_pay".localized
        static let buttonPay = "dojo_ui_sdk_card_details_checkout_button_pay".localized
    }
    
    enum PaymentResult {
        static let titleSuccess = "dojo_ui_sdk_payment_result_title_success".localized
        static let titleFail = "dojo_ui_sdk_payment_result_title_fail".localized
        static let mainTitleSuccess = "dojo_ui_sdk_payment_result_main_title_success".localized
        static let mainTitleFail = "dojo_ui_sdk_payment_result_main_title_fail".localized
        static let buttonDone = "dojo_ui_sdk_payment_result_button_done".localized
    }
    
    enum PoweredBy {
        static let title = "dojo_ui_sdk_footer_powered_by_title".localized
        static let terms = "dojo_ui_sdk_footer_powered_by_terms".localized
        static let privacy = "dojo_ui_sdk_footer_powered_by_privacy".localized
    }
}
