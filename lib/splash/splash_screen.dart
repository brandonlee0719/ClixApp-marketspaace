import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:market_space/apis/firebaseManager.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/dashboard/dashboard_bloc.dart';
import 'package:market_space/dashboard/products/fav_products/favourite_products_bloc.dart';
import 'package:market_space/dashboard/products/products_bloc.dart';
import 'package:market_space/login/login_route.dart';
import 'package:market_space/model/flash_promo_model/flash_promo_algolia.dart';
import 'package:market_space/notification/routes/notification_route.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/repositories/dashboardRepository/dashboard_repository.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/routes/HomeScreenRoute.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/splash/splash_screen_bloc.dart';
import 'package:market_space/splash/splash_screen_event.dart';
import 'package:market_space/splash/splash_screen_state.dart';
// import 'package:market_space/forgotPasswordOtp/forgot_password_otp_route.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashScreenBloc _SplashScreenBloc = SplashScreenBloc(Initial());
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticated = false;
  final _globalKey = GlobalKey<ScaffoldState>();
  final dashboardRepo = DashboardRepository();
  AuthRepository _authRepository = AuthRepository();

  @override
  void initState() {
    // if(_SplashScreenBloc.isAuthorized) {
    if (SplashScreenBloc.notifyTxt == "") {
      _SplashScreenBloc.add(NavigateToHomeScreenEvent());
    } else if (SplashScreenBloc.notifyTxt == "notification") {
      _SplashScreenBloc.add(NavigateToNotificationEvent());
      SplashScreenBloc.notifyTxt = "";
    }
    // }
    // else{
    //   _SplashScreenBloc.add(CheckLoginBioMetricAvaiable());
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('do we enter the splash screen');

    return Scaffold(
      backgroundColor: AppColors.toolbarBlue,
      key: _globalKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.toolbarBlue,
        child: BlocProvider(
          create: (_) => _SplashScreenBloc,
          child: BlocListener<SplashScreenBloc, SplashScreenState>(
            listener: (context, state) {
              // if ((state is Initial) || (state is Loading)) {
              //   return _buildSplashWidget();
              // }
              // else if (state is Loaded) {
              //   RouterService.appRouter.navigateTo(LogInRoute.buildPath());
              // }
              if (state is EmailSigned) {
                // if(_SplashScreenBloc.isAuthorized){
                // print('and the email is signed ay?');
                _getDashboardData();
                // }else{
                //   _SplashScreenBloc.add(CheckLoginBioMetricAvaiable());
                // }
              }
              if (state is GoogleSigned) {
                // if(_SplashScreenBloc.isAuthorized){
                RouterService.appRouter.navigateTo(HomeScreenRoute.buildPath());
                // }else{
                //   _SplashScreenBloc.add(CheckLoginBioMetricAvaiable());
                // }
              }
              if (state is LoginNeeded) {
                // if(_SplashScreenBloc.isAuthorized){
                RouterService.appRouter.navigateTo(LogInRoute.buildPath());
                // }else{
                //   _SplashScreenBloc.add(CheckLoginBioMetricAvaiable());
                // }
              }
              if (state is LoginFailed) {
                // if(_SplashScreenBloc.isAuthorized){
                RouterService.appRouter.navigateTo(LogInRoute.buildPath());
                // }else{
                //   _SplashScreenBloc.add(CheckLoginBioMetricAvaiable());
                // }
              }
              if (state is NotificationNavigate) {
                // if(_SplashScreenBloc.isAuthorized){
                RouterService.appRouter
                    .navigateTo(NotificationRoute.buildPath());
                // }else{
                //   _SplashScreenBloc.add(CheckLoginBioMetricAvaiable());
                // }
              }
              if (state is BiometricChecking) {
                //TODO: USSING BLOC
                // setState(() {
                //   // _isLoading = true;
                // });
              }
              if (state is BiometricChecked) {
                //TODO: USSING BLOC
                // setState(() {
                //   // _isLoading = false;
                //   _canCheckBiometrics = _SplashScreenBloc.canCheckBiometrics;
                //   if (_canCheckBiometrics) {
                //     _availableBiometrics =
                //         _SplashScreenBloc.availableBiometrics;
                //   }
                // });
              }
              if (state is BiometricAuthorized) {
                //TODO: USSING BLOC
                // setState(() {
                //   _isAuthenticated = _SplashScreenBloc.isAuthorized;
                //   if (_isAuthenticated) {
                //     if (SplashScreenBloc.notifyTxt == "") {
                //       _SplashScreenBloc.add(NavigateToHomeScreenEvent());
                //     } else if (SplashScreenBloc.notifyTxt == "notification") {
                //       _SplashScreenBloc.add(NavigateToNotificationEvent());
                //       SplashScreenBloc.notifyTxt = "";
                //     }
                //     // RouterService.appRouter.navigateTo(HomeScreenRoute.buildPath());
                //   }
                // });
              }
              if (state is BiometricAuthorizationFailed) {
                final snackBar = SnackBar(
                  duration: Duration(seconds: 100),
                  content: Text('Biometric authorization failed.'),
                  action: SnackBarAction(
                    label: 'retry',
                    onPressed: () {
                      //TODO: cHECK FOR oUT OF MEMORY ERROR
                      _SplashScreenBloc.add(LaunchBiometric());
                      // _globalKey.currentState.hideCurrentSnackBar();
                    },
                  ),
                );
                _globalKey.currentState.showSnackBar(snackBar);
              }
            },
            child: _buildSplashWidget(),
          ),
        ),
      ),
    );
  }

  Widget _buildSplashWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: AppColors.white,
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Positioned(
            top: SizeConfig.heightMultiplier * 0.0,
            child: Image.asset(
              'assets/images/forgot_pass_top.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: _bottomPageDesign(),
          ),
          Positioned(
            top: MediaQuery.of(context).size.width * 0.5,
            left: MediaQuery.of(context).size.width * 0.28,
            child: Image.asset(
              'assets/images/mkt_space_logo.png',
              height: MediaQuery.of(context).size.width * 0.45,
              width: MediaQuery.of(context).size.width * 0.45,
            ),
          ),
          // Positioned(
          //     top: MediaQuery.of(context).size.width * 0.8,
          //     left: MediaQuery.of(context).size.width * 0.45,
          //     child: LoadingProgress(
          //       color: AppColors.app_orange,
          //     )),
        ],
      ),
    );
  }

  Widget _bottomPageDesign() {
    return Stack(
      children: [
        Image.asset(
          'assets/images/login_bottom_blue.png',
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * -4.861111111111111,
          top: SizeConfig.heightMultiplier * 15.064562410329986,
          child: Image.asset(
            'assets/images/cld_image.png',
            width: SizeConfig.widthMultiplier * 19.444444444444443,
            height: SizeConfig.heightMultiplier * 10.043041606886657,
          ),
        ),
        Positioned(
          right: SizeConfig.widthMultiplier * 0.0,
          top: SizeConfig.heightMultiplier * 21.969153515064562,
          child: Image.asset(
            'assets/images/cloud_right.png',
            width: SizeConfig.widthMultiplier * 19.444444444444443,
            height: SizeConfig.heightMultiplier * 10.043041606886657,
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 29.166666666666664,
          top: SizeConfig.heightMultiplier * 13.809182209469155,
          child: Image.asset(
            'assets/images/rocket.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 29.166666666666664,
          top: SizeConfig.heightMultiplier * 13.809182209469155,
          child: Image.asset(
            'assets/images/rocket_shade.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 0.0,
          top: SizeConfig.heightMultiplier * 19.4583931133429,
          child: Image.asset(
            'assets/images/rocket_dust1.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * -2.4305555555555554,
          top: SizeConfig.heightMultiplier * 19.4583931133429,
          child: Image.asset(
            'assets/images/rocket_dust.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 24.305555555555554,
          top: SizeConfig.heightMultiplier * 16.319942611190818,
          child: Image.asset(
            'assets/images/left_wing.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 24.305555555555554,
          top: SizeConfig.heightMultiplier * 16.319942611190818,
          child: Image.asset(
            'assets/images/left_wing_shade.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 32.08333333333333,
          top: SizeConfig.heightMultiplier * 19.4583931133429,
          child: Image.asset(
            'assets/images/right_wing.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 41.31944444444444,
          top: SizeConfig.heightMultiplier * 15.064562410329986,
          child: Image.asset(
            'assets/images/rocket_window.png',
          ),
        ),
      ],
    );
  }

  Future<void> _getDashboardData() async {
    // await dashboardRepo.dashboardProvider.getBannerImages();
    Constants.otpConfirmed = await _authRepository.getOtpConfirmed();
    if (Constants.country == null) {
      Constants.country = await _authRepository.getCountry() ?? "Australia";
    } else {
      Constants.country = "Australia";
    }
    // print('are we getting this far');

    // String currency = await _authRepository.getPrefferedCurrency();
    // if (currency == null) {
    //   await _authRepository.savePrefferedCurrency("AUD");
    //   await _authRepository.saveCryptoCurrency("BTC");
    // }
    // ProductsBloc.userCurrency = await _authRepository.getPrefferedCurrency();
    // var products = await _authRepository.getFavoriteProducts();
    // if (products != null && products.isNotEmpty && products != "[]") {
    //   // print('hit here3-1');
    //   List<dynamic> favlst = jsonDecode(products);
    //   // print('hit here3-2');
    //   DashboardScreenBloc.favProductList.clear();
    //   // print('hit here3-3');
    //   for (int i = 0; i < favlst.length; i++) {
    //     // print('hit here3-4-$i');
    //     FlashPromoAlgoliaObj fav = FlashPromoAlgoliaObj.fromJson(favlst[i]);
    //     // print('hit here3-4-$i-boolshit');
    //     DashboardScreenBloc.favProductList.add(fav);
    //   }
    // }
    // DashboardScreenBloc.productList.clear();
    // List<FlashPromoAlgoliaObj> productList = await dashboardRepo.dashboardProvider.getProducts(0, "", false, "","");
    // DashboardScreenBloc.productList.addAll(productList);

    List<FlashPromoAlgoliaObj> lst = await dashboardRepo.dashboardProvider
        .flashWithAlgolia(0, "", false, "", "");
    // print('did algolia complete?');
    // DashboardScreenBloc.flashList.clear();
    // DashboardScreenBloc.flashList.addAll(lst);

    Constants.aud = "0.0001";
    Constants.btc = "0.0002";

    context.read<FavouriteProductsBloc>().add(LoadFavouriteProducts());

    var cryptoValue = await dashboardRepo.getCryptoRate();

    Constants.aud = "60000";
    // cryptoValue.fiatRates.aud != null ? cryptoValue.fiatRates.aud : "1";
    // // print("AUD: ${Constants.aud}");
    Constants.btc = "70000";
    // cryptoValue.cryptoRates.btc != null
    //     ? cryptoValue.cryptoRates.btc
    //     : "0.000002";
    // print("BTC: ${Constants.btc}");

    //Todo: Call from own component
    // await dashboardRepo.getBanner();

    //TODO: Don't show flashlist of no flash item found

    RouterService.appRouter.navigateTo(HomeScreenRoute.buildPath());
    if (Constants.otpConfirmed == "true")
      RouterService.appRouter.navigateTo("/BiometricsAuth/0");
    else {
      if (FirebaseManager.instance.getUID() != null &&
          Constants.otpConfirmed != "true") {
        RouterService.appRouter.navigateTo(LogInRoute.buildPath());
      }
    }
  }
}
