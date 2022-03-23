import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/apis/userApi/shoppingCartManager.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/model/product_detail_model/product_det_model.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/locator.dart';

class CartCard extends StatefulWidget {
  final ProductDetModel model;

  const CartCard({Key key, this.model}) : super(key: key);
  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  bool _isTags;
  bool isChecked = false;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.selected,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return AppColors.appBlue;
    }
    return AppColors.grey_700;
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
                fit: BoxFit.fill,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      color: AppColors.toolbarBlue,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.fill)),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: SizeConfig.heightMultiplier*2, left: SizeConfig.widthMultiplier*1, right: SizeConfig.widthMultiplier*1),
      child: AnimatedOpacity(
        opacity: isChecked ? 1.0 : 0.6,
        duration: const Duration(milliseconds: 500),
        child: Card(
          elevation: 9,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          child: Container(

              margin: EdgeInsets.only(
                  // left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                  // top: SizeConfig.heightMultiplier * 2.5107604017216643
              ),
              // height: SizeConfig.heightMultiplier * 16.947632711621235,
              child: Stack(

                children: [
                  Container(
                      margin: EdgeInsets.zero,

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _recentlyImage(widget.model),
                          _cartTxt(widget.model)
                        ],
                      )),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.75,
                    top: SizeConfig.heightMultiplier * 11.809182209469155,
                    child: InkWell(
                        onTap: () {
                          locator<ShoppingCartManager>().removeFromCart(widget.model);
                        },
                        child: Row(
                          children: [
                            Container(
                                height: SizeConfig.heightMultiplier * 2.5107604017216643,
                                width: SizeConfig.widthMultiplier * 4.861111111111111,
                                child: Image.asset('assets/images/remove_img.png')),
                            Checkbox(
                              checkColor: Colors.white,
                              fillColor: MaterialStateProperty.resolveWith(getColor),
                              value: isChecked,
                              onChanged: (bool value) {
                                setState(() {
                                  isChecked = value;
                                  if(isChecked){
                                    locator<ShoppingCartManager>().addToPurchase(widget.model);

                                  }
                                  else{
                                    locator<ShoppingCartManager>().removeFromPurchase(widget.model);
                                  }
                                });
                              },
                            ),

                          ],
                        )

                    ),
                  )
                ],
              )),
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
