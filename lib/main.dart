import 'dart:async';
import 'package:algolia/algolia.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:market_space/authScreen/authApi.dart';
import 'package:market_space/authScreen/authRoute.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/apis/smsAuthApi.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/util/creditCardHelper.dart';
import 'package:market_space/logics/rate_bloc/rate_bloc.dart';
import 'package:market_space/notification/logics/blocs/notification_bloc.dart';
import 'package:market_space/notification_util/notification_util.dart';
import 'package:market_space/profile/logics/orderProvider.dart';
import 'package:market_space/providers/localDatabaseHelper.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/services/locator.dart';
import 'package:market_space/services/routServiceProvider.dart';
import 'package:market_space/services/userDetailService/UserService.dart';
import 'package:market_space/services/userDetailService/userDetail.dart';
import 'package:market_space/simple_bloc_observer.dart';
import 'package:market_space/splash/splash_screen.dart';
import 'package:market_space/theme_cubit.dart';
import 'package:provider/provider.dart';

import 'apis/firebaseManager.dart';
import 'authScreen/logic/password_cubit.dart';
import 'authScreen/screens/OtpScreen.dart';
import 'common/mixins/test_cubit.dart';
import 'dashboard/Categories/categories/categories_bloc.dart';
import 'dashboard/Categories/sub_categories/sub_categories_bloc.dart';
import 'dashboard/banners/banners_bloc.dart';
import 'dashboard/dashboard_filters/dashboard_filter_bloc.dart';
import 'dashboard/flash/flash_bloc.dart';
import 'dashboard/products/fav_products/favourite_products_bloc.dart';
import 'dashboard/products/products_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  // var initializationSettingsAndriod = AndroidInitializationSettings('defaultIcon');
  testProcess();
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      onDidReceiveLocalNotification:
          ((int id, String title, String body, String payload) async {}));

  var initiwalizationSettings =
      InitializationSettings(iOS: initializationSettingsIOS);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  RouterService.init();
  setUpLocator();
  NotificationBloc notifiBloc = new NotificationBloc(Initial());

  notifiBloc.add(NotificationScreenEvent());
  RateBloc rate = new RateBloc(notifiBloc);
  rate.add(RateEvent.doit);
  FirebaseManager.instance.signIn();
  LocalDataBaseHelper().initializeDatabase();

  runZonedGuarded(() async {
    runApp(App(
      notifiBloc: notifiBloc,
      rate: rate,
    )); // starting point of app
  }, (error, stackTrace) {
    print("Error FROM OUT_SIDE FRAMEWORK ");
    print("--------------------------------");
    print("Error :  $error");
    print("StackTrace :  $stackTrace");
  });

  // runApp(App(notifiBloc: notifiBloc, rate: rate,));
}

class White extends StatefulWidget {
  static bool isPushed = false;
  String id;
  bool isSetting;

  White(param) {
    print(id);
    this.id = param;
    if (this.id == '0') {
      isSetting = false;
    } else {
      isSetting = true;
    }
  }

  @override
  _WhiteState createState() => _WhiteState();
}

class _WhiteState extends State<White> {
  TextEditingController _c = TextEditingController();
  String id;
  String _text;
  SmsAuthApi smsApi = SmsAuthApi();
  @override
  void initState() {
    // TODO: implement initState
    print("I am the id");
    print(widget.id);
  }

