import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/common/selling_item.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/sell_new_products/upload_product_key/upload_product_key_bloc.dart';
import 'package:market_space/sell_new_products/upload_product_key/upload_product_key_l10n.dart';
import 'package:market_space/sell_new_products/upload_product_key/upload_product_key_route.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/sell_new_products/sell_new_product_toolbar.dart';

class UploadProductKeyScreen extends StatefulWidget {
  @override
  _UploadProductKeyScreenState createState() => _UploadProductKeyScreenState();
}

class _UploadProductKeyScreenState extends State<UploadProductKeyScreen> {
  final UploadProductKeyBloc _sellNewProductsBloc =
      UploadProductKeyBloc(Initial());

  UploadProductKeyL10n _l10n = UploadProductKeyL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  bool _isLoading = false;
  List<String> _courierDropItems;
  List<String> _sellerHandlingTimes;
  List<DropdownMenuItem<String>> _courierMenuItems;
  String _courierSelected;
  bool _freeShipping = false;
  List<String> _shippingDropItems;
  List<DropdownMenuItem<String>> _shippingMenuItems;
  String _shippingSelected;
  String _deliveryInfo;
  String _sellerHandlingTime;

  TextEditingController _lenghtController = TextEditingController();
  TextEditingController _widthController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _deliveryInfoController = TextEditingController();
  TextEditingController _courierController = TextEditingController();
  TextEditingController _shippingController = TextEditingController();
  TextEditingController _sellerHandlingController = TextEditingController();

  OverlayEntry _overlayEntry;
  static final _courierKey = GlobalKey<ScaffoldState>();
  final _shippingKey = GlobalKey<ScaffoldState>();
  final _handlingKey = GlobalKey<ScaffoldState>();
  static final FocusNode _deliveryInfoFocusNode = FocusNode();
  final FocusNode _courierServiceFocusNode = FocusNode();
  final FocusNode _heightFocusNode = FocusNode();
  final FocusNode _weightFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _sellerHandlingFocusNode = FocusNode();

  @override
  void initState() {
    _deliveryInfoFocusNode.addListener(() {
      if (!_deliveryInfoFocusNode.hasFocus) {
        setState(() {
          _deliveryInfo = _deliveryInfoController.text;
        });
      }
    });

    _sellerHandlingFocusNode.addListener(() {
      if (!_sellerHandlingFocusNode.hasFocus) {
        setState(() {
          _sellerHandlingTime = _sellerHandlingController.text;
        });
      }
    });

    // if (UploadProductKeyRoute.courierService != null) {
    //   _courierController.text = UploadProductKeyRoute.courierService;
    // }

    // if (UploadProductKeyRoute.shippingMethod != null) {
    //   _shippingController.text = UploadProductKeyRoute.shippingMethod;
    // }

    // if (UploadProductKeyRoute.packageHeight != null) {
    //   _heightController.text = UploadProductKeyRoute.packageHeight;
    // }

    // if (UploadProductKeyRoute.packageLength != null) {
    //   _lenghtController.text = UploadProductKeyRoute.packageLength;
    // }

    // if (UploadProductKeyRoute.packageWeight != null) {
    //   _weightController.text = UploadProductKeyRoute.packageWeight;
    // }

    // if (UploadProductKeyRoute.packageWidth != null) {
    //   _widthController.text = UploadProductKeyRoute.packageWidth;
    // }

    // if (UploadProductKeyRoute.estimatedShippingPrice != null) {
    //   _shippingController.text = UploadProductKeyRoute.estimatedShippingPrice;
    // }

    // if (UploadProductKeyRoute.deliveryInformation != null) {
    //   _deliveryInfoController.text = UploadProductKeyRoute.deliveryInformation;
    // }

    // if (UploadProductKeyRoute.sellerHandlingTime != null) {
    //   _sellerHandlingController.text = UploadProductKeyRoute.sellerHandlingTime;
    // }

    // if (UploadProductKeyRoute.freeShipping != null) {
    //   _freeShipping = UploadProductKeyRoute.freeShipping;
    // }

    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = UploadProductKeyL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n = UploadProductKeyL10n(Locale.fromSubtags(languageCode: 'zh'));
      }

      _courierDropItems = [
        "${_l10n.courierServices} *",
        "${_l10n.awb}",
      ];

      _sellerHandlingTimes = [
        "< 1 hr",
        "12 hrs",
        "24 hrs",
        "2 Days",
        "3 Days",
        "5 Days"
      ];

