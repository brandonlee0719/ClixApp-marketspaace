import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:market_space/profile_settings/update_password/update_password_screen.dart';
import 'package:market_space/routes/route.dart';

class UpdatePasswordRoute extends ARoute {
  static String _path = '/settings/editPassword';
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
      UpdatePasswordScreen();
}
