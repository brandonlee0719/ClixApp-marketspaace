import 'package:market_space/investment/sell_assets/models/ConvertModel.dart';
import 'package:market_space/providers/marketSpaaceParentProvider.dart';

abstract class ICacher {
  /// this interface is to be the parent class of all cacheable value
  /// for example the bank account and BTC public address for the user\

  Future<Map> getBTCAddress();
}

class CacheableManager implements ICacher {
  CacheableProvider _provider;

  Map addressMap;

  CacheableManager() {
    _provider = CacheableProvider();
  }

  @override
  Future<Map> getBTCAddress() async {
    // print("I am triggerf");

    if (addressMap == null) {
      addressMap = await _provider.getBTCAddress();
    }
    return addressMap;
  }

  Future<List> withdraw(String amount, String address, String coinType) async {
    return await _provider.withdraw(amount, address, coinType.toUpperCase());
  }

  Future<int> confirmWithdraw(String transferID, bool biometricSuccess) async {
    return await _provider.confirmWithdraw(transferID, biometricSuccess);
  }

  Future<ConvertModel> convert(String sourceCurrency, String sourceAmount,
      String currencyOfSale, String destCurrency) async {
    return await _provider.convert(
        sourceCurrency, sourceAmount, currencyOfSale, destCurrency);
  }

  Future<int> confirmConvert(String id) async {
    return await _provider.confirmConvert(id);
  }
}

class CacheableProvider extends MarketSpaceParentProvider implements ICacher {
  String _btcAddressEndpoint = "/get_crypto_address";
  String _withdrawAdd = "/withdraw_crypto";
  String _confirmWithdrawAdd = "/confirm_wallet_withdrawal";
  String _convertAdd = "/create_convert_order";
  String _confirmAdd = "/confirm_convert_order";
  @override
  Future<Map> getBTCAddress() async {
    try {
      final response =
          await super.post(_btcAddressEndpoint, {"address": "Bitcoin"});
      // print(response.data);
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      // print(e);
    }

    return null;
  }

  Future<List> withdraw(String amount, String address, String coinType) async {
    // print('this has been entered');
    final data = {
      "sourceCurrency": coinType,
      "sourceAmount": amount,
      "withdrawalAddress": address
    };
    // print(data);
    final response = await super.post(_withdrawAdd, data);
    // print(data);
    // print(response.statusCode);
    // print(response.data);
    // print('withdraw data: ${response.data}');
    return [response.data, response.statusCode];
  }

  Future<int> confirmWithdraw(String transferID, bool biometricSuccess) async {
    final data = {
      "transferID": transferID,
      "biometricSuccess": biometricSuccess
    };

    final response = await super.post(_confirmWithdrawAdd, data);
    if (response.data == "Successfully withdrawn") {
      return response.statusCode;
    } else {
      return 400;
    }
  }

  Future<ConvertModel> convert(String sourceCurrency, String sourceAmount,
      String currencyOfSale, String destCurrency) async {
    final data = {
      "sourceCurrency": sourceCurrency,
      "sourceAmount": sourceAmount,
      "currencyOfSale": currencyOfSale,
      "destCurrency": destCurrency,
    };
    // print(data);
    final response = await super.post(_convertAdd, data);
    // print(response.statusCode);
    // print(response.data);
    if (response.statusCode == 200) {
      return ConvertModel.fromJson(response.data);
    }
    return null;
  }

  Future<int> confirmConvert(String id) async {
    final data = {"transferID": id};
    // print(data);
    final response = await super.post(_confirmAdd, data);
    // print(response.data);
    return response.statusCode;
  }
}
