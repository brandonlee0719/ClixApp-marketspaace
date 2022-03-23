import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:market_space/routes/route.dart';
import 'package:market_space/sell_new_products/sell_new_products_screen.dart';

class SellNewProductsRoute extends ARoute {
  static String _path = '/dashboard/sellnewproducts';
  static String buildPath() => _path;
  static List<String> imageArray;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.fadeIn;

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) =>
      SellNewProductsScreen();
}
