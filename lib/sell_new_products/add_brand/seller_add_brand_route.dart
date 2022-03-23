import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:market_space/routes/route.dart';
import 'package:market_space/sell_new_products/add_brand/seller_add_brand.dart';
import 'dart:io';

class SellerAddBrandRoute extends ARoute {
  static String _path = '/dashboard/sellerAddBrand';
  static String buildPath() => _path;
  static String brandName;
  static bool customBrand;
  static String customBrandName;
  static File customBrandImg;
  static String customBrandDescription;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.fadeIn;

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) =>
      SellerAddBrand();
}
