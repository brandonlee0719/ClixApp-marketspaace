import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/investment/sell_assets/sell_asset_route.dart';
import 'package:market_space/notification/routes/notification_route.dart';
import 'package:market_space/profile_settings/receiving_payment/receiving_payment_route.dart';
import 'package:market_space/profile_settings/seller_sending_payments/add_new_sending_payment/add_new_sending_route.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/responsive_layout/size_config.dart';

import 'buy_assets_bloc.dart';

class BuyAssetsScreen extends StatefulWidget {
  @override
  _BuyAssetsScreenState createState() => _BuyAssetsScreenState();
}

class _BuyAssetsScreenState extends State<BuyAssetsScreen> {
  bool _isLoading = false;
  final BuyAssetsBloc _buyAssetsBloc = BuyAssetsBloc(Initial());
  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);
  int slideIndex = 0;
  String _bitcoinValue = "0";
  String _bitLimit = "3000";

  @override
  void initState() {
    _buyAssetsBloc.add(BuyAssetsScreenEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _toolbar(),
      backgroundColor: AppColors.appBlue,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.white,
        child: BlocProvider(
          create: (_) => _buyAssetsBloc,
          child: BlocListener<BuyAssetsBloc, BuyAssetsState>(
              listener: (context, state) {
                if (state is Loading) {
                  setState(() {
                    _isLoading = true;
                  });
                }
                if (state is Loaded) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  // _buyBitcoinUI(),
                  _baseScreen(),
                ],
              )),
        ),
      ),
    );
  }

  Widget _baseScreen() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 2.0086083213773316,
                bottom: SizeConfig.heightMultiplier * 2.0086083213773316),
            child: Text(
              'Select asset to buy',
              style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                  color: AppColors.app_txt_color),
            ),
          ),
          _bitcoinCard(),
          _ethereumCard(),
          _USDCCard(),
        ],
      ),
    );
  }

  Widget _toolbar() {
    return PreferredSize(
        child: SafeArea(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: kToolbarHeight,
              // margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 4.770444763271162),
              color: AppColors.appBlue,
              child: Row(
                children: [
                  Container(
                    child: Container(
                      // width: SizeConfig.widthMultiplier * 60.27777777777777,
                      height: kToolbarHeight,
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: SizeConfig.widthMultiplier *
                                        2.4305555555555554),
                                child: SvgPicture.asset(
                                  'assets/images/Back_button.svg',
                                  width: SizeConfig.widthMultiplier *
                                      5.833333333333333,
                                  height: SizeConfig.heightMultiplier *
                                      3.0129124820659974,
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: SizeConfig.widthMultiplier *
                                      2.4305555555555554),
                              child: Text(
                                'MY WALLET',
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontFamily: 'inter',
                                    fontStyle: FontStyle.normal,
                                    fontSize: SizeConfig.textMultiplier *
                                        2.0086083213773316,
                                    fontWeight: FontWeight.w300),
                              )),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 2.9166666666666665,
                        top: SizeConfig.heightMultiplier * 1.5064562410329987,
                        right: SizeConfig.widthMultiplier * 2.9166666666666665,
                        bottom:
                            SizeConfig.heightMultiplier * 1.0043041606886658),
                    child: InkWell(
                        onTap: () {
                          RouterService.appRouter
                              .navigateTo(NotificationRoute.buildPath());
                        },
                        child: Badge(
                          badgeContent: Text(
                            '12',
                            style: GoogleFonts.inter(
                                color: AppColors.white,
                                fontSize: SizeConfig.textMultiplier *
                                    1.3809182209469155),
                          ),
                          badgeColor: AppColors.gradient_button_light,
                          child: SvgPicture.asset(
                            'assets/images/la_bell.svg',
                            height: SizeConfig.heightMultiplier *
                                3.0129124820659974,
                            width:
                                SizeConfig.widthMultiplier * 5.833333333333333,
                            color: AppColors.white,
                          ),
                        )),
                  ),
                ],
              )),
        ),
        preferredSize: Size.fromHeight(
            SizeConfig.heightMultiplier * 16.571018651362985704000955107872));
  }

  Widget _bitcoinCard() {
    return GestureDetector(
      onTap: () => {
        RouterService.appRouter.navigateTo(SellAssetRoute.buildPath()),
      },
      child: Card(
        color: AppColors.bitcoin_orange,
        margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
        ),
        child: Container(
          height: SizeConfig.heightMultiplier * 7.40674318507891,
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 0.9722222222222221),
          color: AppColors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 2.9166666666666665,
                      top: SizeConfig.heightMultiplier * 2.0086083213773316,
                      bottom: SizeConfig.heightMultiplier * 2.259684361549498,
                      right: SizeConfig.widthMultiplier * 2.9166666666666665),
                  child: Image.asset(
                    'assets/images/logos_bitcoin.png',
                    height: SizeConfig.heightMultiplier * 3.0129124820659974,
                    width: SizeConfig.widthMultiplier * 5.833333333333333,
                  )),
              Container(
                child: Text(
                  'Bitcoin (BTC)',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                  ),
                ),
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 2.9166666666666665,
                        top: SizeConfig.heightMultiplier * 2.0086083213773316,
                        right: SizeConfig.widthMultiplier * 2.9166666666666665),
                    child: Text(
                      'A\$60,609.42',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 2.9166666666666665,
                        right: SizeConfig.widthMultiplier * 2.9166666666666665),
                    child: Text(
                      '-1.23%',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize:
                              SizeConfig.textMultiplier * 1.5064562410329987,
                          color: AppColors.red_text,
                          letterSpacing: 0.4),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _ethereumCard() {
    return Card(
      color: AppColors.black,
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 1.5064562410329987),
      child: Container(
        height: SizeConfig.heightMultiplier * 7.40674318507891,
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 0.9722222222222221),
        color: AppColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 2.9166666666666665,
                    top: SizeConfig.heightMultiplier * 2.0086083213773316,
                    bottom: SizeConfig.heightMultiplier * 2.259684361549498,
                    right: SizeConfig.widthMultiplier * 2.9166666666666665),
                // padding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 2.4305555555555554, right: SizeConfig.widthMultiplier * 2.4305555555555554),
                child: Image.asset(
                  'assets/images/ethereum_logo.png',
                  height: SizeConfig.heightMultiplier * 3.0129124820659974,
                  width: SizeConfig.widthMultiplier * 4.861111111111111,
                )),
            Container(
              child: Text(
                'Ethereum (ETH)',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                ),
              ),
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 2.9166666666666665,
                      top: SizeConfig.heightMultiplier * 2.0086083213773316,
                      right: SizeConfig.widthMultiplier * 2.9166666666666665),
                  child: Text(
                    'A\$60,609.42',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 2.9166666666666665,
                      right: SizeConfig.widthMultiplier * 2.9166666666666665),
                  child: Text(
                    '-1.23%',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize:
                            SizeConfig.textMultiplier * 1.5064562410329987,
                        color: AppColors.red_text,
                        letterSpacing: 0.4),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _USDCCard() {
    return Card(
      color: AppColors.toolbarBlue,
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 1.5064562410329987),
      child: Container(
        height: SizeConfig.heightMultiplier * 7.40674318507891,
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 0.9722222222222221),
        color: AppColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 2.9166666666666665,
                    top: SizeConfig.heightMultiplier * 2.0086083213773316,
                    bottom: SizeConfig.heightMultiplier * 2.259684361549498,
                    right: SizeConfig.widthMultiplier * 2.9166666666666665),
                child: Image.asset(
                  'assets/images/cryptocurrency_usdc.png',
                  height: SizeConfig.heightMultiplier * 3.0129124820659974,
                  width: SizeConfig.widthMultiplier * 5.833333333333333,
                )),
            Container(
              child: Text(
                'USD coin (USDC)',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                ),
              ),
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 2.9166666666666665,
                      top: SizeConfig.heightMultiplier * 2.0086083213773316,
                      right: SizeConfig.widthMultiplier * 2.9166666666666665),
                  child: Text(
                    'A\$60,609.42',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 2.9166666666666665,
                      right: SizeConfig.widthMultiplier * 2.9166666666666665),
                  child: Text(
                    '-1.23%',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize:
                            SizeConfig.textMultiplier * 1.5064562410329987,
                        color: AppColors.red_text,
                        letterSpacing: 0.4),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _ausDollarCard() {
    return Card(
      color: AppColors.appBlue,
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 1.5064562410329987),
      child: Container(
        height: SizeConfig.heightMultiplier * 7.40674318507891,
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 0.9722222222222221),
        color: AppColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 2.9166666666666665,
                    top: SizeConfig.heightMultiplier * 2.0086083213773316,
                    bottom: SizeConfig.heightMultiplier * 2.259684361549498,
                    right: SizeConfig.widthMultiplier * 2.9166666666666665),
                child: Image.asset(
                  'assets/images/aus_flag.png',
                  height: SizeConfig.heightMultiplier * 3.0129124820659974,
                  width: SizeConfig.widthMultiplier * 5.833333333333333,
                )),
            Container(
              child: Text(
                'Australia dollars(AUD)',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                ),
              ),
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 2.9166666666666665,
                  right: SizeConfig.widthMultiplier * 2.9166666666666665),
              child: Text(
                '\$0.99',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chineseYuanCard() {
    return Card(
      color: AppColors.cancel_red,
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 1.5064562410329987),
      child: Container(
        height: SizeConfig.heightMultiplier * 7.40674318507891,
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 0.9722222222222221),
        color: AppColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 2.9166666666666665,
                    top: SizeConfig.heightMultiplier * 2.0086083213773316,
                    bottom: SizeConfig.heightMultiplier * 2.259684361549498,
                    right: SizeConfig.widthMultiplier * 2.9166666666666665),
                child: Image.asset(
                  'assets/images/china_flag.png',
                  height: SizeConfig.heightMultiplier * 3.0129124820659974,
                  width: SizeConfig.widthMultiplier * 5.833333333333333,
                )),
            Container(
              child: Text(
                'Chinese Yuan(CYN)',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                ),
              ),
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 2.9166666666666665,
                  right: SizeConfig.widthMultiplier * 2.9166666666666665),
              child: Text(
                '\$0.99',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addNewPaymentButton() {
    return GestureDetector(
      onTap: () =>
          RouterService.appRouter.navigateTo(ReceivingPaymentRoute.buildPath()),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.appBlue)),
        margin: EdgeInsets.only(
            top: SizeConfig.heightMultiplier * 2.0086083213773316,
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: SizeConfig.widthMultiplier * 3.8888888888888884),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 1.8830703012912482,
                  left: SizeConfig.widthMultiplier * 4.618055555555555,
                  right: SizeConfig.widthMultiplier * 4.131944444444444,
                  bottom: SizeConfig.heightMultiplier * 1.5064562410329987),
              child: Icon(
                Icons.add,
                color: AppColors.appBlue,
                size: 24,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 1.8830703012912482,
                  bottom: SizeConfig.heightMultiplier * 1.5064562410329987),
              child: Text(
                'Add new card',
                style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  fontWeight: FontWeight.w400,
                  color: AppColors.appBlue,
                  letterSpacing: 0.25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buyBitcoinUI() {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 2.0086083213773316,
                bottom: SizeConfig.heightMultiplier * 1.0043041606886658),
            child: Text(
              'Buy bitcoin',
              style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                  color: AppColors.app_txt_color),
            ),
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  ),
                  child: Text(
                    'A\$$_bitcoinValue',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    // softWrap: true,
                    // overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 6.527977044476327,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.5,
                        color: AppColors.investment_back),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  ),
                  child: Image.asset(
                    'assets/images/suffel_icon.png',
                    height: SizeConfig.heightMultiplier * 3.0129124820659974,
                    width: SizeConfig.widthMultiplier * 5.833333333333333,
                  ),
                ),
              ],
            ),
          ),
          // _orderPreview(),
          _cardDetails(),
          _addNewPaymentButton(),
          _inputUI(),
        ],
      ),
    );
  }

  Widget _cardDetails() {
    return Container(
      height: SizeConfig.heightMultiplier * 8.159971305595409,
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 3.0129124820659974),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.appBlue)),
      child: Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      top: SizeConfig.heightMultiplier * 1.2553802008608321),
                  child: Text(
                    'VISA ******009',
                    style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  ),
                  child: Text(
                    'Holder name',
                    style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            child: Text(
              'A\$3,000.00 limit',
              style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.25,
                  color: AppColors.app_txt_color),
            ),
          ),
        ],
      )),
    );
  }

  Widget _inputUI() {
    double _width = MediaQuery.of(context).size.width;
    return Container(
      width: _width,
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 1.5064562410329987),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: SizeConfig.heightMultiplier * 9.038737446197992,
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Material(
                    color: AppColors.white,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (_bitcoinValue.length < 7 &&
                              double.parse(_bitcoinValue) <=
                                  double.parse(_bitLimit)) {
                            if (_bitcoinValue == "0") {
                              _bitcoinValue = "1";
                            } else {
                              _bitcoinValue = _bitcoinValue.toString() + "1";
                            }
                          } else {
                            // print('limit exceed');
                          }
                        });
                      },
                      child: Container(
                        width: _width * 0.33,
                        color: Colors.transparent,
                        child: Text(
                          '1',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              fontSize:
                                  SizeConfig.textMultiplier * 4.017216642754663,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.25,
                              color: AppColors.app_txt_color),
                        ),
                      ),
                    )),
                Material(
                    color: AppColors.white,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_bitcoinValue.length < 7 &&
                                double.parse(_bitcoinValue) <=
                                    double.parse(_bitLimit)) {
                              if (_bitcoinValue == "0") {
                                _bitcoinValue = "2";
                              } else {
                                _bitcoinValue = _bitcoinValue.toString() + "2";
                              }
                            } else {
                              // print('limit exceed');
                            }
                          });
                        },
                        child: Container(
                          width: _width * 0.33,
                          child: Text(
                            '2',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    4.017216642754663,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: AppColors.app_txt_color),
                          ),
                        ))),
                Material(
                    color: AppColors.white,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_bitcoinValue.length < 7 &&
                                double.parse(_bitcoinValue) <=
                                    double.parse(_bitLimit)) {
                              if (_bitcoinValue == "0") {
                                _bitcoinValue = "3";
                              } else {
                                _bitcoinValue = _bitcoinValue.toString() + "3";
                              }
                            } else {
                              // print('limit exceed');
                            }
                          });
                        },
                        child: Container(
                          width: _width * 0.33,
                          child: Text(
                            '3',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    4.017216642754663,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: AppColors.app_txt_color),
                          ),
                        ))),
              ],
            ),
          ),
          Container(
            height: SizeConfig.heightMultiplier * 9.038737446197992,
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Material(
                    color: AppColors.white,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_bitcoinValue.length < 7 &&
                                double.parse(_bitcoinValue) <=
                                    double.parse(_bitLimit)) {
                              if (_bitcoinValue == "0") {
                                _bitcoinValue = "4";
                              } else {
                                _bitcoinValue = _bitcoinValue.toString() + "4";
                              }
                            } else {
                              // print('limit exceed');
                            }
                          });
                        },
                        child: Container(
                          width: _width * 0.33,
                          child: Text(
                            '4',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    4.017216642754663,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: AppColors.app_txt_color),
                          ),
                        ))),
                Material(
                    color: AppColors.white,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_bitcoinValue.length < 7 &&
                                double.parse(_bitcoinValue) <=
                                    double.parse(_bitLimit)) {
                              if (_bitcoinValue == "0") {
                                _bitcoinValue = "5";
                              } else {
                                _bitcoinValue = _bitcoinValue.toString() + "5";
                              }
                            } else {
                              // print('limit exceed');
                            }
                          });
                        },
                        child: Container(
                          width: _width * 0.33,
                          child: Text(
                            '5',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    4.017216642754663,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: AppColors.app_txt_color),
                          ),
                        ))),
                Material(
                    color: AppColors.white,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_bitcoinValue.length < 7 &&
                                double.parse(_bitcoinValue) <=
                                    double.parse(_bitLimit)) {
                              if (_bitcoinValue == "0") {
                                _bitcoinValue = "6";
                              } else {
                                _bitcoinValue = _bitcoinValue.toString() + "6";
                              }
                            } else {
                              // print('limit exceed');
                            }
                          });
                        },
                        child: Container(
                          width: _width * 0.33,
                          child: Text(
                            '6',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    4.017216642754663,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: AppColors.app_txt_color),
                          ),
                        ))),
              ],
            ),
          ),
          Container(
            height: SizeConfig.heightMultiplier * 9.038737446197992,
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Material(
                    color: AppColors.white,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_bitcoinValue.length < 7 &&
                                double.parse(_bitcoinValue) <=
                                    double.parse(_bitLimit)) {
                              if (_bitcoinValue == "0") {
                                _bitcoinValue = "7";
                              } else {
                                _bitcoinValue = _bitcoinValue.toString() + "7";
                              }
                            } else {
                              // print('limit exceed');
                            }
                          });
                        },
                        child: Container(
                          width: _width * 0.33,
                          child: Text(
                            '7',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    4.017216642754663,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: AppColors.app_txt_color),
                          ),
                        ))),
                Material(
                    color: AppColors.white,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_bitcoinValue.length < 7 &&
                                double.parse(_bitcoinValue) <=
                                    double.parse(_bitLimit)) {
                              if (_bitcoinValue == "0") {
                                _bitcoinValue = "8";
                              } else {
                                _bitcoinValue = _bitcoinValue.toString() + "8";
                              }
                            } else {
                              // print('limit exceed');
                            }
                          });
                        },
                        child: Container(
                          width: _width * 0.33,
                          child: Text(
                            '8',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    4.017216642754663,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: AppColors.app_txt_color),
                          ),
                        ))),
                Material(
                    color: AppColors.white,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_bitcoinValue.length < 7 &&
                                double.parse(_bitcoinValue) <=
                                    double.parse(_bitLimit)) {
                              if (_bitcoinValue == "0") {
                                _bitcoinValue = "9";
                              } else {
                                _bitcoinValue = _bitcoinValue.toString() + "9";
                              }
                            } else {
                              // print('limit exceed');
                            }
                          });
                        },
                        child: Container(
                          width: _width * 0.33,
                          child: Text(
                            '9',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    4.017216642754663,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: AppColors.app_txt_color),
                          ),
                        ))),
              ],
            ),
          ),
          Container(
            height: SizeConfig.heightMultiplier * 9.038737446197992,
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: _width * 0.33,
                  child: Text(
                    '.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 4.017216642754663,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.25,
                        color: AppColors.app_txt_color),
                  ),
                ),
                Material(
                    color: AppColors.white,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_bitcoinValue.length <= _bitLimit.length &&
                                double.parse(_bitcoinValue) <=
                                    double.parse(_bitLimit)) {
                              if (_bitcoinValue == "0") {
                                _bitcoinValue = "0";
                              } else {
                                _bitcoinValue = _bitcoinValue.toString() + "0";
                              }
                            } else {
                              // print('limit exceed');
                            }
                          });
                        },
                        child: Container(
                          width: _width * 0.33,
                          child: Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    4.017216642754663,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: AppColors.app_txt_color),
                          ),
                        ))),
                Material(
                    color: AppColors.white,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_bitcoinValue.length >= 2) {
                              if (_bitcoinValue != null &&
                                  _bitcoinValue.length > 0) {
                                _bitcoinValue = _bitcoinValue.substring(
                                    0, _bitcoinValue.length - 1);
                              }
                            }
                          });
                        },
                        child: Container(
                          width: _width * 0.33,
                          child: Text(
                            '<-',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    4.017216642754663,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: AppColors.app_txt_color),
                          ),
                        ))),
              ],
            ),
          ),
          _previewButton(),
        ],
      ),
    );
  }

  Widget _previewButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: SizeConfig.heightMultiplier * 6.025824964131995,
        margin: EdgeInsets.only(
            top: SizeConfig.heightMultiplier * 5.0215208034433285,
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: SizeConfig.widthMultiplier * 3.8888888888888884),
        child: RaisedGradientButton(
          gradient: LinearGradient(
            colors: <Color>[
              AppColors.gradient_button_light,
              AppColors.gradient_button_dark,
            ],
          ),
          child: Padding(
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: Text(
                'PREVIEW BUY',
                style: GoogleFonts.inter(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    letterSpacing: 0.5,
                    textStyle: TextStyle(fontFamily: 'Roboto')),
              )),
        ),
      ),
    );
  }

  Widget _orderPreview() {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 4.017216642754663),
            child: Row(
              children: [
                Container(
                  child: Text(
                    'BTC price',
                    style: GoogleFonts.inter(
                      color: AppColors.sub_text,
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  child: Text(
                    'A\$60,955.55',
                    style: GoogleFonts.inter(
                      color: AppColors.text_field_container,
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 4.017216642754663),
            child: Row(
              children: [
                Container(
                  child: Text(
                    'Payment method',
                    style: GoogleFonts.inter(
                      color: AppColors.sub_text,
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  child: Text(
                    'A\$60,955.55',
                    style: GoogleFonts.inter(
                      color: AppColors.text_field_container,
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 4.017216642754663),
            child: Row(
              children: [
                Container(
                  child: Text(
                    'Purchase',
                    style: GoogleFonts.inter(
                      color: AppColors.sub_text,
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  child: Text(
                    'A\$60,955.55',
                    style: GoogleFonts.inter(
                      color: AppColors.text_field_container,
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 4.017216642754663),
            child: Row(
              children: [
                Container(
                  child: Text(
                    'Market spaace fee',
                    style: GoogleFonts.inter(
                      color: AppColors.sub_text,
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  child: Text(
                    'A\$60,955.55',
                    style: GoogleFonts.inter(
                      color: AppColors.text_field_container,
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 4.017216642754663),
            child: Row(
              children: [
                Container(
                  child: Text(
                    'Total',
                    style: GoogleFonts.inter(
                      color: AppColors.app_txt_color,
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  child: Text(
                    'A\$60,955.55',
                    style: GoogleFonts.inter(
                      color: AppColors.text_field_container,
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 4.017216642754663),
            child: Row(
              children: [
                Container(
                  child: Text(
                    'Processed by',
                    style: GoogleFonts.inter(
                      color: AppColors.text_field_container,
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: SizeConfig.widthMultiplier *
                                1.2152777777777777),
                        child: Text(
                          'Market Spaace',
                          style: GoogleFonts.inter(
                              color: AppColors.appBlue,
                              fontWeight: FontWeight.w400,
                              fontSize: SizeConfig.textMultiplier *
                                  1.5064562410329987,
                              letterSpacing: 0.5,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      // Container(
                      //   height: SizeConfig.heightMultiplier * 0.12553802008608322,
                      //   // width: MediaQuery.of(context).size.width * 0.3,
                      //   color: AppColors.toolbarBlue,
                      // )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
