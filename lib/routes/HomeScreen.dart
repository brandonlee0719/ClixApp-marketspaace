import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/active_products/active_product_state.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/fab_bottom_app_bar_item.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/dashboard/dashboard_bloc.dart';
import 'package:market_space/dashboard/dashboard_events.dart';
import 'package:market_space/dashboard/dashboard_route.dart';
import 'package:market_space/dashboard/dashboard_screen.dart';
import 'package:market_space/investment/buy_assets/buy_assets_route.dart';
import 'package:market_space/investment/investment_route.dart';
import 'package:market_space/investment/sell_assets/sell_asset_route.dart';
import 'package:market_space/investment_top_up/investment_top_up_route.dart';
import 'package:market_space/messages/messages_route.dart';
import 'package:market_space/notification_util/notification_util.dart';
import 'package:market_space/profile/profile_route.dart';
import 'package:market_space/routes/HomeScreenRoute.dart';
import 'package:market_space/routes/home_l10n.dart';
import 'package:market_space/routes/route.dart';
import 'package:market_space/sell_new_products/sell_new_products_route.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/services/locator.dart';
import 'package:market_space/services/routServiceProvider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  static const int PROFILE_INDEX = 4;
  static const int HOME_INDEX = 0;
  static const int MESSAGE_INDEX = 1;
  static const int WALLET_INDEX = 3;

  static final Map<int, GlobalKey<NavigatorState>> _buyerNavigatorKeys = {
    HOME_INDEX: RouterService.homeNavigatorKey,
    PROFILE_INDEX: RouterService.profileNavigatorKey,
    MESSAGE_INDEX: RouterService.messagesNavigatorKey,
    WALLET_INDEX: RouterService.walletNavigatorKey,
  };

  static final Map<int, ARoute> _homeRouter = {
    HOME_INDEX: DashboardRoute(),
    PROFILE_INDEX: ProfileRoute(),
    MESSAGE_INDEX: MessageRoute(),
    WALLET_INDEX: InvestmentRoute(),
  };
  static final Map<int, RouterService> _homeRouters = {
    HOME_INDEX: RouterService.homeRouter,
    PROFILE_INDEX: RouterService.profileRouter,
    MESSAGE_INDEX: RouterService.messagesRouter,
    WALLET_INDEX: RouterService.walletRouter,
  };

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  var _currentBottomNavIndex = HomeScreen.HOME_INDEX;
  String _selectedItem;
  int _selectedTab = 0;
  bool _searchClicked = false;
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  List<String> _dropdownItems = ["Categories"];
  double toolbarHeight = kToolbarHeight;
  bool _loading = true;
  TabController _tabController;
  bool _homeSelected = true,
      _chatSelected = false,
      _profileSelected = false,
      _investmentSelected = false;

  final _globalKey = GlobalKey<ScaffoldState>();
  HomeL10n _l10n = HomeL10n(Locale.fromSubtags(languageCode: 'zh'));

  final NotificationUtil notificationUtil = locator<NotificationUtil>();

  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, length: 5, vsync: this);
    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n =
            HomeL10n(Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n = HomeL10n(Locale.fromSubtags(languageCode: 'zh'));
      }
    });

    // _handelStartUps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.light));

    return Scaffold(
      key: _globalKey,
      backgroundColor: AppColors.toolbarBlue,
      bottomNavigationBar: Material(
        color: Colors.white,
        elevation: 10,
        child: BottomAppBar(
          notchMargin: 8,
          color: _investmentSelected ? AppColors.white : AppColors.white,
          shape: CircularNotchedRectangle(),
          child: Container(
            // height: 42,
            child: TabBar(
              tabs: [
                Tab(
                  child: Container(
                      margin:
                          EdgeInsets.only(left: 2, right: 2, top: 7, bottom: 1),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/images/home.svg',
                            width: 26,
                            height: 26,
                            color: _homeSelected
                                ? AppColors.toolbarBlue
                                : AppColors.unselected_tab,
                          ),
                          Text(
                            _l10n.home,
                            style: GoogleFonts.inter(
                                color: AppColors.unselected_tab,
                                fontSize: 10,
                                fontWeight: _homeSelected
                                    ? FontWeight.w400
                                    : FontWeight.w200),
                          )
                        ],
                      )),
                ),
                Tab(
                    child: Container(
                        margin: EdgeInsets.only(
                            left: 2, right: 2, top: 7, bottom: 1),
                        child: Column(children: [
                          SvgPicture.asset(
                            'assets/images/chat.svg',
                            width: 26,
                            height: 26,
                            color: _chatSelected
                                ? AppColors.toolbarBlue
                                : AppColors.unselected_tab,
                          ),
                          Text(
                            _l10n.messages,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: GoogleFonts.inter(
                                color: AppColors.unselected_tab,
                                fontSize: 10,
                                fontWeight: _chatSelected
                                    ? FontWeight.w400
                                    : FontWeight.w200),
                          )
                        ]))),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                ),
                Tab(
                    child: Container(
                        margin: EdgeInsets.only(
                            left: 2, right: 2, top: 7, bottom: 1),
                        child: Column(children: [
                          SvgPicture.asset(
                            'assets/images/purse.svg',
                            width: 26,
                            height: 26,
                            color: _investmentSelected
                                ? AppColors.toolbarBlue
                                : AppColors.unselected_tab,
                          ),
                          Text(
                            _l10n.wallet,
                            style: GoogleFonts.inter(
                                color: AppColors.unselected_tab,
                                fontSize: 10,
                                fontWeight: _investmentSelected
                                    ? FontWeight.w400
                                    : FontWeight.w200),
                          )
                        ]))),
                Tab(
                    child: Container(
                        margin: EdgeInsets.only(
                            left: 2, right: 2, top: 7, bottom: 1),
                        child: Column(children: [
                          SvgPicture.asset(
                            'assets/images/profile.svg',
                            width: 26,
                            height: 26,
                            color: _profileSelected
                                ? AppColors.toolbarBlue
                                : AppColors.unselected_tab,
                          ),
                          Text(
                            _l10n.profile,
                            style: GoogleFonts.inter(
                                color: AppColors.unselected_tab,
                                fontSize: 10,
                                fontWeight: _profileSelected
                                    ? FontWeight.w400
                                    : FontWeight.w200),
                          )
                        ])))
              ],
              labelStyle: TextStyle(fontSize: 10),
              labelColor: AppColors.toolbarBlue,
              unselectedLabelColor: AppColors.white,
              isScrollable: true,
              controller: _tabController,
              indicator: UnderlineTabIndicator(
                  insets: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  borderSide: BorderSide(width: 2, color: Colors.transparent)),
              onTap: (index) {
                setState(() {
                  _selectedTab = index;
                  if (_selectedTab == 4) {
                    _onTapBottomNav(4);
                    _homeSelected = false;
                    _investmentSelected = false;
                    _chatSelected = false;
                    _profileSelected = true;
                  }
                  if (_selectedTab == 0) {
                    _homeSelected = true;
                    _investmentSelected = false;
                    _chatSelected = false;
                    _profileSelected = false;
                    _onTapBottomNav(0);
                  }
                  if (_selectedTab == 1) {
                    _homeSelected = false;
                    _investmentSelected = false;
                    _chatSelected = true;
                    _profileSelected = false;
                    _onTapBottomNav(1);
                  }
                  if (_selectedTab == 3) {
                    _homeSelected = false;
                    _investmentSelected = true;
                    _chatSelected = false;
                    _profileSelected = false;
                    _onTapBottomNav(3);
                    White.isPushed = true;
                    // print("hahaha");
                    RouterService.appRouter.navigateTo('/BiometricsAuth/0');
                  }
                });
              },
            ),
          ),
        ),
      ),
      // ),
      // _bottomNavigation(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_investmentSelected) {
            _showOptionsSheet();
            // RouterService.appRouter.navigateTo(
            //     BuyAssetsRoute.buildPath());
          } else {
            // RouterService.appRouter
            //     .navigateTo(SellNewProductsRoute.buildPath());
            // print('clicked here');
            RouterService.appRouter.navigateTo(SellerSellingRoute.buildPath());
          }
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [
                AppColors.gradient_button_light,
                AppColors.gradient_button_dark,
              ])),
          child: _investmentSelected
              ? Image.asset('assets/images/exchange_icon.png')
              : Icon(Icons.add),
        ),
        elevation: 2.0,
      ),
      body: Stack(children: <Widget>[
        _buildOffstageNavigator(HomeScreen.HOME_INDEX),
        _buildOffstageNavigator(HomeScreen.PROFILE_INDEX),
        _buildOffstageNavigator(HomeScreen.MESSAGE_INDEX),
        _buildOffstageNavigator(HomeScreen.WALLET_INDEX),
      ]),
    );
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _currentBottomNavIndex != index,
      child: Navigator(
        key: HomeScreen._buyerNavigatorKeys[index],
        onGenerateRoute: HomeScreen._homeRouters[index].generator,
        initialRoute: HomeScreen._homeRouter[index].path,
        observers: [HeroController()],
      ),
    );
  }

  _onTapBottomNav(int position) {
    if (_currentBottomNavIndex != position) {
      setState(() {
        _currentBottomNavIndex = position;
      });
    }
  }

  void _showOptionsSheet() {
    double width = MediaQuery.of(context).size.width;
    showMaterialModalBottomSheet(
        context: context,
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              controller: ModalScrollController.of(context),
              child: Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () {
                            // context.read<RouteServiceProvider>().transferRoute =
                            //     CryptoRouteType.buy;

                            // RouterService.appRouter
                            //     .navigateTo(SellAssetRoute.buildPath());
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
                            child: Row(
                              children: [
                                Container(
                                  child: Image.asset(
                                    'assets/images/add_circle_icon.png',
                                    fit: BoxFit.contain,
                                    height: 28,
                                    width: 28,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          'Buy',
                                          style: GoogleFonts.inter(
                                              color: AppColors.app_txt_color,
                                              letterSpacing: 0.1,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14),
                                        ),
                                      ),
                                      Container(
                                        width: width * 0.8,
                                        child: Text(
                                          'Coming soon',
                                          style: GoogleFonts.inter(
                                              color: AppColors
                                                  .text_field_container,
                                              letterSpacing: 0.4,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                      GestureDetector(
                          onTap: () {
                            // RouterService.appRouter.navigateTo(
                            //     SellAssetRoute.buildPath() + "?isSell=true");
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
                            child: Row(
                              children: [
                                Container(
                                  child: Image.asset(
                                    'assets/images/minus_circle.png',
                                    fit: BoxFit.contain,
                                    height: 28,
                                    width: 28,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          'Sell',
                                          style: GoogleFonts.inter(
                                              color: AppColors.app_txt_color,
                                              letterSpacing: 0.1,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14),
                                        ),
                                      ),
                                      Container(
                                        width: width * 0.8,
                                        child: Text(
                                          'Coming soon',
                                          style: GoogleFonts.inter(
                                              color: AppColors
                                                  .text_field_container,
                                              letterSpacing: 0.4,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                      GestureDetector(
                        onTap: () {
                          // RouterService.appRouter.navigateTo(
                          //     SellAssetRoute.buildPath() + "?isConvert=true");
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
                          child: Row(
                            children: [
                              Container(
                                child: Image.asset(
                                  'assets/images/convert_icon.png',
                                  fit: BoxFit.contain,
                                  height: 28,
                                  width: 28,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Convert',
                                        style: GoogleFonts.inter(
                                            color: AppColors.app_txt_color,
                                            letterSpacing: 0.1,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      ),
                                    ),
                                    Container(
                                      width: width * 0.8,
                                      child: Text(
                                        'Coming soon',
                                        style: GoogleFonts.inter(
                                            color:
                                                AppColors.text_field_container,
                                            letterSpacing: 0.4,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          RouterService.appRouter.navigateTo(
                              SellAssetRoute.buildPath() + "?withDraw=true");
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
                          child: Row(
                            children: [
                              Container(
                                child: Image.asset(
                                  'assets/images/send_icon.png',
                                  fit: BoxFit.contain,
                                  height: 28,
                                  width: 28,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Send',
                                        style: GoogleFonts.inter(
                                            color: AppColors.app_txt_color,
                                            letterSpacing: 0.1,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      ),
                                    ),
                                    Container(
                                      width: width * 0.8,
                                      child: Text(
                                        'Send cryptos to an external wallet',
                                        style: GoogleFonts.inter(
                                            color:
                                                AppColors.text_field_container,
                                            letterSpacing: 0.4,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
                        child: Row(
                          children: [
                            Container(
                              child: Image.asset(
                                'assets/images/receive_icon.png',
                                fit: BoxFit.contain,
                                height: 28,
                                width: 28,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                RouterService.appRouter.navigateTo(
                                    SellAssetRoute.buildPath() +
                                        "?isReceive=true");
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Receive',
                                        style: GoogleFonts.inter(
                                            color: AppColors.app_txt_color,
                                            letterSpacing: 0.1,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      ),
                                    ),
                                    Container(
                                      width: width * 0.8,
                                      child: Text(
                                        'Receive cryptocurrency from your external wallet',
                                        style: GoogleFonts.inter(
                                            color:
                                                AppColors.text_field_container,
                                            letterSpacing: 0.4,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            );
          });
        });
  }
}
