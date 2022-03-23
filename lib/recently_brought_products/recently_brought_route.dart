import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:market_space/recently_brought_products/recently_brought_screen.dart';
import 'package:market_space/routes/route.dart';

class RecentlyBroughtRoute extends ARoute {
  static String _path = '/profile/RecentlyBroughts';
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
      RecentlyBroughtScreen();
}
