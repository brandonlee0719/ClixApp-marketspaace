import 'package:market_space/investment/sell_assets/screens/orderPreview.dart';
import 'package:market_space/order_checkout/network/checkoutProvider.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';

import '../sell_asset_screen.dart';

enum PreviewButtonStatus {
  buyInitial,
  awaitCvv,
  awaitCardAuth,
  finalize,

  sellInitial,
  awaitProve,

  convertInitial,
  awaitConvertProve,
}

class SelleAssetProvider {
  Future<TradeCryptoModel> tradeModel;
  TradeCryptoModel model;
  String currencyName;
  String currencySimpleName = "BTC";
  String destCurrencySimpleName = "ETH";
  PreviewButtonStatus status = PreviewButtonStatus.buyInitial;
  Map<PreviewButtonStatus, Function> thisMap =
      Map<PreviewButtonStatus, Function>();

  Map<PreviewButtonStatus, PreviewButtonStatus> map = {
    PreviewButtonStatus.buyInitial: PreviewButtonStatus.awaitCvv,
    PreviewButtonStatus.sellInitial: PreviewButtonStatus.awaitProve,
    PreviewButtonStatus.awaitProve: PreviewButtonStatus.finalize,
    PreviewButtonStatus.awaitCvv: PreviewButtonStatus.awaitCardAuth,
    PreviewButtonStatus.awaitCardAuth: PreviewButtonStatus.finalize,
    PreviewButtonStatus.convertInitial: PreviewButtonStatus.awaitConvertProve,
    PreviewButtonStatus.awaitConvertProve: PreviewButtonStatus.finalize,
  };

  void handleScreenCall() {
    // print(status);
    thisMap[status]();
  }

  void goNext() {
    this.status = map[status];
  }

  Function operator [](PreviewButtonStatus value) {
    return thisMap[value];
  }

  void operator []=(PreviewButtonStatus value, Function func) {
    thisMap[value] = func;
  }

  void getTradeModel(String useSource, String amount) {
    this.tradeModel = CheckoutProvider()
        .createCryptoOrder(
      useSource,
      currencySimpleName.toUpperCase(),
      amount,
    )
        .then(
      (value) {
        this.model = value;
        return value;
      },
    );
  }

  void getSellModel(String useSource, String amount) {
    this.tradeModel = CheckoutProvider()
        .sellCrypto(currencySimpleName.toUpperCase(), amount, useSource)
        .then(
      (value) {
        // print(value.total);
        // print(value.getOrderJson());
        this.model = value;
        return value;
      },
    );
  }

  Future<int> confirmSell() async {
    int response = await CheckoutProvider().confirmSell(model.reservationID);
    return response;
  }

  void setCoin(String title) {
    List<String> nameList = title.split(" ");
    // print(nameList);
    if (nameList.length == 3) {
      currencyName = nameList[0] + " " + nameList[1];
    } else {
      currencyName = nameList[0];
    }

    currencySimpleName = nameList.last;
    if (currencySimpleName.length == 6) {
      currencySimpleName = currencySimpleName.substring(1, 5);
    } else {
      currencySimpleName = currencySimpleName.substring(1, 4);
    }
    // print(currencyName);
    // print(currencySimpleName);
  }

  void reload() {
    this.tradeModel = Future.delayed(Duration(seconds: 3), () {
      this.model = TradeCryptoModel(12, 1, "reservationID", "srn", 4, 5);
      return model;
    });
  }

  Future<Map<String, dynamic>> buy(String cvv, BuyCryptoMode mode) async {
    String typeMode;
    if (mode == BuyCryptoMode.aud) {
      typeMode = "source";
    } else {
      typeMode = "dest";
    }

    var map = _generatePaymentMap(cvv, typeMode);
    Map<String, dynamic> authMap = await CheckoutProvider().buyCrypto(map);
    return authMap;
  }

  Map<String, dynamic> _generatePaymentMap(String cvv, String mode) {
    Map<String, dynamic> map1 = {
      "useSourceOrDest": mode,
      "cvv": cvv,
      "destCurrency": this.currencySimpleName,
    };

    Map<String, dynamic> map3 = {
      "billingFirstName": "Nivasan",
      "billingLastName": "Babu Srinivasan",
      "ipAddress": "220.245.169.228",
      "billingStreetAddress": "20 Greenhaven Gardens",
      "billingStreetAddressTwo": "Melbourne",
      "billingState": "Victoria",
      "billingPostCode": "3752",
      "countryCode": "AU"
    };
    Map<String, dynamic> map2 = model.getOrderJson();

    map1.addAll(map2);
    map1.addAll(map3);
    // print(map1);
    return map1;
  }
}
