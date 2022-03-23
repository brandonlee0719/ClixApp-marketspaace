import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:market_space/profile/profile_screen.dart';
import 'package:market_space/routes/route.dart';

class ProfileRoute extends ARoute {
  static String _path = '/dashboard/profile';
  static String buildPath() => _path;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.fadeIn;

  @override
  bool get clearStack => true;

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) =>
      ProfileScreen();
}
