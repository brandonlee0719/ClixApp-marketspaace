import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:market_space/model/order_status_model/order_status_model.dart';
import 'package:market_space/model/recently_product_model/recently_brought_model.dart';
import 'package:market_space/recently_brought_details/recently_detail_screen.dart';
import 'package:market_space/routes/route.dart';

class RecentlyDetailRoute extends ARoute {
  static String _path = '/profile/RecentlyDetails';
  static String buildPath() => _path;
  static RecentlyBrought recentlyBoughtModel = RecentlyBrought();
  static OrderStatusModel orderStatusModel = OrderStatusModel();

  @override
  String get path => _path;

  // @override
  // final bool clearStack = true;

  @override
  final TransitionType transition = TransitionType.inFromRight;

  @override
  Duration get transitionDuration => Duration(milliseconds: 400);

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) {
    // print("parameters are:");
    // print(params);
    if (params['id'] == null) {
      return RecentlyDetailScreen();
    }
    String id = params['id'][0];
    // print(id);

    return RecentlyDetailScreen(
      id: id,
    );
  }
}
