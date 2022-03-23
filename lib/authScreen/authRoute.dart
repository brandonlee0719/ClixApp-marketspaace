import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/authScreen/logic/password_cubit.dart';
import 'package:market_space/authScreen/screens/OtpScreen.dart';
import 'package:market_space/main.dart';
import 'package:market_space/product_landing_screen/product_landing_screen.dart';

import 'package:market_space/routes/route.dart';

class AuthRoute extends ARoute {
  static String _path = '/BiometricsAuth/:id';
  static String buildPath() => _path;
  static bool isReset = false;
  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => Duration(milliseconds: 0);

  @override
  String get path => _path;
  //
  @override
  final TransitionType transition = TransitionType.none;

  // @override
  // Widget handlerFunc(BuildContext context, Map<String, dynamic> params) => White(params["id"][0]);
  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) {
    // print("do i triggered?");
    return BlocProvider(
        create: (_) => PasswordCubit(false), child: OtpScreen());
  }
}
