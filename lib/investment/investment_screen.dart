import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/util/commonBlocs.dart';
import 'package:market_space/dashboard/banner_widget.dart';
import 'package:market_space/investment/logic/investment_bloc.dart';
import 'package:market_space/investment/wigets/badgeContent.dart';
import 'package:market_space/investment/wigets/cryptoCurrencyCard.dart';
import 'package:market_space/investment/wigets/fiatCard.dart';
import 'package:market_space/notification/routes/notification_route.dart';
import 'package:market_space/investment/network/wallet_provider.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/routServiceProvider.dart';

// to-do clean the code!
class InvestmentScreen extends StatefulWidget {
  @override
  _InvestmentScreenState createState() => _InvestmentScreenState();
}

class _InvestmentScreenState extends State<InvestmentScreen> {
  bool _isLoading = false;

  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);
  int slideIndex = 0;
  double _width = 0.0;
  Response response;

  // to-do delete this function when the whole thing is finished
  // Future<void> doit() async {
  //   WalletProvider provider = new WalletProvider();
  //   // print('zzzzz');
  //   await provider.getResponse();
  //   Response response = provider.response;
  //   // print('jijijijiji');
  //   // print(provider.response);
  //
  // }

  Future<void> refreshScreen() {
    investmentBloc.add(InvestmentEvent.InvestmentScreenEvent);
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  void initState() {
    // investmentBloc.add(InvestmentEvent.InvestmentScreenEvent);
    // doit();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.investment_back,
        centerTitle: false,
        title: Text(
          'MY WALLET',
          style: GoogleFonts.inter(
            fontSize: SizeConfig.textMultiplier * 1.6319942611190819,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
            textStyle: TextStyle(fontFamily: 'Montserrat'),
          ),
        ),
        // actions: [
        //   Container(
        //     margin: EdgeInsets.only(
        //         right: SizeConfig.widthMultiplier * 3.8888888888888884,
        //         top: SizeConfig.heightMultiplier * 1.129842180774749,
        //         bottom: SizeConfig.heightMultiplier * 1.129842180774749),
        //     child: InkWell(
        //       onTap: () {
        //         context.read<RouteServiceProvider>().type = NotificationType.order;
        //         RouterService.appRouter
        //             .navigateTo(NotificationRoute.buildPath());
        //       },
        //       child: BadgeContent(),
        //     ),
        //   )
        // ],
      ),
      body: CustomRefreshIndicator(
        onRefresh: refreshScreen,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.white,
          child: BlocProvider.value(
            value: investmentBloc,
            child: BlocListener<InvestmentBloc, InvestmentState>(
                listener: (context, state) {
                  if (state == InvestmentState.loading) {
                    setState(() {
                      _isLoading = true;
                    });
                  } else if (state == InvestmentState.reloadFail) {
                    setState(() {
                      _isLoading = false;
                      // _investmentBloc.add(InvestmentEvent.InvestmentScreenEvent);
                    });
                  } else {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                child: ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: [
                    _baseScreen(),
                    // _imageBanner(),
                    const BannerWidget(),
                    Container(
                      margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                        top: SizeConfig.heightMultiplier * 3.0129124820659974,
                      ),
                      child: Text(
                        'Assets',
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 2.887374461979914,
                            fontWeight: FontWeight.w900,
                            color: AppColors.app_txt_color),
                      ),
                    ),
                    Container(
                        child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.heightMultiplier *
                                    1.5064562410329987,
                                left: SizeConfig.widthMultiplier *
                                    3.8888888888888884,
                                bottom: SizeConfig.heightMultiplier *
                                    2.0086083213773316),
                            child: Builder(builder: (context) {
                              final state =
                                  context.watch<InvestmentBloc>().state;
                              if (state == InvestmentState.reloadSuccess) {
                                return Text(
                                  'Cryptocurrency',
                                  style: GoogleFonts.inter(
                                      fontSize: SizeConfig.textMultiplier *
                                          2.259684361549498,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.app_txt_color),
                                );
                              }
                              return Text(
                                'Cryptocurrencies',
                                style: GoogleFonts.inter(
                                    fontSize: SizeConfig.textMultiplier *
                                        2.259684361549498,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.app_txt_color),
                              );
                            })),
                        InkWell(
                          onTap: () {
                            _showCurrencyInfo();
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: SizeConfig.widthMultiplier *
                                    1.2152777777777777,
                                top: SizeConfig.heightMultiplier *
                                    1.5064562410329987,
                                bottom: SizeConfig.heightMultiplier *
                                    2.0086083213773316),
                            child: Image.asset(
                              'assets/images/info_icon.png',
                              width: SizeConfig.widthMultiplier *
                                  3.4027777777777772,
                              height: SizeConfig.heightMultiplier *
                                  1.757532281205165,
                              fit: BoxFit.fill,
                              color: AppColors.app_txt_color,
                            ),
                          ),
                        ),
                      ],
                    )),
                    UniversalCard(
                      color: AppColors.bitcoin_orange,
                      imageUri: 'assets/images/logos_bitcoin.png',
                      labelText: 'Bitcoin (BTC)',
                      // interestRate: '2.5',
                      type: CardType.BTC,
                    ),
                    UniversalCard(
                      color: AppColors.black,
                      imageUri: 'assets/images/ethereum_logo.png',
                      labelText: 'Ethereum (ETH)',
                      // interestRate: '3',
                      type: CardType.ETH,
                    ),
                    UniversalCard(
                      color: AppColors.toolbarBlue,
                      imageUri: 'assets/images/cryptocurrency_usdc.png',
                      labelText: 'USD Coin (USDC)',
                      // interestRate: '8',
                      type: CardType.USDC,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                        top: SizeConfig.heightMultiplier * 2.0086083213773316,
                      ),
                      child: Text(
                        'Fiat currencies',
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 2.259684361549498,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.15,
                            color: AppColors.app_txt_color),
                      ),
                    ),
                    FiatCard(
                      color: AppColors.appBlue,
                      imageUri: 'assets/images/aus_flag.png',
                      labelText: 'Australia dollars(AUD)',
                    ),
                    // FiatCard(
                    //   color: AppColors.cancel_red,
                    //   imageUri: 'assets/images/china_flag.png',
                    //   labelText: 'Chinese Yuan(CNY)',
                    // ),
                    Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 3.8888888888888884,
                          right:
                              SizeConfig.widthMultiplier * 3.8888888888888884,
                          top: SizeConfig.heightMultiplier * 3.0129124820659974,
                          bottom:
                              SizeConfig.heightMultiplier * 6.276901004304161),
                      height: SizeConfig.heightMultiplier * 6.025824964131995,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.catTextColor),
                      ),
                      child: Center(
                        child: Text(
                          'HELP CENTER',
                          style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w700,
                            color: AppColors.catTextColor,
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ),
        builder: (
          BuildContext context,
          Widget child,
          IndicatorController controller,
        ) {
          return child;
        },
      ),
    );
  }

  Widget _baseScreen() {
    return Container(
      color: AppColors.white,
      child: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          children: [
            if (_isLoading)
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.3),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                    child: Lottie.network(
                      'https://assets3.lottiefiles.com/packages/lf20_FVqg63.json',
                      width: SizeConfig.widthMultiplier * 12.152777777777777,
                      height: SizeConfig.heightMultiplier * 6.276901004304161,
                      animate: true,
                    ),
                  )),
            _amountCard(),
          ],
        ),
      ),
    );
  }

  Widget _amountCard() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.16,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        AppColors.investment_start,
        AppColors.investment_end,
      ])),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: height * 0.12,
              width: width * 0.43,
              decoration: BoxDecoration(
                color: Color.fromRGBO(213, 213, 213, 0.1),
              ),
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  top: SizeConfig.heightMultiplier * 3.0129124820659974,
                  bottom: SizeConfig.heightMultiplier * 3.0129124820659974),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            // top: SizeConfig.heightMultiplier * 1.5064562410329987,
                            ),
                        child: Text(
                          'AMOUNT IN WALLET',
                          style: GoogleFonts.inter(
                              fontSize: SizeConfig.textMultiplier *
                                  1.2553802008608321,
                              fontWeight: FontWeight.w400,
                              color: AppColors.list_separator2),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 1.2152777777777777,
                          // top: SizeConfig.heightMultiplier * 1.5064562410329987,
                        ),
                        child: SvgPicture.asset(
                          'assets/images/purse.svg',
                          width:
                              SizeConfig.widthMultiplier * 2.4305555555555554,
                          height:
                              SizeConfig.heightMultiplier * 1.2553802008608321,
                          fit: BoxFit.fill,
                          color: AppColors.list_separator2,
                        ),
                      ),
                    ],
                  )),
                  Container(
                    margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 0.6276901004304161,
                    ),
                    child: Builder(builder: (context) {
                      final state = investmentBloc.state;
                      if (state == InvestmentState.reloadSuccess) {
                        return Text(
                          '\$${investmentBloc.walletRepository.wallet.totalAmount.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                              fontSize:
                                  SizeConfig.textMultiplier * 2.259684361549498,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.15,
                              color: AppColors.white),
                        );
                      }
                      return Text(
                        'Loading...',
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 2.259684361549498,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.15,
                            color: AppColors.white),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Container(
              height: height * 0.12,
              width: width * 0.43,
              decoration: BoxDecoration(
                color: Color.fromRGBO(213, 213, 213, 0.1),
              ),
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  top: SizeConfig.heightMultiplier * 3.0129124820659974,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                  bottom: SizeConfig.heightMultiplier * 3.0129124820659974),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            // top: SizeConfig.heightMultiplier * 1.5064562410329987,
                            ),
                        child: Text(
                          'TOTAL EARNED',
                          style: GoogleFonts.inter(
                              fontSize: SizeConfig.textMultiplier *
                                  1.2553802008608321,
                              fontWeight: FontWeight.w400,
                              color: AppColors.list_separator2),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 1.2152777777777777,
                          // top: SizeConfig.heightMultiplier * 1.5064562410329987,
                        ),
                        child: Image.asset(
                          'assets/images/money_bill.png',
                          width:
                              SizeConfig.widthMultiplier * 2.4305555555555554,
                          height:
                              SizeConfig.heightMultiplier * 1.2553802008608321,
                          fit: BoxFit.fill,
                          color: AppColors.list_separator2,
                        ),
                      ),
                    ],
                  )),
                  Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.heightMultiplier * 0.6276901004304161),
                    child: Builder(builder: (context) {
                      final state = investmentBloc.state;
                      if (state == InvestmentState.reloadSuccess) {
                        return Text(
                          '\$${investmentBloc.walletRepository.wallet.interestEarnings.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                              fontSize:
                                  SizeConfig.textMultiplier * 2.259684361549498,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.15,
                              color: AppColors.white),
                        );
                      }
                      return Text(
                        'Loading...',
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 2.259684361549498,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.15,
                            color: AppColors.white),
                      );
                    }),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(
                  //     top: SizeConfig.heightMultiplier * 0.6276901004304161,
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Container(
                  //         height: SizeConfig.heightMultiplier * 1.0043041606886658,
                  //         width: SizeConfig.widthMultiplier * 1.9444444444444442,
                  //         decoration: BoxDecoration(
                  //             color: Colors.green, shape: BoxShape.circle),
                  //       ),
                  //       // Container(
                  //       //   margin: EdgeInsets.only(
                  //       //     left: SizeConfig.widthMultiplier * 1.2152777777777777,
                  //       //   ),
                  //       //   child: Text(
                  //       //     '+11% in last 42 WEEKS ',
                  //       //     style: GoogleFonts.inter(
                  //       //         fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                  //       //         fontWeight: FontWeight.w400,
                  //       //         color: Colors.green),
                  //       //   ),
                  //       // ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog to show currency info
  _showCurrencyInfo() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return Material(
            type: MaterialType.transparency,
            child: AbsorbPointer(
                absorbing: false,
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                    child: Center(
                      child: Container(
                        height: SizeConfig.heightMultiplier * 40,
                        width: _width * 0.9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.appBlue),
                        child: Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.heightMultiplier *
                                  1.2553802008608321),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              color: AppColors.white),
                          child: Stack(
                            children: [
                              Positioned(
                                top: SizeConfig.heightMultiplier *
                                    1.2553802008608321,
                                right: SizeConfig.widthMultiplier *
                                    3.8888888888888884,
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                        child: Icon(
                                      Icons.cancel_outlined,
                                      size: 30,
                                      color: AppColors.app_orange,
                                    ))),
                              ),
                              Positioned(
                                  top: SizeConfig.heightMultiplier *
                                      7.532281205164993,
                                  left: SizeConfig.widthMultiplier *
                                      3.8888888888888884,
                                  child: Container(
                                    width: _width * 0.8,
                                    child: Text(
                                      'Cryptocurrency Assets',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: SizeConfig.textMultiplier *
                                              2.259684361549498,
                                          letterSpacing: 0.15),
                                    ),
                                  )),
                              Positioned(
                                  top: SizeConfig.heightMultiplier *
                                      13.809182209469155,
                                  left: SizeConfig.widthMultiplier *
                                      3.8888888888888884,
                                  child: Container(
                                    width: _width * 0.8,
                                    child: Text(
                                      'Market Spaace allows our users to buy, store, and send crypto funds within our platform, just like your own crypto bank account!\n\nStoring cryptocurrency on our platform also gives you an interest payout.The Annual Percentage Yield (APY) rate for each asset, is shown below each token. Interest is accrued daily and paid out on the first day of each month.',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: SizeConfig.textMultiplier *
                                              1.757532281205165,
                                          letterSpacing: 0.25),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ))),
          );
        });
  }
}
