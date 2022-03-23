import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/common_widgets.dart';
import 'package:market_space/common/product_card.dart';
import 'package:market_space/common/shimmers/shimmer_product_grid.dart';
import 'package:market_space/common/toolbar_new.dart';
import 'package:market_space/dashboard/Categories/categories/categories_bloc.dart';
import 'package:market_space/dashboard/products/products_bloc.dart';
import 'package:market_space/model/flash_promo_model/flash_promo_algolia.dart';
import 'package:market_space/product_landing_screen/product_landing_route.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/search/search_l10n.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductsPageWrapper extends StatelessWidget {
  // final String algoliaString;

  const ProductsPageWrapper();

  @override
  Widget build(BuildContext context) {
    return ProductsPage();
    // return BlocBuilder<CategoriesBloc, CategoriesState>(
    //   builder: (context, state) {
    //     if (state is CategoriesLoadSuccessState)
    //       return BlocProvider.value(
    //         value: ProductsBloc()
    //           ..add(LoadListEvent(
    //             category: state
    //                 .categoryList
    //                 .categoriesList[state.selectedCategoryIndex]
    //                 .algoliaSearchString,
    //             subCategory: algoliaString,
    //           )),
    //         child: ProductsPage(),
    //       );
    //     return Container();
  }
  // );
  // }
}

class ProductsPage extends StatefulWidget {
  const ProductsPage() : super();

  // final String algoliaString;

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  SearchL10n _l10n =
      SearchL10n(Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
  final TextEditingController _searchController = TextEditingController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ProductsBloc _productsBloc = ProductsBloc();
  List<FlashPromoAlgoliaObj> lst;

  FocusNode searchFocusNode = FocusNode();

  void _onRefresh() async {
    // getProducts(null);
    _refreshController.refreshCompleted();
  }

  final Color background = AppColors.toolbarBlue;
  final Color fill = AppColors.lightgrey;

  @override
  void initState() {
    setState(() {
      _productsBloc..add(SetupEvent());
    });
    super.initState();
    // getProducts(widget.algoliaString);

    // print('Algolia String is ==> ${widget.algoliaString}');
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];

    final double fillPercent = 39.7; // fills 56.23% for container from bottom
    final double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: gradient,
              stops: stops)),
      child: Scaffold(
        appBar: ToolbarNew(title: 'Search'),
        body: Column(
          children: [
            _searchBar(),
            Padding(
                padding: EdgeInsets.only(top: SizeConfig.heightMultiplier * 2)),
            Expanded(
              child: ListView(
                children: [
                  BlocBuilder<ProductsBloc, ProductsState>(
                    cubit: _productsBloc,
                    builder: (context, state) {
                      print('state is: ' + state.toString());
                      if (state is Blank) {
                        return emptySearch();
                      }
                      if (state is LoadingProducts) {
                        return ShimmerProductGrid(
                          yMargin: 20,
                        );
                      } else if (state is ProductLoaded) {
                        return productsWidget(state.productList);
                      } else if (state is ProductLoadingFailed) {
                        return Column(
                          children: [
                            retryErrorBtn(state.errorMessage, () {
                              // getProducts(widget.algoliaString);
                            }, yMargin: 15),
                          ],
                        );
                      } else {
                        return ShimmerProductGrid(
                          yMargin: 20,
                        );
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget emptySearch() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Center(child: Text("Start searching")));
  }

  Widget productsWidget(List<FlashPromoAlgoliaObj> data) {
    // var size = MediaQuery.of(context).size;
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    // final double itemWidth = size.width / 2;
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 0),
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      scrollDirection: Axis.vertical,
      itemCount: data.length,
      staggeredTileBuilder: (i) {
        return StaggeredTile.count(
          2,
          data[i].size.length,
        );
      },
      itemBuilder: (BuildContext context, index) {
        return ProductCard(
          data: data[index],
          onTap: () {
            ProductLandingRoute.productNum = data[index].productNum;
            ProductLandingRoute.productName = data[index].productName;
            // ProductLandingRoute.isProductLiked = _isLiked;
            RouterService.appRouter.navigateTo(ProductLandingRoute.buildPath());
          },
          width: double.infinity,
          bottomSizedSpace: yHeight2,
          isExpandedImage: true,
        );
      },
    );
  }

  Widget _searchBar() {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 1.5064562410329987),
      child: Theme(
        data: ThemeData(
          primaryColor: AppColors.appBlue,
          primaryColorDark: AppColors.appBlue,
        ),
        child: TextField(
          keyboardType: TextInputType.text,
          controller: _searchController,
          autocorrect: false,
          textInputAction: TextInputAction.search,
          // onEditingComplete: () {

          // },
          // focusNode: searchFocusNode,
          onSubmitted: (value) {
            // if (!searchFocusNode.hasPrimaryFocus)
            print('value is: ' + value);
            if (value != null && value.isNotEmpty) {
              _productsBloc.add(LoadListEvent(searchText: value));
            }
          },
          maxLength: 25,
          buildCounter: (BuildContext context,
                  {int currentLength, int maxLength, bool isFocused}) =>
              null,
          style: GoogleFonts.inter(
            color: AppColors.text_field_color,
            fontWeight: FontWeight.w400,
            fontSize: SizeConfig.textMultiplier * 1.757532281205165,
            letterSpacing: 0.25,
          ),
          decoration: new InputDecoration(
              border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(30.0)),
              hintText: '${_l10n.search}...',
              contentPadding: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3.8888888888888884),
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    _searchController.clear();
                  });
                },

                // },
                // onTap: () {
                //   _productsBloc.add(event)
                // }
                child: Icon(
                  Icons.close,
                  color: AppColors.text_field_container,
                  size: 14,
                ),
              ),
              suffixStyle: GoogleFonts.inter(
                color: AppColors.appBlue,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.25,
              )),
        ),
      ),
    );
  }

// void getProducts(String category) {
//   BlocProvider.of<ProductsBloc>(context)
//       .add(LoadListEvent(category: category ?? ''));
// }
}
