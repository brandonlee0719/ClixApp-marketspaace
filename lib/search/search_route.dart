import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:market_space/dashboard/products_grid.dart';
import 'package:market_space/routes/route.dart';

import 'search_screen.dart';

class SearchRoute extends ARoute {
  static String _path = '/dashboard/search';
  static String buildPath() => _path;

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
      ProductsPageWrapper();
}
