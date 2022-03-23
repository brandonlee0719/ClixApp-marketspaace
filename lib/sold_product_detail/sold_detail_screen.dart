import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/multi_selected_chip.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/main.dart';
import 'package:market_space/model/order/order_model.dart';
import 'package:market_space/model/product_model.dart';
import 'package:market_space/model/promo_model.dart';
import 'package:market_space/model/seller_option_model/seller_options_model.dart';
import 'package:market_space/model/sold_product_model/sold_product_model.dart';
import 'package:market_space/sold_product_detail/sold_detail_bloc.dart';
import 'package:market_space/sold_product_detail/sold_detail_event.dart';
import 'package:market_space/sold_product_detail/sold_detail_l10n.dart';
import 'package:market_space/sold_product_detail/sold_detail_route.dart';
import 'package:market_space/sold_product_detail/sold_detail_state.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class SoldDetailScreen extends StatefulWidget {
  @override
  _SoldDetailScreenState createState() => _SoldDetailScreenState();
}

class _SoldDetailScreenState extends State<SoldDetailScreen> {
  final SoldDetailBloc _SoldDetailBloc = SoldDetailBloc(Initial());
  bool _isLoading = false;
  SoldDetailL10n _l10n =
      SoldDetailL10n(Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  List<String> _categoryList;
  List<ProductModel> _productList = List();
  bool _currentStatus = false;
  List<String> _dropdownItems = ["Reason", "Yes", "No"];
  List<String> _dropdownClaimItems = [
    "Claim",
    "Item no longer available",
    "Mistakenly listed",
    "Other"
  ];
  List<String> _dropdownExtendedProtection = [
    "Reason",
    "Item is still in transit",
    "Purchase protection is running out",
    "Other"
  ];
  String _selectedItem;
  String _claimReason;
  String _extendedReason;

  List<DropdownMenuItem<String>> _dropdownMenuItems;
  List<DropdownMenuItem<String>> _dropdownMenuClaimItems;
  List<DropdownMenuItem<String>> _dropdownMenuExtendedItems;
  double _rating = 0.0;
  final TextEditingController _trackingController = TextEditingController();
  final TextEditingController _shippingController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _claimController = TextEditingController();
  final TextEditingController _feedbackCommentController =
      TextEditingController();
  bool _isTags = false;
  bool _feedbackClicked = false;
  SellerOptionsModel _sellerOptionsModel;

  @override
  void initState() {
    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = SoldDetailL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n = SoldDetailL10n(Locale.fromSubtags(languageCode: 'zh'));
      }

      _categoryList = [_l10n.Software, _l10n.Movies, _l10n.Clothing];
    });
    _SoldDetailBloc.add(SoldDetailScreenEvent());
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;

    _dropdownMenuClaimItems = buildDropDownMenuItems(_dropdownClaimItems);
    _claimReason = _dropdownMenuClaimItems[0].value;

    _dropdownMenuExtendedItems =
        buildDropDownMenuItems(_dropdownExtendedProtection);
    _extendedReason = _dropdownMenuExtendedItems[0].value;
    if (SoldDetailRoute.shippingCompany != null) {
      _shippingController.text = SoldDetailRoute.shippingCompany;
    }
    if (SoldDetailRoute.trackingNumber != null) {
      _trackingController.text = SoldDetailRoute.trackingNumber;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.toolbarBlue,
      appBar: Toolbar(
        title: '${_l10n.SOLD} ${_l10n.PRODUCTS}',
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.white,
        child: BlocProvider(
          create: (_) => _SoldDetailBloc,
          child: BlocListener<SoldDetailBloc, SoldDetailState>(
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
                if (state is Failed) {
                  setState(() {
                    _isLoading = false;
                  });
                }
                if (state is CancelOrderSuccessful) {
                  setState(() {
                    _isLoading = false;
                    Fluttertoast.showToast(
                        msg: _l10n.OrderSuccessfullyCanceled,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: AppColors.appBlue,
                        textColor: Colors.white,
                        fontSize:
                            SizeConfig.textMultiplier * 2.0086083213773316);
                    Navigator.pop(context);
                  });
                }
                if (state is CancelOrderFailed) {
                  setState(() {
                    _isLoading = false;
                    Fluttertoast.showToast(
                        msg: _l10n.OrderCancelFailed,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: AppColors.appBlue,
                        textColor: Colors.white,
                        fontSize:
                            SizeConfig.textMultiplier * 2.0086083213773316);
                  });
                }
                if (state is SellerOptionsSuccessfully) {
                  setState(() {
                    _isLoading = false;
                    _sellerOptionsModel = _SoldDetailBloc.sellerOptionsModel;
                  });
                }
                if (state is SellerOptionsFailed) {
                  setState(() {
                    _isLoading = false;
                  });
                }

                if (state is ClaimRaisedSuccessfully) {
                  Fluttertoast.showToast(
                      msg: "Claim Raised",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColors.appBlue,
                      textColor: Colors.white,
                      fontSize: SizeConfig.textMultiplier * 2.0086083213773316);
                }
                if (state is ClaimRaisingFailed) {
                  Fluttertoast.showToast(
                      msg: "Claim Raising Failed",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColors.appBlue,
                      textColor: Colors.white,
                      fontSize: SizeConfig.textMultiplier * 2.0086083213773316);
                }
                if (state is MarkItemShippedSuccessfully) {
                  _showToast('Item Marked Successfully');
                }
                if (state is MarkItemShippedFailed) {
                  _showToast('Mark Item Failed');
                }

                if (state is FeedbackSuccessfullySent) {
                  setState(() {
                    _feedbackClicked = false;
                  });
                  _showToast('Feedback left for buyer');
                }
                if (state is FeedbackSendingFailed) {
                  setState(() {
                    _feedbackClicked = false;
                  });
                  _showToast('Feedback sending failed');
                }
              },
              child: ListView(
                shrinkWrap: true,
                children: [_filter(), _baseScreen()],
              )),
        ),
      ),
    );
  }

  Widget _baseScreen() {
    return Container(
      color: Colors.white,
      child: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          children: [_recentlyProductCard(SoldDetailRoute.order)],
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

  Widget _recentlyProductCard(Orders model) {
    return GestureDetector(
      onTap: () {
        setState(() {});
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: SizeConfig.widthMultiplier * 3.8888888888888884,
            top: SizeConfig.heightMultiplier * 2.5107604017216643),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
                child: Row(
              children: [
                Container(
                  width: SizeConfig.widthMultiplier * 29.166666666666664,
                  child: _recentlyImage(model),
                ),
                Container(
                  child: _recentlyBroughtTxt(model),
                )
              ],
            )),
            _orderStatus(model),
          ],
        ),
      ),
    );
  }

  Widget _recentlyImage(Orders model) {
    return Stack(
      children: [
        Container(
          child: Image.network(
            model.imgLink,
            height: SizeConfig.heightMultiplier * 15.692252510760403,
            width: SizeConfig.widthMultiplier * 30.138888888888886,
            fit: BoxFit.fill,
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
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18)),
            child: Center(
              child: Text(
                model.shippingStatus,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )),
      ],
    );
  }

  Widget _recentlyBroughtTxt(Orders model) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () {
                // ProductLandingRoute.productModel = model;
                // RouterService.profileRouter
                //     .navigateTo(ProductLandingRoute.buildPath());
              },
              child: Container(
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 2.9166666666666665,
                          top:
                              SizeConfig.heightMultiplier * 1.0043041606886658),
                      child: Text(model.title,
                          style: GoogleFonts.inter(
                              fontSize:
                                  SizeConfig.textMultiplier * 2.259684361549498,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.15)),
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.heightMultiplier *
                                  1.5064562410329987,
                              right: SizeConfig.widthMultiplier *
                                  1.9444444444444442,
                              left: SizeConfig.widthMultiplier *
                                  3.645833333333333),
                          child: Text(
                            '${model.fiatPrice}\$',
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    1.757532281205165,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.1),
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.only(right: SizeConfig.widthMultiplier * 1.9444444444444442, left: SizeConfig.widthMultiplier * 3.645833333333333),
                        //   child: Text(
                        //     model.cryptoCheckoutPriceSeller,
                        //     style: GoogleFonts.inter(
                        //         fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                        //         fontWeight: FontWeight.w400,
                        //         letterSpacing: 0.4),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              )),
          if (_isTags)
            Container(
                height: SizeConfig.heightMultiplier * 6.276901004304161,
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
              model.description,
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

  Widget _orderStatus(Orders model) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 1.9444444444444442,
                top: SizeConfig.heightMultiplier * 1.5064562410329987),
            child: Text(
              _l10n.Hastheitembeenshipped,
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
                    hintText: _l10n.Trackingnumber,
                    labelText: _l10n.Trackingnumber,
                    contentPadding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884),
                    suffixStyle: const TextStyle(color: AppColors.appBlue)),
              ),
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
          Container(
            width: MediaQuery.of(context).size.width,
            height: SizeConfig.heightMultiplier * 6.025824964131995,
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 2.5107604017216643,
                left: SizeConfig.widthMultiplier * 1.9444444444444442,
                right: SizeConfig.widthMultiplier * 1.9444444444444442),
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
                  _showToast("${_l10n.pleseEnter} ${_l10n.Trackingnumber}.");
                } else if (_trackingController.text.length == 0) {
                  _showToast("${_l10n.pleseEnter} ${_l10n.ShippingCompany}.");
                } else {
                  _SoldDetailBloc.orderId = model.orderID;
                  _SoldDetailBloc.add(MarkItemShippedEvent());
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 2.5107604017216643,
                left: SizeConfig.widthMultiplier * 2.9166666666666665,
                right: SizeConfig.widthMultiplier * 2.9166666666666665),
            child: Text(_l10n.Buyershippinginstructions,
                style: TextStyle(
                    color: AppColors.catTextColor,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.bold)),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.0043041606886658,
                left: SizeConfig.widthMultiplier * 2.9166666666666665,
                right: SizeConfig.widthMultiplier * 2.9166666666666665),
            child: Text(
                _SoldDetailBloc?.buyerInfo?.instructions == null
                    ? Constants.shipping_instructions
                    : _SoldDetailBloc?.buyerInfo?.instructions,
                style: TextStyle(
                  color: AppColors.catTextColor,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                )),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 2.5107604017216643,
                left: SizeConfig.widthMultiplier * 2.9166666666666665,
                right: SizeConfig.widthMultiplier * 2.9166666666666665),
            child: Text(_l10n.RaiseClaim,
                style: TextStyle(
                    color: AppColors.app_txt_color,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w700)),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.0043041606886658,
                left: SizeConfig.widthMultiplier * 2.9166666666666665,
                right: SizeConfig.widthMultiplier * 2.9166666666666665),
            height: SizeConfig.heightMultiplier * 7.532281205164993,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 2.9166666666666665,
                right: SizeConfig.widthMultiplier * 2.9166666666666665),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: AppColors.app_txt_color)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  value: _claimReason,
                  items: _dropdownMenuClaimItems,
                  icon: Icon(Icons.keyboard_arrow_down),
                  onChanged: (value) {
                    setState(() {
                      _claimReason = value;
                    });
                  }),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.5064562410329987,
                left: SizeConfig.widthMultiplier * 2.9166666666666665,
                right: SizeConfig.widthMultiplier * 2.9166666666666665),
            child: Theme(
              data: ThemeData(
                primaryColor: AppColors.appBlue,
                primaryColorDark: AppColors.appBlue,
              ),
              child: TextField(
                controller: _claimController,
                minLines: 3,
                maxLines: 5,
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: AppColors.text_field_container),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: _l10n.claimReasonCheck,
                ),
              ),
            ),
          ),
          if (_sellerOptionsModel?.claimAvailable == "false")
            GestureDetector(
              onTap: () {
                _SoldDetailBloc.reason = _claimReason;
                _SoldDetailBloc.detail = _claimController.text;
                _SoldDetailBloc.orderId = model.orderID;
                _SoldDetailBloc.add(RaiseClaimEvent());
              },
              child: Container(
                  height: SizeConfig.heightMultiplier * 6.276901004304161,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 1.5064562410329987,
                      left: SizeConfig.widthMultiplier * 2.9166666666666665,
                      right: SizeConfig.widthMultiplier * 2.9166666666666665),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.appBlue)),
                  child: Center(
                    child: Text(
                      _l10n.RaiseClaim,
                      style: TextStyle(
                          fontSize:
                              SizeConfig.textMultiplier * 1.757532281205165,
                          color: AppColors.appBlue,
                          fontWeight: FontWeight.w700),
                    ),
                  )),
            ),
          if (_sellerOptionsModel?.claimAvailable == "true")
            GestureDetector(
              onTap: () {
                Fluttertoast.showToast(
                    msg: _l10n.ClaimAlreadyRaised,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: AppColors.appBlue,
                    textColor: Colors.white,
                    fontSize: SizeConfig.textMultiplier * 2.0086083213773316);
              },
              child: Container(
                  height: SizeConfig.heightMultiplier * 6.276901004304161,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 1.5064562410329987,
                      left: SizeConfig.widthMultiplier * 2.9166666666666665,
                      right: SizeConfig.widthMultiplier * 2.9166666666666665),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: AppColors.text_field_container)),
                  child: Center(
                    child: Text(
                      _l10n.RaiseClaim,
                      style: TextStyle(
                          fontSize:
                              SizeConfig.textMultiplier * 1.757532281205165,
                          color: AppColors.text_field_container,
                          fontWeight: FontWeight.w700),
                    ),
                  )),
            ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 3.51506456241033,
                left: SizeConfig.widthMultiplier * 2.9166666666666665,
                right: SizeConfig.widthMultiplier * 2.9166666666666665),
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 1.2152777777777777,
                right: SizeConfig.widthMultiplier * 1.2152777777777777),
            child: Text(_l10n.Extendpurchaseprotection,
                style: TextStyle(
                    color: AppColors.app_txt_color,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w700)),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.0043041606886658,
                left: SizeConfig.widthMultiplier * 2.9166666666666665,
                right: SizeConfig.widthMultiplier * 2.9166666666666665),
            height: SizeConfig.heightMultiplier * 6.276901004304161,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 2.4305555555555554,
                right: SizeConfig.widthMultiplier * 2.4305555555555554),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: AppColors.text_field_container)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  value: _extendedReason,
                  items: _dropdownMenuExtendedItems,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _extendedReason = value;
                    });
                  }),
            ),
          ),
          GestureDetector(
            onTap: () {
              _SoldDetailBloc.reason = _selectedItem;
              _SoldDetailBloc.extensionTime = 7;
              _SoldDetailBloc.add(ExtendProtectionEvent());
            },
            child: Container(
                height: SizeConfig.heightMultiplier * 6.276901004304161,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 2.5107604017216643,
                    left: SizeConfig.widthMultiplier * 2.9166666666666665,
                    right: SizeConfig.widthMultiplier * 2.9166666666666665),
                padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 1.2152777777777777,
                    right: SizeConfig.widthMultiplier * 1.2152777777777777),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.appBlue)),
                child: Center(
                  child: Text(
                    _l10n.ExtendpurchaseprotectionCaps,
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        color: AppColors.appBlue,
                        fontWeight: FontWeight.w700),
                  ),
                )),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 2.5107604017216643,
                left: SizeConfig.widthMultiplier * 2.9166666666666665,
                right: SizeConfig.widthMultiplier * 2.9166666666666665),
            child: Text(_l10n.Leavefeedbacktobuyer,
                style: TextStyle(
                    color: AppColors.catTextColor,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w700)),
          ),
          Container(
              margin: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 0.25107604017216645,
                  left: SizeConfig.widthMultiplier * 2.9166666666666665,
                  right: SizeConfig.widthMultiplier * 2.9166666666666665),
              child: RatingBar(
                itemSize: 25,
                glow: false,
                initialRating: _rating,
                itemCount: 5,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return Icon(
                        Icons.star,
                        size: 5,
                        color: Colors.orangeAccent,
                      );
                    case 1:
                      return Icon(
                        Icons.star,
                        size: 5,
                        color: Colors.orangeAccent,
                      );
                    case 2:
                      return Icon(
                        Icons.star,
                        size: 5,
                        color: Colors.orangeAccent,
                      );
                    case 3:
                      return Icon(
                        Icons.star,
                        size: 5,
                        color: Colors.orangeAccent,
                      );
                    default:
                      return Icon(
                        Icons.star,
                        size: 5,
                        color: Colors.orangeAccent,
                      );
                  }
                },
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                  // print(rating);
                },
              )),
          Container(
              margin: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 2.5107604017216643,
                  left: SizeConfig.widthMultiplier * 2.9166666666666665,
                  right: SizeConfig.widthMultiplier * 2.9166666666666665),
              child: TextField(
                minLines: 3,
                maxLines: 5,
                controller: _feedbackCommentController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText: _l10n.aboutBuyer,
                    suffixStyle: const TextStyle(color: Colors.blue)),
              )),
          if (_SoldDetailBloc?.sellerOptionsModel?.leaveFeedback == "true")
            GestureDetector(
                onTap: () {
                  setState(() {
                    _feedbackClicked = true;
                  });
                  _SoldDetailBloc.orderId = model.orderID;
                  _SoldDetailBloc.rating = _rating;
                  _SoldDetailBloc.comment = _feedbackCommentController.text;
                  _SoldDetailBloc.add(FeedbackSendingEvent());
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(
                        top: SizeConfig.heightMultiplier * 1.5064562410329987,
                        left: SizeConfig.widthMultiplier * 2.9166666666666665,
                        right: SizeConfig.widthMultiplier * 2.9166666666666665),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.appBlue),
                    ),
                    child: Center(
                      child: _feedbackClicked
                          ? Lottie.asset(
                              'assets/loader/widget_loading.json',
                              height: SizeConfig.heightMultiplier *
                                  2.5107604017216643,
                              width: SizeConfig.widthMultiplier *
                                  21.874999999999996,
                            )
                          : Text(
                              _l10n.leaveFeedback,
                              style: TextStyle(
                                  fontSize: SizeConfig.textMultiplier *
                                      1.757532281205165,
                                  color: AppColors.appBlue,
                                  fontWeight: FontWeight.w700),
                            ),
                    ))),
          if (_SoldDetailBloc?.sellerOptionsModel?.leaveFeedback == "false")
            GestureDetector(
                onTap: () {
                  _showToast('Feedback already given for this order.');
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(
                        top: SizeConfig.heightMultiplier * 1.5064562410329987,
                        left: SizeConfig.widthMultiplier * 2.9166666666666665,
                        right: SizeConfig.widthMultiplier * 2.9166666666666665),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.text_field_container),
                    ),
                    child: Center(
                      child: _feedbackClicked
                          ? Lottie.asset(
                              'assets/loader/widget_loading.json',
                              height: SizeConfig.heightMultiplier *
                                  2.5107604017216643,
                              width: SizeConfig.widthMultiplier *
                                  21.874999999999996,
                            )
                          : Text(
                              _l10n.leaveFeedback,
                              style: TextStyle(
                                  fontSize: SizeConfig.textMultiplier *
                                      1.757532281205165,
                                  color: AppColors.text_field_container,
                                  fontWeight: FontWeight.w700),
                            ),
                    ))),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.5064562410329987,
                left: SizeConfig.widthMultiplier * 2.9166666666666665,
                right: SizeConfig.widthMultiplier * 2.9166666666666665),
            child: Text(_l10n.cancelOrder,
                style: TextStyle(
                    color: AppColors.catTextColor,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w700)),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.0043041606886658,
                left: SizeConfig.widthMultiplier * 2.9166666666666665,
                right: SizeConfig.widthMultiplier * 2.9166666666666665),
            height: SizeConfig.heightMultiplier * 6.276901004304161,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 2.4305555555555554,
                right: SizeConfig.widthMultiplier * 2.4305555555555554),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: AppColors.text_field_container)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  value: _selectedItem,
                  items: _dropdownMenuItems,
                  icon: Icon(Icons.keyboard_arrow_down),
                  onChanged: (value) {
                    setState(() {
                      _selectedItem = value;
                    });
                  }),
            ),
          ),
          Container(
              margin: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 1.5064562410329987,
                  left: SizeConfig.widthMultiplier * 2.9166666666666665,
                  right: SizeConfig.widthMultiplier * 2.9166666666666665),
              child: TextField(
                controller: _reasonController,
                minLines: 3,
                maxLines: 5,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText: '${_l10n.claimReasonCheck}.',
                    suffixStyle: const TextStyle(color: Colors.blue)),
              )),
          GestureDetector(
            onTap: () {
              setState(() {
                _SoldDetailBloc.orderId = model.orderID;
                _SoldDetailBloc.reason = _selectedItem;
                _SoldDetailBloc.detail = _reasonController.text;
                _SoldDetailBloc.add(CancelOrderEvent());
              });
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 1.5064562410329987,
                    left: SizeConfig.widthMultiplier * 2.9166666666666665,
                    right: SizeConfig.widthMultiplier * 2.9166666666666665,
                    bottom: SizeConfig.heightMultiplier * 5.0215208034433285),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cancel_red),
                ),
                child: Center(
                  child: Text(
                    _l10n.CancelorderCAPs,
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                        color: AppColors.cancel_red,
                        fontWeight: FontWeight.w700),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Expanded(
            child: Text(
              listItem,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.text_field_container),
            ),
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  Widget _shippingAddress() {
    return Container(
        // height: SizeConfig.heightMultiplier * 31.384505021520805,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.darkgrey500)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'John Deo',
              style: TextStyle(
                  color: AppColors.darkgrey,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '2972 Westheimer Rd. Santa Ana Illinois 85486 United States',
              style: TextStyle(
                color: AppColors.darkgrey,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
              ),
            ),
          ],
        ));
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
