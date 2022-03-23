import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:market_space/active_products/active_product_route.dart';
import 'package:market_space/authScreen/authRoute.dart';
import 'package:market_space/cart/cart_route.dart';
import 'package:market_space/changePassword/change_password_route.dart';
import 'package:market_space/dashboard/dashboard_new.dart';
import 'package:market_space/dashboard/dashboard_route.dart';
import 'package:market_space/feedback/feedback_route.dart';
import 'package:market_space/forgotPassword/forgot_pass_route.dart';
import 'package:market_space/forgotPasswordOtp/forgot_password_otp_route.dart';
import 'package:market_space/investment/buy_assets/buy_assets_route.dart';
import 'package:market_space/investment/investment_route.dart';
import 'package:market_space/investment/sell_assets/routes/chooseCoinRoute.dart';
import 'package:market_space/investment/sell_assets/sell_asset_route.dart';
import 'package:market_space/investment_top_up/investment_top_up_route.dart';
import 'package:market_space/login/login_route.dart';
import 'package:market_space/message_chat/message_chat_route.dart';
import 'package:market_space/messages/messages_route.dart';
import 'package:market_space/notification/routes/notification_route.dart';
import 'package:market_space/order_checkout/order_checkout_route.dart';
import 'package:market_space/product_landing_screen/product_image_screen/product_image_route.dart';
import 'package:market_space/product_landing_screen/product_landing_route.dart';
import 'package:market_space/profile/profile_route.dart';
import 'package:market_space/profile_settings/add_new_address/add_new_address_route.dart';
import 'package:market_space/profile_settings/editEmail/edit_email_route.dart';
import 'package:market_space/profile_settings/help_center/help_center_route.dart';
import 'package:market_space/profile_settings/profile_setting_route.dart';
import 'package:market_space/profile_settings/receiving_payment/receiving_payment_route.dart';
import 'package:market_space/profile_settings/seller_sending_payments/add_new_sending_payment/add_new_sending_route.dart';
import 'package:market_space/profile_settings/update_password/update_password_route.dart';
import 'package:market_space/recent_product_feedback/recent_product_feedback_route.dart';
import 'package:market_space/recently_brought_details/recently_detail_route.dart';
import 'package:market_space/recently_brought_products/recently_brought_route.dart';
import 'package:market_space/routes/HomeScreenRoute.dart';
import 'package:market_space/routes/route.dart';
import 'package:market_space/search/search_route.dart';
import 'package:market_space/sell_new_products/add_brand/seller_add_brand_route.dart';
import 'package:market_space/sell_new_products/product_variation/add_new_variation/add_new_variation_route.dart';
import 'package:market_space/sell_new_products/product_variation/edit_variator/add_additional_variator/add_additional_route.dart';
import 'package:market_space/sell_new_products/product_variation/edit_variator/edit_variator_route.dart';
import 'package:market_space/sell_new_products/product_variation/seller_product_variation_route.dart';
import 'package:market_space/sell_new_products/sale_condition/sale_condition_route.dart';
import 'package:market_space/sell_new_products/sell_new_products_route.dart';
import 'package:market_space/sell_new_products/tags/tags_route.dart';
import 'package:market_space/sell_new_products/upload_product_key/upload_product_key_route.dart';
import 'package:market_space/signup/general_info_route.dart';
import 'package:market_space/sold_product_detail/sold_detail_route.dart';
import 'package:market_space/sold_products/sold_product_route.dart';
import 'package:market_space/splash/splash_route.dart';
import 'package:market_space/subcategoryResults/subCategoryResults_route.dart';
import 'package:market_space/interested_categories/interested_categories_route.dart';

class RouterService {
  static final GlobalKey<NavigatorState> appNavigatorKey =
      GlobalKey<NavigatorState>();
  static final appRouter = RouterService._init(appNavigatorKey, _appRoutes);
  static final GlobalKey<NavigatorState> profileNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> messagesNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> walletNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> homeNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> loginNavigatorKey =
      GlobalKey<NavigatorState>();

  static final homeRouter = RouterService._init(homeNavigatorKey, _HomeRoutes);

