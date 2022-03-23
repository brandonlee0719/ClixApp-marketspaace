import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:market_space/routes/route.dart';
import 'package:market_space/sell_new_products/tags/tags_screen.dart';
import 'package:market_space/sell_new_products/upload_product_key/upload_product_key_screen.dart';

class TagsRoute extends ARoute {
  static String _path = '/dashboard/AddTags';
  static String buildPath() => _path;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.fadeIn;

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) =>
      TagsScreen();
}
