import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:market_space/model/buyer_info_model/buyer_info_model.dart';
import 'package:market_space/model/sold_product_model/sold_product_model.dart';
import 'package:market_space/routes/route.dart';
import 'package:market_space/sold_product_detail/sold_detail_screen.dart';

class SoldDetailRoute extends ARoute {
  static String _path = '/profile/SoldDetails';
  static String buildPath() => _path;
  static Orders order;
  static String trackingNumber, shippingCompany;

  @override
  String get path => _path;

  // @override
  // final bool clearStack = true;

  @override
  final TransitionType transition = TransitionType.inFromRight;

  @override
  Duration get transitionDuration => Duration(milliseconds: 400);

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) =>
      SoldDetailScreen();
}
