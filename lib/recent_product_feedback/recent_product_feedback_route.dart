import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:market_space/model/product_model.dart';
import 'package:market_space/product_landing_screen/product_landing_screen.dart';
import 'package:market_space/recent_product_feedback/recent_product_feedback_screen.dart';
import 'package:market_space/routes/route.dart';

class RecentProductFeedbackRoute extends ARoute {
  static String _path = '/dashboard/recentProductFeedback';
  static String buildPath() => _path;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.fadeIn;

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) =>
      RecentProductFeedbackScreen();
}
