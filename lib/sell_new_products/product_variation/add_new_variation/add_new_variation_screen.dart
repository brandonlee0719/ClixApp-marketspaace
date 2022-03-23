import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/common/selling_item.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/model/sell_item_req_model/sell_item_req_model.dart';
import 'package:market_space/sell_new_products/product_variation/add_new_variation/add_new_variation_bloc.dart';
import 'package:market_space/sell_new_products/product_variation/add_new_variation/add_new_variation_l10n.dart';
import 'package:market_space/sell_new_products/product_variation/add_new_variation/add_new_variation_route.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class AddNewVariationScreen extends StatefulWidget {
  @override
  _AddNewVariationScreenState createState() => _AddNewVariationScreenState();
}

class _AddNewVariationScreenState extends State<AddNewVariationScreen> {
  final AddNewVariationBloc _addNewVariationBloc =
      AddNewVariationBloc(Initial());
  AddNewVariationL10n _l10n = AddNewVariationL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
  bool _isLoading = false;
  TextEditingController _variatorName = TextEditingController();
  TextEditingController _variation = TextEditingController();
  TextEditingController _quantity = TextEditingController();
  List<Variation> _variationList = List();
  List<Variations> _variationsList = List();

  @override
  void initState() {
    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = AddNewVariationL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n = AddNewVariationL10n(Locale.fromSubtags(languageCode: 'zh'));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomSheet: _bottomButton(),
      backgroundColor: AppColors.toolbarBlue,
      appBar: Toolbar(
        title: 'MARKETSPAACE',
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.white,
        child: BlocProvider(
          create: (_) => _addNewVariationBloc,
          child: BlocListener<AddNewVariationBloc, AddNewVariationState>(
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
                children: [_variationScreen()],
              )),
        ),
      ),
    );
  }

  Widget _bottomButton() {
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
              _l10n.CONFIRM,
              style: GoogleFonts.roboto(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.5,
              ),
            )),
        onPressed: () {
          if (_variationsList == null || _variationsList.isEmpty) {
            _showToast("${_l10n.pleseEnter} details and add");
          } else {
            if (AddNewVariationRoute.variation != null) {
              List<Variations> list = List();
              // Variation variation = Variation();
              // variation.variationLabel = AddNewVariationRoute.variation;
              // variation.quantity = AddNewVariationRoute.quantity;
              // list.add(variation);
              //
              // Variations variations = Variations();
              // variations.variation = list;
              // variations.variator = AddNewVariationRoute.variator;
              for (int i = 0; i < SellingItems.variations.length; i++) {
                for (int j = 0;
                    j < SellingItems.variations[i].variation.length;
                    j++) {
                  if (SellingItems.variations[i].variation[j].variationLabel !=
                      AddNewVariationRoute.variation) {
                    list.add(SellingItems.variations[i]);
                  }
                }
              }
              // SellingItems.variations.remove(variations);
              _variationsList.addAll(list);
              SellingItems.variations.clear();
              SellingItems.variations.addAll(_variationsList);
              Navigator.of(context).pop('navigator');
            } else {
              SellingItems.variations.addAll(_variationsList);
              Navigator.of(context).pop('navigator');
            }
          }
        },
      ),
    );
  }

  Widget _variationScreen() {
    setState(() {
      if (AddNewVariationRoute.variator != null) {
        _variatorName.text = AddNewVariationRoute.variator;
        _variation.text = AddNewVariationRoute.variation;
        _quantity.text = AddNewVariationRoute.quantity.toString();
      }
    });
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            bottom: SizeConfig.heightMultiplier * 1.0043041606886658,
            top: SizeConfig.heightMultiplier * 2.0086083213773316),
        child: Text(
            AddNewVariationRoute.variator == null
                ? _l10n.Newvariation
                : _l10n.Editvariation,
            maxLines: 2,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                letterSpacing: 0.15,
                textStyle: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4),
                color: AppColors.app_txt_color)),
      ),
      Container(
        margin: EdgeInsets.only(
            top: SizeConfig.heightMultiplier * 2.0086083213773316,
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: SizeConfig.widthMultiplier * 3.8888888888888884),
        child: Theme(
          data: ThemeData(
            primaryColor: AppColors.appBlue,
            primaryColorDark: AppColors.appBlue,
          ),
          child: TextField(
            textAlign: TextAlign.start,
            controller: _variatorName,
            style: GoogleFonts.inter(
              color: AppColors.text_field_color,
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.textMultiplier * 1.757532281205165,
              letterSpacing: 0.25,
            ),
            decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide:
                        new BorderSide(color: AppColors.text_field_color),
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: '${_l10n.Variator} (e.g Color/Size)',
                labelText: _l10n.Variator,
                contentPadding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    top: SizeConfig.heightMultiplier * 1.2553802008608321),
                suffixStyle: const TextStyle(color: AppColors.appBlue)),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(
            top: SizeConfig.heightMultiplier * 2.0086083213773316,
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: SizeConfig.widthMultiplier * 3.8888888888888884),
        child: Theme(
          data: ThemeData(
            primaryColor: AppColors.appBlue,
            primaryColorDark: AppColors.appBlue,
          ),
          child: TextField(
            controller: _variation,
            textAlign: TextAlign.start,
            style: GoogleFonts.inter(
              color: AppColors.text_field_color,
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.textMultiplier * 1.757532281205165,
              letterSpacing: 0.25,
            ),
            decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide:
                        new BorderSide(color: AppColors.text_field_color),
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: '${_l10n.Variation} (e.g Black/M)',
                labelText: _l10n.Variation,
                contentPadding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    top: SizeConfig.heightMultiplier * 1.2553802008608321),
                suffixStyle: const TextStyle(color: AppColors.appBlue)),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(
            top: SizeConfig.heightMultiplier * 2.0086083213773316,
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: SizeConfig.widthMultiplier * 3.8888888888888884),
        child: Theme(
          data: ThemeData(
            primaryColor: AppColors.appBlue,
            primaryColorDark: AppColors.appBlue,
          ),
          child: TextField(
            controller: _quantity,
            textAlign: TextAlign.start,
            style: GoogleFonts.inter(
              color: AppColors.text_field_color,
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.textMultiplier * 1.757532281205165,
              letterSpacing: 0.25,
            ),
            decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide:
                        new BorderSide(color: AppColors.text_field_color),
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: '${_l10n.Quantity} (e.g 10)',
                labelText: _l10n.Quantity,
                contentPadding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    top: SizeConfig.heightMultiplier * 1.2553802008608321),
                suffixStyle: const TextStyle(color: AppColors.appBlue)),
          ),
        ),
      ),
      GestureDetector(
          onTap: () {
            if (_variatorName.text.length == 0) {
              _showToast("${_l10n.pleseEnter} ${_l10n.Variator}");
            } else if (_variation.text.length == 0) {
              _showToast("${_l10n.pleseEnter} ${_l10n.Variation}");
            } else if (_quantity.text.length == 0) {
              _showToast("${_l10n.pleseEnter} ${_l10n.Quantity}");
            } else {
              _variationList.clear();
              Variation variation = Variation();
              variation.variationLabel = _variation.text;
              variation.quantity = int.parse(_quantity.text);
              _variationList.add(variation);
              Variations variations = Variations();
              variations.variator = _variatorName.text;
              variations.variation = _variationList;
              _variationsList.add(variations);

              _showToast("New variation added");
              setState(() {
                _variatorName.text = "";
                AddNewVariationRoute.variation = "";
                AddNewVariationRoute.variator = "";
                AddNewVariationRoute.quantity = 0;
                _variation.text = "";
                _quantity.text = "";
              });
            }
          },
          child: Container(
              margin: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 2.0086083213773316,
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884),
              height: SizeConfig.heightMultiplier * 6.276901004304161,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.text_field_container)),
              child: Row(
                children: [
                  Container(
                    width: SizeConfig.widthMultiplier * 5.833333333333333,
                    height: SizeConfig.heightMultiplier * 3.0129124820659974,
                    margin: EdgeInsets.only(
                        top: SizeConfig.heightMultiplier * 1.2553802008608321,
                        left: SizeConfig.widthMultiplier * 3.645833333333333,
                        bottom:
                            SizeConfig.heightMultiplier * 1.2553802008608321),
                    child: Icon(
                      Icons.add,
                      color: AppColors.text_field_container,
                      size: 20,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.heightMultiplier * 1.5064562410329987,
                          left: SizeConfig.widthMultiplier * 2.6736111111111107,
                          bottom:
                              SizeConfig.heightMultiplier * 1.5064562410329987),
                      child: Text(
                        _l10n.Addnewvariation,
                        style: GoogleFonts.inter(
                          fontSize:
                              SizeConfig.textMultiplier * 1.757532281205165,
                          fontWeight: FontWeight.w400,
                          color: AppColors.text_field_container,
                          letterSpacing: 0.25,
                        ),
                      )),
                ],
              ))),
    ]));
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