  void getId(String id) {
    this.id = id;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PasswordCubit(false), child: OtpScreen());
    // Container(child: Scaffold(
    //     backgroundColor: AppColors.white,
    //     body:  new Column(
    //       children: <Widget>[
    //         new TextField(
    //           decoration: new InputDecoration(hintText: "Update Info"),
    //           controller: _c,
    //
    //         ),
    //         new FlatButton(
    //           child: new Text("Save"),
    //           onPressed: (){
    //             setState((){
    //               this._text = _c.text;
    //               // Navigator.pop(context);
    //             });
    //
    //           },
    //
    //         ),
    //         new FlatButton(
    //           child: new Text("send"),
    //           onPressed: (){
    //             setState((){
    //               this._text = _c.text;
    //               SmsAuthApi.sendSms((verificationId) => getId(verificationId),"+61 403 208 238");
    //               Navigator.pop(context);
    //             });
    //
    //           },
    //
    //         ),
    //         new FlatButton(
    //           child: new Text("auth"),
    //           onPressed: (){
    //             setState((){
    //               this._text = _c.text;
    //               smsApi.auth("123456", this.id);
    //             });
    //
    //           },
    //
    //         ),
    //
    //       ],
    //     ),
    //     // body: GestureDetector(
    //     //   onTap:() async{
    //     //     bool result = await LocalAuthApi.authenticate();
    //     //
    //     //     if(result){
    //     //       White.isPushed = false;
    //     //       Navigator.pop(context);
    //     //     }
    //     //   },
    //     //   child: Center(child: new Text("Auth with biometric!")
    //     //   ),
    //     // )
    // ));
  }
}

class App extends StatelessWidget {
  final notificationUtil = locator<NotificationUtil>();
  final NotificationBloc notifiBloc;
  final RateBloc rate;

  App({Key key, this.notifiBloc, this.rate}) : super(key: key) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    notificationUtil.initFirebase();
    notificationUtil.requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
    notificationUtil.initializeFCM(context);

    // imageCache.clear();

    // SystemChrome.setEnabledSystemUIOverlays([]);

    return FGBGNotifier(
      onEvent: (event) async {
        // print(event.toString());
        if (event == FGBGType.foreground) {
          await Future.delayed(Duration(milliseconds: 500));

          // print("hahaha");
          if (FirebaseManager.instance.getUID() != null) {
            RouterService.appRouter.navigateTo("/BiometricsAuth/0");
          }
          // ProductLandingRoute.productNum = 110;
          // ProductLandingRoute.productName = "model.productName";
          // ProductLandingRoute.isProductLiked = true;
          // RouterService.appRouter.navigateTo(ProductLandingRoute.buildPath());
        }
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => OrderProvider()),
          ChangeNotifierProvider(create: (_) => RouteServiceProvider()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
            BlocProvider<RateBloc>(create: (_) => rate),
            BlocProvider<NotificationBloc>(create: (_) => notifiBloc),
            BlocProvider<WrongInputCubit>(create: (_) => WrongInputCubit()),
            BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
            BlocProvider<RateBloc>(create: (_) => rate),
            BlocProvider<NotificationBloc>(create: (_) => notifiBloc),
            BlocProvider<FlashBloc>(create: (_) => FlashBloc()),
            BlocProvider<FavouriteProductsBloc>(
                create: (_) => FavouriteProductsBloc()),
            BlocProvider<CategoriesBloc>(create: (_) => CategoriesBloc()),
            BlocProvider<ProductsBloc>(
                create: (_) =>
                    ProductsBloc()..add(LoadListEvent(category: ''))),
            BlocProvider<SubCategoriesBloc>(create: (_) => SubCategoriesBloc()),
            BlocProvider<BannersBloc>(create: (_) => BannersBloc()),
            BlocProvider<DashboardFilterBloc>(
                create: (_) => DashboardFilterBloc()),
          ],
          child: BlocBuilder<ThemeCubit, ThemeData>(
            builder: (_, theme) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return OrientationBuilder(
                    builder: (context, orientation) {
                      SizeConfig().init(constraints, orientation);
                      return MaterialApp(
                          navigatorKey: RouterService.appNavigatorKey,
                          onGenerateRoute: RouterService.appRouter.generator,
                          debugShowCheckedModeBanner: false,
                          theme: theme,
                          home: SplashScreen());
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<void> testProcess() async {
  print("testing processs again....");
  // UserDetail detail  = await UserService().getUser("V6J8t9PrLbZ1eGHZ3B6TO45LwCM2");
}

class Application {
  static final Algolia algolia = Algolia.init(
    applicationId: Constants.algolia_Id,
    apiKey: Constants.algolia_key_search,
  );
}
