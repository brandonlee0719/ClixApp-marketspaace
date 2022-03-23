import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';

import 'package:market_space/profile_settings/profile_setting_screen.dart';
import 'package:market_space/routes/route.dart';

class ProfileSettingRoute extends ARoute {
  static String _path = '/settings';
  static String buildPath() => _path;
  static UpdateAddressModel updateAddressModel;

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
      ProfileSettingScreen();
}
