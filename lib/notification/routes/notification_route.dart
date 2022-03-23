import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/notification/logics/blocs/notification_bloc.dart';
import 'package:market_space/notification/representation/screens/notification_screen.dart';
import 'package:market_space/notification/representation/screens/staticListScreen.dart';
import 'package:market_space/routes/route.dart';
import 'package:market_space/seller_selling/seller_selling_screen.dart';

class NotificationRoute extends ARoute {
  static String _path = '/dashboard/notification';
  static String buildPath() => _path;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.fadeIn;

  @override

  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) =>
      QAScreen();
      // NotificationScreen();
}
