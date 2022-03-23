import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'colors.dart';

final storage = new FlutterSecureStorage();

class Constants {
  //Validations
  static const String password_validation =
      "Please enter a password with at least one letter, one number";
  static const String password_match_validation =
      "Password and confirm password do not match.";
  static const String currency_selection_validation = "Please select currency.";
  static const String phone_validation = "Please enter a valid phone number.";
  static const String dob_validation = "Please select date of birth.";
  static const String email_match_validation = "Email address do not match.";
  static const String email_validation = "Please enter valid email.";

  // Constant Texts
  static const String mail_check_txt =
      "By checking this box I allow MarketSpaace's to send me information and newsletter via email.";
  static const String policy_txt =
      "By checking this box I agree to MarketSpaace's term and fee policy.";
  static const String shipping_instructions =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In amet, id nullam et, nibh. Aliquam nulla eget sit faucibus sollicitudin enim lacus semper egestas. Rhoncus, placerat porttitor.";
  static String language = "English";

  //URL
  static const String add_liked_item = "/add_liked_item";
  static const String delete_liked_item = "/delete_liked_item";
  static const String get_products = "/get_products";
  static const String get_banner = "/get_banner";
  static const String edit_bio = "/edit_bio";
  static const String get_profile_data = "/get_profile_data";
  static const String set_profile_url = "/set_profile_url";
  static const String set_background_url = "/set_background_url";
  static const String get_active_products = "/get_active_products";
  static const String get_seller_orders = "/get_seller_orders";
  static const String get_seller_feedback = "/get_seller_feedback";
  static const String get_buyer_feedback = "/get_buyer_feedback";
  static const String delete_user_info = "/delete_user_info";
  static const String update_seller_tracking = "/update_seller_tracking";
  static const String get_buyer_data = "/get_buyer_data";
  static const String mark_item_shipped = "/mark_item_shipped";
  static const String seller_options = "/seller_options";
  static const String get_recently_bought = "/get_recently_bought";
  static const String get_order_status = "/get_order_status";
  static const String confirm_reception_item = "/confirm_item_reception";
  static const String get_buyer_options = "/get_buyer_options";
  static const String buyer_cancel_order = "/buyer_cancel_order";
  static const String buyer_raise_claim = "/buyer_raise_claim";
  static const String leave_seller_feedback = "/leave_seller_feedback";
  static const String update_email = "/update_email";
  static const String update_password = "/update_password";
  static const String view_address = "/view_address";
  static const String add_address = "/add_address";
  static const String edit_address = "/edit_address";
  static const String get_product = "/get_product";
  static const String get_product_feedback = "/get_product_feedback";
  static const String get_notifications = "/get_notifications";
  static const String test_recently_sold = "/test_recently_sold";
  static const String get_chat_list = "/get_chat_list";
  static const String get_chat_history = "/get_chat_history";
  static const String mark_chat_read = "/mark_chat_read";
  static const String send_message = "/send_message";
  static const String sell_item = "/sell_item";
  static const String get_brands = "/get_brands";
  static const String get_notification_settings = "/get_notification_settings";
  static const String update_notification_setting =
      "/update_notification_setting";
  static const String mark_notification_read = "/mark_notification_read";
  static const String add_interested_categories = "/add_interested_categories";
  static const String get_rates = "/get_rates";
  static const String get_seller_details = "/get_seller_details";
  static const String shipping_calculator = "/shipping_calculator";
  static const String get_bank_details = "/get_bank_details";
  static const String save_bank = "/save_bank";
  static const String get_bank_status = "/get_bank_status";
  static const String upload_bank_statement = "/upload_bank_statement";
  static const String delete_bank_method = "/delete_bank_method";
  static const String get_vault_creds = "/get_vault_creds";
  static const String save_key_server = "/save_key";
  static const String get_key_data = "/get_key_data";
  static const String save_vault_data = "/save_vault_data";
  static const String get_vault_data = "/get_vault_data";
  static const String delete_vault_data = "/delete_vault_data";
  static const String delete_key = "/delete_key";
  static const String get_wallet_balance = "/get_wallet_balance";
  static const String update_stock = "/update_stock";

  //Signuptypes
  static const String googleSigned = "googleSigned";
  static const String emailSigned = "emailSigned";
  static const String anonymousSigned = "anonymousSigned";

  //Key
  static const String encryptKey =
      "0SXAu3IsgeyW7onqyhWzcT1fLKOk-P1EqvrFQaSddBA=";
  static List<String> selectedChoices = List();

  //Debit card
  static const String debit_base_url = "https://api.pcivault.io/v1/";
  static const String get_pass_phrase = "passphrase";
  static const String add_key_vault = "key";
  static const String save_debit = "vault";
  static const String get_debit = "vault";

  static const FlutterSecureStorage singletonSecureStorage =
      FlutterSecureStorage();

  // Common functions
  static void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.appBlue,
        textColor: AppColors.white,
        fontSize: 16.0);
  }

  // Algolia keys
  static final String algolia_Id = "G12DUZNO30";
  static final String algolia_key_search = "59be02d8c04fa45ea11bafdb25a76c4a";
  static final String algolia_key_search_admin =
      "c79f75b23c373d1bfbf9153be5ee7bed";
  static String aud = "1.0", btc = "1.0";
  static String country;
  static bool isSplashLoading = true;
  static String email;
  static String otpConfirmed = "false";
  static bool isLogin = false;
  static int cartCount = 0;

  static String adminUid = "tSpty2eXTVPIT7FzgF5Iuin9m812";
}
