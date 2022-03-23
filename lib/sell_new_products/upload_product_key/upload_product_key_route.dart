import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:market_space/routes/route.dart';
import 'package:market_space/sell_new_products/upload_product_key/upload_product_key_screen.dart';
import 'package:market_space/model/sell_item_req_model/sell_item_req_model.dart';
import 'package:market_space/common/selling_item.dart';
import 'package:market_space/sell_new_products/sell_new_products_page_bloc.dart';

class UploadProductKeyRoute extends ARoute {
  static String _path = '/dashboard/uploadProductKey';
  static String buildPath() => _path;
  static String courierService;
  static String shippingMethod;
  static String packageHeight;
  static String packageLength;
  static String packageWeight;
  static String packageWidth;
  static String estimatedShippingPrice;
  static String deliveryInformation;
  static String sellerHandlingTime;
  static bool freeShipping;
  static SellerPageBloc sellerPageBloc;

  @override
  String get path => _path;

  @override
  final TransitionType transition = TransitionType.fadeIn;

  @override
  Widget handlerFunc(BuildContext context, Map<String, dynamic> params) =>
      UploadProductKeyScreen();
}
