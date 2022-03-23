import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:market_space/forgotPasswordOtp/forgot_password_otp_screen.dart';
import 'package:market_space/routes/route.dart';

class ForgotPassOtpRoute extends ARoute {
  static String _path = '/ForgotPassOtp/:type';
  static String buildPath() => _path;
  static bool isForget;
  static bool isForgetPIN = false;

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
    // print(params['varId']);
    try {
      String id = params['varId'][0];
      // print("id is: $id");
      return ForgotPasswordOtpScreen(params["type"][0], varID: id);
    } catch (e) {}

    return ForgotPasswordOtpScreen(params["type"][0]);
  }
}
