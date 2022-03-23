import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/common/common_widgets.dart';
import 'package:market_space/common/shimmers/shimmer_home_banner.dart';
import 'package:market_space/dashboard/banners/banners_bloc.dart';
import 'package:market_space/model/image_banner/image_banner_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'Categories/categories/categories_bloc.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({Key key}) : super(key: key);

  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  @override
  void initState() {
    super.initState();
    getBanners();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannersBloc, BannersState>(builder: (bContext, state) {
      if (state is BannerLoading) {
        return ShimmerHomeBanner();
      } else if (state is BannerLoaded) {
        return _bannerWidget(state.bannerList);
      } else if (state is BannerLoadingFailed) {
        return retryErrorBtn('Banner Loading Failed', () {
          getBanners();
        });
      } else {
        return ShimmerHomeBanner();
      }
    });
  }

  Widget _bannerWidget(BannerImagesModel imageBanner) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoadSuccessState && state.showHomeCategories) {
          if (state.selectedCategoryIndex > 0) return SizedBox.shrink();
        }
        return Column(
          children: [
            yHeight2,
            CarouselSlider.builder(
                itemCount: imageBanner.imgUrLs.length,
                itemBuilder: (BuildContext context, int i, int pageViewIndex) =>
                    _imageContainer(imageBanner.imgUrLs[i]),
                options: CarouselOptions(
                  height: 165,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.99,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 7),
                  autoPlayAnimationDuration: Duration(seconds: 1),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,
                )),
          ],
        );
      },
    );
  }

  Widget _imageContainer(String url) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            new BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
            ),
          ],
          image: DecorationImage(
              image: CachedNetworkImageProvider(url), fit: BoxFit.cover)),
    );
  }

  void getBanners() {
    BlocProvider.of<BannersBloc>(context).add(LoadBannerEvent());
  }
}
