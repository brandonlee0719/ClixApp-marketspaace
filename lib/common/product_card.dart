import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/common_widgets.dart';
import 'package:market_space/dashboard/products/fav_products/favourite_products_bloc.dart';
import 'package:market_space/model/flash_promo_model/flash_promo_algolia.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatefulWidget {
  const ProductCard(
      {Key key,
      this.height,
      this.width,
      this.isExpandedImage,
      @required this.onTap,
      @required this.data,
      this.imageBorderBottomRadius = true,
      this.index,
      this.bottomSizedSpace})
      : super(key: key);

  final double height;
  final double width;
  final bool isExpandedImage;
  final Function onTap;
  final FlashPromoAlgoliaObj data;
  final bool imageBorderBottomRadius;
  final int index;
  final Widget bottomSizedSpace;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with AutomaticKeepAliveClientMixin {
  // final ProductsBloc _productsBloc =  ProductsBloc(Initial());

  // final Set<String> _favLoadingItems = HashSet();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // bool _isLiked = _favLoadingItems.contains(widget.data.productNum.toString());

    return BlocBuilder<FavouriteProductsBloc, FavouriteProductsState>(
      builder: (context, state) {
        if (state is FavouriteProductsLoaded) {
          bool liked = state.favProducts.contains(widget.data.productNum);
          return GestureDetector(
              onTap: widget.onTap,
              child: Container(
                  height: SizeConfig.heightMultiplier * 25.107604017216644,
                  width: SizeConfig.widthMultiplier * 36.45833333333333,
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 0.48611111111111105,
                      right: SizeConfig.widthMultiplier * 0.48611111111111105),
                  child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              if (widget.isExpandedImage)
                                Expanded(
                                    child: _imageContainer(
                                        widget.data.thumbnailURL,
                                        width: widget.width,
                                        height: widget.height))
                              else
                                _imageContainer(widget.data.imgURL,
                                    width: widget.width, height: widget.height),
                              Padding(
                                padding: EdgeInsets.all(
                                    1 * SizeConfig.widthMultiplier),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            '${widget.data.productName}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                                fontSize:
                                                    SizeConfig.textMultiplier *
                                                        1.8,
                                                color: AppColors.app_txt_color,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.15))),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      child: Text('\$${widget.data.price}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      1.757532281205165,
                                              color: AppColors.app_txt_color,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.1)),
                                    ),
                                    widget.bottomSizedSpace ?? Container(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Positioned(
                          //   top: SizeConfig.heightMultiplier *
                          //       0.25107604017216645,
                          //   right: SizeConfig.widthMultiplier *
                          //       0.48611111111111105,
                          //   child: Container(
                          //     height: SizeConfig.heightMultiplier *
                          //         4.017216642754663,
                          //     padding: EdgeInsets.only(
                          //         left: SizeConfig.widthMultiplier *
                          //             0.48611111111111105,
                          //         right: SizeConfig.widthMultiplier *
                          //             0.48611111111111105),
                          //     child: GestureDetector(
                          //       onTap: () {},
                          //       // onTap: () =>
                          //       //     BlocProvider.of<FavouriteProductsBloc>(
                          //       //             context)
                          //       //         .add(AddRemoveFavouriteProduct(
                          //       //             widget.data.productNum)
                          //       //             ),
                          //       child: liked
                          //           ? Container(
                          //               padding: EdgeInsets.all(2),
                          //               child: Image.asset(
                          //                 'assets/images/img_fav.png',
                          //                 width: SizeConfig.widthMultiplier *
                          //                     5.833333333333333,
                          //                 height: SizeConfig.heightMultiplier *
                          //                     4.017216642754663,
                          //               ),
                          //             )
                          //           : SvgPicture.asset(
                          //               'assets/images/heart.svg',
                          //               width: SizeConfig.widthMultiplier *
                          //                   5.833333333333333,
                          //               height: SizeConfig.heightMultiplier *
                          //                   4.017216642754663,
                          //               color: AppColors.nextButtonPrimary,
                          //             ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ))));
        }
        return Container();
      },
    );
  }

  Widget _imageContainer(String url, {double height, double width}) {
    // print('height of product card: ${height}');
    // url = "https://ubxty.com/assets/tree-1.webp";
    return Container(
      height: height ?? 140,
      width: width ?? 140,
      margin: EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: CachedNetworkImageProvider(url), fit: BoxFit.cover),
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft:
                  Radius.circular(widget.imageBorderBottomRadius ? 8 : 0),
              bottomRight:
                  Radius.circular(widget.imageBorderBottomRadius ? 8 : 0))),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
