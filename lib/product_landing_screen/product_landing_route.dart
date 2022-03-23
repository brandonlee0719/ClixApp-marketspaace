import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:market_space/model/flash_promo_model/flash_promo_algolia.dart';
import 'package:market_space/model/product_detail_model/product_det_model.dart';
import 'package:market_space/model/product_model.dart';
import 'package:market_space/product_landing_screen/product_landing_screen.dart';
import 'package:market_space/routes/route.dart';

class ProductLandingRoute extends ARoute {
  static String _path = '/dashboard/ProductLanding';
  static String buildPath() => _path;
  static String productName;
  static int productNum;
  static bool isProductLiked = false;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.inFromRight;

  // @override
  // final Duration duration = Duration(seconds: 3);

  // @override
  // TransitionBuilder().;
  // final AnimationController _controller = AnimationController(
  //   duration: const Duration(seconds: 2),
  // );

  // final Animation<double> _animation = CurvedAnimation(
  //   parent: _controller,
  //   curve: Curves.fastOutSlowIn,
  // );

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) {
    // print(params);
    return ProductLandingScreen();
  }
}
