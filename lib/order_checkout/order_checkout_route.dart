import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/model/product_detail_model/product_det_model.dart';
import 'package:market_space/order_checkout/logic/order_checkout_bloc/order_checkout_bloc.dart';
import 'package:market_space/routes/route.dart';

import 'logic/page_bloc.dart';
import 'order_checkout_screen.dart';

class OrderCheckoutRoute extends ARoute {
  static String _path = '/profile/orderCheckouts';

  static List<int> productList;
  static String buildPath() => _path;
  static bool isBuyNow = false;
  static ProductDetModel productDetModel;

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
    OrderCheckoutBloc order = new OrderCheckoutBloc(Initial());
    return MultiBlocProvider(providers: [
      BlocProvider<OrderCheckoutBloc>(
        create: (BuildContext context) => order,
      ),
      BlocProvider<PageBloc>(
        create: (BuildContext context) => PageBloc(PageState.initial, order),
      )
    ], child: OrderCheckoutScreen(productList));
  }
}
