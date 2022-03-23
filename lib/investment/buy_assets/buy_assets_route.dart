import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:market_space/investment/buy_assets/buy_assets_screen.dart';
import 'package:market_space/routes/route.dart';

class BuyAssetsRoute extends ARoute{
  static String _path = '/dashboard/investment/buyAssets';
  static String buildPath() => _path;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.fadeIn;

  // @override
  // bool get clearStack => true;

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) => BuyAssetsScreen();

}