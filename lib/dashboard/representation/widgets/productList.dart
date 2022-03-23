import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/model/flash_promo_model/flash_promo_algolia.dart';
import 'package:market_space/product_landing_screen/product_landing_route.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/RouterServices.dart';
part 'productCard.dart';

class CardList extends StatefulWidget {
  final List<FlashPromoAlgoliaObj> productList;
  final bool isLoading;
  final ValueNotifier notifier;

  const CardList(this.notifier, {Key key, this.productList, this.isLoading})
      : super(key: key);
  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  ScrollController _productScrollController;
  List<FlashPromoAlgoliaObj> _productList;
  bool _isLoading;

  @override
  void initState() {
    _productList = widget.productList;
    _isLoading = widget.isLoading;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('product loading: ${_isLoading}');
    return ValueListenableBuilder(
        valueListenable: widget.notifier,
        builder: (context, value, int) {
          return _productList.isNotEmpty
              ? Container(
                  // margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 4.017216642754663),
                  child: StaggeredGridView.countBuilder(
                  crossAxisCount: 4,

                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: _productList.length,
                  itemBuilder: (BuildContext context, index) =>
                      // openBuilder: (context, _) => RouterService.appRouter.navigateTo(ProductLandingRoute.buildPath()),

                      _ProductCard(
                          model: _productList[index], isChinese: false),
                  // onClicked: openContainer,
                  staggeredTileBuilder: (index) => new StaggeredTile.count(
                      2, _productList[index].size.length),
                  // mainAxisSpacing: 0.0,
                  // crossAxisSpacing: 1.0,
                ))
              : _productList.isEmpty && !_isLoading
                  ? Container(
                      margin:
                          EdgeInsets.only(top: SizeConfig.heightMultiplier * 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image.asset(
                          //   'assets/images/empty_box.png',
                          //   fit: BoxFit.contain,
                          //   height: SizeConfig.heightMultiplier * 18.830703012912483,
                          //   width: SizeConfig.widthMultiplier * 24.305555555555554,
                          // ),
                          Center(
                            child: Text(
                              "No items in this category, be the first to add one!",
                              style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    1.757532281205165,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.heightMultiplier * 4.017216642754663),
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        children: [
                          Container(
                              height: SizeConfig.heightMultiplier *
                                  24.60545193687231,
                              width: SizeConfig.widthMultiplier *
                                  30.138888888888886,
                              margin: EdgeInsets.only(
                                  left: SizeConfig.widthMultiplier *
                                      2.4305555555555554,
                                  right: SizeConfig.widthMultiplier *
                                      2.4305555555555554,
                                  top: SizeConfig.heightMultiplier *
                                      1.2553802008608321),
                              child: Lottie.asset(
                                  'assets/loader/loading_card.json',
                                  width: SizeConfig.widthMultiplier *
                                      30.138888888888886)),
                          Container(
                              height: SizeConfig.heightMultiplier *
                                  24.60545193687231,
                              width: SizeConfig.widthMultiplier *
                                  30.138888888888886,
                              margin: EdgeInsets.only(
                                  left: SizeConfig.widthMultiplier *
                                      2.4305555555555554,
                                  right: SizeConfig.widthMultiplier *
                                      2.4305555555555554,
                                  top: SizeConfig.heightMultiplier *
                                      1.2553802008608321),
                              child: Lottie.asset(
                                  'assets/loader/loading_card.json',
                                  width: SizeConfig.widthMultiplier *
                                      30.138888888888886)),
                          Container(
                              height: SizeConfig.heightMultiplier *
                                  24.60545193687231,
                              width: SizeConfig.widthMultiplier *
                                  30.138888888888886,
                              margin: EdgeInsets.only(
                                  left: SizeConfig.widthMultiplier *
                                      2.4305555555555554,
                                  right: SizeConfig.widthMultiplier *
                                      2.4305555555555554,
                                  top: SizeConfig.heightMultiplier *
                                      1.2553802008608321),
                              child: Lottie.asset(
                                  'assets/loader/loading_card.json',
                                  width: SizeConfig.widthMultiplier *
                                      30.138888888888886)),
                          Container(
                              height: SizeConfig.heightMultiplier *
                                  24.60545193687231,
                              width: SizeConfig.widthMultiplier *
                                  30.138888888888886,
                              margin: EdgeInsets.only(
                                  left: SizeConfig.widthMultiplier *
                                      2.4305555555555554,
                                  right: SizeConfig.widthMultiplier *
                                      2.4305555555555554,
                                  top: SizeConfig.heightMultiplier *
                                      1.2553802008608321),
                              child: Lottie.asset(
                                  'assets/loader/loading_card.json',
                                  width: SizeConfig.widthMultiplier *
                                      30.138888888888886)),
                        ],
                      ),
                    );
        });
  }
}
