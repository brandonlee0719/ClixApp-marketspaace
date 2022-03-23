import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:market_space/investment/investment_screen.dart';
import 'package:market_space/routes/route.dart';

class InvestmentRoute extends ARoute{
  static String _path = '/dashboard/investment';
  static String buildPath() => _path;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.fadeIn;

  @override
  bool get clearStack => true;

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) => InvestmentScreen();

}