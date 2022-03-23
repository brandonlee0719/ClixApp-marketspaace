import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/investment/screens/chooseCoinScreen.dart';
import 'package:market_space/investment/sell_assets/screens/UploadBankScreen.dart';
import 'package:market_space/investment/sell_assets/screens/bankScreen.dart';
import 'package:market_space/investment/sell_assets/screens/withdrawPreview.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/routes/route.dart';

class ChooseCoinRoute extends ARoute{
  static String _path = '/dashboard/investment/chooseCoin';
  static String buildPath() => _path;
  static String coinType;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.fadeIn;

  // @override
  // bool get clearStack => true;

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) {
     return ChooseCoinScreen();
  }

}

class UploadBankRoute extends ARoute{
  static String _path = '/dashboard/investment/uploadBank';
  static String buildPath() => _path;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.fadeIn;

  // @override
  // bool get clearStack => true;

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) {
    return BankScreen();
  }

}


class PayPreviewRoute extends ARoute{
  static String _path = '/dashboard/investment/paymentPreview';
  static String buildPath() => _path;
  static String coinType;
  static  String number;
  static String address;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.fadeIn;

  // @override
  // bool get clearStack => true;

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) {
    return WithdrawPreview();
  }

}