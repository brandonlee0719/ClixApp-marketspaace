import 'dart:convert';
import 'package:market_space/profile_settings/model/debit_card_model.dart';
import 'package:market_space/providers/localStorageParentProvider.dart';

class LocalCardProvider extends LocalStorageParentProvider {
  //always gives the last 4 digits for card

  final String _cardKey = 'card__';
  Future<DebitCardModel> getDebitCardFromLocal() async {
    final String cardString = await getValue(_cardKey);
    if (cardString != null) {
      Map cardMap = json.decode(cardString);
      DebitCardModel debit = DebitCardModel.fromJson(cardMap);
      if (debit.cardHolder == null) {
        return null;
      }
      return debit;
    }
    return null;
  }

  Future<void> storeCreditCard(String creditString) async {
    await setValue(creditString, _cardKey);
  }

  Future<void> delete() async {
    await setValue(null, _cardKey);
  }
}
