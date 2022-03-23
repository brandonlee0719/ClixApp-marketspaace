import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/active_products/active_product_bloc.dart';
import 'package:market_space/active_products/active_product_events.dart';
import 'package:market_space/active_products/active_product_route.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/multi_selected_chip.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/model/active_products_model/active_product_model.dart';
import 'package:market_space/model/product_model.dart';
import 'package:market_space/product_landing_screen/product_landing_route.dart';
import 'package:market_space/repositories/active_product_repository/active_product_repository.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/responsive_layout/size_config.dart';

import 'active_product_l10n.dart';
import 'active_product_state.dart';

class ActiveProductScreen extends StatefulWidget {
  @override
  _ActiveProductScreenState createState() => _ActiveProductScreenState();
}

class _ActiveProductScreenState extends State<ActiveProductScreen> {
  final ActiveProductsBloc _ProductBloc = ActiveProductsBloc(Initial());
  final ActiveProductRepository _activeProductRepository =
      ActiveProductRepository();
  ActiveProductL10n _l10n = ActiveProductL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  bool _isLoading = true;
  List<String> _categoryList = ["Software", "Movies", "Clothing"];
  List<String> _tagsList = ["Software", "longest tag", "Clothing", "tag"];
  bool _isTags = false;

  @override
  void initState() {
    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = ActiveProductL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n = ActiveProductL10n(Locale.fromSubtags(languageCode: 'zh'));
      }
    });
    _ProductBloc.add(ActiveProductsScreenEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.toolbarBlue,
      appBar: Toolbar(
        title: _l10n.ACTIVEPRODUCTS,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.white,
        child: BlocProvider(
          create: (_) => _ProductBloc,
          child: BlocListener<ActiveProductsBloc, ActiveProductsState>(
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
                children: [
                  // if (!_isLoading)
                  //   Container(
                  //     margin: EdgeInsets.all(5),
                  //     width: SizeConfig.widthMultiplier * 12.152777777777777,
                  //     child: _filter(),
                  //   ),
                  _baseScreen(),
                ],
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
          children: [
            // if (!_isLoading)
            StreamBuilder(
              stream: _ProductBloc.activeProductStream,
              builder: (context, stream) {
                if (stream.connectionState == ConnectionState.done) {}

                if (stream.hasData) {
                  return Container(
                    child: ListView(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        children: stream.data
                            .map<Widget>((e) => _activeProductCard(e))
                            .toList()),
                  );
                } else {
                  return Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 3.8888888888888884,
                          right:
                              SizeConfig.widthMultiplier * 3.8888888888888884,
                          top:
                              SizeConfig.heightMultiplier * 2.5107604017216643),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: ListView(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: [
                            Container(
                              height: SizeConfig.heightMultiplier *
                                  18.830703012912483,
                              width: MediaQuery.of(context).size.width,
                              child: Lottie.asset(
                                'assets/loader/horizontal_card_loding.json',
                              ),
                            ),
                            Container(
                              height: SizeConfig.heightMultiplier *
                                  18.830703012912483,
                              width: MediaQuery.of(context).size.width,
                              child: Lottie.asset(
                                  'assets/loader/horizontal_card_loding.json'),
                            ),
                            Container(
                              height: SizeConfig.heightMultiplier *
                                  18.830703012912483,
                              width: MediaQuery.of(context).size.width,
                              child: Lottie.asset(
                                  'assets/loader/horizontal_card_loding.json'),
                            ),
                            Container(
                              height: SizeConfig.heightMultiplier *
                                  18.830703012912483,
                              width: MediaQuery.of(context).size.width,
                              child: Lottie.asset(
                                  'assets/loader/horizontal_card_loding.json'),
                            ),
                          ]));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _activeProductCard(ActiveProducts model) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 2.5107604017216643),
      child: GestureDetector(
        onTap: () {
          ProductLandingRoute.productNum = model.productNum;
          RouterService.appRouter.navigateTo(ProductLandingRoute.buildPath());
        },
        child: Card(
            child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: SizeConfig.widthMultiplier * 29.166666666666664,
              child: _activeImage(model),
            ),
            Container(
              child: _activeBroughtTxt(model),
            )
          ],
        )),
      ),
    );
  }

  Widget _activeImage(ActiveProducts model) {
    if (model.tags == null) {
      _isTags = false;
    } else {
      _isTags = true;
    }
    return Container(
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

  Widget _activeBroughtTxt(ActiveProducts model) {
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
                    Container(
                      child: Column(
                        children: [
                          Container(
                            width:
                                SizeConfig.widthMultiplier * 24.305555555555554,
                            margin: EdgeInsets.only(
                                left: SizeConfig.widthMultiplier *
                                    2.9166666666666665,
                                top: SizeConfig.heightMultiplier *
                                    1.0043041606886658),
                            child: Expanded(
                                child: Text(
                              model.title,
                              style: GoogleFonts.inter(
                                  fontSize: SizeConfig.textMultiplier *
                                      2.259684361549498,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.15),
                            )),
                          ),
                          if (_isTags)
                            Container(
                                height: SizeConfig.heightMultiplier *
                                    6.276901004304161,
                                // width: SizeConfig.widthMultiplier * 60.76388888888888,
                                child: GridView.count(
                                    crossAxisCount: 2,
                                    shrinkWrap: true,
                                    childAspectRatio: 0.35,
                                    scrollDirection: Axis.horizontal,
                                    children: model.tags
                                        .map((e) => _tags(e))
                                        ?.toList())),
                        ],
                      ),
                    ),
                    Spacer(),
                    Expanded(
                        child: Container(
                            child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            right:
                                SizeConfig.widthMultiplier * 1.9444444444444442,
                          ),
                          child: Text(
                            '\$${model.fiatPrice}',
                            maxLines: 1,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    1.757532281205165,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.1),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              right: SizeConfig.widthMultiplier *
                                  1.9444444444444442,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  CryptoFontIcons.BTC,
                                  size: 12,
                                ),
                                Expanded(
                                    child: Text(
                                  model.cryptoPrice,
                                  maxLines: 1,
                                  style: GoogleFonts.inter(
                                      fontSize: SizeConfig.textMultiplier *
                                          1.5064562410329987,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.4),
                                )),
                              ],
                            )),
                      ],
                    ))),
                  ])),
            ])),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 2.9166666666666665,
                  top: SizeConfig.heightMultiplier * 1.0043041606886658,
                  right: SizeConfig.widthMultiplier * 1.9444444444444442),
              child: Text(
                model.description ?? "",
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
}
