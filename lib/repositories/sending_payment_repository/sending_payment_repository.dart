import 'dart:io';

import 'package:market_space/model/bank_account_model/bank_account_model.dart';
import 'package:market_space/model/bank_account_model/bank_details_request_model.dart';
import 'package:market_space/providers/sending_payment_method_provider/sending_payment_method_provider.dart';

class SendingPaymentRepository {
  SendingPaymentMethodProvider paymentMethodProvider =
      SendingPaymentMethodProvider();

  Future<BankAccountModel> getBankDetails() async {
    return await paymentMethodProvider.getBankAccount();
  }

  Future<String> saveBankDetails(BankDetailsRequestModel model) async {
    return await paymentMethodProvider.saveBankDetails(model);
  }

  Future<String> getBankStatus() async {
    return await paymentMethodProvider.getBankStatus();
  }

  Future<String> removeBankAccount() async {
    return await paymentMethodProvider.removeBankAccount();
  }

  Future<String> uploadBankStatement(File file) async {
    return await paymentMethodProvider.uploadFile(file);
  }

  Future<String> getPassPhrase() async {
    return await paymentMethodProvider.getPassPhrase();
  }

  Future<String> addKey(String passPhrase) async {
    return await paymentMethodProvider.addKey(passPhrase);
  }

  Future<String> saveDebitCardDetails(
      String cardNumber, String name, String expire) async {
    return await paymentMethodProvider.saveDebitCard(cardNumber, name, expire);
  }

  Future<String> getVaultBasicCreds() async {
    return await paymentMethodProvider.getVaultBasicCredentials();
  }
}
