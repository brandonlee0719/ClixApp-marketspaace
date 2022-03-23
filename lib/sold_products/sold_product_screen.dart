import 'dart:collection';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/multi_selected_chip.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/model/buyer_info_model/buyer_info_model.dart';
import 'package:market_space/model/product_model.dart';
import 'package:market_space/model/sold_product_model/sold_product_model.dart';
import 'package:market_space/notification/representation/widgets/screen/recentBuywidget.dart';
import 'package:market_space/product_landing_screen/product_landing_route.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/sold_product_detail/sold_detail_route.dart';
import 'package:market_space/sold_products/sold_product_bloc.dart';
import 'package:market_space/sold_products/sold_product_event.dart';
import 'package:market_space/sold_products/sold_product_l10n.dart';
import 'package:market_space/sold_products/sold_product_route.dart';
import 'package:market_space/sold_products/sold_product_state.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class SoldProductScreen extends StatefulWidget {
  @override
  _SoldProductScreenState createState() => _SoldProductScreenState();
}

class _SoldProductScreenState extends State<SoldProductScreen> {
  final SoldProductBloc _SoldProductBloc = SoldProductBloc(Initial());
  SoldProductL10n _l10n = SoldProductL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  bool _isLoading = false;
  bool _buyerInfoLoading = false;
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  String _selectedItem;
  bool _filterSelected = false;
  bool _currentStatus = false;
  List<String> _dropdownItems = ["Filter By"];
  List<String> _categoryList = ["Software", "Movies", "Clothing"];
  final Set<String> _expandedItems = HashSet();
  final TextEditingController _trackingController = TextEditingController();
  final TextEditingController _shippingController = TextEditingController();
  bool _isTags = false;
  final _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _SoldProductBloc.add(SoldProductScreenEvent());
    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = SoldProductL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n = SoldProductL10n(Locale.fromSubtags(languageCode: 'zh'));
      }
    });
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _globalKey,
      backgroundColor: AppColors.toolbarBlue,
      appBar: Toolbar(
        title: _l10n.SOLDPRODUCTS,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.white,
        child: BlocProvider(
          create: (_) => _SoldProductBloc,
          child:
          // BlocListener<SoldProductBloc, SoldProductState>(
          //     listener: (context, state) {
          //       if (state is Loading) {
          //         setState(() {
          //           _isLoading = true;
          //         });
          //       }
          //       if (state is Loaded) {
          //         setState(() {
          //           _isLoading = false;
          //           // _categoryList = _SoldProductBloc.categoryList;
          //         });
          //       }
          //       if (state is BuyerInfoLoaded) {
          //         setState(() {
          //           _buyerInfoLoading = false;
          //           _buyerInfoDialog();
          //         });
          //       }
          //       if (state is BuyerInfoFailed) {
          //         setState(() {
          //           _buyerInfoLoading = false;
          //           _showSnackBar('Fetching buyer info failed');
          //         });
          //       }
          //
          //       if (state is MarkItemShippedSuccessfully) {
          //         setState(() {
          //           _trackingController.clear();
          //         });
          //         _showToast('Item Marked Successfully');
          //       }
          //       if (state is MarkItemShippedFailed) {
          //         _showToast('Mark Item Failed');
          //       }
          //     },
          //     child:
          ListView(
                shrinkWrap: true,
                children: [
                  _filter(),
                  RecentBuyWidget(isPart: false, isBuy: false,),
                ],
              )
      // ),
        ),
      ),
    );
  }

  Widget _baseScreen() {
    return Expanded(

      child: RecentBuyWidget(isPart: false,),
    );
  }

  Widget _recentlyProductCard(Orders model) {
    bool isExpanded = _expandedItems.contains(model.orderID);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_expandedItems.contains(model.orderID)) {
            _expandedItems.remove(model.orderID);
          } else {
            _expandedItems.add(model.orderID);
          }
        });
      },
      child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 2.5107604017216643),
          // height: isExpanded ? 314 : 135,
          child: isExpanded
              ? _expandedProductCard(model)
              : Card(
                  child: Row(
                  children: [
                    Container(
                      width: SizeConfig.widthMultiplier * 29.166666666666664,
                      child: _recentlyImage(model),
                    ),
                    Container(
                      child: _SoldProductTxt(model),
                    )
                  ],
                ))),
    );
  }

  Widget _recentlyImage(Orders model) {
    return Stack(
      children: [
        Container(
          child: CachedNetworkImage(
            imageUrl: model.imgLink != null
                ? model.imgLink
                : 'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg',
            placeholder: (context, url) =>
                Lottie.asset('assets/loader/image_loading.json'),
            errorWidget: (context, url, error) =>
                Image.asset('assets/images/shoes.png'),
            fit: BoxFit.fill,
            height: SizeConfig.heightMultiplier * 15.692252510760403,
            width: double.infinity,
          ),
        ),
        Container(
          height: SizeConfig.heightMultiplier * 2.5107604017216643,
          margin: EdgeInsets.only(
              top: SizeConfig.heightMultiplier * 12.679340028694405,
              left: SizeConfig.widthMultiplier * 1.7013888888888886,
              bottom: SizeConfig.heightMultiplier * 0.5021520803443329,
              right: SizeConfig.widthMultiplier * 1.7013888888888886),
          padding: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 0.7291666666666666,
              right: SizeConfig.widthMultiplier * 0.7291666666666666),
          decoration: BoxDecoration(
              color: AppColors.white, borderRadius: BorderRadius.circular(18)),
          child: Center(
              child: Text(
            model.shippingStatus,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
              fontWeight: FontWeight.w400,
            ),
          )),
        ),
      ],
    );
  }

  Widget _SoldProductTxt(Orders model) {
    if (model.tags == null) {
      _isTags = false;
    } else {
      _isTags = true;
    }
    return Container(
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                  onTap: () {
                    // ProductLandingRoute.productNum = model.productNum;
                    // RouterService.appRouter
                    //     .navigateTo(ProductLandingRoute.buildPath());
                  },
                  child: Row(children: [
                    GestureDetector(
                      onTap: () {
                        // ProductLandingRoute.productNum = model.productNum;
                        // RouterService.appRouter.navigateTo(ProductLandingRoute.buildPath());
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.widthMultiplier *
                                      2.9166666666666665,
                                  top: SizeConfig.heightMultiplier *
                                      1.0043041606886658),
                              child: Text(model.title,
                                  style: GoogleFonts.inter(
                                      fontSize: SizeConfig.textMultiplier *
                                          2.259684361549498,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.15)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Spacer(),
                    Expanded(
                        child: Container(
                            margin: EdgeInsets.only(
                                left: SizeConfig.widthMultiplier *
                                    4.861111111111111),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: SizeConfig.heightMultiplier *
                                          1.0043041606886658,
                                      right: SizeConfig.widthMultiplier *
                                          1.2152777777777777),
                                  child: Expanded(
                                    child: Text(
                                      '\$${model.fiatPrice}',
                                      maxLines: 1,
                                      // overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                          fontSize: SizeConfig.textMultiplier *
                                              1.757532281205165,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.1),
                                    ),
                                  ),
                                ),
                                // Container(
                                //     margin: EdgeInsets.only(right: SizeConfig.widthMultiplier * 1.2152777777777777),
                                //     child: Row(children: [
                                //       Icon(CryptoFontIcons.BTC, size: 12,),
                                //       Expanded(child: Text(
                                //         model.cryptoCheckoutPriceSeller,
                                //         maxLines: 1,
                                //         // overflow: TextOverflow.ellipsis,
                                //         style: GoogleFonts.inter(
                                //             fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                                //             fontWeight: FontWeight.w400,
                                //             letterSpacing: 0.4),
                                //       )),
                                //     ],)
                                // ),
                              ],
                            ))),
                  ])),
            ])),
            if (_isTags)
              Container(
                  height: SizeConfig.heightMultiplier * 6.276901004304161,
                  // width: SizeConfig.widthMultiplier * 60.76388888888888,
                  child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      childAspectRatio: 0.35,
                      scrollDirection: Axis.horizontal,
                      children: model.tags.map((e) => _tags(e))?.toList())),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 2.9166666666666665,
                  top: SizeConfig.heightMultiplier * 1.0043041606886658,
                  right: SizeConfig.widthMultiplier * 1.9444444444444442),
              child: Text(
                model?.description ?? "",
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                    fontWeight: FontWeight.w400,
                    color: AppColors.catTextColor,
                    letterSpacing: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tags(String tag) {
    Color color;
    if (tag.length <= 3) {
      color = AppColors.tag_short;
    } else if (tag.length > 3 && tag.length < 6) {
      color = AppColors.tag_normal;
    } else if (tag.length > 6 && tag.length < 8) {
      color = AppColors.tag_medium;
    } else if (tag.length > 8) {
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

  Widget _filter() {
    return GestureDetector(
      onTap: () {
        _showReportDialog();
      },
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: SizeConfig.heightMultiplier * 2.5107604017216643,
              width: SizeConfig.widthMultiplier * 19.444444444444443,
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 4.131944444444444,
                  top: SizeConfig.heightMultiplier * 2.1341463414634148),
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
              child: Row(
                children: [
                  Image.asset('assets/images/filter.png'),
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 0.48611111111111105),
                    child: Text(
                      'FILTER BY',
                      style: TextStyle(
                          fontSize:
                              SizeConfig.textMultiplier * 1.2553802008608321,
                          color: AppColors.appBlue,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: SizeConfig.heightMultiplier * 2.5107604017216643,
              width: SizeConfig.widthMultiplier * 27.70833333333333,
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 4.131944444444444,
                  top: SizeConfig.heightMultiplier * 2.1341463414634148),
              padding: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 1.9444444444444442,
                  right: SizeConfig.widthMultiplier * 1.9444444444444442,
                  top: SizeConfig.heightMultiplier * 0.25107604017216645,
                  bottom: SizeConfig.heightMultiplier * 0.25107604017216645),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.white,
                      width: SizeConfig.widthMultiplier * 0.24305555555555552),
                  color: AppColors.appBlue),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppColors.white,
                    size: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 0.48611111111111105),
                    child: Text(
                      'LAST 3 MONTHS',
                      style: TextStyle(
                          fontSize:
                              SizeConfig.textMultiplier * 1.2553802008608321,
                          color: AppColors.white,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Row(
            children: [
              Image.asset('assets/images/filter.png'),
              Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  listItem,
                  style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      color: AppColors.toolbarBlue),
                ),
              )
            ],
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("filter"),
            content: MultiSelectChip(_categoryList),
            actions: <Widget>[
              FlatButton(
                child: Text("Save"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  Widget _expandedProductCard(Orders model) {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: SizeConfig.widthMultiplier * 29.166666666666664,
              child: _recentlyImage(model),
            ),
            Container(
              child: _SoldProductTxt(model),
            ),
          ],
        ),
        Container(
          child: _expandedText(model),
        ),
      ],
    ));
  }

  Widget _expandedText(Orders model) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 0.25107604017216645),
            height: SizeConfig.heightMultiplier * 0.12553802008608322,
            decoration: BoxDecoration(
                color: AppColors.lightgrey, shape: BoxShape.rectangle),
          ),
          _orderStatus(model),
        ],
      ),
    );
  }

  Widget _orderStatus(Orders model) {
    _trackingController.text = model.trackingNumber;
    _shippingController.text = model.shippingCompany;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 1.9444444444444442,
                top: SizeConfig.heightMultiplier * 1.5064562410329987),
            child: Text(
              '${_l10n.ItemShippedCheck}?',
              style: GoogleFonts.inter(
                  color: AppColors.app_txt_color,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.1,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.0043041606886658,
                left: SizeConfig.widthMultiplier * 1.9444444444444442,
                right: SizeConfig.widthMultiplier * 1.9444444444444442),
            child: Theme(
              data: ThemeData(
                primaryColor: AppColors.appBlue,
                primaryColorDark: AppColors.appBlue,
              ),
              child: TextField(
                controller: _trackingController,
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText: _l10n.TrackingNumber,
                    labelText: _l10n.TrackingNumber,
                    contentPadding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884),
                    suffixStyle: const TextStyle(color: AppColors.appBlue)),
                maxLength: 35,
                buildCounter: (BuildContext context,
                        {int currentLength, int maxLength, bool isFocused}) =>
                    null,
                onChanged: (value) {},
              ),
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 1.0043041606886658, left: SizeConfig.widthMultiplier * 1.9444444444444442, right: SizeConfig.widthMultiplier * 1.9444444444444442),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10.0),
          //     border: Border.all(color: Colors.grey.shade300),
          //   ),
          //   child: Text(model.trackingNumber ?? "",
          //       style: TextStyle(
          //           color: AppColors.appBlue,
          //           fontSize: SizeConfig.textMultiplier * 1.757532281205165,
          //           fontWeight: FontWeight.bold)),
          // ),

          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.0043041606886658,
                left: SizeConfig.widthMultiplier * 1.9444444444444442,
                right: SizeConfig.widthMultiplier * 1.9444444444444442),
            child: Theme(
              data: ThemeData(
                primaryColor: AppColors.appBlue,
                primaryColorDark: AppColors.appBlue,
              ),
              child: TextField(
                controller: _shippingController,
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText: _l10n.ShippingCompany,
                    labelText: _l10n.ShippingCompany,
                    contentPadding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884),
                    suffixStyle: const TextStyle(color: AppColors.appBlue)),
              ),
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 1.0043041606886658, left: SizeConfig.widthMultiplier * 1.9444444444444442, right: SizeConfig.widthMultiplier * 1.9444444444444442),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10.0),
          //     border: Border.all(color: Colors.grey.shade300),
          //   ),
          //   child: Text(model.shippingCompany ?? "",
          //       style: TextStyle(
          //           color: AppColors.appBlue,
          //           fontSize: SizeConfig.textMultiplier * 1.757532281205165,
          //           fontWeight: FontWeight.bold)),
          // ),
          Row(children: [
            GestureDetector(
              onTap: () {
                SoldDetailRoute.order = model;
                if (_trackingController.text != null &&
                    _trackingController.text != "") {
                  SoldDetailRoute.trackingNumber = _trackingController.text;
                }
                if (_shippingController.text != null &&
                    _shippingController.text != "") {
                  SoldDetailRoute.shippingCompany = _shippingController.text;
                }
                RouterService.profileRouter
                    .navigateTo(SoldDetailRoute.buildPath());
              },
              child: Container(
                width: SizeConfig.widthMultiplier * 24.305555555555554,
                margin: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 2.0086083213773316,
                  left: SizeConfig.widthMultiplier * 2.9166666666666665,
                ),
                child: Text(_l10n.moreOptions,
                    style: TextStyle(
                        color: AppColors.appBlue,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  _buyerInfoLoading = true;
                  _SoldProductBloc.orderId = model.orderID;
                  _SoldProductBloc.add(SoldProductBuyerInfoEvent());
                });
              },
              child: Container(
                width: SizeConfig.widthMultiplier * 19.444444444444443,
                margin: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 2.0086083213773316,
                ),
                child: _buyerInfoLoading
                    ? Lottie.asset('assets/loader/widget_loading.json',
                        height:
                            SizeConfig.heightMultiplier * 3.7661406025824964,
                        width: SizeConfig.widthMultiplier * 19.444444444444443)
                    : Text(_l10n.BuyerInfo,
                        style: TextStyle(
                            color: AppColors.appBlue,
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.bold)),
              ),
            ),
            Spacer(),
            Container(
              width: SizeConfig.widthMultiplier * 19.444444444444443,
              margin: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 2.0086083213773316,
                  right: SizeConfig.widthMultiplier * 2.9166666666666665),
              child: Text(_l10n.CancelOrder,
                  style: TextStyle(
                      color: AppColors.cancel_red,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165)),
            ),
          ]),
          _markItemButton(model),
        ],
      ),
    );
  }

  void _buyerInfoDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: Container(
                alignment: Alignment.center,
                child: Text(
                  _l10n.BuyerInfo,
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                      fontWeight: FontWeight.w600),
                ),
              ),
              content: StreamBuilder(
                stream: _SoldProductBloc.buyerInfoStream,
                builder: (context, stream) {
                  if (stream.connectionState == ConnectionState.done) {}

                  if (stream.hasData) {
                    return _alertDialogContent(context, stream.data);
                  } else {
                    return Container(
                      child: Center(
                        child: Lottie.asset('assets/loader/loading_icon.json',
                            width:
                                SizeConfig.widthMultiplier * 19.444444444444443,
                            height: SizeConfig.heightMultiplier *
                                10.043041606886657),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        });
  }

  Widget _alertDialogContent(BuildContext context, BuyerInfoModel model) {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 1.2152777777777777,
          right: SizeConfig.widthMultiplier * 1.2152777777777777,
          top: SizeConfig.heightMultiplier * 0.5021520803443329),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          child: Text(
            '${_l10n.Name} : ${model.buyerDisplayName}',
            style: GoogleFonts.inter(
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.1),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: SizeConfig.heightMultiplier * 1.0043041606886658),
          child: Text(
            '${_l10n.ShippingAddress} : ${model.streetAddress}, ${model.suburb}, ${model.state}, ${model.postcode.trim()}',
            style: GoogleFonts.inter(
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.1),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: SizeConfig.heightMultiplier * 1.0043041606886658),
          child: Expanded(
            child: Text(
              '${_l10n.ShippingInstructions} : ${model.instructions}',
              style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1),
            ),
          ),
        ),
      ]),
    );
  }

  _showSnackBar(String snackText) {
    final snackBar = SnackBar(
      content: Text(snackText),
    );
    _globalKey.currentState.showSnackBar(snackBar);
  }

  Widget _markItemButton(Orders model) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: SizeConfig.heightMultiplier * 6.025824964131995,
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 2.5107604017216643,
          left: SizeConfig.widthMultiplier * 1.9444444444444442,
          right: SizeConfig.widthMultiplier * 1.9444444444444442,
          bottom: SizeConfig.heightMultiplier * 0.5021520803443329),
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
              _l10n.MARKITEMSHIPPED,
              style: GoogleFonts.inter(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.5,
                  textStyle: TextStyle(fontFamily: 'Roboto')),
            )),
        onPressed: () {
          FocusScope.of(context).unfocus();
          if (_trackingController.text.length == 0) {
            _showToast("${_l10n.enterTrackingNumber}.");
          } else if (_trackingController.text.length == 0) {
            _showToast("${_l10n.enterShippingCompany}.");
          } else {
            _SoldProductBloc.orderId = model.orderID;
            _SoldProductBloc.add(MarkItemShippedEvent());
          }
        },
      ),
    );
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.appBlue,
        textColor: Colors.white,
        fontSize: SizeConfig.textMultiplier * 2.0086083213773316);
  }
}
