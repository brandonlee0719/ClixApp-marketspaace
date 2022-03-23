import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/dropdownField.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/common/selling_item.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/sell_new_products/add_brand/seller_add_brand_bloc.dart';
import 'package:market_space/sell_new_products/add_brand/seller_add_brand_l10n.dart';
import 'package:market_space/sell_new_products/add_brand/seller_add_brand_route.dart';
import 'package:market_space/sell_new_products/sell_new_product_toolbar.dart';
import 'package:path/path.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'dart:io';

class SellerAddBrand extends StatefulWidget {
  @override
  _SellerAddBrandState createState() => _SellerAddBrandState();
}

class _SellerAddBrandState extends State<SellerAddBrand> {
  final SellerAddBrandBloc _addBrandBloc = SellerAddBrandBloc(Initial());
  SellerAddBrandL10n _l10n = SellerAddBrandL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  List<String> _brandItems;

  final Color background = AppColors.toolbarBlue;
  final Color fill = AppColors.lightgrey;

  bool _isLoading = false;
  bool _customBrand = false;
  String _brandName;
  String _customBrandName;
  File _customBrandImage;
  String _customBrandDescription;
  String _customBrandImgText = "Custom brand image";

  TextEditingController _customBrandController = TextEditingController();
  TextEditingController _customBrandImageController = TextEditingController();
  TextEditingController _customBrandDescriptionController =
      TextEditingController();
  OverlayEntry _overlayEntry;
  final _brandKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _initOperations();
    super.initState();
  }

  _initOperations() {
    _addBrandBloc.add(LoadAvailableBrands());

    if (SellerAddBrandRoute.brandName != null &&
        !(SellerAddBrandRoute.customBrand ?? false)) {
      _brandName = SellerAddBrandRoute.brandName;
    }

    if (_brandName == null) {
      if (SellerAddBrandRoute.customBrand != null) {
        _customBrand = SellerAddBrandRoute.customBrand;
      }

      if (SellerAddBrandRoute.customBrandName != null) {
        _customBrandController.text = SellerAddBrandRoute.customBrandName;
      }

      if (SellerAddBrandRoute.customBrandImg != null) {
        _customBrandImage = SellerAddBrandRoute.customBrandImg;
        _customBrandImgText = "Brand loaded";
      }

      if (SellerAddBrandRoute.customBrandDescription != null) {
        _customBrandDescriptionController.text =
            SellerAddBrandRoute.customBrandDescription;
      }
    }

    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = SellerAddBrandL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n = SellerAddBrandL10n(Locale.fromSubtags(languageCode: 'zh'));
      }
    });
  }

  @override
  void dispose() {
    _customBrandController?.dispose();
    _customBrandDescriptionController?.dispose();
    _customBrandImageController?.dispose();
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
        resizeToAvoidBottomInset: false,
        bottomSheet: _bottomButton(context),
        backgroundColor: Colors.transparent,
        appBar: Toolbar(
          title: 'Sell item',
          overlayEntry: _overlayEntry,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.white,
          child: BlocProvider(
            create: (_) => _addBrandBloc,
            child: BlocListener<SellerAddBrandBloc, SellerAddBrandState>(
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

                  if (state is BrandsLoaded) {
                    setState(() {
                      _brandItems = _addBrandBloc?.brandItems;
                      _brandItems.insert(0, "${_l10n.brand} ${_l10n.name} *");
                      _brandName ??= _brandItems?.first;
                      // print("brandItems: $_brandItems");
                    });
                  }

                  if (state is PickedImage) {
                    setState(() {
                      _customBrandImage = _addBrandBloc?.image;
                      _customBrandImgText = "Brand image loaded";
                    });
                  }
                },
                child: ListView(
                  shrinkWrap: true,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  children: [_AddbrandScreen(context)],
                )),
          ),
        ),
      ),
    );
  }

  Widget _AddbrandScreen(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_l10n.brand,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                  letterSpacing: 0.15,
                  textStyle: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4),
                  color: AppColors.app_txt_color)),
          SizedBox(height: 15),
          DropdownField<String>(
            bottomMargin: SizeConfig.heightMultiplier * 1.5043041606886658,
            dropdownItems: (_brandItems ?? [])
                .map(
                  (e) => DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  ),
                )
                .toList(),
            hintText: 'Brand name *',
            value: _brandName,
            onChanged:
                _customBrand ? null : (val) => setState(() => _brandName = val),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (_customBrand)
                    _customBrandDescription =
                        _customBrandDescriptionController.text;
                  else
                    _brandName = "${_l10n.brand} ${_l10n.name} *";
                  _customBrand = !_customBrand;
                });
              },
              child: Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    margin: EdgeInsets.only(top: 9),
                    child: _customBrand
                        ? Icon(
                            Icons.check,
                            color: AppColors.appBlue,
                            size: 16,
                          )
                        : SizedBox.shrink(),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.appBlue, width: 1),
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  Flexible(
                    child: Container(
                        margin: EdgeInsets.only(left: 12, right: 13, top: 11),
                        child: Text("Add custom brand",
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.4))),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.0043041606886658),
            child: Theme(
              data: ThemeData(
                primaryColor: AppColors.appBlue,
                primaryColorDark: AppColors.appBlue,
              ),
              child: TextField(
                controller: _customBrandController,
                enabled: _customBrand ? true : false,
                textAlign: TextAlign.start,
                style: GoogleFonts.inter(
                  color: AppColors.text_field_color,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.25,
                ),
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: AppColors.text_field_container),
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText:
                        '${_l10n.custom} ${_l10n.brandSmall} ${_l10n.name}',
                    hintStyle: TextStyle(color: AppColors.text_field_color),
                    labelText:
                        '${_l10n.custom} ${_l10n.brandSmall} ${_l10n.name}',
                    contentPadding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                        top: SizeConfig.heightMultiplier * 1.2553802008608321),
                    suffixStyle: const TextStyle(color: AppColors.appBlue)),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (_customBrand) {
                  _addBrandBloc.add(PickImage());
                }
              });
            },
            child: Container(
                height: SizeConfig.heightMultiplier * 12.553802008608322,
                margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 1.0043041606886658),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: _customBrand
                            ? AppColors.text_field_container
                            : AppColors.list_separator2)),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      ),
                      child: Text(
                        _customBrandImgText,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                            color: _customBrand
                                ? _customBrandImage != null
                                    ? Colors.green
                                    : AppColors.upload_box_text_color
                                : AppColors.hint_color),
                      ),
                    ),
                    Spacer(),
                    Container(
                        margin: EdgeInsets.only(
                          right:
                              SizeConfig.widthMultiplier * 3.8888888888888884,
                        ),
                        child: SvgPicture.asset(
                          'assets/images/upload_file.svg',
                          width: SizeConfig.widthMultiplier * 4.861111111111111,
                          height:
                              SizeConfig.heightMultiplier * 2.5107604017216643,
                          color: _customBrand
                              ? AppColors.upload_box_text_color
                              : AppColors.hint_color,
                        ))
                  ],
                )),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.0043041606886658),
            child: Theme(
              data: ThemeData(
                primaryColor: AppColors.appBlue,
                primaryColorDark: AppColors.appBlue,
              ),
              child: TextField(
                controller: _customBrandDescriptionController,
                textInputAction: TextInputAction.done,
                enabled: _customBrand ? true : false,
                textAlign: TextAlign.start,
                minLines: 4,
                maxLines: 7,
                style: GoogleFonts.inter(
                  color: AppColors.text_field_color,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.25,
                ),
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: AppColors.text_field_container),
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText:
                        '${_l10n.custom} ${_l10n.brandSmall} ${_l10n.description}',
                    hintStyle: TextStyle(color: AppColors.text_field_color),
                    labelText:
                        '${_l10n.custom} ${_l10n.brandSmall} ${_l10n.description}',
                    contentPadding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                        top: SizeConfig.heightMultiplier * 1.8830703012912482),
                    suffixStyle: const TextStyle(color: AppColors.appBlue)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomButton(BuildContext context) {
    return Container(
      height: SizeConfig.heightMultiplier * 6.025824964131995,
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 3.89167862266858,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          bottom: SizeConfig.heightMultiplier * 5.0215208034433285),
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
              "${_l10n.CONFIRM}",
              style: GoogleFonts.inter(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.5,
                  textStyle: TextStyle(fontFamily: 'Roboto')),
            )),
        onPressed: () {
          if (_brandName != "${_l10n.brand} ${_l10n.name} *" &&
              _customBrand == false) {
            SellerAddBrandRoute.brandName = _brandName;
            SellerAddBrandRoute.customBrand = false;
            Navigator.pop(context);
          } else if (_customBrand &&
              _customBrandController.text.length > 0 &&
              _customBrandDescriptionController.text.length > 0 &&
              _customBrandImage != null &&
              _customBrandImage.existsSync()) {
            SellerAddBrandRoute.customBrandName = _customBrandController.text;
            SellerAddBrandRoute.customBrandDescription =
                _customBrandDescriptionController.text;
            SellerAddBrandRoute.customBrandImg = _customBrandImage;
            SellerAddBrandRoute.customBrand = true;
            Navigator.pop(context);
          } else {
            _showToast("Please either select a brand or input your own");
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
              height: _dropdownList.length < 3 ? 130 : 180,
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
                                  _overlayEntry = null;
                                  controller.text = value;
                                });
                              },
                              child: value == _dropdownList[0]
                                  ? ListTile(
                                      title: Text(
                                        value,
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
                                        value,
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

  Future<bool> _onWillPop() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
      return Future.value(false);
    }
    return Future.value(true);
  }
}
