import 'package:algolia/algolia.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/subcategoryResults/subCatToolBar.dart';
import 'package:market_space/main.dart';
import 'package:market_space/model/flash_promo_model/flash_promo_algolia.dart';
import 'package:market_space/product_landing_screen/product_landing_route.dart';
import 'package:market_space/subcategoryResults/subCategoryResults_route.dart';
import 'package:market_space/search/search_l10n.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class SubCategoryResultsScreen extends StatefulWidget {
  @override
  _SubCategoryResultsState createState() => _SubCategoryResultsState();
}

class _SubCategoryResultsState extends State<SubCategoryResultsScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  SearchL10n _l10n =
      SearchL10n(Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
  List<AlgoliaObjectSnapshot> _results = [];
  List<FlashPromoAlgoliaObj> _productList = List();
  bool _searching = false;
  bool _isTags = false;
  bool _isChinese;
  int _pageNumber = 0;
  bool _productLoadMore = false;
  bool _productLoaded = false;
  bool _tabSelected = false;
  double _toolbarExtendHeight = 94;
  double toolbarHeight =
      SizeConfig.heightMultiplier * 18.0468750000000007049560546875;
  ScrollController _productScrollController;
  TabController _tabController;

  String _category;
  String _selectedSubCategory;
  String _algoliaSubCategorySearch;
  String _algoliaCategorySearch;
  List<String> _subCategories;
  List<GestureDetector> _subCategoryLabels;

  @override
  void initState() {
    if (SubCategoryResultsRoute.subCategoryResultsModel != null) {
      _category = SubCategoryResultsRoute.subCategoryResultsModel.category;
      _subCategories =
          SubCategoryResultsRoute.subCategoryResultsModel.subCategories;
      _selectedSubCategory =
          SubCategoryResultsRoute.subCategoryResultsModel.selectedSubCategory;
      _algoliaSubCategorySearch = SubCategoryResultsRoute
          .subCategoryResultsModel.algoliaSubCategorySearch
          .replaceAll(" ", "_");
      _algoliaSubCategorySearch =
          _algoliaSubCategorySearch.replaceAll("'", "-");
      _algoliaCategorySearch =
          SubCategoryResultsRoute.subCategoryResultsModel.algoliaCategorySearch;
    }

    _subCategoryLabels = _tabs();

    if (_productList == null || _productList.length == 0) {
      _pageNumber = 0;
      // print('algolia sub: ' + _algoliaSubCategorySearch);
      searchWithAlgolia(_algoliaSubCategorySearch, _algoliaCategorySearch);
    } else {
      // print('prodlist: ' + _productList.length.toString());
    }

    // print('sub category length: ' + _subCategories.length.toString());
    _tabController = TabController(length: _subCategories.length, vsync: this);
    super.initState();
    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _isChinese = false;
        _l10n = SearchL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _isChinese = true;
        _l10n = SearchL10n(Locale.fromSubtags(languageCode: 'zh'));
      }

      _productScrollController = ScrollController();
      _productScrollController.addListener(() {
        setState(() {
          if (_productList != null && _productList.length != 0) {
            // print('routine here');
            if (!_productLoadMore && !_productLoaded) {
              // print('ok');
              if (_productScrollController.position.pixels ==
                  _productScrollController.position.maxScrollExtent) {
                _pageNumber = _pageNumber + 1;
                // print('ummm');
                setState(() {
                  if (!_productLoadMore) {
                    _productLoadMore = true;
                  }
                });
                loadMoreProducts(
                    _algoliaSubCategorySearch, _algoliaCategorySearch);
              }
            }
          }
        });
      });
    });

    _searchController.addListener(() {});
  }

  Widget _recentItems() {
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 1.2553802008608321,
          left: SizeConfig.widthMultiplier * 1.2152777777777777,
          right: SizeConfig.widthMultiplier * 1.2152777777777777,
          bottom: SizeConfig.heightMultiplier * 10.043041606886657),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Text(
              'Search Results',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  color: Colors.grey[700]),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: _searching == true
                ? Center(
                    child: Text("Searching, please wait..."),
                  )
                : _productList.length == 0
                    ? Center(
                        child: Text("No results found."),
                      )
                    : Container(
                        child: StaggeredGridView.count(
                        crossAxisCount: 4,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        controller: _productScrollController,
                        physics: ClampingScrollPhysics(),
                        children: _productList
                            .map<Widget>((e) => _productCard(e))
                            ?.toList(),
                        staggeredTiles: _productList
                            .map<StaggeredTile>((_) => StaggeredTile.fit(2))
                            .toList(),
                      )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubCatToolbar(
        title: _category,
        subCategories: _subCategories,
        subCategoryList: _subCategoryLabels,
        tabController: _tabController,
      ),
      backgroundColor: AppColors.toolbarBlue,
      body: GestureDetector(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: AppColors.white,
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                _recentItems(),
                if (_productLoadMore)
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom:
                              SizeConfig.heightMultiplier * 10.043041606886657),
                      height: SizeConfig.heightMultiplier * 3.7661406025824964,
                      width: SizeConfig.widthMultiplier * 7.291666666666666,
                      child: LoadingProgress(
                        color: AppColors.app_orange,
                      ),
                    ),
                  )
              ],
            )),
      ),
    );
  }

  Widget _buildSubCatText(String subCat, int position) {
    subCat = subCat.replaceAll('\n', ' ');
    return GestureDetector(
      onTap: () => {
        setState(() {
          _pageNumber = 0;
          _productList.clear();

          switch (subCat) {
            case "Comp Accs":
              {
                _algoliaSubCategorySearch = "Computer_Accessories";
              }
              break;

            case "Mobile Accs":
              {
                _algoliaSubCategorySearch = "Mobile_Accessories";
              }
              break;

            case "Car Accs":
              {
                _algoliaSubCategorySearch = "Car_Accessories";
              }
              break;

            default:
              {
                _algoliaSubCategorySearch = subCat;
              }
              break;
          }
          // print('our position: ' + position.toString());
          _tabController.animateTo(position);
          // print('tab controller index: ' + _tabController.index.toString());
          // print('algolia sub: ' + _algoliaSubCategorySearch);
        })
      },
      child: Text(
        subCat,
        style: TextStyle(
            // color: AppColors.tab_indicator_color,
            fontSize: SizeConfig.textMultiplier * 1.757532281205165,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 120,
//          margin: margin,
        color: AppColors.toolbarBack,
        child: Column(
          children: [
            Row(children: [
              Container(
                  child: Card(
                      margin: EdgeInsets.zero,
//                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20))),
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 60,
                          decoration: BoxDecoration(
                              color: AppColors.toolbarBlue,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20))),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 5),
                                            child: Text(
                                              _category,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: AppColors.white,
                                                  fontFamily: 'Montserrat',
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500),
                                            ))),
                                  ],
                                ),
                              ]))))
            ]),
            AnimatedContainer(
              height: 40,
              decoration: BoxDecoration(
                  color: AppColors.toolbarBack,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
              duration: Duration(milliseconds: 200),
              child: DefaultTabController(
                length: _subCategories.length,
                initialIndex: 0,
                child: TabBar(
                    isScrollable: true,
                    indicatorColor: AppColors.tab_indicator_color,
                    indicatorSize: TabBarIndicatorSize.label,
                    unselectedLabelColor: AppColors.unselected_tab,
                    labelColor: AppColors.tab_indicator_color,
                    controller: _tabController,
                    onTap: (index) {},
                    tabs: _subCategoryLabels),
              ),
            )
          ],
        ));
  }

  List<GestureDetector> _tabs() {
    List<GestureDetector> subCategoryList = [];
    subCategoryList.add(_buildSubCatText(_selectedSubCategory, 0));
    int _tabNumber = 0;
    // print(_subCategories);
    for (int i = 0; i < _subCategories.length; i++) {
      // print('tab num now: ' + _tabNumber.toString());
      if (_subCategories[i] != _selectedSubCategory) {
        _tabNumber++;
        // print('tab num at here: ' + _tabNumber.toString());
        subCategoryList.add(_buildSubCatText(_subCategories[i], _tabNumber));
      }
    }

    return subCategoryList;
  }

  Widget _productCard(FlashPromoAlgoliaObj model) {
    // if (model.tags == null) {
    //   _isTags = false;
    // } else {
    //   _isTags = true;
    // }

    // double prefCurrency, cryto;
    // var prefSevenDecimal, cryptoDecimal;
    // if (Constants.aud != null) {
    //   prefCurrency = model.price / double.parse(Constants.aud);
    //   cryto = (model.price / double.parse(Constants.aud)) *
    //       double.parse(Constants.btc);
    //   if (prefCurrency.toString().length > 7) {
    //     prefSevenDecimal = double.parse(prefCurrency.toStringAsFixed(7));
    //     cryptoDecimal = double.parse(cryto.toStringAsFixed(7));
    //   } else {
    //     prefSevenDecimal = prefCurrency;
    //     cryptoDecimal = double.parse(cryto.toStringAsFixed(7));
    //   }
    // } else {
    //   cryto = (model.price / 1.0) * double.parse(Constants.btc);
    //   cryptoDecimal = double.parse(cryto.toStringAsFixed(7));
    // }

    // if (model.likedItem == "true") {
    //   _favLoadingItems.add(model.productNum);
    // }

    // bool _isLiked = _favLoadingItems.contains(model.productNum.toString());
    // print("I am built");
    return GestureDetector(
        onTap: () {
          ProductLandingRoute.productNum = model.productNum;
          ProductLandingRoute.productName = model.productName;
          // ProductLandingRoute.isProductLiked = _isLiked;
          RouterService.appRouter.navigateTo(ProductLandingRoute.buildPath());
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
                        //   Positioned(
                        //     right: SizeConfig.widthMultiplier * 3,
                        //     top: SizeConfig.widthMultiplier * 1,
                        //     height:
                        //         SizeConfig.heightMultiplier * 4.017216642754663,
                        //     // padding: EdgeInsets.only(
                        //     //     left: SizeConfig.widthMultiplier *
                        //     //         1.2152777777777777,
                        //     //     right: SizeConfig.widthMultiplier *
                        //     //         1.2152777777777777),
                        //     child: _isLiked
                        //         ? GestureDetector(
                        //             onTap: () {
                        //               _DashboardScreenBloc.liked_deleted =
                        //                   int.parse(model.productNum.toString());
                        //               _DashboardScreenBloc.liked_item = 0;
                        //               _DashboardScreenBloc.favProduct = model;
                        //               _DashboardScreenBloc.add(
                        //                   LikeDislikeEvent());
                        //               setState(() {
                        //                 // print("this25");
                        //                 // _favLoadingItems
                        //                 //     .remove(model.productNum.toString());
                        //               });
                        //             },
                        //             child: Container(
                        //               padding: EdgeInsets.all(2),
                        //               child: Image.asset(
                        //                 'assets/images/img_fav.png',
                        //                 width: SizeConfig.widthMultiplier *
                        //                     5.833333333333333,
                        //                 height: SizeConfig.heightMultiplier *
                        //                     4.017216642754663,
                        //               ),
                        //             ))
                        //         : GestureDetector(
                        //             onTap: () {
                        //               _DashboardScreenBloc.liked_deleted = 0;
                        //               _DashboardScreenBloc.liked_item =
                        //                   int.parse(model.productNum.toString());
                        //               _DashboardScreenBloc.favProduct = model;
                        //               _DashboardScreenBloc.add(
                        //                   LikeDislikeEvent());
                        //               setState(() {
                        //                 // print("this26");
                        //                 // _favLoadingItems
                        //                     // .add(model.productNum.toString());
                        //               });
                        //             },
                        //             child: SvgPicture.asset(
                        //               'assets/images/heart.svg',
                        //               width: SizeConfig.widthMultiplier *
                        //                   5.833333333333333,
                        //               height: SizeConfig.heightMultiplier *
                        //                   4.017216642754663,
                        //               color: AppColors.nextButtonPrimary,
                        //             )),
                        //   ),
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
                              child: Text(
                                  // Constants.aud == null && _priceLoading
                                  //     ? 'Loading...'
                                  // : Constants.aud == null &&
                                  // !_productLoading
                                  // :
                                  '\$${model.price}',
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
                          if (_isTags)
                            Container(
                                height: SizeConfig.heightMultiplier *
                                    6.276901004304161,
                                // width: SizeConfig.widthMultiplier * 48.61111111111111,
                                child: GridView.count(
                                    crossAxisCount: 2,
                                    shrinkWrap: true,
                                    childAspectRatio: 0.35,
                                    scrollDirection: Axis.horizontal,
                                    children: model.tags
                                        .map((e) => _tags(e))
                                        ?.toList())),
                        ],
                      ),
                    ),
                  ],
                ))));
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

  Widget _recentItem(String item) {
    return InkWell(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.only(
              top: SizeConfig.heightMultiplier * 1.0043041606886658,
              bottom: SizeConfig.heightMultiplier * 1.0043041606886658),
          child: Text(
            item,
            style: TextStyle(
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                color: Colors.grey[600]),
          ),
        ));
  }

  Widget _relatedItems() {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 4.861111111111111,
          right: SizeConfig.widthMultiplier * 4.861111111111111,
          top: SizeConfig.heightMultiplier * 4.519368723098996),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Related Products',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                color: Colors.grey[700]),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 2.0086083213773316,
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [1, 2, 3].map((i) {
              switch (i) {
                case 0:
                  return _relatedItem("Hot & cold lunch box");
                case 1:
                  return _relatedItem("Copper bottle");
                default:
                  return _relatedItem("Bottle cover");
              }
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _relatedItem(String item) {
    return InkWell(
        onTap: () {},
        child: Container(
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 1.9444444444444442,
                right: SizeConfig.widthMultiplier * 1.9444444444444442,
                top: SizeConfig.heightMultiplier * 0.37661406025824967,
                bottom: SizeConfig.heightMultiplier * 0.37661406025824967),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(color: Colors.grey[600])),
            child: Text(
              item,
              style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  color: Colors.grey[600]),
            )));
  }

  void searchWithAlgolia(
      String algoliaSearchCategory, String algoliaPrimaryCategory) async {
    Algolia algolia = Application.algolia;

    setState(() {
      _searching = true;
    });

    AlgoliaQuery query = algolia.instance
        .index("simpleProductData")
        .search('')
        .setPage(_pageNumber);
    query.setHitsPerPage(20);
    query = query.setFacetFilter('approvalStatus:true');
    query = query.setFacetFilter(
        ["country: ${Constants.country}", "hasInternationalShipping:true"]);
    query = query.setNumericFilter('qtyAvail > 0');
    query = query.setFacetFilter('subCategory:${algoliaSearchCategory}');
    query = query.setFacetFilter('category:${algoliaPrimaryCategory}');

    AlgoliaQuerySnapshot snap = await query.getObjects();
    List<AlgoliaObjectSnapshot> _algoliaSearch = [];

    // Checking if has [AlgoliaQuerySnapshot]
    // print("Snap ${snap.index}");
    // print('Hits count: ${snap.nbHits}');
    _algoliaSearch = (await query.getObjects()).hits;

    // print('\n\n');

    _results = _algoliaSearch;
    // print("results algolia search ${_results.length}");
    List<FlashPromoAlgoliaObj> productsList = List();
    for (int i = 0; i < _results.length; i++) {
      AlgoliaObjectSnapshot snap = _results[i];
      FlashPromoAlgoliaObj obj = FlashPromoAlgoliaObj.fromJson(snap.data);
      productsList.add(obj);
    }

    setState(() {
      // print('are we here??');
      _productList = productsList;
      _searching = false;
    });
  }

  void loadMoreProducts(
      String algoliaSearchCategory, String algoliaPrimaryCategory) async {
    Algolia algolia = Application.algolia;
    List<AlgoliaObjectSnapshot> _moreResults = [];

    AlgoliaQuery query = algolia.instance
        .index("simpleProductData")
        .search('')
        .setPage(_pageNumber);
    query.setHitsPerPage(20);
    query = query.setFacetFilter('approvalStatus:true');
    query = query.setFacetFilter(
        ["country: ${Constants.country}", "hasInternationalShipping:true"]);
    query = query.setNumericFilter('qtyAvail > 0');
    query = query.setFacetFilter('subCategory:${algoliaSearchCategory}');
    query = query.setFacetFilter('category:${algoliaPrimaryCategory}');

    AlgoliaQuerySnapshot snap = await query.getObjects();
    List<AlgoliaObjectSnapshot> _algoliaSearch = [];

    // Checking if has [AlgoliaQuerySnapshot]
    // print("Snap ${snap.index}");
    // print('Hits count: ${snap.nbHits}');
    _algoliaSearch = (await query.getObjects()).hits;

    // print("results algolia search ${_moreResults.length}");

    // print('\n\n');

    _moreResults = _algoliaSearch;
    List<FlashPromoAlgoliaObj> productsList = List();
    for (int i = 0; i < _moreResults.length; i++) {
      AlgoliaObjectSnapshot snap = _moreResults[i];
      FlashPromoAlgoliaObj obj = FlashPromoAlgoliaObj.fromJson(snap.data);
      productsList.add(obj);
    }

    setState(() {
      _productList.addAll(productsList);
      _productLoadMore = false;
      if (_productList.length < 20) {
        _productLoaded = true;
      }
    });
  }
}
