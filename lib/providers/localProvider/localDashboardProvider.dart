import 'dart:convert';
import 'package:market_space/model/rates_model/rates_model.dart';
import 'package:market_space/profile_settings/model/debit_card_model.dart';
import 'package:market_space/providers/localStorageParentProvider.dart';

class LocalDashBoardProvider extends LocalStorageParentProvider {
  //always gives the last 4 digits for card

  final String _exchangeRateKey = 'card';
  Future<RatesModel> getRateFromLocal() async {
    final String cardString = await getValue(_exchangeRateKey);
    if (cardString != null) {
      Map cardMap = json.decode(cardString);
      RatesModel rate = RatesModel.fromJson(cardMap);
      return rate;
    }
    return null;
  }

  Future<void> storeRate(String creditString) async {
    await setValue(creditString, _exchangeRateKey);
  }
}
