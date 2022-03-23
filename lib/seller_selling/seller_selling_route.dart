import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:market_space/routes/route.dart';
import 'package:market_space/seller_selling/seller_selling_screen.dart';

class SellerSellingRoute extends ARoute {
  static String _path = '/dashboard/sellerSelling';
  static String buildPath() => _path;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.fadeIn;

  @override
  bool get clearStack => true;

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) =>
      SellerSellingScreen();
}