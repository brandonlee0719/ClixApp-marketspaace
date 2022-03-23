import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:market_space/common/common_widgets.dart';
import 'package:market_space/common/product_card.dart';
import 'package:market_space/common/shimmers/shimmer_product_grid.dart';
import 'package:market_space/dashboard/products/products_bloc.dart';
import 'package:market_space/model/flash_promo_model/flash_promo_algolia.dart';
import 'package:market_space/product_landing_screen/product_landing_route.dart';
import 'package:market_space/services/RouterServices.dart';

import 'Categories/categories/categories_bloc.dart';

class ProductsGridWrapper extends StatelessWidget {
  const ProductsGridWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      buildWhen: (prev, current) {
        if (prev is CategoriesLoadingState &&
            current is CategoriesLoadSuccessState) {
          return true;
        }
        return prev is CategoriesLoadSuccessState &&
            current is CategoriesLoadSuccessState &&
            (prev.selectedCategoryIndex != current.selectedCategoryIndex);
      },
      builder: (context, state) {
        if (state is CategoriesLoadSuccessState) {
          // // print(
          //     "IN GRID STATE = ${state.categoryList.categoriesList[state.selectedCategoryIndex].algoliaSearchString}");
          return BlocProvider.value(
            value: context.read<ProductsBloc>(),
            child: ProductsGrid(),
          );
        }
        return Container();
      },
    );
  }
}

class ProductsGrid extends StatefulWidget {
  ProductsGrid({Key key}) : super(key: key);

  @override
  _ProductsGridState createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        // print("LoadingProducts State : $state");
        if (state is LoadingProducts) {
          return ShimmerProductGrid(
            yMargin: 15,
          );
        } else if (state is ProductLoaded) {
          return productsWidget(state.productList);
        } else if (state is ProductLoadingFailed) {
          return retryErrorBtn(state.errorMessage, () {
            getProducts(null);
          }, yMargin: 15);
        } else {
          return ShimmerProductGrid(
            yMargin: 15,
          );
        }
      },
    );
  }

  Widget productsWidget(List<FlashPromoAlgoliaObj> data) {
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 0),
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      scrollDirection: Axis.vertical,
      itemCount: data.length,
      addAutomaticKeepAlives: true,
      staggeredTileBuilder: (i) {
        return StaggeredTile.count(
          2,
          data[i].size.length,
        );
      },
      itemBuilder: (BuildContext context, index) {
        return buildProductCard(data[index], index);
      },
    );
  }

  Widget buildProductCard(data, index) {
    return ProductCard(
      data: data,
      onTap: () {
        ProductLandingRoute.productNum = data.productNum;
        ProductLandingRoute.productName = data.productName;
        ProductLandingRoute.isProductLiked = data.liked;
        RouterService.appRouter.navigateTo(ProductLandingRoute.buildPath());
      },
      width: double.infinity,
      isExpandedImage: true,
      imageBorderBottomRadius: false,
      index: index,
      bottomSizedSpace: yHeight2,
    );
  }

  void getProducts(String category) {
    // print('category:' + category);
    // BlocProvider.of<ProductsBloc>(context)
    //     .add(LoadListEvent(category: category));
  }

// Widget oldGrid() {
//   return GridView.builder(
//       shrinkWrap: true,
//       padding: EdgeInsets.symmetric(horizontal: 15),
//       physics: NeverScrollableScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         mainAxisSpacing: 10,
//         crossAxisSpacing: 0,
//         childAspectRatio: (itemWidth / itemHeight),
//       ),
//       itemCount: data.length,
//       itemBuilder: (BuildContext ctx, i) {
//         return ProductCard(
//           data: data[i],
//           onTap: () {
//             ProductLandingRoute.productNum = data[i].productNum;
//             ProductLandingRoute.productName = data[i].productName;
//             // ProductLandingRoute.isProductLiked = _isLiked;
//             RouterService.appRouter
//                 .navigateTo(ProductLandingRoute.buildPath());
//           },
//           width: double.infinity,
//           isExpandedImage: true,
//         );
//       });
// }
}
