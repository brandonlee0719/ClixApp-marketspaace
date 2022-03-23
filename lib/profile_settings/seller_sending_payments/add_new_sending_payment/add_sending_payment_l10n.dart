import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  TimeLeft,
  addNewBuyerPayment,
  addNewSellerPayment,
  Bank,
  addCryptoCurrency,
  otherCryptoCurrency,
  CreditCard,
  Wallet,
  selectCryptoPayment,
  confirm,
  close,
}

class AddSendingPaymentL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.TimeLeft: "Time left",
      _LKeys.addNewBuyerPayment: "ADD NEW BUYER PAYMENT",
      _LKeys.addNewSellerPayment: "SELLER PAYMENT METHOD",
      _LKeys.Bank: "Bank",
      _LKeys.addCryptoCurrency: "Add cryptocurrency address",
      _LKeys.otherCryptoCurrency: "Other cryptocurrency",
      _LKeys.CreditCard: "Credit Card",
      _LKeys.Wallet: "Wallet",
      _LKeys.selectCryptoPayment:
          "Select crypto payout method when listing item",
      _LKeys.confirm: "CONFIRM",
      _LKeys.close: "CLOSE",
    },
    L10nService.ptZh.toString(): {
      _LKeys.TimeLeft: "剩下的时间",
      _LKeys.addNewBuyerPayment: "添加新买家付款",
      _LKeys.addNewSellerPayment: "卖家付款方式",
      _LKeys.Bank: "银行",
      _LKeys.addCryptoCurrency: "添加加密货币地址",
      _LKeys.otherCryptoCurrency: "其他加密货币",
      _LKeys.CreditCard: "信用卡",
      _LKeys.Wallet: "钱包",
      _LKeys.selectCryptoPayment: "列出项目时选择加密支付方式",
      _LKeys.confirm: "确认",
      _LKeys.close: "关闭",
    },
  };

  String get TimeLeft => _localizedValues[locale.toString()][_LKeys.TimeLeft];
  String get addNewBuyerPayment =>
      _localizedValues[locale.toString()][_LKeys.addNewBuyerPayment];
  String get addNewSellerPayment =>
      _localizedValues[locale.toString()][_LKeys.addNewSellerPayment];
  String get Bank => _localizedValues[locale.toString()][_LKeys.Bank];
  String get addCryptoCurrency =>
      _localizedValues[locale.toString()][_LKeys.addCryptoCurrency];
  String get otherCryptoCurrency =>
      _localizedValues[locale.toString()][_LKeys.otherCryptoCurrency];
  String get CreditCard =>
      _localizedValues[locale.toString()][_LKeys.CreditCard];
  String get Wallet => _localizedValues[locale.toString()][_LKeys.Wallet];
  String get selectCryptoPayment =>
      _localizedValues[locale.toString()][_LKeys.selectCryptoPayment];
  String get confirm => _localizedValues[locale.toString()][_LKeys.confirm];
  String get close => _localizedValues[locale.toString()][_LKeys.close];

  final Locale locale;

  AddSendingPaymentL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _AddSendingPaymentL10nDelegate();
}

class _AddSendingPaymentL10nDelegate
    extends AL10nDelegate<AddSendingPaymentL10n> {
  const _AddSendingPaymentL10nDelegate();

  @override
  Future<AddSendingPaymentL10n> load(Locale locale) =>
      SynchronousFuture<AddSendingPaymentL10n>(AddSendingPaymentL10n(locale));
}
