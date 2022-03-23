import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:market_space/investment/buy_assets/buy_assets_screen.dart';
import 'package:market_space/investment/sell_assets/sell_asset_screen.dart';
import 'package:market_space/routes/route.dart';

class SellAssetRoute extends ARoute {
  static String _path = '/dashboard/investment/sellAssets';
  static String buildPath() => _path;
  static String coinType;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.fadeIn;

  static void dipose() {
    coinType = null;
  }

  // @override
  // bool get clearStack => true;

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) {
    // print(params["isSell"]);
    if (params["isSell"] != null) {
      return SellAssetScreen(isSell: true);
    } else if (params["isReceive"] != null) {
      return SellAssetScreen(isReceive: true);
    } else if (params["withDraw"] != null) {
      return SellAssetScreen(isWithdraw: true);
    } else if (params["isConvert"] != null) {
      return SellAssetScreen(isConvert: true);
    }
    return SellAssetScreen(isSell: false, isReceive: false, isWithdraw: false);
  }
}
