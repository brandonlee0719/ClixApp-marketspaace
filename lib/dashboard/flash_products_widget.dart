import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/common_widgets.dart';
import 'package:market_space/common/product_card.dart';
import 'package:market_space/common/shimmers/shimmer_product_slider.dart';
import 'package:market_space/dashboard/flash/flash_bloc.dart';
import 'package:market_space/model/flash_promo_model/flash_promo_algolia.dart';
import 'package:market_space/product_landing_screen/product_landing_route.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/RouterServices.dart';

import 'Categories/categories/categories_bloc.dart';

class FlashProductsWidget extends StatefulWidget {
  const FlashProductsWidget({Key key}) : super(key: key);

  @override
  _FlashProductsState createState() => _FlashProductsState();
}

class _FlashProductsState extends State<FlashProductsWidget> {
  final _sc = ScrollController();

  @override
  void initState() {
    super.initState();
    _sc.addListener(() {
      if ((_sc.position.maxScrollExtent - _sc.offset) == 0) {
        context.read<FlashBloc>().add(LoadMoreFlashPromoEvent());
      }
    });
    getProducts();
    // print("Calling Init State");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashBloc, FlashState>(
      builder: (bContext, state) {
        // print("IN FLASH STATE $state");
        if (state is FlashLoadingState) {
          return ShimmerProductSlider();
        } else if (state is FlashLoadSuccessState) {
          return productsWidget(state.flashList, state.showLoader);
        } else if (state is FlashLoadFailedState) {
          return retryErrorBtn('Some Api Errors', () {
            getProducts();
          });
        } else {
          return ShimmerProductSlider();
        }
      },
    );
  }

  Widget productsWidget(List<FlashPromoAlgoliaObj> data, bool showLoader) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoadSuccessState && state.showHomeCategories) {
          if (state.selectedCategoryIndex > 0) return SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            yHeight2,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Flash Promo',
                style: TextStyle(
                    color: AppColors.app_txt_color,
                    fontSize: SizeConfig.textMultiplier * 2.887374461979914,
                    fontWeight: FontWeight.bold),
              ),
            ),
            yHeight1,
            Container(
              height: 200,
              child: ListView(
                  controller: _sc,
                  // physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final i in data)
                      Container(
                        width: 150,
                        child: ProductCard(
                          data: i,
                          onTap: () {
                            ProductLandingRoute.productNum = i.productNum;
                            ProductLandingRoute.productName = i.productName;
                            ProductLandingRoute.isProductLiked = i.liked;
                            RouterService.appRouter
                                .navigateTo(ProductLandingRoute.buildPath());
                          },
                          isExpandedImage: true,
                          width: double.infinity,
                          imageBorderBottomRadius: true,
                          bottomSizedSpace: yHeight2,
                        ),
                      ),
                    if (showLoader)
                      Center(
                          child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(AppColors.app_orange)))
                  ]),
            ),
          ],
        );
      },
    );
  }

  void getProducts() {
    BlocProvider.of<FlashBloc>(context).add(LoadFlashPromoEvent());
  }
}
