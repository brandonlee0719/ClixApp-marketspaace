import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/apis/userApi/shoppingCartManager.dart';
import 'package:market_space/cart/cart_bloc.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/multi_selected_chip.dart';
import 'package:market_space/model/product_detail_model/product_det_model.dart';
import 'package:market_space/order_checkout/order_checkout_route.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:market_space/services/dialogueServices/dialogueService.dart';
import 'package:market_space/services/locator.dart';
import 'package:market_space/services/RouterServices.dart';

import 'cart_l10n.dart';
import 'model/cartModel.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartBloc _cartBloc = CartBloc(Initial());
  final _globalKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;

  List<ProductDetModel> _productList = List();
  List<String> _categoryList = ["Dollar", "AUD", "Bitcoin"];
  bool _isTags = false;
  double _totalPrefferedCurrency = 0.0, _totalBitcoin = 0.0;
  CartL10n _l10n =
      CartL10n(Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
  bool _isChinese = false;
  bool _isCurrentProductRemoved = false;

  final Color background = AppColors.toolbarBlue;
  final Color fill = AppColors.lightgrey;

  @override
  void initState() {
    _cartBloc.add(CartScreenEvent());
    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n =
            CartL10n(Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _isChinese = true;
        _l10n = CartL10n(Locale.fromSubtags(languageCode: 'zh'));
      }

      locator<ShoppingCartManager>().getCart();
    });

    super.initState();
  }

  @override
  void dispose() {
    locator<ShoppingCartManager>().purchaseProduct.clear();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];

    final double fillPercent = 39.7; // fills 56.23% for container from bottom
    final double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: gradient,
              stops: stops)),
      child: Scaffold(
        appBar: _toolbar(),
        bottomNavigationBar: Container(
          color: AppColors.white,
          child: _bottomButtons(),
        ),
        key: _globalKey,
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.white,
          child: BlocProvider(
              create: (_) => _cartBloc,
              child: BlocListener<CartBloc, CartState>(
                  listener: (context, state) {
                    if (state is Loading) {
                      setState(() {
                        _isLoading = true;
                      });
                    }
                    if (state is Loaded) {
                      setState(() {
                        _productList = _cartBloc.productList;
                        Constants.cartCount = _productList.length;
                        for (ProductDetModel model in _productList) {
                          if (Constants.aud != null) {
                            double prefCurrency =
                                model.fiatPrice / double.parse(Constants.aud);
                            _totalPrefferedCurrency =
                                _totalPrefferedCurrency + prefCurrency;
                            double cryto = (model.fiatPrice /
                                    double.parse(Constants.aud)) *
                                double.parse(Constants.btc);
                            _totalBitcoin = _totalBitcoin + cryto;
                            _totalBitcoin =
                                double.parse(_totalBitcoin.toStringAsFixed(7));
                          }
                        }
                        _isLoading = false;
                      });
                    }
                    if (state is Failed) {
                      setState(() {
                        _isLoading = false;
                      });
                    }

                    if (state is ProductRemovedSuccessfully) {
                      setState(() {
                        _productList = _cartBloc.productList;
                        _totalPrefferedCurrency = 0.0;
                        _totalBitcoin = 0.0;
                        Constants.cartCount = _productList.length;
                        for (ProductDetModel model in _productList) {
                          if (Constants.aud != null) {
                            double prefCurrency =
                                model.fiatPrice / double.parse(Constants.aud);
                            _totalPrefferedCurrency =
                                _totalPrefferedCurrency + prefCurrency;
                            double cryto = (model.fiatPrice /
                                    double.parse(Constants.aud)) *
                                double.parse(Constants.btc);
                            _totalBitcoin = _totalBitcoin + cryto;
                            _totalBitcoin =
                                double.parse(_totalBitcoin.toStringAsFixed(7));
                          }
                        }
                      });
                    }
                    if (state is ProductRemovedFailed) {
                      setState(() {
                        _productList = _cartBloc.productList;
                        Constants.cartCount = _productList.length;
                      });
                    }
                  },
                  child: StreamBuilder<List<dynamic>>(
                      stream: locator<ShoppingCartManager>().cartStream.stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("loading");
                        }
                        if (snapshot.data.isEmpty) {
                          return _cartEmpty();
                        }
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return _cartCard(snapshot.data[index]);
                            });
                      }))),
        ),
      ),
    );
  }

  Widget _baseScreen() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          children: [
            if (!_isLoading)
              Container(
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: [
                    Container(
                      child: Column(
                          children:
                              _productList.map((e) => _cartCard(e)).toList()),
                    ),
                    _grandTotal()
                  ],
                ),
              ),
            if (_isLoading)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                child: Align(
                    alignment: Alignment.center,
                    child: LoadingProgress(
                      color: Colors.deepOrangeAccent,
                    )),
              ),
          ],
        ),
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
              color: AppColors.toolbarBack,
              child: Row(
                children: [
                  Container(
                    child: Container(
                      width: SizeConfig.widthMultiplier * 60.27777777777777,
                      height: kToolbarHeight,
                      decoration: BoxDecoration(
                          color: AppColors.toolbarBlue,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () => {
                                        Navigator.pop(context, "Success"),
                                      },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: SizeConfig.widthMultiplier *
                                            2.4305555555555554),
                                    child: SvgPicture.asset(
                                      'assets/images/Back_button.svg',
                                      width: SizeConfig.widthMultiplier *
                                          6.033333333333333,
                                      height: SizeConfig.heightMultiplier *
                                          3.0129124820659974,
                                    ),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.widthMultiplier *
                                          2.4305555555555554),
                                  child: Text(
                                    _l10n.cart,
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
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              )),
        ),
        preferredSize: Size.fromHeight(
            SizeConfig.heightMultiplier * 16.571018651362985704000955107872));
  }

  Widget _bottomButtons() {
    return GestureDetector(
      onTap: () {
        // print(locator<ShoppingCartManager>().purchaseProduct);
        if (locator<ShoppingCartManager>().purchaseProduct.isEmpty) {
          DialogueService.instance.showErrorDialogue(
              context, "You should at least checkout with one item", () {});
        }
        // else if (locator<ShoppingCartManager>().purchaseProduct.length > 1) {
        //   DialogueService.instance.showErrorDialogue(
        //       context,
        //       "Market Spaace currently does not supporting checking out multiple items with credit card,"
        //       " if you are purchasing multiple items you can only check out with wallet",
        //       () {
        //     RouterService.appRouter.navigateTo(OrderCheckoutRoute.buildPath());
        //   }, buttonText: 'Proceed', title: 'Attention');
        // }
        else {
          RouterService.appRouter.navigateTo(OrderCheckoutRoute.buildPath());
        }
      },
      child: _productList.isNotEmpty
          ? Container(
              height: SizeConfig.heightMultiplier * 6.025824964131995,
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  top: SizeConfig.heightMultiplier * 2.5107604017216643,
                  bottom: SizeConfig.heightMultiplier * 2.5107604017216643,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884),
              decoration: BoxDecoration(
                  // border: Border.all(color: AppColors.appBlue),
                  borderRadius: BorderRadius.circular(10),
                  //TODO:Fix
                  gradient: LinearGradient(colors: [
                    AppColors.gradient_button_light,
                    AppColors.gradient_button_dark
                  ])),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  child: Text(
                    _l10n.proceedToCheckout,
                    style: GoogleFonts.lato(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.white),
                  ),
                ),
              ),
            )
          : Container(
              height: SizeConfig.heightMultiplier * 0.12553802008608322,
            ),
    );
  }

  Widget _cartCard(ProductDetModel model) {
    return CartCard(model: model);
  }

  Widget _recentlyImage(ProductDetModel model) {
    return Stack(
      children: [
        Container(
            height: SizeConfig.heightMultiplier * 16.947632711621235,
            width: SizeConfig.widthMultiplier * 30.138888888888886,
            child: CachedNetworkImage(
                imageUrl: model?.productImages[0] != null
                    ? model?.productImages[0]
                    : 'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg',
                placeholder: (context, url) =>
                    Lottie.asset('assets/loader/image_loading.json'),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          color: AppColors.toolbarBlue,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ))),
      ],
    );
  }

  Widget _cartTxt(ProductDetModel model) {
    if (model.tags == null) {
      _isTags = false;
    } else {
      _isTags = true;
    }
    double prefCurrency, cryto;
    var prefSevenDecimal, cryptoDecimal;
    if (Constants.aud != null) {
      prefCurrency = model.fiatPrice / double.parse(Constants.aud);
      cryto = (model.fiatPrice / double.parse(Constants.aud)) *
          double.parse(Constants.btc);
      if (prefCurrency.toString().length > 7) {
        prefSevenDecimal = double.parse(prefCurrency.toStringAsFixed(7));
        cryptoDecimal = double.parse(cryto.toStringAsFixed(7));
      } else {
        prefSevenDecimal = prefCurrency;
        cryptoDecimal = double.parse(cryto.toStringAsFixed(7));
      }
    } else {
      cryto = (model.fiatPrice / 1.0) * double.parse(Constants.btc);
      cryptoDecimal = double.parse(cryto.toStringAsFixed(7));
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 0.9166666666666665,
                      top: SizeConfig.heightMultiplier * 1.0043041606886658),
                  child: Text(model?.productTitle,
                      style: GoogleFonts.inter(
                          fontSize: SizeConfig.textMultiplier * 1.9,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.15)),
                ),
              ),
              // Spacer(),
              const SizedBox(width: 10),
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.heightMultiplier * 1.5064562410329987,
                        right: SizeConfig.widthMultiplier * 1.9444444444444442,
                      ),
                      child: Text(
                        '\$${prefCurrency}',
                        maxLines: 1,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.1),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: SizeConfig.widthMultiplier * 1.9444444444444442,
                        // left: SizeConfig.widthMultiplier * 3.645833333333333
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              CryptoFontIcons.BTC,
                              size: 12,
                            ),
                            Text(
                              '$cryptoDecimal',
                              maxLines: 1,
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.4),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (model?.tags?.isNotEmpty ?? false)
            Container(
                height: SizeConfig.heightMultiplier * 6.276901004304161,
                width: double.infinity,
                padding: EdgeInsets.all(2),
                child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: 0.22,
                    scrollDirection: Axis.horizontal,
                    children: model?.tags?.map((e) => _tags(e))?.toList())),
          Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 0.9166666666666665,
                top: SizeConfig.heightMultiplier * 1.0043041606886658,
                right: SizeConfig.widthMultiplier * 1.9444444444444442,
                bottom: SizeConfig.heightMultiplier * 0.6276901004304161),
            child: Text(
              model?.description ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                  fontWeight: FontWeight.w400,
                  color: AppColors.catTextColor,
                  letterSpacing: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _grandTotal() {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 2.761836441893831),
      // height: SizeConfig.heightMultiplier * 7.78335724533716,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.appBlue)),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    top: SizeConfig.heightMultiplier * 1.6319942611190819),
                child: Text(
                  _l10n.orderTotal,
                  style: GoogleFonts.lato(
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      color: AppColors.app_txt_color,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4),
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                    right: SizeConfig.widthMultiplier * 3.8888888888888884,
                    top: SizeConfig.heightMultiplier * 1.6319942611190819),
                child: Text(
                  '\$$_totalPrefferedCurrency',
                  style: GoogleFonts.lato(
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      color: AppColors.app_txt_color,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.25),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    bottom: SizeConfig.heightMultiplier * 1.5064562410329987),
                child: Text(
                  'Crypto value',
                  style: GoogleFonts.lato(
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      color: AppColors.app_txt_color,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(
                    right: SizeConfig.widthMultiplier * 1.9444444444444442,
                    left: SizeConfig.widthMultiplier * 3.645833333333333),
                child: Row(children: [
                  Icon(
                    CryptoFontIcons.BTC,
                    size: 12,
                  ),
                  Text(
                    '$_totalBitcoin',
                    maxLines: 1,
                    style: GoogleFonts.inter(
                        fontSize:
                            SizeConfig.textMultiplier * 1.5064562410329987,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.4),
                  ),
                ]),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _cartEmpty() {
    return Center(
      child: _isLoading
          ? LoadingProgress(
              color: AppColors.app_orange,
            )
          : Container(
              margin: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 5.0215208034433285),
              child: Column(
                children: [
                  Container(
                    child: Image.asset(
                      'assets/images/empty_cart.png',
                      width: SizeConfig.widthMultiplier * 63.194444444444436,
                      height: SizeConfig.heightMultiplier * 32.76542324246772,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.heightMultiplier * 3.0129124820659974),
                    child: Text(
                      _l10n.YourCartEmpty,
                      style: GoogleFonts.lato(
                          fontSize:
                              SizeConfig.textMultiplier * 2.259684361549498,
                          color: AppColors.app_txt_color,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.15),
                    ),
                  ),
                ],
              )),
    );
  }

  Widget _tags(String tag) {
    Color color;
    if (tag.length <= 3) {
      color = AppColors.tag_short;
    } else if (tag.length > 3 && tag.length < 6) {
      color = AppColors.tag_normal;
    } else if (tag.length >= 6 && tag.length < 8) {
      color = AppColors.tag_medium;
    } else if (tag.length >= 8) {
      color = AppColors.tag_longest;
    }
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 1.0043041606886658,
          left: SizeConfig.widthMultiplier * 0.9722222222222221),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
      child: Center(
        child: Text(
          tag,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}
