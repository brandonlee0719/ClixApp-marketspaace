import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:market_space/common/util/globalKeys.dart';
import 'package:market_space/profile_settings/add_new_address/add_new_address_screen.dart';
import 'package:market_space/profile_settings/receiving_payment/receiving_payment_screen.dart';
import 'package:market_space/routes/route.dart';

class ReceivingPaymentRoute extends ARoute {
  static String _path = '/settings/receivingPayment';
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
      ReceivingPaymentScreen(
        key: GlobalKeys.buyerScreenKey,
        isReceive: isReceive,
      );
}
