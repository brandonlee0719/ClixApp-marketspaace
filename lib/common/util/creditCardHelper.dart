import 'package:market_space/profile_settings/model/debit_card_model.dart';
import 'package:market_space/profile_settings/network/vaultProvider.dart';
import 'package:market_space/repositories/paymentRepositrory/card_repository.dart';

class CreditCardHelper {
  CardRepository repo = CardRepository();
  VaultProvider vault = VaultProvider();

  bool hasCredit;

  static final CreditCardHelper _singleton = CreditCardHelper._internal();

  factory CreditCardHelper() {
    return _singleton;
  }

  CreditCardHelper._internal();

  Future<void> fetchCard() async {
    CardRepository provider = CardRepository();
    await provider.getCard();
    // throw Exception([]);
  }

  Future<void> addCard(
      String expiryDate, String cardHolderName, String cardNumber) async {
    vault.setBankDetails(expiryDate, cardHolderName, cardNumber);
    int _ = await vault.uploadVaultData();
    fetchCard();
  }

  Future<void> deleteCard() async {
    CardRepository provider = CardRepository();
    // print("deleting cards......");
    await vault.deleteKey();
    await provider.deleteCard();
  }

  onError(error, stackTrace) {
    // print("I am a error in card");
  }
}
