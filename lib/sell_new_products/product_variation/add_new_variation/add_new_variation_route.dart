import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:market_space/routes/route.dart';
import 'package:market_space/sell_new_products/add_brand/seller_add_brand.dart';
import 'package:market_space/sell_new_products/product_variation/add_new_variation/add_new_variation_screen.dart';
import 'package:market_space/sell_new_products/product_variation/seller_product_variation_screen.dart';

class AddNewVariationRoute extends ARoute {
  static String _path = '/dashboard/addNewVariation';
  static String buildPath() => _path;
  static String variator;
  static String variation;
  static int quantity;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.fadeIn;

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) =>
      AddNewVariationScreen();
}
