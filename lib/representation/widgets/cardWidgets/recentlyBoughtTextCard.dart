import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/model/recently_product_model/recently_brought_model.dart';
import 'package:market_space/recently_brought_details/recently_detail_route.dart';
import 'package:market_space/representation/commons/reusanleFonts.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/RouterServices.dart';

class RecentlyBoughtText extends StatelessWidget {
  final BasicProductModel model;

  const RecentlyBoughtText({Key key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    model.description == null
        ? model.description = ("No description for this item is uploaded")
        : () {};
    return Expanded(
      child: Container(
        height: SizeConfig.heightMultiplier * 17,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: SizeConfig.heightMultiplier * 13,
              child: Text(
                '\$${model?.fiatPrice}',
                maxLines: 1,
                style: ReusableFonts.priceStyle1,
              ),
            ),
            Positioned(
              left: SizeConfig.widthMultiplier * 3.5,
              bottom: SizeConfig.heightMultiplier * 13,
              child: Text(
                '${model?.title}',
                maxLines: 1,
                style: ReusableFonts.cardTitleStyle,
              ),
            ),
            Positioned(
              left: SizeConfig.widthMultiplier * 3.5,
              top: SizeConfig.heightMultiplier * 7,
              child: Container(
                width: SizeConfig.widthMultiplier * 50,
                child: Text(
                  '${model?.description}',
                  style: ReusableFonts.cardDescription,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecentlyBoughtImage extends StatelessWidget {
  final BasicProductModel model;

  const RecentlyBoughtImage({Key key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.widthMultiplier * 30,
      height: SizeConfig.heightMultiplier * 17,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child: CachedNetworkImage(
                imageUrl: model?.imgLink != null
                    ? model?.imgLink
                    : 'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg',
                placeholder: (context, url) =>
                    Lottie.asset('assets/loader/image_loading.json'),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.fill,
                imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15)),
                          color: AppColors.toolbarBlue,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.fill)),
                    )),
          ),
          if (model is RecentlyBrought)
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: SizeConfig.widthMultiplier * 30,
                height: SizeConfig.heightMultiplier * 5,
                child: Center(
                  child: Container(
                    height: SizeConfig.heightMultiplier * 2.5107604017216643,
                    width: SizeConfig.widthMultiplier * 20,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(
                      child: Text(
                        (model as RecentlyBrought).shippingStatus,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize:
                              SizeConfig.textMultiplier * 1.2553802008608321,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class RecentBroughtCard extends StatelessWidget {
  final BasicProductModel model;

  const RecentBroughtCard({Key key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        RecentlyDetailRoute.recentlyBoughtModel = model;
        RouterService.appRouter.navigateTo(RecentlyDetailRoute.buildPath());
      },
      child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          shadowColor: AppColors.grey_700,
          margin: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
          child: Row(
            children: [
              RecentlyBoughtImage(model: model),
              RecentlyBoughtText(model: model),
            ],
          )),
    );
  }
}
