import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:market_space/routes/HomeScreen.dart';
import 'package:market_space/routes/route.dart';

class HomeScreenRoute extends ARoute {
  static String _path = '/Home';
  static String buildPath() => _path;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.inFromRight;

  @override
  Duration get transitionDuration => Duration(milliseconds: 400);

  @override
  bool get clearStack => true;

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) =>
      HomeScreen();
}
