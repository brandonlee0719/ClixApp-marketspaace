import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/apis/userApi/shoppingCartManager.dart';
import 'package:market_space/cart/cart_route.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/dashboard/products/fav_products/favourite_products_bloc.dart';
import 'package:market_space/message_chat/message_chat_route.dart';
import 'package:market_space/model/flash_promo_model/flash_promo_algolia.dart';
import 'package:market_space/model/product_detail_model/product_det_model.dart';
import 'package:market_space/model/promo_model.dart';
import 'package:market_space/model/shipping_price_model/shipping_price_model.dart';
import 'package:market_space/notification/routes/notification_route.dart';
import 'package:market_space/order_checkout/order_checkout_route.dart';
import 'package:market_space/product_landing_screen/product_image_screen/product_image_route.dart';
import 'package:market_space/product_landing_screen/product_landing_bloc.dart';
import 'package:market_space/product_landing_screen/product_landing_event.dart';
import 'package:market_space/product_landing_screen/product_landing_l10n.dart';
import 'package:market_space/product_landing_screen/product_landing_route.dart';
import 'package:market_space/product_landing_screen/product_landing_state.dart';
import 'package:market_space/providers/messages_provider/messageProvider.dart';
import 'package:market_space/recent_product_feedback/recent_product_feedback_route.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/locator.dart';
import 'package:market_space/services/routServiceProvider.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

class ProductLandingScreen extends StatefulWidget {
  @override
  _ProductLandingScreenState createState() => _ProductLandingScreenState();
}

class _ProductLandingScreenState extends State<ProductLandingScreen> {
  final ProductLandingBloc _ProductLandingBloc = ProductLandingBloc(Initial());
  ProductLandingL10n _l10n = ProductLandingL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
  final _globalKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _isRelatedLoading = false;
  bool _sellerLoading = false;
  List<String> _colorItems = ["color/size", "Black", "Blue", "Orange"];
  String _colorSelectedItem;
  List<String> _quantityItems = ["quantity", "1", "2", "3"];
  String _quantitySelectedItem;

  List<DropdownMenuItem<String>> _dropdownMenuItems;
  List<DropdownMenuItem<String>> _quantitydownMenuItems;
  List<Variation> _variationList = List();

  ScrollController _recentItemsController;
  List<PromoModel> _promoList = List();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  // bool _productLiked = false;

  final _variatorKey = GlobalKey<ScaffoldState>();
  OverlayEntry _overlayEntry;
  final TextEditingController _variatorController = TextEditingController();
  bool _isChinese = false;
  SellerData _sellerData;
  List<RelatedItems> _relatedItemList = List();
  String _product;
  int slideIndex = 0;
  String _shippingPrice;
  bool _priceCalculatorLoading = false;
  bool _addToCartLoading = false;
  bool _productInCart = false;
  Widget imageAssetNext = SvgPicture.asset(
    'assets/images/svgs/next.svg',
    height: 25,
    width: 25,
  );
  Widget twistedImageAssetNext = Transform(
    alignment: Alignment.center,
    transform: Matrix4.rotationY(math.pi),
    child: SvgPicture.asset(
      'assets/images/svgs/next.svg',
      height: 25,
      width: 25,
    ),
  );

  final Color background = AppColors.toolbarBlue;
  final Color fill = AppColors.lightgrey;

  @override
  void initState() {
    _ProductLandingBloc.productNum = ProductLandingRoute.productNum;
    _product = ProductLandingRoute.productName;
    _ProductLandingBloc.add(ProductLandingScreenEvent());
    _ProductLandingBloc.add(SellerDataEvent());
    _quantitydownMenuItems = buildQuantityItems(_quantityItems);
    _quantitySelectedItem = _quantitydownMenuItems[0].value;
    _recentItemsController = ScrollController();
    _recentItemsController.addListener(() {
      if (!_isLoading && !_isRelatedLoading) {
        if (_recentItemsController.position.pixels ==
            _recentItemsController.position.maxScrollExtent) {
          _ProductLandingBloc.pageCount = _ProductLandingBloc.pageCount + 1;
          setState(() {
            if (!_isRelatedLoading) {
              _isRelatedLoading = true;
            }
          });
          _ProductLandingBloc.add(LoadMoreRelatedEvent());
        }
      }
    });

    // _dropdownMenuItems = buildColorItems(_variationList);
    // _colorSelectedItem = _variationList[0]?.variationLabel;

    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = ProductLandingL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n = ProductLandingL10n(Locale.fromSubtags(languageCode: 'zh'));
        _isChinese = true;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
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
        bottomNavigationBar: _bottomButtons(),
        key: _globalKey,
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.white,
          child: BlocProvider(
            create: (_) => _ProductLandingBloc,
            child: BlocListener<ProductLandingBloc, ProductLandingState>(
              listener: (context, state) {
                if (state is Loading) {
                  setState(() {
                    _isLoading = true;
                    _sellerLoading = true;
                  });
                }
                if (state is Loaded) {
                  setState(() {
                    _isLoading = false;
                    // _productLiked = ProductLandingRoute.isProductLiked;
                    _relatedItemList.addAll(_ProductLandingBloc?.relatedItems);
                    _productInCart = _ProductLandingBloc.productExistInCart;
                    Constants.cartCount = _ProductLandingBloc.cartItemCount;
                    // _promoList = _ProductLandingBloc.promoList;
                    // _variationList.addAll(_ProductLandingBloc
                    //     .productDetailModel?.variations[0]?.variation);
                    // _colorItems.clear();
                    // _colorItems.add(_ProductLandingBloc
                    //     .productDetailModel?.variations[0]?.variator);
                    // for (Variation color in _variationList) {
                    //   _colorItems.add(color.variationLabel);
                    // }
                    // _dropdownMenuItems = buildColorItems(_colorItems);
                    // _colorSelectedItem = _colorItems[0];
                  });
                }
                if (state is Failed) {
                  setState(() {
                    _isLoading = false;
                    // _showToast("No product details available");
                  });
                }
                if (state is SellerDataLoaded) {
                  setState(() {
                    _sellerData = _ProductLandingBloc.sellerData;
                    _sellerLoading = false;
                  });
                }
                if (state is SellerDataFailed) {
                  setState(() {
                    _sellerLoading = false;
                  });
                }
                if (state is RelatedItemsLoaded) {
                  setState(() {
                    _relatedItemList.addAll(_ProductLandingBloc.relatedItems);
                    _isRelatedLoading = false;
                  });
                }
                if (state is RelatedItemsFailed) {
                  setState(() {
                    _isRelatedLoading = false;
                  });
                }
                if (state is ShippingCalculatedSuccessfully) {
                  setState(() {
                    _shippingPrice = _ProductLandingBloc.shippingPrice.price;
                    _priceCalculatorLoading = false;
                  });
                }
                if (state is ShippingCalculationFailed) {
                  setState(() {
                    _showToast("Price calculation failed");
                    _priceCalculatorLoading = false;
                  });
                }
                if (state is ItemAddedToCartSuccessfully) {
                  setState(() {
                    _productInCart = _ProductLandingBloc.productExistInCart;
                    _addToCartLoading = false;
                    Constants.cartCount = _ProductLandingBloc.cartItemCount;
                  });
                  _showToast('Item added to cart');
                }
                if (state is ItemAddedToCartFailed) {
                  setState(() {
                    _addToCartLoading = false;
                  });
                  Constants.cartCount = _ProductLandingBloc.cartItemCount;
                  _productInCart = _ProductLandingBloc.productExistInCart;
                  _showToast('Item already in cart');
                }
              },
              child: _isLoading
                  ? Container(
                      child: Center(
                        child: LoadingProgress(
                          color: AppColors.app_orange,
                        ),
                      ),
                    )
                  : _ProductLandingBloc.productDetailModel == null
                      ? Container(
                          child: Center(
                            child: Text(
                              "No product detail available.",
                              style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    1.757532281205165,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                      : _baseScreen(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _baseScreen() {
    // print(_ProductLandingBloc.productDetailModel.toString());
    return Stack(
      children: [
        if (_isLoading)
          BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
              child: Center(
                  child: LoadingProgress(
                color: Colors.deepOrangeAccent,
              ))),
        if (!_isLoading)
          CustomScrollView(slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 456.0,
              collapsedHeight: 100,
              // shape: ContinuousRectangleBorder(
              //     borderRadius: BorderRadius.only(
              //         bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),                        floating: false,
              leading: InkWell(onTap: () {}, child: null),
              actions: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      right: SizeConfig.widthMultiplier * 3.8888888888888884),
                  child: Column(
                    children: [
                      BlocBuilder<FavouriteProductsBloc,
                          FavouriteProductsState>(
                        builder: (context, state) {
                          if (state is FavouriteProductsLoaded)
                            return GestureDetector(
                              onTap: () {
                                context.read<FavouriteProductsBloc>().add(
                                    AddRemoveFavouriteProduct(
                                        _ProductLandingBloc
                                            .productDetailModel.productNum));
                              },
                              child: Container(
                                child: state.favProducts.contains(
                                        _ProductLandingBloc
                                            .productDetailModel.productNum)
                                    ? Image.asset(
                                        'assets/images/img_fav.png',
                                        width: SizeConfig.widthMultiplier *
                                            5.833333333333333,
                                        height: SizeConfig.heightMultiplier *
                                            2.887374461979914,
                                      )
                                    : SvgPicture.asset(
                                        'assets/images/heart.svg',
                                        width: 35,
                                        height: 35,
                                        color: AppColors.nextButtonPrimary,
                                      ),
                              ),
                            );
                          return Container();
                        },
                      ),
                      // Container(
                      //   child: Image.asset(
                      //     'assets/images/share_white.png',
                      //     width: SizeConfig.widthMultiplier * 5.833333333333333,
                      //     height:
                      //         SizeConfig.heightMultiplier * 2.887374461979914,
                      //     color: AppColors.nextButtonPrimary,
                      //   ),
                      // )
                    ],
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  background: InkWell(
                      onTap: () {
                        ProductImageRoute.productDetailModel =
                            _ProductLandingBloc?.productDetailModel;
                        RouterService.appRouter
                            .navigateTo(ProductImageRoute.buildPath());
                      },
                      child: _imagePageView())),

              bottom: _customTitle(_ProductLandingBloc?.productDetailModel),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  // print(_ProductLandingBloc?.productDetailModel);
                  return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: _productCard(
                          _ProductLandingBloc?.productDetailModel));
                },
                childCount: 1,
              ),
            ),
          ])
      ],
    );
  }

