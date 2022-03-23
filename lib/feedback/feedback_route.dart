import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:market_space/feedback/feedback_screen.dart';
import 'package:market_space/routes/route.dart';

class FeedbackRoute extends ARoute {
  static String _path = '/dashboard/feedback';
  static String buildPath() => _path;
  static bool isSeller = true;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.fadeIn;

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) =>
      FeedbackScreen();
}
