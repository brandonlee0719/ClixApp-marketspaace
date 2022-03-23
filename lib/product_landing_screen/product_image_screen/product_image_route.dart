import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:market_space/model/product_detail_model/product_det_model.dart';
import 'package:market_space/model/product_model.dart';
import 'package:market_space/product_landing_screen/product_image_screen/product_image_screen.dart';
import 'package:market_space/product_landing_screen/product_landing_screen.dart';
import 'package:market_space/routes/route.dart';

class ProductImageRoute extends ARoute {
  static String _path = '/dashboard/ProductImage';
  static String buildPath() => _path;
  static ProductDetModel productDetailModel;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.fadeIn;

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) =>
      ProductImageScreen();
}
