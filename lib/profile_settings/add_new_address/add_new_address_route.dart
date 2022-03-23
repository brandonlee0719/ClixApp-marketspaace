import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:market_space/profile_settings/add_new_address/add_new_address_screen.dart';
import 'package:market_space/routes/route.dart';

class AddNewAddressRoute extends ARoute {
  static String _path = '/settings/addNewAddress';
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
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) {
    // print(params);
    if (params.containsKey("isBilling")) {
      return AddNewAddressScreen(
        isBilling: true,
      );
    }
    return AddNewAddressScreen(
      isBilling: false,
    );
  }
}
