import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/common/selling_item.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/model/sell_item_req_model/sell_item_req_model.dart';
import 'package:market_space/sell_new_products/product_variation/add_new_variation/add_new_variation_route.dart';
import 'package:market_space/sell_new_products/product_variation/add_new_variation/add_new_variation_screen.dart';
import 'package:market_space/sell_new_products/product_variation/seller_product_variation_bloc.dart';
import 'package:market_space/sell_new_products/product_variation/seller_product_variation_l10n.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class SellerProductVariationScreen extends StatefulWidget {
  @override
  _SellerProductVariationScreenState createState() =>
      _SellerProductVariationScreenState();
}

class _SellerProductVariationScreenState
    extends State<SellerProductVariationScreen> {
  final SellerProductVariationBloc _productVariationBloc =
      SellerProductVariationBloc(Initial());
  SellerProductVariationL10n _l10n = SellerProductVariationL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
  bool _isLoading = false;
  var navigateText;
  List<Variations> variations = List();
  List<Variation> variatorList = List();

  @override
  void initState() {
    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = SellerProductVariationL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n =
            SellerProductVariationL10n(Locale.fromSubtags(languageCode: 'zh'));
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
          create: (_) => _productVariationBloc,
          child: BlocListener<SellerProductVariationBloc,
                  SellerProductVariationState>(
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
              style: GoogleFonts.inter(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.5,
              ),
            )),
        onPressed: () {
          setState(() {
            Navigator.pop(context);
          });
        },
      ),
    );
  }

  Widget _variationScreen() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                bottom: SizeConfig.heightMultiplier * 1.0043041606886658,
                top: SizeConfig.heightMultiplier * 2.0086083213773316),
            child: Text(
                '${_l10n.Product} ${_l10n.Variation} & ${_l10n.Quantity}',
                maxLines: 2,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                    letterSpacing: 0.15,
                    textStyle: GoogleFonts.inter(
                        fontSize:
                            SizeConfig.textMultiplier * 2.0086083213773316,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4),
                    color: AppColors.app_txt_color)),
          ),
          if (variations == null || variations.isEmpty)
            Container(
              height: SizeConfig.heightMultiplier * 25.107604017216644,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/empty_box.png',
                    fit: BoxFit.contain,
                    height: SizeConfig.heightMultiplier * 18.830703012912483,
                    width: SizeConfig.widthMultiplier * 24.305555555555554,
                  ),
                  Text(
                    "${_l10n.NoRecentProductsAvailable} !!",
                    style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 2.5107604017216643,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          if (variations != null || variations.isNotEmpty)
            Container(
                child: ListView(
              shrinkWrap: true,
              children: variations
                  .map((e) => _variatorWidget(e.variation, e.variator))
                  .toList(),
            )),
          GestureDetector(
              onTap: () {
                _navigateToPage();
              },
              child: Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 2.0086083213773316,
                      left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      right: SizeConfig.widthMultiplier * 3.8888888888888884),
                  height: SizeConfig.heightMultiplier * 6.276901004304161,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: AppColors.text_field_container)),
                  child: Row(
                    children: [
                      Container(
                        width: SizeConfig.widthMultiplier * 5.833333333333333,
                        height:
                            SizeConfig.heightMultiplier * 3.0129124820659974,
                        margin: EdgeInsets.only(
                            top: SizeConfig.heightMultiplier *
                                1.2553802008608321,
                            left:
                                SizeConfig.widthMultiplier * 3.645833333333333,
                            bottom: SizeConfig.heightMultiplier *
                                1.2553802008608321),
                        child: Icon(
                          Icons.add,
                          color: AppColors.text_field_container,
                          size: 20,
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.heightMultiplier *
                                  1.5064562410329987,
                              left: SizeConfig.widthMultiplier *
                                  2.6736111111111107,
                              bottom: SizeConfig.heightMultiplier *
                                  1.5064562410329987),
                          child: Text(
                            '${_l10n.Addnewvariation}',
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    1.757532281205165,
                                fontWeight: FontWeight.w400,
                                color: AppColors.text_field_container,
                                letterSpacing: 0.25,
                                textStyle: TextStyle(fontFamily: 'Roboto')),
                          )),
                    ],
                  ))),
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
                    hintText: '${_l10n.Quantity}',
                    labelText: '${_l10n.Quantity}',
                    contentPadding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                        top: SizeConfig.heightMultiplier * 1.2553802008608321),
                    suffixStyle: const TextStyle(color: AppColors.appBlue)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _variatorWidget(List<Variation> variation, String variator) {
    // print('variation: ${variation}');
    return Container(
        // height: SizeConfig.heightMultiplier * 20.086083213773314,
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: SizeConfig.widthMultiplier * 3.8888888888888884,
            top: SizeConfig.heightMultiplier * 1.0043041606886658),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.appBlue)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: variation.map((e) => _variationItem(e, variator)).toList(),
        ));
  }

  Widget _variationItem(Variation variation, String variator) {
    return Container(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(5),
          child: Row(
            children: [
              Container(
                  child: Text(
                variator,
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                    fontWeight: FontWeight.w400,
                    color: AppColors.app_txt_color),
              )),
              Container(
                  child: Text(
                '/${variation.variationLabel}',
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                    fontWeight: FontWeight.w400,
                    color: AppColors.app_txt_color),
              ))
            ],
          ),
        ),
        Spacer(),
        Container(
            margin: EdgeInsets.all(5),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    AddNewVariationRoute.variator = variator;
                    AddNewVariationRoute.variation = variation.variationLabel;
                    AddNewVariationRoute.quantity = variation.quantity;
                    _navigateToPage();
                  },
                  child: Container(
                    height: SizeConfig.heightMultiplier * 2.5107604017216643,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      right: SizeConfig.widthMultiplier * 1.2152777777777777,
                    ),
                    padding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 1.9444444444444442,
                        right: SizeConfig.widthMultiplier * 1.9444444444444442,
                        top: SizeConfig.heightMultiplier * 0.25107604017216645,
                        bottom:
                            SizeConfig.heightMultiplier * 0.25107604017216645),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.seeAllText,
                            width: SizeConfig.widthMultiplier *
                                0.24305555555555552),
                        color: AppColors.seeAllBack),
                    child: Text(
                      _l10n.EDIT,
                      style: TextStyle(
                        color: AppColors.seeAllText,
                        fontSize:
                            SizeConfig.textMultiplier * 1.2553802008608321,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      List<Variations> list = List();
                      for (int i = 0; i < SellingItems.variations.length; i++) {
                        for (int j = 0;
                            j < SellingItems.variations[i].variation.length;
                            j++) {
                          if (SellingItems
                                  .variations[i].variation[j].variationLabel !=
                              variation.variationLabel) {
                            list.add(SellingItems.variations[i]);
                          }
                        }
                      }
                      // SellingItems.variations.remove(variations);
                      // _variationsList.addAll(list);
                      variations.clear();
                      variations.addAll(list);
                      SellingItems.variations.clear();
                      SellingItems.variations.addAll(list);
                    });
                  },
                  child: Container(
                    height: SizeConfig.heightMultiplier * 2.5107604017216643,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      right: SizeConfig.widthMultiplier * 1.2152777777777777,
                    ),
                    padding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 1.9444444444444442,
                        right: SizeConfig.widthMultiplier * 1.9444444444444442,
                        top: SizeConfig.heightMultiplier * 0.25107604017216645,
                        bottom:
                            SizeConfig.heightMultiplier * 0.25107604017216645),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.remove_red,
                            width: SizeConfig.widthMultiplier *
                                0.24305555555555552),
                        color: AppColors.remove_red),
                    child: Text(
                      _l10n.Remove,
                      style: TextStyle(
                        color: AppColors.cancel_red,
                        fontSize:
                            SizeConfig.textMultiplier * 1.2553802008608321,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ],
    ));
  }

  Future _navigateToPage() async {
    final navigateText = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => AddNewVariationScreen()));
    if (navigateText != null && navigateText == "navigator") {
      setState(() {
        variations = SellingItems.variations;
      });
      // print(navigateText);
    }
  }
}
