import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

abstract class ARoute {
  String path;
  bool replace = false;
  bool clearStack = false;
  TransitionType transition = TransitionType.native;
  Duration transitionDuration = Duration(milliseconds: 250);
  RouteTransitionsBuilder transitionBuilder;
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params);
  Future<bool> hasPermission(Map<String, List<String>> params) async => true;
}