  Widget _productCard(ProductDetModel model) {
    // print(model.toString());
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: Column(
        // shrinkWrap: true,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _description(model),
          if (model.variations != null) _dropdownRow(model),
          _shippingInfo(model),
          // _productReviews(model),
          // if(_relatedItemList != null && _relatedItemList.isNotEmpty)
          if (_relatedItemList.length > 0) _relatedItems(_relatedItemList),
          _otherDetails(model, _sellerData),
        ],
      ),
    );
  }

  Widget _productTitleRow(ProductDetModel model) {
    double prefCurrency, cryto;
    var prefSevenDecimal, cryptoDecimal;
    prefCurrency = model.fiatPrice / double.parse(Constants.aud);
    cryto = (model.fiatPrice / double.parse(Constants.aud)) *
        double.parse(Constants.btc);
    if (prefCurrency.toString().length > 7) {
      prefSevenDecimal = double.parse(prefCurrency.toStringAsFixed(6));
      cryptoDecimal = double.parse(cryto.toStringAsFixed(6));
    } else {
      prefSevenDecimal = prefCurrency;
      cryptoDecimal = double.parse(cryto.toStringAsFixed(6));
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            model?.productTitle == null
                ? Container(
                    margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 2.0086083213773316,
                      left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    ),
                    height: SizeConfig.heightMultiplier * 7.532281205164993,
                    width: SizeConfig.widthMultiplier * 19.444444444444443,
                    child: Lottie.asset('assets/loader/simple_loading.json'))
                : Flexible(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(
                        right: SizeConfig.widthMultiplier * 3.8888888888888884,
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                        top: 10,
                      ),
                      child: Text(
                        model.productTitle,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 2.259684361549498,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.15,
                            color: AppColors.blue_900),
                      ),
                    ),
                  ),
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //
            //   child: Text(
            //     _isChinese
            //         ? model.chineseProductTitle ?? ""
            //         : model?.productTitle ?? "",
            //     style: GoogleFonts.inter(
            //         fontSize: SizeConfig.textMultiplier * 2.259684361549498,
            //         fontWeight: FontWeight.w400,
            //         letterSpacing: 0.15,
            //         color: AppColors.blue_900),
            //   ),
            //     ),

            // Spacer(),
            model == null
                ? Container(
                    margin: EdgeInsets.only(
                      right: SizeConfig.widthMultiplier * 3.8888888888888884,
                      left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    ),
                    height: SizeConfig.heightMultiplier * 3.7661406025824964,
                    width: SizeConfig.widthMultiplier * 12.152777777777777,
                    child: Lottie.asset('assets/loader/simple_loading.json'))
                : Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig.heightMultiplier * 1.0086083213773316,
                          right:
                              SizeConfig.widthMultiplier * 3.8888888888888884),
                      child: Text(
                        '\$${prefSevenDecimal ?? ""}',
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.1,
                            color: AppColors.app_txt_color),
                      ),
                    ),
                  ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: model == null
              ? Container(
                  margin: EdgeInsets.only(
                    right: SizeConfig.widthMultiplier * 3.8888888888888884,
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  ),
                  height: SizeConfig.heightMultiplier * 3.7661406025824964,
                  width: SizeConfig.widthMultiplier * 12.152777777777777,
                  child: Lottie.asset('assets/loader/simple_loading.json'))
              : Container(
                  margin: EdgeInsets.only(
                      right: SizeConfig.widthMultiplier * 3.8888888888888884),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        CryptoFontIcons.BTC,
                        size: 12,
                      ),
                      Text(
                        '${cryptoDecimal}',
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.5064562410329987,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.4,
                            color: AppColors.app_txt_color),
                      ),
                    ],
                  )),
        ),
        const SizedBox(height: 2),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(
                right: SizeConfig.widthMultiplier * 3.8888888888888884),
            child: Text(
              model?.freeShipping == "true"
                  ? _l10n.Freeshipping
                  : '${model.shippingPrice ?? '+ 0.00'} shipping',
              style: GoogleFonts.inter(
                  color: AppColors.text_field_container,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                  fontSize: 12),
            ),
          ),
        )
      ],
    );
  }

  Widget _tags(String tag) {
    return tag == null
        ? Container(
            height: SizeConfig.heightMultiplier * 2.0086083213773316,
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 0.25107604017216645),
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 1.9444444444444442,
                right: SizeConfig.widthMultiplier * 1.9444444444444442),
            decoration: BoxDecoration(
              color: AppColors.tag_short,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Lottie.asset('assets/loader/simple_loading.json'))
        : Container(
            height: SizeConfig.heightMultiplier * 2.0086083213773316,
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 0.25107604017216645),
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 1.9444444444444442,
                right: SizeConfig.widthMultiplier * 1.9444444444444442),
            decoration: BoxDecoration(
              color: AppColors.tag_short,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              tag,
              softWrap: false,
              style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.4),
              textAlign: TextAlign.center,
            ),
          );
  }

  Widget _description(ProductDetModel model) {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 1.0043041606886658),
      child: Text(
        _isChinese
            ? model.chineseDescription
            : model?.description ?? _l10n.Description,
        style: GoogleFonts.inter(
            fontSize: SizeConfig.textMultiplier * 1.757532281205165,
            fontWeight: FontWeight.w400,
            color: AppColors.catTextColor,
            letterSpacing: 0.25),
      ),
    );
  }

  Widget _dropdownRow(ProductDetModel model) {
    return Row(
      children: [
        Container(
            width: MediaQuery.of(context).size.width * 0.5,
            padding: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.8830703012912482,
                left: SizeConfig.widthMultiplier * 3.8888888888888884),
            child: Theme(
              data: ThemeData(
                primaryColor: AppColors.text_field_container,
                primaryColorDark: AppColors.text_field_container,
              ),
              child: TextField(
                keyboardType: TextInputType.phone,
                key: _variatorKey,
                controller: _variatorController,
                readOnly: true,
                showCursor: false,
                onTap: () {
                  setState(() {
                    this._overlayEntry = this._createOverlayEntry(
                        _isChinese
                            ? model.chineseVariations[0].variation
                            : model.variations[0].variation,
                        _variatorKey,
                        _variatorController);
                    Overlay.of(context).insert(this._overlayEntry);
                  });
                },
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    letterSpacing: 0.1,
                    color: AppColors.app_txt_color),
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.text_field_container),
                        borderRadius: BorderRadius.circular(10.0)),
                    contentPadding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884),
                    hintText: _l10n.Variation,
                    suffixStyle:
                        const TextStyle(color: AppColors.text_field_container)),
              ),
            )),
        Container(
          height: SizeConfig.heightMultiplier * 6.276901004304161,
          width: SizeConfig.widthMultiplier * 29.166666666666664,
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 2.4305555555555554,
              right: SizeConfig.widthMultiplier * 2.4305555555555554,
              top: SizeConfig.heightMultiplier * 1.8830703012912482),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.text_field_container,
              primaryColorDark: AppColors.text_field_container,
            ),
            child: TextField(
              keyboardType: TextInputType.number,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.25,
              ),
              buildCounter: (BuildContext context,
                      {int currentLength, int maxLength, bool isFocused}) =>
                  null,
              maxLength: 3,
              controller: _quantityController,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: AppColors.text_field_color),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: _l10n.Quantity,
                  labelText: _l10n.Quantity,
                  contentPadding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884),
                  suffixStyle:
                      const TextStyle(color: AppColors.text_field_container)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _shippingInfo(ProductDetModel model) {
    return Container(
      padding: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 1.2553802008608321,
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                child: Text(
                  'Delivery time:  ',
                  style: GoogleFonts.inter(
                      color: AppColors.text_field_container,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.25,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 0.48611111111111105),
                child: Text(
                  model.deliveryTime ?? 'Not Provided',
                  style: GoogleFonts.inter(
                      color: AppColors.text_field_container,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165),
                ),
              ),
            ],
          ),
          // Container(
          //   margin: EdgeInsets.only(
          //       left: SizeConfig.widthMultiplier * 1.2152777777777777,
          //       right: SizeConfig.widthMultiplier * 1.2152777777777777),
          //   width: SizeConfig.widthMultiplier * 0.48611111111111105,
          //   height: SizeConfig.heightMultiplier * 2.5107604017216643,
          //   color: AppColors.text_field_container,
          // ),
          Row(
            children: [
              Container(
                child: Text(
                  'Handling time:  ',
                  style: GoogleFonts.inter(
                      color: AppColors.text_field_container,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.25,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 0.48611111111111105),
                child: Text(
                  model.sellerHandlingTime ?? 'Not Given',
                  style: GoogleFonts.inter(
                      color: AppColors.text_field_container,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _shippingInfoDelivery(ShippingPriceModel model) {
    return Container(
      padding: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 1.2553802008608321,
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child: Row(
            children: [
              Text(
                model.shippingOption != null ? 'Shipping : ' : 'Shipping :  ',
                style: GoogleFonts.inter(
                    color: AppColors.text_field_container,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165),
              ),
              Text(
                model.shippingOption != null ? ' ${model.shippingOption}' : '',
                style: GoogleFonts.inter(
                    color: AppColors.text_field_color,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.25,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165),
              ),
            ],
          )),
          Container(
              child: Row(
            children: [
              Text(
                model.price != null
                    ? 'Estimated price : '
                    : 'Estimated price :  ',
                style: GoogleFonts.inter(
                    color: AppColors.text_field_container,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165),
              ),
              Text(
                model.price != null ? ' ${model.price}' : '',
                style: GoogleFonts.inter(
                    color: AppColors.text_field_color,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.25,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165),
              ),
            ],
          )),
          Container(
              child: Row(
            children: [
              Text(
                model.deliveryTime != null
                    ? 'Estimated time : '
                    : 'Estimated time :  ',
                style: GoogleFonts.inter(
                    color: AppColors.text_field_container,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165),
              ),
              Text(
                model.deliveryTime != null ? ' ${model.deliveryTime}' : '',
                style: GoogleFonts.inter(
                    color: AppColors.text_field_color,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.25,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165),
              ),
            ],
          )),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> buildColorItems(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    // Variation colorVar = Variation();
    // colorVar.variationLabel = "Colors";
    // colorVar.quantity = 0;
    // items.add(DropdownMenuItem(
    //   child: Text(
    //     "Colors",
    //     style: GoogleFonts.inter(
    //         fontWeight: FontWeight.w400,
    //         fontSize: SizeConfig.textMultiplier * 1.757532281205165,
    //         color: AppColors.text_field_container,
    //         letterSpacing: 0.25),
    //   ),
    //   value: colorVar,));
    if (listItems != null && listItems.isNotEmpty)
      for (String listItem in listItems) {
        items.add(
          DropdownMenuItem(
            child: Text(
              listItem,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  color: AppColors.text_field_container,
                  letterSpacing: 0.25),
            ),
            value: listItem,
          ),
        );
      }
    return items;
  }

  List<DropdownMenuItem<String>> buildQuantityItems(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(
            listItem,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                color: AppColors.text_field_container,
                letterSpacing: 0.25),
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  Widget _bottomButtons() {
    return Container(
      height: 100, //_productInCart && !_isLoading ? 1 : 100,
      color: AppColors.white,
      // margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884, top: SizeConfig.heightMultiplier * 1.5064562410329987, bottom: SizeConfig.heightMultiplier * 2.0086083213773316),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // if (!_productInCart && !_isLoading)
          GestureDetector(
            onTap: () {
              OrderCheckoutRoute.isBuyNow = false;
              _ProductLandingBloc.cartProduct =
                  _ProductLandingBloc.productDetailModel;
              _addToCartLoading = true;
              // if (_productInCart)
              //   _ProductLandingBloc.add(RemoveFromCartEvent());
              // else
              _ProductLandingBloc.add(AddToCartEvent());
            },
            child: Container(
              // width: SizeConfig.widthMultiplier * 37.67361111111111,
              height: SizeConfig.heightMultiplier * 6.025824964131995,
              margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 1.5064562410329987,
                bottom: SizeConfig.heightMultiplier * 2.0086083213773316,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.appBlue),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/cart.svg',
                      height: SizeConfig.heightMultiplier * 4.809124820659974,
                      width: SizeConfig.widthMultiplier * 4.029,
                    ),
                    _addToCartLoading
                        ? Lottie.asset('assets/loader/widget_loading.json',
                            height: SizeConfig.heightMultiplier *
                                2.5107604017216643,
                            width:
                                SizeConfig.widthMultiplier * 4.861111111111111)
                        : Text(
                            // _productInCart
                            //     ? 'ADDED TO CART'
                            //     :
                            _l10n.ADDTOCART,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    1.757532281205165,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: AppColors.appBlue),
                          ),
                  ],
                ),
              ),
            ),
          ),
          // if (!_productInCart && !_isLoading)
          Expanded(
            child: GestureDetector(
              onTap: () {
                _ProductLandingBloc.cartProduct =
                    _ProductLandingBloc.productDetailModel;
                // _addToCartLoading = true;
                // _ProductLandingBloc.add(AddToCartEvent());
                OrderCheckoutRoute.isBuyNow = true;
                OrderCheckoutRoute.productDetModel =
                    _ProductLandingBloc.productDetailModel;
                OrderCheckoutRoute.productList = [
                  OrderCheckoutRoute.productDetModel.productNum
                ];

                locator
                    .get<ShoppingCartManager>()
                    .addToPurchase(_ProductLandingBloc.productDetailModel);
                // print(OrderCheckoutRoute.productDetModel.productNum);
                RouterService.appRouter
                    .navigateTo(OrderCheckoutRoute.buildPath());
              },
              child: Container(
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 4.374999999999999,
                    top: SizeConfig.heightMultiplier * 1.5064562410329987,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884,
                    bottom: SizeConfig.heightMultiplier * 2.0086083213773316),
                // padding: const EdgeInsets.symmetric(horizontal: 28),
                height: SizeConfig.heightMultiplier * 6.025824964131995,
                decoration: BoxDecoration(
                    // border: Border.all(color: AppColors.appBlue),
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: [
                      AppColors.gradient_button_light,
                      AppColors.gradient_button_dark
                    ])),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/buy_now.png',
                      width: SizeConfig.widthMultiplier * 5.833333333333333,
                      height: SizeConfig.heightMultiplier * 3.0129124820659974,
                    ),
                    Text(
                      "  " + _l10n.BUYNOW,
                      style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /* Widget _productReviews(ProductDetModel model) {
    return Column(
      children: [
        Container(
          height: SizeConfig.heightMultiplier * 0.12553802008608322,
          margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884, right: SizeConfig.widthMultiplier * 3.8888888888888884, top: SizeConfig.heightMultiplier * 3.0129124820659974),
          color: AppColors.text_field_container,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884, top: SizeConfig.heightMultiplier * 2.0086083213773316),
              child: Text(
                _l10n.ProductReviews,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                  color: AppColors.app_txt_color,
                ),
              ),
            ),
            Spacer(),
            if (model != null &&
                model.productReviews!=null && model?.productReviews?.isNotEmpty &&
                model?.productReviews?.length > 3)
              GestureDetector(
                onTap: () {
                  // if (_broughtTxt == "Sold Items") {
                  //   RouterService.profileRouter
                  //       .navigateTo(SoldProductRoute.buildPath());
                  // } else {
                  //   RouterService.profileRouter
                  //       .navigateTo(RecentlyBroughtRoute.buildPath());
                  // }
                  RouterService.appRouter
                      .navigateTo(RecentProductFeedbackRoute.buildPath());
                },
                child: Container(
                  height: SizeConfig.heightMultiplier * 2.5107604017216643,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: SizeConfig.widthMultiplier * 3.645833333333333, top: SizeConfig.heightMultiplier * 2.0086083213773316),
                  padding:
                      EdgeInsets.only(left: SizeConfig.widthMultiplier * 1.9444444444444442, right: SizeConfig.widthMultiplier * 1.9444444444444442, top: SizeConfig.heightMultiplier * 0.25107604017216645, bottom: SizeConfig.heightMultiplier * 0.25107604017216645),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.seeAllText, width: SizeConfig.widthMultiplier * 0.24305555555555552),
                      color: AppColors.seeAllBack),
                  child: Text(
                    _l10n.seeAll,
                    style: TextStyle(
                      color: AppColors.seeAllText,
                      fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (model != null && model?.productReviews != null)
          Container(
              child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: model?.productReviews?.isNotEmpty
                ? model?.productReviews?.length > 3
                    ? 3
                    : model?.productReviews?.length
                : 1,
            itemBuilder: (context, index) {
              return model == null
                  ? Lottie.asset('assets/loader/list_loading.json')
                  : model?.productReviews?.isNotEmpty
                      ? _productReviewCard(model?.productReviews[index])
                      : Container(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/empty_box.png',
                                fit: BoxFit.contain,
                                height: SizeConfig.heightMultiplier * 18.830703012912483,
                                width: SizeConfig.widthMultiplier * 24.305555555555554,
                              ),
                              Text(
                                "${_l10n.NoReviews} !!",
                                style: GoogleFonts.inter(
                                  fontSize: SizeConfig.textMultiplier * 2.5107604017216643,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        );
            },
          ))
      ],
    );
  }

  Widget _productReviewCard(ProductReviews model) {
    return Container(
      margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884, right: SizeConfig.widthMultiplier * 3.8888888888888884, top: SizeConfig.heightMultiplier * 2.0086083213773316),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              model == null
                  ? Container(
                      margin: EdgeInsets.only(
                        right: SizeConfig.widthMultiplier * 3.8888888888888884,
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      ),
                      height: SizeConfig.heightMultiplier * 3.7661406025824964,
                      width: SizeConfig.widthMultiplier * 12.152777777777777,
                      child: Lottie.asset('assets/loader/simple_loading.json'))
                  : Container(
                      child: Text(
                        model?.buyerDisplayName ?? "",
                        style: GoogleFonts.inter(
                            fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w700,
                            color: AppColors.app_txt_color,
                            letterSpacing: 0.1),
                      ),
                    ),
              Spacer(),
              model == null
                  ? Container(
                      margin: EdgeInsets.only(
                        right: SizeConfig.widthMultiplier * 3.8888888888888884,
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      ),
                      height: SizeConfig.heightMultiplier * 3.7661406025824964,
                      width: SizeConfig.widthMultiplier * 12.152777777777777,
                      child: Lottie.asset('assets/loader/simple_loading.json'))
                  : Container(
                      margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 0.5021520803443329),
                      child: RatingBar(
                        itemSize: 16,
                        glow: false,
                        initialRating:
                            double.parse(model?.buyerRating.toString()) ?? 0,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return Image.asset(
                                'assets/images/feedback_star.png',
                                width: SizeConfig.widthMultiplier * 3.8888888888888884,
                                height: SizeConfig.heightMultiplier * 2.0086083213773316,
                              );
                            case 1:
                              return Image.asset(
                                'assets/images/feedback_star.png',
                                width: SizeConfig.widthMultiplier * 3.8888888888888884,
                                height: SizeConfig.heightMultiplier * 2.0086083213773316,
                              );
                            case 2:
                              return Image.asset(
                                'assets/images/feedback_star.png',
                                width: SizeConfig.widthMultiplier * 3.8888888888888884,
                                height: SizeConfig.heightMultiplier * 2.0086083213773316,
                              );
                            case 3:
                              return Image.asset(
                                'assets/images/feedback_star.png',
                                width: SizeConfig.widthMultiplier * 3.8888888888888884,
                                height: SizeConfig.heightMultiplier * 2.0086083213773316,
                              );
                            default:
                              return Image.asset(
                                'assets/images/feedback_star.png',
                                width: SizeConfig.widthMultiplier * 3.8888888888888884,
                                height: SizeConfig.heightMultiplier * 2.0086083213773316,
                              );
                          }
                        },
                        onRatingUpdate: (rating) {
                          setState(() {
                            // _rating = rating;
                          });
                          // print(rating);
                        },
                      ),
                    )
            ],
          ),
          model == null
              ? Container(
                  margin: EdgeInsets.only(
                    right: SizeConfig.widthMultiplier * 3.8888888888888884,
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  ),
                  height: SizeConfig.heightMultiplier * 3.7661406025824964,
                  width: SizeConfig.widthMultiplier * 12.152777777777777,
                  child: Lottie.asset('assets/loader/simple_loading.json'))
              : Container(
                  margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 0.5021520803443329,
                  ),
                  child: Text(
                    model?.buyerComment ?? "",
                    style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w400,
                        color: AppColors.app_txt_color,
                        letterSpacing: 0.25),
                  ),
                ),
        ],
      ),
    );
  }*/

  Widget _relatedItems(List<RelatedItems> relatedItems) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        height: SizeConfig.heightMultiplier * 0.12553802008608322,
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: SizeConfig.widthMultiplier * 3.8888888888888884,
            top: SizeConfig.heightMultiplier * 3.0129124820659974),
        color: AppColors.lightgrey,
      ),
      Padding(
        padding: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            top: SizeConfig.heightMultiplier * 3.389526542324247,
            bottom: SizeConfig.heightMultiplier * 2.1341463414634148),
        child: Text(
          _l10n.RelatedItems,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: SizeConfig.textMultiplier * 2.259684361549498,
            color: AppColors.app_txt_color,
          ),
        ),
      ),
      // if (relatedItems != null && relatedItems.isNotEmpty)
      !_isLoading && _relatedItemList.isNotEmpty
          ? Container(
              height: SizeConfig.heightMultiplier * 25.107604017216644,
              child: ListView(
                  controller: _recentItemsController,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Row(
                      children: _relatedItemList
                          .map<Widget>((e) => _relatedItemsCard(e))
                          ?.toList(),
                    ),
                    if (_isRelatedLoading)
                      Container(
                        margin: EdgeInsets.only(
                            right: SizeConfig.widthMultiplier *
                                12.152777777777777),
                        height:
                            SizeConfig.heightMultiplier * 3.7661406025824964,
                        width: SizeConfig.widthMultiplier * 7.291666666666666,
                        child: LoadingProgress(
                          color: AppColors.app_orange,
                        ),
                      )
                  ]),
            )
          : !_isLoading && (_relatedItemList.isEmpty)
              ? const SizedBox.shrink()
              : Container(
                  height: SizeConfig.heightMultiplier * 25.107604017216644,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                          height:
                              SizeConfig.heightMultiplier * 24.60545193687231,
                          width:
                              SizeConfig.widthMultiplier * 30.138888888888886,
                          margin: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier *
                                  2.4305555555555554,
                              right: SizeConfig.widthMultiplier *
                                  2.4305555555555554),
                          child: Lottie.asset('assets/loader/loading_card.json',
                              width: SizeConfig.widthMultiplier *
                                  30.138888888888886)),
                      Container(
                          height:
                              SizeConfig.heightMultiplier * 24.60545193687231,
                          width:
                              SizeConfig.widthMultiplier * 30.138888888888886,
                          margin: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier *
                                  2.4305555555555554,
                              right: SizeConfig.widthMultiplier *
                                  2.4305555555555554),
                          child: Lottie.asset('assets/loader/loading_card.json',
                              width: SizeConfig.widthMultiplier *
                                  30.138888888888886)),
                      Container(
                          height:
                              SizeConfig.heightMultiplier * 24.60545193687231,
                          width:
                              SizeConfig.widthMultiplier * 30.138888888888886,
                          margin: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier *
                                  2.4305555555555554,
                              right: SizeConfig.widthMultiplier *
                                  2.4305555555555554),
                          child: Lottie.asset('assets/loader/loading_card.json',
                              width: SizeConfig.widthMultiplier *
                                  30.138888888888886)),
                      Container(
                          height:
                              SizeConfig.heightMultiplier * 24.60545193687231,
                          width:
                              SizeConfig.widthMultiplier * 30.138888888888886,
                          margin: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier *
                                  2.4305555555555554,
                              right: SizeConfig.widthMultiplier *
                                  2.4305555555555554),
                          child: Lottie.asset('assets/loader/loading_card.json',
                              width: SizeConfig.widthMultiplier *
                                  30.138888888888886)),
                    ],
                  )),
    ]);
  }

  Widget _relatedItemsCard(RelatedItems model) {
    double prefCurrency;
    var prefSevenDecimal;
    String _productName;

    if (!_isChinese) {
      if (model.productName.length > 8) {
        _productName = "${model.productName}...";
      } else {
        _productName = model.productName;
      }
    } else if (_isChinese) {
      if (model.chineseTitle.length > 8) {
        _productName = "${model.chineseTitle}...";
      } else {
        _productName = model.chineseTitle;
      }
    }

    if (Constants.aud != null) {
      prefCurrency = model.price / double.parse(Constants.aud);

      if (prefCurrency.toString().length > 7) {
        prefSevenDecimal = double.parse(prefCurrency.toStringAsFixed(6));
      } else {
        prefSevenDecimal = prefCurrency;
      }
    }
    return GestureDetector(
        onTap: () {
          ProductLandingRoute.productNum = model.productNum;
          ProductLandingRoute.productName = model.productName;
          RouterService.appRouter.navigateTo(ProductLandingRoute.buildPath());
        },
        child: Container(
            height: SizeConfig.heightMultiplier * 25.107604017216644,
            width: SizeConfig.widthMultiplier * 36.45833333333333,
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 0.48611111111111105,
                right: SizeConfig.widthMultiplier * 0.48611111111111105),
            child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    Container(
                        height:
                            SizeConfig.heightMultiplier * 16.319942611190818,
                        width: SizeConfig.widthMultiplier * 36.45833333333333,
                        // margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 0.6276901004304161),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: AppColors.white,
                        ),
                        child: CachedNetworkImage(
                            imageUrl: model.imgURL != null
                                ? model.imgURL
                                : 'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg',
                            placeholder: (context, url) => Lottie.asset(
                                'assets/loader/image_loading.json'),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                            imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.toolbarBlue,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover)),
                                ))),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                                left: SizeConfig.widthMultiplier *
                                    1.2152777777777777),
                            child: Text(
                                _productName.length > 14
                                    ? _productName.substring(0, 12) + '...'
                                    : _productName,
                                style: GoogleFonts.inter(
                                    fontSize: SizeConfig.textMultiplier *
                                        2.0086083213773316,
                                    color: AppColors.app_txt_color,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.15))),
                        Container(
                          margin: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier *
                                  1.2152777777777777),
                          child: Text(
                              Constants.aud != null
                                  ? '\$${model.price}'
                                  : '\$$prefSevenDecimal',
                              style: GoogleFonts.inter(
                                  fontSize: SizeConfig.textMultiplier *
                                      1.757532281205165,
                                  color: AppColors.app_txt_color,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.1)),
                        ),
                        // Container(
                        //     margin: EdgeInsets.only(
                        //         left: SizeConfig.widthMultiplier *
                        //             1.2152777777777777),
                        //     child: Row(
                        //       children: [
                        //         Icon(
                        //           CryptoFontIcons.BTC,
                        //           size: 12,
                        //           color: AppColors.app_txt_color,
                        //         ),
                        //         Text('\$$cryptoDecimal',
                        //             textAlign: TextAlign.center,
                        //             style: GoogleFonts.inter(
                        //                 fontSize: SizeConfig.textMultiplier *
                        //                     1.5064562410329987,
                        //                 color: AppColors.app_txt_color,
                        //                 fontWeight: FontWeight.w400,
                        //                 letterSpacing: 0.4))
                        //       ],
                        //     )),
                      ],
                    )
                  ],
                ))));
  }

  Widget _otherDetails(ProductDetModel model, SellerData sellerData) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((model?.saleConditions?.isNotEmpty ?? false) ||
              (_isChinese &&
                  (model.chineseSaleConditions?.isNotEmpty ?? false))) ...[
            _saleCOndition(model),
            //  _subList(model),
          ],
          if (model?.brandDescription != null ||
              model?.chineseBrandDescription != null)
            _aboutTheBrand(model),
          if ((model?.deliveryInformation?.isNotEmpty ?? false) ||
              (_isChinese &&
                  (model.chineseDeliveryInformation?.isNotEmpty ?? false)))
            _deliveryInfo(model),
          if (sellerData != null) _aboutTheSeller(sellerData),
        ],
      ),
    );
  }

  Widget _saleCOndition(ProductDetModel model) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: SizeConfig.heightMultiplier * 0.12553802008608322,
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 5.0215208034433285),
            color: AppColors.lightgrey,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884,
                    top: SizeConfig.heightMultiplier * 2.0086083213773316),
                child: Text(
                  _l10n.SaleCondition,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                      color: AppColors.app_txt_color,
                      letterSpacing: 0.1),
                ),
              ),
              Spacer(),
              if (model?.freeShipping != null && model?.freeShipping == "true")
                Container(
                  margin: EdgeInsets.only(
                      right: SizeConfig.widthMultiplier * 3.8888888888888884,
                      top: SizeConfig.heightMultiplier * 2.0086083213773316),
                  child: Text(
                    _l10n.Freeshipping,
                    style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w400,
                        color: Colors.green.shade300,
                        letterSpacing: 0.1),
                  ),
                ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 0.5021520803443329),
            child: Text(
              _isChinese
                  ? model.chineseSaleConditions
                  : model?.saleConditions[0].toUpperCase() +
                      model?.saleConditions.substring(1),
              style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  fontWeight: FontWeight.w400,
                  color: AppColors.catTextColor,
                  letterSpacing: 0.25),
            ),
          ),
        ],
      ),
    );
  }

  Widget _subList(ProductDetModel model) {
    return Container(
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 10.937499999999998,
            right: SizeConfig.widthMultiplier * 6.562499999999999,
            top: SizeConfig.heightMultiplier * 1.0043041606886658),
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            Row(
              children: [
                Container(
                  height: SizeConfig.heightMultiplier * 0.6276901004304161,
                  width: SizeConfig.widthMultiplier * 1.2152777777777777,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.catTextColor),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 1.2152777777777777),
                  child: Text(
                    '${_l10n.Courierservice}: ${model?.courierService ?? "Quisque velit nisi, pretium ut"}',
                    style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w400,
                        color: AppColors.catTextColor,
                        letterSpacing: 0.25),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  height: SizeConfig.heightMultiplier * 0.6276901004304161,
                  width: SizeConfig.widthMultiplier * 1.2152777777777777,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.catTextColor),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 1.2152777777777777),
                  child: Text(
                    '${_l10n.ShippingMethod}: ${model?.shippingMethod ?? "Quisque velit nisi, pretium ut"}',
                    style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w400,
                        color: AppColors.catTextColor,
                        letterSpacing: 0.25),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  height: SizeConfig.heightMultiplier * 0.6276901004304161,
                  width: SizeConfig.widthMultiplier * 1.2152777777777777,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.catTextColor),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 1.2152777777777777),
                  child: Text(
                    _isChinese
                        ? '${_l10n.Sellerhandlingtime}: ${model?.chineseSellerHandlingTime ?? "Quisque velit nisi, pretium ut"}'
                        : '${_l10n.Sellerhandlingtime}: ${model?.sellerHandlingTime ?? "Quisque velit nisi, pretium ut"}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w400,
                        color: AppColors.catTextColor,
                        letterSpacing: 0.25),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _aboutTheBrand(ProductDetModel model) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: SizeConfig.heightMultiplier * 0.12553802008608322,
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 5.0215208034433285),
            color: AppColors.lightgrey,
          ),
          Container(
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 2.0086083213773316),
            child: Text(
              _l10n.AboutTheBrand,
              style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  fontWeight: FontWeight.w700,
                  color: AppColors.app_txt_color,
                  letterSpacing: 0.1),
            ),
          ),
          Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                  top: SizeConfig.heightMultiplier * 0.5021520803443329),
              child: Row(
                children: [
                  if (model?.brandImg != null)
                    Container(
                      child: Image.network(
                        model?.brandImg,
                        width: width * 0.2,
                        height: SizeConfig.heightMultiplier * 9.540889526542324,
                      ),
                    ),
                  Container(
                    width: width * 0.61,
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                        right: SizeConfig.widthMultiplier * 3.8888888888888884,
                        top: SizeConfig.heightMultiplier * 0.5021520803443329),
                    child: Text(
                      _isChinese
                          ? model.chineseBrandDescription
                          : model?.brandDescription ??
                              'Brand description. Donec rutrum congue leo eget malesuada. Quisque velit nisi, pretium ut lacinia in, elemen.',
                      style: GoogleFonts.inter(
                          fontSize:
                              SizeConfig.textMultiplier * 1.757532281205165,
                          fontWeight: FontWeight.w400,
                          color: AppColors.app_txt_color,
                          letterSpacing: 0.25),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }

  Widget _deliveryInfo(ProductDetModel model) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: SizeConfig.heightMultiplier * 0.12553802008608322,
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 5.0215208034433285),
            color: AppColors.lightgrey,
          ),
          Container(
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 2.0086083213773316),
            child: Text(
              _l10n.DeliveryInformation,
              style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  fontWeight: FontWeight.w700,
                  color: AppColors.app_txt_color,
                  letterSpacing: 0.1),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 0.5021520803443329),
            child: Container(
              width: width * 0.8,
              child: Text(
                _isChinese
                    ? model.chineseDeliveryInformation
                    : model?.deliveryInformation,
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w400,
                    color: AppColors.app_txt_color,
                    letterSpacing: 0.25),
              ),
            ),
          ),
          if (model.courierService == "AusPost") _calculateShipping(),
          if (model.courierService == "AusPost" && _shippingPrice != null)
            _shippingInfoDelivery(_ProductLandingBloc.shippingPrice),
        ],
      ),
    );
  }

  Widget _calculateShipping() {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 1.2553802008608321),
      child: Row(
        children: [
          Container(
              height: SizeConfig.heightMultiplier * 5.0215208034433285,
              width: MediaQuery.of(context).size.width * 0.5,
              margin: EdgeInsets.only(
                  right: SizeConfig.widthMultiplier * 2.4305555555555554),
              child: Theme(
                data: ThemeData(
                  primaryColor: Colors.blue,
                  primaryColorDark: Colors.blue.shade700,
                ),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: _zipController,
                  maxLength: 6,
                  style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey_700,
                      letterSpacing: 0.25),
                  buildCounter: (BuildContext context,
                          {int currentLength, int maxLength, bool isFocused}) =>
                      null,
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide:
                              new BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10.0)),
                      hintText: 'Zip Code',
                      contentPadding: EdgeInsets.only(
                          left:
                              SizeConfig.widthMultiplier * 3.8888888888888884),
                      suffixStyle: const TextStyle(color: AppColors.appBlue)),
                ),
              )),
          InkWell(
            onTap: () {
              if (_zipController.text.length == 0) {
                _showToast("Please enter zip code.");
              } else {
                setState(() {
                  _priceCalculatorLoading = true;
                });
                _ProductLandingBloc.zipCode = _zipController.text;
                _ProductLandingBloc.add(CalculateShippingEvent());
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: SizeConfig.heightMultiplier * 5.0215208034433285,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.appBlue)),
              child: Center(
                child: _priceCalculatorLoading
                    ? Lottie.asset('assets/loader/loding_dots.json',
                        height: SizeConfig.heightMultiplier * 1.757532281205165,
                        width: SizeConfig.widthMultiplier * 4.861111111111111)
                    : Text(
                        'Calculate',
                        style: GoogleFonts.inter(
                          fontSize:
                              SizeConfig.textMultiplier * 1.757532281205165,
                          color: AppColors.appBlue,
                        ),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _aboutTheSeller(SellerData sellerData) {
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        height: SizeConfig.heightMultiplier * 0.12553802008608322,
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: SizeConfig.widthMultiplier * 3.8888888888888884,
            top: SizeConfig.heightMultiplier * 5.0215208034433285),
        color: AppColors.lightgrey,
      ),
      Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 4.142754662840746),
            child: Text(
              _l10n.AboutTheSeller,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                color: AppColors.app_txt_color,
              ),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () async {
              context.read<RouteServiceProvider>().queryProductName =
                  this._product;
              RouterService.appRouter.navigateTo(
                  '/dashboard/messageChat?isCreating=true&uid=${this._sellerData.uid}&name=${this._sellerData.sellerDisplayName}');
            },
            child: Container(
              height: SizeConfig.heightMultiplier * 2.5107604017216643,
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  right: SizeConfig.widthMultiplier * 3.645833333333333,
                  top: SizeConfig.heightMultiplier * 4.017216642754663),
              padding: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 1.9444444444444442,
                  right: SizeConfig.widthMultiplier * 1.9444444444444442,
                  top: SizeConfig.heightMultiplier * 0.25107604017216645,
                  bottom: SizeConfig.heightMultiplier * 0.25107604017216645),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.seeAllText,
                      width: SizeConfig.widthMultiplier * 0.24305555555555552),
                  color: AppColors.seeAllBack),
              child: Text(
                _l10n.CONTACTSELLER,
                style: TextStyle(
                  color: AppColors.seeAllText,
                  fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                ),
              ),
            ),
          ),
        ],
      ),
      Container(
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            top: SizeConfig.heightMultiplier * 1.0043041606886658,
            right: SizeConfig.widthMultiplier * 3.645833333333333),
        child: Row(
          children: [
            Container(
              width: SizeConfig.widthMultiplier * 18.47222222222222,
              height: SizeConfig.heightMultiplier * 9.540889526542324,
              child: ClipOval(
                child: Image.asset('assets/images/seller_img.png'),
              ),
            ),
            if (sellerData != null) _aboutTheSellerText(sellerData),
          ],
        ),
      ),
    ]));
  }

  Widget _aboutTheSellerText(SellerData sellerData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 2.6736111111111107),
          child: Text(
            sellerData?.sellerDisplayName ?? "",
            style: GoogleFonts.inter(
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25,
                color: AppColors.app_txt_color),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 2.6736111111111107,
              top: SizeConfig.heightMultiplier * 0.5021520803443329),
          child: Text(
            sellerData?.sellerBio ?? "",
            style: GoogleFonts.inter(
                fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.4,
                color: AppColors.app_txt_color),
          ),
        ),
        if (sellerData?.sellerVerificationStatus == 1)
          Container(
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 2.6736111111111107,
                top: SizeConfig.heightMultiplier * 1.5064562410329987),
            child: Row(
              children: [
                Text(
                  _l10n.Confirmseller,
                  style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.4,
                      color: AppColors.catTextColor),
                ),
                const SizedBox(width: 5),
                Icon(
                  Icons.verified_user_rounded,
                  color: AppColors.catTextColor,
                  size: 14,
                )
              ],
            ),
          ),
        if (sellerData?.sellerVerificationStatus == 0)
          Container(
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 2.6736111111111107,
                top: SizeConfig.heightMultiplier * 1.5064562410329987),
            child: Text(
              _l10n.sellerNotConfirmed,
              style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.4,
                  color: AppColors.catTextColor),
            ),
          ),
        Row(
          children: [
            Container(
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 2.6736111111111107,
                    top: SizeConfig.heightMultiplier * 0.5021520803443329),
                child: RatingBar(
                  itemSize: 16,
                  glow: false,
                  initialRating: sellerData?.sellerRating ?? 0,
                  itemCount: 5,
                  allowHalfRating: true,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Image.asset(
                          'assets/images/feedback_star.png',
                          width:
                              SizeConfig.widthMultiplier * 3.8888888888888884,
                          height:
                              SizeConfig.heightMultiplier * 2.0086083213773316,
                        );
                      case 1:
                        return Image.asset(
                          'assets/images/feedback_star.png',
                          width:
                              SizeConfig.widthMultiplier * 3.8888888888888884,
                          height:
                              SizeConfig.heightMultiplier * 2.0086083213773316,
                        );
                      case 2:
                        return Image.asset(
                          'assets/images/feedback_star.png',
                          width:
                              SizeConfig.widthMultiplier * 3.8888888888888884,
                          height:
                              SizeConfig.heightMultiplier * 2.0086083213773316,
                        );
                      case 3:
                        return Image.asset(
                          'assets/images/feedback_star.png',
                          width:
                              SizeConfig.widthMultiplier * 3.8888888888888884,
                          height:
                              SizeConfig.heightMultiplier * 2.0086083213773316,
                        );
                      default:
                        return Image.asset(
                          'assets/images/feedback_star.png',
                          width:
                              SizeConfig.widthMultiplier * 3.8888888888888884,
                          height:
                              SizeConfig.heightMultiplier * 2.0086083213773316,
                        );
                    }
                  },
                  onRatingUpdate: (rating) {
                    setState(() {
                      // _rating = rating;
                    });
                    // print(rating);
                  },
                )),

            // Spacer(),
            Container(
              margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 0.5021520803443329,
              ),
              padding: EdgeInsets.all(5),
              child: Text(
                '${sellerData?.sellerRating}/5 out of ${sellerData?.numRaters} reviews.',
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.4,
                    color: AppColors.catTextColor),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _customTitle(ProductDetModel model) {
    return PreferredSize(
        preferredSize: Size.fromHeight(
            SizeConfig.heightMultiplier * 16.571018651362985704000955107872),
        child: Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          width: MediaQuery.of(context).size.width,
          // height: SizeConfig.heightMultiplier * 2.5107604017216643,
          // elevation: 2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _productTitleRow(model),
              if (_isChinese && (model?.chineseTags?.isNotEmpty ?? false))
                Container(
                    height: SizeConfig.heightMultiplier * 2.5107604017216643,
                    child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children:
                            model.chineseTags?.map((e) => _tags(e))?.toList())),
              if (!_isChinese && (model?.tags?.isNotEmpty ?? false))
                Container(
                    height: SizeConfig.heightMultiplier * 2.5107604017216643,
                    child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: model?.tags?.map((e) => _tags(e))?.toList())),
            ],
          ),
        ));
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
                                  onTap: () => Navigator.pop(context),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: SizeConfig.widthMultiplier *
                                            2.4305555555555554),
                                    child: SvgPicture.asset(
                                      'assets/images/Back_button.svg',
                                      width: SizeConfig.widthMultiplier *
                                          7.833333333333333,
                                      height: SizeConfig.heightMultiplier *
                                          5.0129124820659974,
                                    ),
                                  )),
                              Container(
                                padding: EdgeInsets.only(
                                    left: SizeConfig.widthMultiplier *
                                        2.4305555555555554),
                                width: SizeConfig.widthMultiplier * 45,
                                height: SizeConfig.heightMultiplier * 3,
                                child: _product.length > 15
                                    ? Marquee(
                                        text: _product ?? _l10n.ProductLanding,
                                        style: TextStyle(
                                            color: AppColors.white,
                                            fontFamily: 'inter',
                                            fontStyle: FontStyle.normal,
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    2.0086083213773316,
                                            fontWeight: FontWeight.w300),
                                        // pauseAfterRound: Duration(seconds: 1),
                                        blankSpace: 100.0,
                                      )
                                    : Text(
                                        _product,
                                        style: TextStyle(
                                            color: AppColors.white,
                                            fontFamily: 'inter',
                                            fontStyle: FontStyle.normal,
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    2.0086083213773316,
                                            fontWeight: FontWeight.w300),
                                      ),

                                // child: SingleChildScrollView(
                                //   scrollDirection: Axis.horizontal,
                                //   child: Text(
                                //     _product ?? _l10n.ProductLanding,
                                //     style: TextStyle(
                                //         color: AppColors.white,
                                //         fontFamily: 'inter',
                                //         fontStyle: FontStyle.normal,
                                //         fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                                //         fontWeight: FontWeight.w300),
                                //   ),
                                // ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                      width: SizeConfig.widthMultiplier * 25.388888888888886,
                      height: SizeConfig.heightMultiplier * 5.0129124820659974,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          // left: SizeConfig.widthMultiplier * 2.9166666666666665,
                          top: SizeConfig.heightMultiplier * 1.5064562410329987,
                          // right:
                          //     SizeConfig.widthMultiplier * 2.9166666666666665,
                          bottom:
                              SizeConfig.heightMultiplier * 1.0043041606886658),
                      child: Row(
                        children: [
                          // Padding(
                          //   padding: EdgeInsets.only(
                          //       right: SizeConfig.widthMultiplier *
                          //           1.9444444444444442),
                          //   child: SvgPicture.asset(
                          //     'assets/images/pin.svg',
                          //     height: SizeConfig.heightMultiplier *
                          //         3.0129124820659974,
                          //     width: SizeConfig.widthMultiplier *
                          //         5.833333333333333,
                          //   ),
                          // ),
                          InkWell(
                              onTap: () {
                                OrderCheckoutRoute.isBuyNow = false;
                                var route = RouterService.appRouter
                                    .navigateTo(CartRoute.buildPath())
                                    .then((value) {
                                  setState(() {
                                    if (value != null && value == "Success") {
                                      Constants.cartCount = Constants.cartCount;
                                      _ProductLandingBloc.add(
                                          ProductLandingScreenEvent());
                                    }
                                  });
                                });
                              },
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      right: SizeConfig.widthMultiplier *
                                          1.9444444444444442),
                                  child: Constants.cartCount == 0
                                      ? SvgPicture.asset(
                                          'assets/images/cart.svg',
                                          // height: SizeConfig.heightMultiplier *
                                          //     4.809124820659974,
                                          width: SizeConfig.widthMultiplier *
                                              7.529,
                                          height: SizeConfig.heightMultiplier *
                                              10.20)
                                      : Badge(
                                          badgeContent: Text(
                                            '${Constants.cartCount}',
                                            style: GoogleFonts.inter(
                                                color: AppColors.white,
                                                fontSize:
                                                    SizeConfig.textMultiplier *
                                                        1.3809182209469155),
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/images/cart.svg',
                                            // height:
                                            //     SizeConfig.heightMultiplier *
                                            //         4.809124820659974,
                                            width: SizeConfig.widthMultiplier *
                                                7.529,
                                          ),
                                        ))),
                          // InkWell(
                          //   onTap: () {
                          //     RouterService.appRouter
                          //         .navigateTo(NotificationRoute.buildPath());
                          //   },
                          //   child: SvgPicture.asset(
                          //     'assets/images/la_bell.svg',
                          //     height: SizeConfig.heightMultiplier *
                          //         3.0129124820659974,
                          //     width: SizeConfig.widthMultiplier *
                          //         5.833333333333333,
                          //   ),
                          // ),
                        ],
                      )),
                ],
              )),
        ),
        preferredSize: Size.fromHeight(
            SizeConfig.heightMultiplier * 16.571018651362985704000955107872));
  }

  OverlayEntry _createOverlayEntry(List<Variation> _dropdownList,
      GlobalKey<ScaffoldState> actionKey, TextEditingController controller) {
    RenderBox renderBox =
        actionKey.currentContext?.findRenderObject(); //EDIT THIS LINE
    var size = renderBox.size;
    var height = renderBox.size.height;
    var width = renderBox.size.width;

    var offset = renderBox.localToGlobal(Offset.zero);
    var xPosition = offset.dx;
    var yPosition = offset.dy;
    // print('xPosition $xPosition');
    // print('yPosition $yPosition');

    return OverlayEntry(
      builder: (context) => Positioned(
          left: xPosition,
          width: width,
          top: yPosition,
          child: Container(
              height: SizeConfig.heightMultiplier * 15.064562410329986,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.text_field_container,
                          width: SizeConfig.widthMultiplier *
                              0.48611111111111105)),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: _dropdownList
                        .map((value) => InkWell(
                              onTap: () {
                                setState(() {
                                  _overlayEntry.remove();
                                  controller.text = value.variationLabel;
                                });
                              },
                              child: value == _dropdownList[0]
                                  ? ListTile(
                                      title: Text(
                                        value.variationLabel,
                                        style: GoogleFonts.inter(
                                            color: AppColors.catTextColor,
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    1.757532281205165),
                                      ),
                                      trailing: Icon(Icons.keyboard_arrow_down),
                                    )
                                  : ListTile(
                                      title: Text(
                                        value.variationLabel,
                                        style: GoogleFonts.inter(
                                            color: AppColors.catTextColor,
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    1.757532281205165),
                                      ),
                                    ),
                            ))
                        .toList(),
                  ),
                ),
              ))),
    );
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.appBlue,
        textColor: AppColors.white,
        fontSize: SizeConfig.textMultiplier * 2.0086083213773316);
  }

  Widget _imagePageView() {
    return Stack(
      children: [
        Container(
            child: PageView.builder(
          physics: PageScrollPhysics(),
          itemCount:
              _ProductLandingBloc?.productDetailModel?.productImages.length,
          onPageChanged: (index) {
            setState(() {
              slideIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return _imageContainer(
                _ProductLandingBloc?.productDetailModel?.productImages[index]);
          },
        )),
        if (_ProductLandingBloc?.productDetailModel?.productImages?.length > 1)
          Positioned(
            top: SizeConfig.heightMultiplier * 30.21520803443329,
            left: MediaQuery.of(context).size.width * 0.45,
            child: _bottomSheet(true),
          ),
        if (slideIndex > 0)
          Positioned(
              top: SizeConfig.heightMultiplier * 10.1520803443329,
              left: 0,
              child: twistedImageAssetNext),
        if (slideIndex <
            _ProductLandingBloc?.productDetailModel?.productImages?.length - 1)
          Positioned(
              top: SizeConfig.heightMultiplier * 10.1520803443329,
              left: MediaQuery.of(context).size.width * 0.95,
              child: imageAssetNext),
      ],
    );
  }

  Widget _imageContainer(String image) {
    return Container(
      child: CachedNetworkImage(
        imageUrl: image != null
            ? image
            : 'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg',
        placeholder: (context, url) =>
            Lottie.asset('assets/loader/image_loading.json'),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.fill,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
              color: AppColors.toolbarBlue,
              image: DecorationImage(image: imageProvider, fit: BoxFit.fill)),
        ),
      ),
    );
  }

  Widget _bottomSheet(bool isCurrentPage) {
    return AnimatedContainer(
      margin: EdgeInsets.only(
        bottom: SizeConfig.heightMultiplier * 15.107604017216644,
        top: SizeConfig.heightMultiplier * 14.0086083213773316,
      ),
      duration: Duration(milliseconds: 500),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (int i = 0;
            i < _ProductLandingBloc?.productDetailModel?.productImages.length;
            i++)
          i == slideIndex
              ? _bottomSheetContainer(true,
                  _ProductLandingBloc?.productDetailModel?.productImages[i])
              : _bottomSheetContainer(false,
                  _ProductLandingBloc?.productDetailModel?.productImages[i]),
      ]),
    );
  }

  Widget _bottomSheetContainer(bool isCurrentPage, String image) {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 0.9722222222222221),
      height: isCurrentPage ? 8 : 8,
      width: isCurrentPage ? 8 : 8,
      decoration: BoxDecoration(
          color: isCurrentPage ? Color(0xff034AA6) : Color(0xffD4D4D4),
          shape: BoxShape.circle),
    );
  }
}