      _shippingDropItems = [
        "${_l10n.shippingMethod}*",
        "${_l10n.byAir}",
      ];
    });
    // _courierMenuItems = buildDropDownMenuItems(_courierDropItems);
    _courierSelected = _courierDropItems[0];

    // _shippingMenuItems = buildDropDownMenuItems(_shippingDropItems);
    _shippingSelected = _shippingDropItems[0];

    _courierServiceFocusNode.addListener(() {
      if (!_courierServiceFocusNode.hasFocus) {
        setState(() {
          _courierSelected = _courierController.text;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: UploadProductKeyRoute.sellerPageBloc,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          // resizeToAvoidBottomPadding: false,
          bottomSheet: _bottomButton(),
          backgroundColor: AppColors.toolbarBlue,
          appBar: SellingToolBar('Sell item'),
          body: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: AppColors.white,
                  child: BlocProvider(
                    create: (_) => _sellNewProductsBloc,
                    child: BlocListener<UploadProductKeyBloc,
                            UploadProductKeyState>(
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
                          children: [_baseScreen()],
                        )),
                  ),
                ),
              ))),
    );
  }

  Widget _baseScreen() {
    return Container(
      margin: EdgeInsets.only(bottom: 40),
      color: Colors.white,
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
                    child: Lottie.asset(
                      'assets/loader/loader_blue1.json',
                      width: 50,
                      height: 50,
                      animate: true,
                    ),
                  )),
            if (!_isLoading)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: 16,
                        bottom: 8,
                        top: SizeConfig.heightMultiplier * 15.0086083213773316),
                    child: Text(
                      "Step 2/3",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          letterSpacing: 0.15,
                          color: AppColors.black),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 16,
                        bottom: 8,
                        top: SizeConfig.heightMultiplier * 2.0086083213773316),
                    child: Text("Shipping information",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            letterSpacing: 0.15,
                            color: AppColors.app_txt_color)),
                  ),
                  _uploadKeyScreen(),
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget _bottomButton() {
    return Container(
      height: 48,
      margin: EdgeInsets.only(top: 31.0, right: 16, left: 16, bottom: 40),
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
              "Next",
              style: GoogleFonts.roboto(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 0.5,
                  textStyle: TextStyle(fontFamily: 'Roboto')),
            )),
        onPressed: () {
          if (_courierSelected == _l10n.courierServices ||
              _courierSelected.length == 0) {
            _showToast("Please enter a courier service");
          } else if (_shippingSelected == _l10n.shippingMethod ||
              _shippingSelected.length == 0) {
            _showToast("Please enter the shipping method");
          } else if (_sellerHandlingTime == "Handling time *" ||
              _sellerHandlingController.text.length == 0) {
            _showToast("Please select the handling time");
          } else if (_freeShipping &&
              (_lenghtController.text.length == 0 ||
                  _widthController.text.length == 0 ||
                  _heightController.text.length == 0 ||
                  _weightController.text.length == 0 ||
                  _priceController.text.length == 0 ||
                  _lenghtController.text == _l10n.length ||
                  _widthController.text == _l10n.width ||
                  _heightController.text == _l10n.width ||
                  _weightController.text == _l10n.weight ||
                  _priceController.text == _l10n.estimatedPrice)) {
            _showToast("Please enter the package descriptions");
          } else {
            // print('this is here');
            UploadProductKeyRoute.courierService = _courierSelected;
            // print('wbt now');
            UploadProductKeyRoute.shippingMethod = _shippingSelected;
            UploadProductKeyRoute.sellerHandlingTime = _sellerHandlingTime;
            UploadProductKeyRoute.freeShipping = _freeShipping;
            if (_freeShipping) {
              UploadProductKeyRoute.freeShipping = false;
              UploadProductKeyRoute.packageHeight = _heightController.text;
              UploadProductKeyRoute.packageLength = _lenghtController.text;
              UploadProductKeyRoute.packageWeight = _weightController.text;
              UploadProductKeyRoute.packageWidth = _widthController.text;
              UploadProductKeyRoute.estimatedShippingPrice =
                  _priceController.text;
              // SellingItems.estimatedShippingPrice = _;
              if (_deliveryInfoController.text.length > 0 &&
                  _deliveryInfoController.text.length !=
                      _l10n.deliveryInformation) {
                UploadProductKeyRoute.deliveryInformation = _deliveryInfo;
                // // print(
                //     "Delivery info ${UploadProductKeyRoute.deliveryInformation}");
              }

              // print("Courier service ${UploadProductKeyRoute.packageHeight}");
            } else {
              UploadProductKeyRoute.freeShipping = true;
            }
            //else {
            //   SellingItems.packageHeight = "0";
            //   SellingItems.packageLength = "0";
            //   SellingItems.packageWeight = "0";
            //   SellingItems.packageWidth = "0";
            //   SellingItems.estimatedShippingPrice = "0";
            // }
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _uploadKeyScreen() {
    return Column(
      // shrinkWrap: true,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 24, left: 16, right: 16),
          height: 44,
          width: MediaQuery.of(context).size.width,
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.text_field_container,
              primaryColorDark: AppColors.text_field_container,
            ),
            child: TextField(
              // key: _courierKey,
              controller: _courierController,
              focusNode: _courierServiceFocusNode,
              // enabled: _overlayEntry == null ? true : false,
              // readOnly: true,
              // showCursor: false,
              // onTap: () {
              //   setState(() {
              //     this._overlayEntry = this._createOverlayEntry(
              //         _courierDropItems, _courierKey, _courierController);
              //     Overlay.of(context).insert(this._overlayEntry);
              //     _courierSelected = _courierController.text;
              //   });
              // },
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  letterSpacing: 0.1,
                  color: AppColors.app_txt_color),
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(
                          color: AppColors.text_field_color,
                          width:
                              SizeConfig.widthMultiplier * 0.12152777777777776),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: '${_l10n.courierServices} *',
                  contentPadding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884),
                  suffixStyle: const TextStyle(color: AppColors.appBlue)),
              // decoration: InputDecoration(
              //     suffixIcon: Icon(Icons.keyboard_arrow_down),
              //     border: OutlineInputBorder(
              //         borderSide: BorderSide(
              //             color: AppColors.text_field_container, width: 0.5),
              //         borderRadius: BorderRadius.circular(10.0)),
              //     contentPadding: EdgeInsets.only(left: 16),
              //     hintText: '${_l10n.courierServices} *',
              //     suffixStyle:
              //         const TextStyle(color: AppColors.text_field_container)),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 8, left: 16, right: 16),
          height: 44,
          width: MediaQuery.of(context).size.width,
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.text_field_container,
              primaryColorDark: AppColors.text_field_container,
            ),
            child: TextField(
              // keyboardType: TextInputType.phone,
              // key: _shippingKey,
              controller: _shippingController,
              // enabled: _overlayEntry == null ? true : false,
              // readOnly: true,
              // showCursor: false,
              // onTap: () {
              //   setState(() {
              //     this._overlayEntry = this._createOverlayEntry(
              //         _shippingDropItems, _shippingKey, _shippingController);
              //     Overlay.of(context).insert(this._overlayEntry);
              //     _shippingSelected = _shippingController.text;
              //   });
              // },
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  letterSpacing: 0.1,
                  color: AppColors.app_txt_color),
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(
                          color: AppColors.text_field_color,
                          width:
                              SizeConfig.widthMultiplier * 0.12152777777777776),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: '${_l10n.shippingMethod} *',
                  contentPadding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884),
                  suffixStyle: const TextStyle(color: AppColors.appBlue)),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 8, left: 16, right: 16),
          height: 44,
          width: MediaQuery.of(context).size.width,
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.text_field_container,
              primaryColorDark: AppColors.text_field_container,
            ),
            child: TextField(
              // key: _handlingKey,
              controller: _sellerHandlingController,
              focusNode: _sellerHandlingFocusNode,
              enabled: _overlayEntry == null ? true : false,
              readOnly: true,
              showCursor: false,
              onTap: () {
                setState(() {
                  this._overlayEntry = this._createOverlayEntry(
                      _sellerHandlingTimes,
                      _handlingKey,
                      _sellerHandlingController);
                  Overlay.of(context).insert(this._overlayEntry);
                });
              },
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  letterSpacing: 0.1,
                  color: AppColors.app_txt_color),
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.keyboard_arrow_down),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColors.text_field_container, width: 0.5),
                      borderRadius: BorderRadius.circular(10.0)),
                  contentPadding: EdgeInsets.only(left: 16),
                  hintText: 'Handling time *',
                  suffixStyle:
                      const TextStyle(color: AppColors.text_field_container)),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_freeShipping)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _freeShipping = true;
                  });
                },
                child: Container(
                  width: 18,
                  height: 18,
                  margin: EdgeInsets.only(left: 16, top: 9),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.appBlue, width: 1),
                      borderRadius: BorderRadius.circular(3)),
                  child: Icon(
                    Icons.check,
                    color: AppColors.appBlue,
                    size: 16,
                  ),
                ),
              ),
            if (_freeShipping)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _freeShipping = false;
                  });
                },
                child: Container(
                  width: 18,
                  height: 18,
                  margin: EdgeInsets.only(left: 16, top: 9),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.appBlue, width: 1),
                      borderRadius: BorderRadius.circular(3)),
                ),
              ),
            Flexible(
              child: Container(
                  margin: EdgeInsets.only(left: 12, right: 13, top: 11),
                  child: Text(_l10n.freeShipping,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.4))),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 16.0, right: 16, top: 16),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              textAlign: TextAlign.start,
              controller: _lenghtController,
              enabled: _freeShipping,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: AppColors.text_field_color),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: '${_l10n.length} (cm)',
                  contentPadding: EdgeInsets.only(left: 16, top: 10),
                  suffixStyle: const TextStyle(color: AppColors.appBlue)),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16.0, right: 16, top: 16),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              controller: _widthController,
              enabled: _freeShipping,
              textAlign: TextAlign.start,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: AppColors.text_field_color),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: '${_l10n.width} (cm)',
                  contentPadding: EdgeInsets.only(left: 16, top: 10),
                  suffixStyle: const TextStyle(color: AppColors.appBlue)),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16.0, right: 16, top: 16),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              textAlign: TextAlign.start,
              controller: _heightController,
              focusNode: _heightFocusNode,
              onTap: () {
                FocusScope.of(context).requestFocus(_heightFocusNode);
              },
              enabled: _freeShipping,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: AppColors.text_field_color),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: '${_l10n.height} (cm)',
                  contentPadding: EdgeInsets.only(left: 16, top: 10),
                  suffixStyle: const TextStyle(color: AppColors.appBlue)),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16.0, right: 16, top: 16),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextFormField(
              controller: _weightController,
              focusNode: _weightFocusNode,
              onTap: () {
                FocusScope.of(context).requestFocus(_weightFocusNode);
              },
              textAlign: TextAlign.start,
              enabled: _freeShipping,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: AppColors.text_field_color),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: '${_l10n.weight} (kg)',
                  contentPadding: EdgeInsets.only(left: 16, top: 10),
                  suffixStyle: const TextStyle(color: AppColors.appBlue)),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16.0, right: 16, top: 16),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextFormField(
              textAlign: TextAlign.start,
              controller: _priceController,
              focusNode: _priceFocusNode,
              onTap: () {
                FocusScope.of(context).requestFocus(_priceFocusNode);
              },
              enabled: _freeShipping,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: AppColors.text_field_color),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: '${_l10n.estimatedPrice}',
                  contentPadding: EdgeInsets.only(left: 16, top: 10),
                  suffixStyle: const TextStyle(color: AppColors.appBlue)),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16.0, right: 16, top: 16, bottom: 100),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.start,
              controller: _deliveryInfoController,
              focusNode: _deliveryInfoFocusNode,
              onTap: () {
                FocusScope.of(context).requestFocus(_deliveryInfoFocusNode);
              },
              minLines: 4,
              maxLines: 6,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: AppColors.text_field_color),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: '${_l10n.deliveryInformation}',
                  contentPadding: EdgeInsets.only(left: 16, top: 10),
                  suffixStyle: const TextStyle(color: AppColors.appBlue)),
            ),
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(
            listItem,
            style: TextStyle(color: AppColors.text_field_container),
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.appBlue,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  OverlayEntry _createOverlayEntry(List<String> _dropdownList,
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
              height: _dropdownList.length <= 2 ? 130 : 180,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.text_field_container, width: 2)),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: _dropdownList
                        .map((value) => InkWell(
                              onTap: () {
                                setState(() {
                                  controller.text = value;
                                  _overlayEntry.remove();
                                  _overlayEntry = null;
                                });
                              },
                              child: value == _dropdownList[0]
                                  ? ListTile(
                                      title: Text(
                                        value,
                                        style: GoogleFonts.inter(
                                            color: AppColors.catTextColor,
                                            fontSize: 14),
                                      ),
                                      trailing: Icon(Icons.keyboard_arrow_down),
                                    )
                                  : ListTile(
                                      title: Text(
                                        value,
                                        style: GoogleFonts.inter(
                                            color: AppColors.catTextColor,
                                            fontSize: 14),
                                      ),
                                    ),
                            ))
                        .toList(),
                  ),
                ),
              ))),
    );
  }
}
