import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:market_space/changePassword/change_password_screen.dart';
import 'package:market_space/forgotPasswordOtp/forgot_password_otp_screen.dart';
import 'package:market_space/routes/route.dart';

class ChangePasswordRoute extends ARoute {
  static String _path = '/log-in/ChangePassword';
  static String buildPath() => _path;
  static String otp;

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
      ChangePasswordScreen();
}
