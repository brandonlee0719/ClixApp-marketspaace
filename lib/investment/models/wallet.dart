import 'dart:math';

import 'package:market_space/order_checkout/model/paymentCurrency.dart';

class Wallet {
  double AUD;
  // String AUDInCNY; may need it later, but now it is not useful
  double BTC;
  //this field is actually 2 field, 1.BTCInCNY, 2 BTCInAUD, to prevent duplicated field, I name it BTCInCNY
  //by neil email: duanxinhuan@163.com
  double BTCInCNY;
  double USDCInCNY;
  double ETHInCNY;
  double CNY;
  double ETH;
  double USDC;
  double heldAUD;
  double heldBTC;
  double heldCNY;
  double heldETH;
  double heldUSDC;
  double BTCAUDPrice;
  double ETHAUDPrice;
  double USDCAUDPrice;
  double interestEarnings;
  double totalAmount;

  Map<String, String> disPlayMap;
  Map<PaymentCurrency, double> walletMap;

  Wallet(
    this.AUD,
    this.BTC,
    this.BTCInCNY,
    this.ETHInCNY,
    this.USDCInCNY,
    this.CNY,
    this.ETH,
    this.USDC,
    this.heldAUD,
    this.heldBTC,
    this.heldCNY,
    this.heldETH,
    this.heldUSDC,
    // this.AUDInCNY,
  );

  double dp(double val, int places) {
    num mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  //to-do ETH,USDC,BTC, please give more consistency and more comment on the logic!
  Wallet.fromJson(Map<String, dynamic> json) {
    AUD = json['AUD'];
    BTC = dp(json['BTC'], 7);
    if (json['BTCinAUD'] != null) {
      BTCInCNY = json['BTCinAUD'];
    } else {
      BTCInCNY = json['BTCinCNY'];
    }
    if (json['ETHinAUD'] != null) {
      ETHInCNY = json['ETHinAUD'];
    } else {
      ETHInCNY = json['ETHinCNY'];
    }
    if (json['USDCinAUD'] != null) {
      USDCInCNY = json['USDCinAUD'];
    } else {
      USDCInCNY = json['USDCinCNY'];
    }
    CNY = json['CNY']?.toDouble();
    ETH = dp(json['ETH']?.toDouble(), 7);
    USDC = dp(json['USDC']?.toDouble(), 2);
    heldAUD = json["heldAUD"]?.toDouble();
    heldBTC = dp(json["heldBTC"]?.toDouble(), 7);
    heldCNY = json["heldCNY"]?.toDouble();
    heldETH = dp(json["heldETH"]?.toDouble(), 7);
    heldUSDC = dp(json["heldUSDC"]?.toDouble(), 2);
    BTCAUDPrice = json["BTCAUDPrice"]?.toDouble();
    ETHAUDPrice = json["ETHAUDPrice"]?.toDouble();
    USDCAUDPrice = json["USDCAUDPrice"]?.toDouble();
    interestEarnings = json["interestEarnings"]?.toDouble();
    totalAmount = json["totalAmount"]?.toDouble();

    walletMap = {
      PaymentCurrency.AUD: AUD,
      PaymentCurrency.CNY: CNY,
      PaymentCurrency.USDC: USDC,
      PaymentCurrency.ETH: ETH,
      PaymentCurrency.BTC: BTC,
    };

    disPlayMap = {
      'Bitcoin (BTC)': "BTC ${BTC.toStringAsFixed(7)}",
      'Bitcoin (BTC)_held': "BTC ${heldBTC.toStringAsFixed(7)}",
      'Bitcoin (BTC)_held_transfer': "0",
      'Bitcoin (BTC)_price': "$BTCAUDPrice".length > 7
          ? "\$ $BTCAUDPrice".substring(0, 7)
          : "\$ $BTCAUDPrice",
      'Bitcoin (BTC)_transfer': "\$$BTCInCNY",
      'Ethereum (ETH)': "ETH ${ETH.toStringAsFixed(7)}",
      'Ethereum (ETH)_price': "$ETHAUDPrice".length > 7
          ? "\$ $ETHAUDPrice".substring(0, 7)
          : "\$ $ETHAUDPrice",
      'Ethereum (ETH)_held': "ETH ${heldETH.toStringAsFixed(7)}",
      'Ethereum (ETH)_held_transfer': "0",
      'Ethereum (ETH)_transfer': "\$$ETHInCNY",
      'USD Coin (USDC)': "USDC ${USDC.toStringAsFixed(2)}",
      'USD Coin (USDC)_price': "$USDCAUDPrice".length > 2
          ? "\$ $USDCAUDPrice".substring(0, 2)
          : "\$ $USDCAUDPrice",
      'USD Coin (USDC)_held': "USDC ${heldUSDC.toStringAsFixed(2)}",
      'USD Coin (USDC)_held_transfer': "0",
      'USD Coin (USDC)_transfer': "\$$USDCInCNY",
      "Australia dollars(AUD)": "\$$AUD",
      "Chinese Yuan(CNY)": "\¥$CNY",
    };

    // print(disPlayMap);
    // print(walletMap);
  }

  Map<String, dynamic> getBTCMap() {
    return {
      "price": BTCAUDPrice,
      "held": heldBTC,
    };
  }
}
