import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:market_space/routes/route.dart';
import 'package:market_space/sell_new_products/sale_condition/sale_condition_screen.dart';

class SaleConditionRoute extends ARoute {
  static String _path = '/dashboard/sellerSaleCondition';
  static String buildPath() => _path;
  static String saleCondition;
  static int quantity;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.fadeIn;

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) =>
      SaleConditionScreen();
}
