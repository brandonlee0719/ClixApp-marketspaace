part of 'productList.dart';

class _ProductCard extends StatefulWidget {
  final FlashPromoAlgoliaObj model;
  final bool isChinese;

  const _ProductCard({Key key, this.model, this.isChinese}) : super(key: key);
  @override
  __ProductCardState createState() => __ProductCardState();
}

class __ProductCardState extends State<_ProductCard> {
  bool _isLiked = false;
  var _emptyStar = Image.asset(
    'assets/images/img_fav.png',
    width: SizeConfig.widthMultiplier * 5.833333333333333,
    height: SizeConfig.heightMultiplier * 4.017216642754663,
  );
  var _start = SvgPicture.asset(
    'assets/images/heart.svg',
    width: SizeConfig.widthMultiplier * 5.833333333333333,
    height: SizeConfig.heightMultiplier * 4.017216642754663,
    color: AppColors.nextButtonPrimary,
  );

  @override
  Widget build(BuildContext context) {
    FlashPromoAlgoliaObj model = widget.model;
    bool _isChinese = widget.isChinese;

    return GestureDetector(
        onTap: () {
          ProductLandingRoute.productNum = model.productNum;
          ProductLandingRoute.productName = model.productName;
          ProductLandingRoute.isProductLiked = _isLiked;
          RouterService.appRouter.navigateTo(
            ProductLandingRoute.buildPath(),
          );
        },
        child: Container(
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 0.24305555555555552,
                top: SizeConfig.heightMultiplier * 0.7532281205164993,
                // bottom: SizeConfig.heightMultiplier * 0.7532281205164993,
                right: SizeConfig.widthMultiplier * 0.24305555555555552),
            child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            color: AppColors.toolbarBlue,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            child: CachedNetworkImage(
                              imageUrl: model.imgURL != null
                                  ? model.imgURL
                                  : 'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg',
                              placeholder: (context, url) => Lottie.asset(
                                  'assets/loader/image_loading.json'),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.fitWidth,
                              // height: _isTags
                              //     ? SizeConfig.heightMultiplier *
                              //         31.44531250000000122833251953125
                              //     : SizeConfig.heightMultiplier *
                              //         34.17968750000000133514404296875,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Positioned(
                            right: SizeConfig.widthMultiplier * 3,
                            top: SizeConfig.widthMultiplier * 1,
                            height:
                                SizeConfig.heightMultiplier * 4.017216642754663,
                            // padding: EdgeInsets.only(
                            //     left: SizeConfig.widthMultiplier *
                            //         1.2152777777777777,
                            //     right: SizeConfig.widthMultiplier *
                            //         1.2152777777777777),
                            child: GestureDetector(
                                onTap: () {
                                  // _DashboardScreenBloc.liked_deleted =
                                  //     int.parse(model.productNum.toString());
                                  // _DashboardScreenBloc.liked_item = 0;
                                  // _DashboardScreenBloc.favProduct = model;
                                  // _DashboardScreenBloc.add(
                                  //     LikeDislikeEvent());
                                  setState(() {
                                    _isLiked = !_isLiked;
                                    // _favLoadingItems
                                    //     .remove(model.productNum.toString());
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  child: _isLiked ? _emptyStar : _start,
                                ))),
                      ],
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: SizeConfig.heightMultiplier * 0.75,
                                left: SizeConfig.heightMultiplier * 0.55),
                            child: Text(
                                _isChinese
                                    ? model.chineseTitle
                                    : model.productName,
                                style: GoogleFonts.inter(
                                    fontSize: SizeConfig.textMultiplier * 1.725,
                                    color: AppColors.app_txt_color,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.15)),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                left: SizeConfig.widthMultiplier *
                                    1.2152777777777777,
                                bottom: SizeConfig.heightMultiplier *
                                    1.2152777777777777,
                              ),
                              child: Text('\$${model.price}',
                                  // : '\$$prefSevenDecimal',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                      fontSize: SizeConfig.textMultiplier *
                                          1.757532281205165,
                                      color: AppColors.app_txt_color,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.1))),
                          Container(
                            margin: EdgeInsets.only(
                                // right: SizeConfig.widthMultiplier *
                                //     3.8888888888888884,
                                left: SizeConfig.widthMultiplier * 1),
                          ),
                          // Spacer(),
                          // if (_isTags)
                          //   Container(
                          //       height: SizeConfig.heightMultiplier *
                          //           6.276901004304161,
                          //       // width: SizeConfig.widthMultiplier * 48.61111111111111,
                          //       child: GridView.count(
                          //           crossAxisCount: 2,
                          //           shrinkWrap: true,
                          //           childAspectRatio: 0.35,
                          //           scrollDirection: Axis.horizontal,
                          //           children: model.tags
                          //               .map((e) => _tags(e))
                          //               ?.toList())),
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}
