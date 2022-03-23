import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/cart/cart_route.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/dashboard/Categories/categories/categories_bloc.dart';
import 'package:market_space/dashboard/dashboard_l10n.dart';
import 'package:market_space/dashboard/products/products_bloc.dart';
import 'package:market_space/model/category/categories_model_new.dart';
import 'package:market_space/order_checkout/order_checkout_route.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/search/search_route.dart';
import 'package:market_space/services/RouterServices.dart';

class HeaderDashboard extends StatefulWidget {
  const HeaderDashboard({Key key}) : super(key: key);

  @override
  _HeaderDashboardState createState() => _HeaderDashboardState();
}

class _HeaderDashboardState extends State<HeaderDashboard> {
  double _toolbarExtendHeight = SizeConfig.heightMultiplier * 12.057;

  double toolbarHeight =
      SizeConfig.heightMultiplier * 18.0468750000000007049560546875;

  DashboardL10n _l10n =
      DashboardL10n(Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  // var _tabController = TabController();

  // int selected = 0;

  @override
  void initState() {
    // print("init state is triggered");
    super.initState();
    getAllCategories();
    // widget.pageController
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
            elevation: 10,
            shadowColor: Color.fromRGBO(0, 0, 0, 20),
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15)),
            ),
            child: Container(
                decoration: BoxDecoration(
                    color: AppColors.lightgrey,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: SizeConfig.widthMultiplier * 60.277777777,
                          // height: SizeConfig.heightMultiplier * 11.80,
                          child: Container(
                            child: Card(
                              elevation: 4,
                              shadowColor: AppColors.darkgrey,
                              margin: EdgeInsets.only(
                                  bottom: SizeConfig.heightMultiplier *
                                      0.25107604017216645),
                              clipBehavior: Clip.antiAlias,
                              color: AppColors.toolbarBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(15),
                              )),
                              child: SafeArea(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                              left: SizeConfig.widthMultiplier *
                                                  3.8888888888888884,
                                              top: SizeConfig.heightMultiplier *
                                                  2.259684361549498,
                                              right:
                                                  SizeConfig.widthMultiplier *
                                                      22.166666666666664,
                                            ),
                                            child: Text(
                                              "MARKETSPAACE",
                                              style: GoogleFonts.montserrat(
                                                textStyle: TextStyle(
                                                    color: AppColors.white,
                                                    fontFamily: 'Montserrat',
                                                    fontSize: SizeConfig
                                                            .textMultiplier *
                                                        1.6319942611190819),
                                              ),
                                            )),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () => RouterService.appRouter
                                          .navigateTo(SearchRoute.buildPath()),
                                      child: Container(
                                        width: SizeConfig.widthMultiplier * 42,
                                        height: SizeConfig.heightMultiplier *
                                            4.017216642754663,
                                        margin: EdgeInsets.only(
                                            left: SizeConfig.widthMultiplier *
                                                3.8888888888888884,
                                            top: SizeConfig.heightMultiplier *
                                                1.3809182209469155,
                                            right: SizeConfig.widthMultiplier *
                                                22.166666666666664,
                                            bottom:
                                                SizeConfig.heightMultiplier *
                                                    1.757532281205165),
                                        padding: EdgeInsets.only(
                                            left: SizeConfig.widthMultiplier *
                                                1.9444444444444442,
                                            top: SizeConfig.heightMultiplier *
                                                0.8787661406025825,
                                            bottom:
                                                SizeConfig.heightMultiplier *
                                                    0.8787661406025825),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: AppColors.toolbarBack),
                                        child: Row(
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: SizeConfig
                                                            .widthMultiplier *
                                                        1.9444444444444442),
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Image.asset(
                                                      'assets/images/search_icon.png',
                                                      width: SizeConfig
                                                              .widthMultiplier *
                                                          3.5170138888888887,
                                                      height: SizeConfig
                                                              .heightMultiplier *
                                                          1.8165351506456242,
                                                    ))),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: SizeConfig
                                                          .widthMultiplier *
                                                      1.2152777777777777),
                                              child: Text(
                                                _l10n.search,
                                                style: GoogleFonts.inter(
                                                  textStyle: TextStyle(
                                                      color: AppColors
                                                          .app_txt_color,
                                                      letterSpacing: .25,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: SizeConfig
                                                              .textMultiplier *
                                                          1.757532281205165),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: SizeConfig.widthMultiplier *
                                    25.388888888888886,
                                height: SizeConfig.heightMultiplier *
                                    5.0129124820659974,
                                alignment: Alignment.center,
                                child: InkWell(
                                    onTap: () {
                                      OrderCheckoutRoute.isBuyNow = false;
                                      var route = RouterService.appRouter
                                          .navigateTo(CartRoute.buildPath())
                                          .then((value) {
                                        //TOdo: mANAGE USING BLOC
                                        // setState(() {
                                        //   if (value != null &&
                                        //       value == "Success") {
                                        //     Constants.cartCount =
                                        //         Constants.cartCount;
                                        //   }
                                        // });
                                      });
                                    },
                                    child: Constants.cartCount == 0
                                        ? SvgPicture.asset(
                                            'assets/images/cart.svg',
                                            // height:
                                            // SizeConfig.heightMultiplier *
                                            //     5.809124820659974,
                                            width: SizeConfig.widthMultiplier *
                                                7.529,
                                          )
                                        : Badge(
                                            badgeContent: Text(
                                              '${Constants.cartCount}',
                                              style: GoogleFonts.inter(
                                                  color: AppColors.white,
                                                  fontSize: SizeConfig
                                                          .textMultiplier *
                                                      2.1),
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/images/cart.svg',
                                              // height:
                                              // SizeConfig.heightMultiplier *
                                              //     3.809124820659974,
                                              width:
                                                  SizeConfig.widthMultiplier *
                                                      7.529,
                                            ),
                                          )),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    context
                                        .read<CategoriesBloc>()
                                        .add(ToggleShowHomeCategories());
                                    // if (BlocProvider.of<CategoriesBloc>(context)
                                    //             .showHomeCategories ==
                                    //         true ||
                                    //     BlocProvider.of<CategoriesBloc>(context)
                                    //         .categoriesList
                                    //         .categoriesList[0]
                                    //         .subCategories
                                    //         .isEmpty) {
                                    //   BlocProvider.of<FlashBloc>(context)
                                    //       .add(ShowFlash());
                                    // } else if (BlocProvider.of<CategoriesBloc>(
                                    //         context)
                                    //     .categoriesList
                                    //     .categoriesList[0]
                                    //     .subCategories
                                    //     .isNotEmpty) {
                                    //   BlocProvider.of<FlashBloc>(context)
                                    //       .add(HideFlash());
                                    // }

                                    // getAllCategories();
                                  },
                                  child: Container(
                                    height: SizeConfig.heightMultiplier *
                                        6.107604017216643,
                                    width: SizeConfig.widthMultiplier *
                                        28.118055555555554,
                                    color: Colors.transparent,
                                    child: Row(
                                      children: [
                                        Text(_l10n.categories,
                                            style: GoogleFonts.inter(
                                              fontSize:
                                                  SizeConfig.textMultiplier * 2,
                                              color: AppColors.toolbarBlue,
                                            )),
                                        SvgPicture.asset(
                                          'assets/images/arrowDown.svg',
                                          color: AppColors.toolbarBlue,
                                          width: 12,
                                          height: 7,
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Builder(
                      builder: (context) {
                        var state = context.watch<CategoriesBloc>().state;
                        if (state is CategoriesLoadingState) {
                          return Text('Loading...');
                        } else if (state is CategoriesLoadSuccessState) {
                          // print("<<<<<<<<ouch${state.showHomeCategories}");
                          if (!state.showHomeCategories) {
                            context
                                .read<ProductsBloc>()
                                .add(LoadListEvent(category: ''));
                            context
                                .read<CategoriesBloc>()
                                .add(CategorySelected(0));
                          }
                          return AnimatedContainer(
                              key: Key("header_dashboard_animatedcontainer"),
                              height: state.showHomeCategories
                                  ? 5.5 * SizeConfig.heightMultiplier
                                  : 0,
                              duration: Duration(milliseconds: 200),
                              child: categoriesWidget(state));
                        } else if (state is CategoriesLoadFailedState) {
                          return Text('Load Failed!!!');
                        } else {
                          // print("EmptyCategories");
                          return Container();
                        }
                      },
                    ),
                    // BlocBuilder<CategoriesBloc, CategoriesState>(
                    //     builder: (bContext, state) {
                    //       // print("STATE IS ${state.runtimeType}");
                    //       if (state is CategoriesLoadingState) {
                    //         return Text('Loading...');
                    //       } else if (state is CategoriesLoadSuccessState) {
                    //         // print("<<<<<<<<${state.showHomeCategories}");
                    //         return AnimatedContainer(
                    //             key: Key("header_dashboard_animatedcontainer"),
                    //             height: state.showHomeCategories ? 5.5 *
                    //                 SizeConfig.heightMultiplier : 0,
                    //             duration: Duration(milliseconds: 200),
                    //             child: categoriesWidget(state));
                    //       }
                    //       else if (state is CategoriesLoadFailedState) {
                    //         return Text('Load Failed!!!');
                    //       } else {
                    //         // print("EmptyCategories");
                    //         return Container();
                    //       }
                    //     }),
                  ],
                ))));
  }

  Widget categoriesWidget(CategoriesLoadSuccessState state) {
    CategoriesModel data = state.categoryList;
    return ListView.builder(
        itemCount: data.categoriesList.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (c, i) => InkWell(
            onTap: () {
              // print("i is:" + i.toString());
              String s = context
                  .read<CategoriesBloc>()
                  .categoriesList
                  .categoriesList[i]
                  .algoliaSearchString
                  .toString();
              // print('s is: ' + s);
              if (s == "null") s = '';
              // print('s is: ' + s);

              context.read<ProductsBloc>().add(LoadListEvent(category: s));

              context.read<CategoriesBloc>().add(CategorySelected(i));

              /////////Perform the Product Search//////////
              // BlocProvider.of<ProductsBloc>(context).add(LoadListEvent(
              //     category: data.categoriesList[i].algolia_search_string));
              /////////Perform the Product Search//////////
              // BlocProvider.of<FlashBloc>(context).add(ShowFlash());
              // BlocProvider.of<SubCategoriesBloc>(context)
              //     .add(HideSubcategories());
              // if (i > 0) {
              // BlocProvider.of<FlashBloc>(context).add(HideFlash());

              // BlocProvider.of<SubCategoriesBloc>(context).add(
              //     LoadSubcategories(data.categoriesList[i].subCategories));
              // } else {}

              // setState(() {
              //   BlocProvider.of<SubCategoriesBloc>(context)
              //       .clickViewMore(false);
              // });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 2,
                          color: state.selectedCategoryIndex == i
                              ? AppColors.tab_indicator_color
                              : Colors.transparent))),
              child: Center(
                child: Text(
                  data.categoriesList[i].categoryName,
                  style: TextStyle(
                      color: state.selectedCategoryIndex == i
                          ? AppColors.tab_indicator_color
                          : const Color(0xff666666),
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      fontWeight: FontWeight.w500),
                ),
              ),
            )));
  }

  getAllCategories() {
    // print("doing this");
    Map map = Map<String, String>();
    if (BlocProvider.of<CategoriesBloc>(context).categoriesList == null) {
      BlocProvider.of<CategoriesBloc>(context).add(GetAllCategories(map));
    }
  }
}
