import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:market_space/profile_settings/add_new_address/add_new_address_screen.dart';
import 'package:market_space/profile_settings/receiving_payment/receiving_payment_screen.dart';
import 'package:market_space/profile_settings/seller_sending_payments/add_new_sending_payment/add_sending_payment_screen.dart';
import 'package:market_space/routes/route.dart';

class AddNewSendingRoute extends ARoute {
  static String _path = '/settings/addSendingPaymentMethod';
  static String buildPath() => _path;
  static bool isReceive;

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
      AddSendingPaymentScreen();
}