  static final profileRouter =
      RouterService._init(profileNavigatorKey, _profileRoute);

  static final messagesRouter =
      RouterService._init(messagesNavigatorKey, _messagesRoute);
  static final walletRouter =
      RouterService._init(walletNavigatorKey, _walletRoute);

  static final List<ARoute> _appRoutes = [
    SplashRoute(),
    LogInRoute(),
    HomeScreenRoute(),
    GeneralInfoRoute(),
    ForgotPassRoute(),
    ForgotPassOtpRoute(),
    ChangePasswordRoute(),
    SearchRoute(),
    ProductLandingRoute(),
    CartRoute(),
    OrderCheckoutRoute(),
    ProfileSettingRoute(),
    HelpCenterRoute(),
    EditEmailRoute(),
    AddNewAddressRoute(),
    ReceivingPaymentRoute(),
    NotificationRoute(),
    SellerSellingRoute(),
    SellNewProductsRoute(),
    FeedbackRoute(),
    RecentlyDetailRoute(),
    UpdatePasswordRoute(),
    RecentProductFeedbackRoute(),
    MessageChatRoute(),
    SellerAddBrandRoute(),
    SellerProductVariationRoute(),
    AddNewVariationRoute(),
    SaleConditionRoute(),
    EditVariatorRoute(),
    AddAdditionalRoute(),
    UploadProductKeyRoute(),
    TagsRoute(),
    ProductImageRoute(),
    AddNewSendingRoute(),
    BuyAssetsRoute(),
    SellAssetRoute(),
    SubCategoryResultsRoute(),
    InterestedCategoriesRoute(),
    AuthRoute(),
    ChooseCoinRoute(),
    UploadBankRoute(),
    PayPreviewRoute(),
  ];

  static final List<ARoute> _HomeRoutes = [
    DashboardRoute(),
  ];

  static final List<ARoute> _profileRoute = [
    DashboardRoute(),
    ProfileRoute(),
    ActiveProductRoute(),
    RecentlyBroughtRoute(),
    SoldProductRoute(),
    SoldDetailRoute(),
  ];
  static final List<ARoute> _messagesRoute = [
    MessageRoute(),
  ];
  static final List<ARoute> _walletRoute = [
    InvestmentRoute(),
  ];

  final _router = FluroRouter();
  final GlobalKey<NavigatorState> _navigatorKey;
  final List<ARoute> _routes;

  static void init() {}

  RouterService._init(this._navigatorKey, this._routes) {
    for (var route in _routes) {
      _router.define(
        route.path,
        handler: Handler(handlerFunc: route.handlerFunc),
        transitionType: route.transition,
      );
    }
  }

  Route<dynamic> generator(RouteSettings routeSettings) =>
      _router.generator(routeSettings);

  bool canPop() => _navigatorKey.currentState.canPop();

  void pop(BuildContext context) => _router.pop(context);

  void popWithResult(dynamic result) => _navigatorKey.currentState.pop(result);

  Future<dynamic> navigateTo(
    String path, {
    bool replace,
    bool clearStack,
    TransitionType transition,
    Duration transitionDuration,
    RouteTransitionsBuilder transitionBuilder,
    BuildContext context,
  }) async {
    final match = _router.match(path);
    if (match != null) {
      final route = _routes.firstWhere((r) => r.path == match.route.route);
      final hasPermission = await route.hasPermission(match.parameters);
      if (hasPermission) {
        if (context != null) {
          return _router.navigateTo(
            context,
            path,
            replace: replace ?? route.replace,
            clearStack: clearStack ?? route.clearStack,
            transition: transition ?? route.transition,
            transitionDuration: transitionDuration ?? route.transitionDuration,
            transitionBuilder: transitionBuilder ?? route.transitionBuilder,
          );
        } else if (clearStack ?? route.clearStack) {
          return _navigatorKey.currentState
              .pushNamedAndRemoveUntil(path, (check) => false);
        } else if (replace ?? route.replace) {
          return _navigatorKey.currentState.pushReplacementNamed(path);
        } else {
          return _navigatorKey.currentState.pushNamed(path);
        }
      }
    }
  }
}
