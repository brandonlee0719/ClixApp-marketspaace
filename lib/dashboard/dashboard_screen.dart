// import 'dart:async';
// import 'dart:collection';
// import 'dart:ui';
//
// import 'package:badges/badges.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// import 'package:market_space/cart/cart_route.dart';
// import 'package:market_space/common/colors.dart';
// import 'package:market_space/common/constants.dart';
// import 'package:market_space/common/loading_progress.dart';
// import 'package:market_space/dashboard/dashboard_bloc.dart';
// import 'package:market_space/dashboard/dashboard_l10n.dart';
// import 'package:market_space/dashboard/representation/widgets/productList.dart';
// import 'package:market_space/model/flash_promo_model/flash_promo_algolia.dart';
// import 'package:market_space/model/flash_promo_model/flash_promo_model.dart';
// import 'package:market_space/model/product_model/product_model.dart';
// import 'package:market_space/model/rates_model/rates_model.dart';
// import 'package:market_space/model/sub_category_results_model/sub_category_results_model.dart';
// import 'package:market_space/order_checkout/order_checkout_route.dart';
// import 'package:market_space/product_landing_screen/product_landing_route.dart';
// import 'package:market_space/providers/api_provider.dart';
// import 'package:market_space/providers/messages_provider/messageProvider.dart';
// import 'package:market_space/responsive_layout/size_config.dart';
// import 'package:market_space/search/search_route.dart';
// import 'package:market_space/services/RouterServices.dart';
// import 'package:market_space/subcategoryResults/subCategoryResults_route.dart';
// import 'package:should_rebuild/should_rebuild.dart';
// import 'package:sticky_headers/sticky_headers.dart';
//
// import 'dashboard_events.dart';
// import 'dashboard_state.dart';
//
// class DashboardScreen extends StatefulWidget {
//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen>
//     with TickerProviderStateMixin {
//   final DashboardScreenBloc _DashboardScreenBloc =
//       DashboardScreenBloc(Initial());
//
//   DashboardL10n _l10n =
//       DashboardL10n(Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
//
//   bool _searchClicked = false;
//   double toolbarHeight =
//       SizeConfig.heightMultiplier * 18.0468750000000007049560546875;
//   bool _isChinese;
//
//   final PageController _pageController =
//       PageController(initialPage: 0, keepPage: true);
//
//   final PageController _baseController = PageController(initialPage: 0);
//   int _currentPage;
//
//   ScrollController _productScrollController;
//   CarouselController _carouselController = CarouselController();
//
//   TabController _tabController;
//   double _toolbarExtendHeight = SizeConfig.heightMultiplier * 12.057;
//
//   int slideIndex = 0;
//   int _selectedTab = 0;
//   List<FlashPromo> _promoList = List();
//
//   List<Products> _products = List();
//   List<DropdownMenuItem<String>> _dropdownMenuItems;
//   String _selectedItem;
//   List<String> _dropdownItems;
//   bool _isLoading = false, _bannerLoading = false, _productLoading = false;
//   bool _isTags = false, _showCategoriesTabs = false;
//   bool _showCategories = false;
//   ScrollController _flashController;
//   final Set<String> _favLoadingItems = HashSet();
//   List<String> _categoriesItems;
//   List<String> _interestingItems;
//   double _offset = 0.0;
//
//   List<String> _selectedCategories = List();
//   List<String> _selectedMoreCategories = List();
//   final _actionKey = GlobalKey<ScaffoldState>();
//   List<FlashPromoAlgoliaObj> _flashList = List();
//   List<FlashPromoAlgoliaObj> _productList = List();
//   bool _flashProductLoaded = false;
//   bool _productLoaded = false;
//   bool _productLoadMore = false;
//   bool _flashLoading = false;
//   bool _flashPromoLoading = false;
//   RatesModel _ratesModel;
//   bool _priceLoading = false;
//   bool _prelovedSelected = false;
//   bool _digitalSelected = false;
//   bool _internationalSelected = false;
//   bool _localSelected = false;
//   bool _noFilterDashboard = true;
//   List<FlashPromoAlgoliaObj> _favProductsList = List();
//   bool _prelovedEnable = true,
//       _digitalEnable = true,
//       _localEnable = true,
//       internationalEnable = true;
//   bool _isSplashLoading = true;
//   bool _tabSelected = false;
//   bool _needScroll = true;
//   String _newSubSelected;
//   ValueNotifier valueNotifier = new ValueNotifier(0);
//
//   List<String> _booksItems;
//   List<String> _filmsItems;
//   List<String> _gamesItems;
//   List<String> _artsItems;
//   List<String> _softwareItems;
//   List<String> _musicItems;
//   List<String> _mensFashionItems;
//   List<String> _womensFashionItems;
//   List<String> _beautyItems;
//   List<String> _technologyItems;
//   List<String> _DIYItems;
//   List<String> _homeItems;
//   List<String> _toysItems;
//   List<String> _sportingItems;
//   List<String> _homeAndKitchenItems;
//   List<String> _herAccessories;
//   List<String> _hisAccessories;
//   List<String> _office;
//   List<String> _sports;
//
//   List<String> _conditionItems;
//   List<String> _subCategoriesItems;
//   List<String> _discountDropItems;
//
//   String _swipeDirection;
//
//   bool _showSubCat = false;
//   String _showCatText = null;
//   ScrollController _categoriesController = ScrollController();
//   ScrollController _singleChildController;
//
//   int _numRows;
//   double _subCategoryHeight = 230;
//   bool _moreSubCategories = false;
//   bool _arrowUp = false;
//   SvgPicture _arrowPath =
//       SvgPicture.asset('assets/images/subcategories/arrowDown.svg');
//   List<Container> _rows = [];
//
//   int _counter = 0;
//   int _secondaryCounter = 0;
//
//   String _direction;
//   double _lastPage;
//
//   @override
//   void initState() {
//     _DashboardScreenBloc.add(LoadListEvent());
//     _productLoading = true;
//     _DashboardScreenBloc.add(LoadBannerEvent());
//     _flashPromoLoading = true;
//     _productScrollController = ScrollController();
//     _singleChildController = ScrollController();
//     // WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
//     _singleChildController.addListener(() {
//       // if (!_productLoadMore && !_productLoaded) {
//
//       if (_singleChildController.position.pixels >=
//           _singleChildController.position.maxScrollExtent -
//               SizeConfig.heightMultiplier * 13) {
//         // print("nidaye");
//
//         _DashboardScreenBloc.add(
//             LoadListEvent(category: _DashboardScreenBloc.category));
//       }
//       // }
//     });
//     // print("diqiuwozuida");
//     MessageProvider2 provider = MessageProvider2();
//     provider.fetchMessage("CH331a46271a634564b0a5204250cd7754",
//         "IMd6079935ac22481997c180cc1f2e52e9");
//     // provider.sendMessage("说什么情深似海我却不敢当，最浪漫不过与你并肩看夕阳，我心之所向",  "CH331a46271a634564b0a5204250cd7754");
//
//     _tabController = TabController(length: 9, vsync: this);
//     setState(() {
//       _flashList = DashboardScreenBloc.flashList;
//       _productList = DashboardScreenBloc.productList;
//       _favProductsList = DashboardScreenBloc.favProductList;
//       if (_favProductsList != null && _favProductsList.isNotEmpty) {
//         for (int index = 0; index < _favProductsList.length; index++) {
//           _favLoadingItems.add(_favProductsList[index].productNum.toString());
//         }
//       }
//     });
//     setState(() {
//       if (Constants.language == null || Constants.language == "English") {
//         _l10n = DashboardL10n(
//             Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
//         _isChinese = false;
//       } else {
//         _l10n = DashboardL10n(Locale.fromSubtags(languageCode: 'zh'));
//         _isChinese = true;
//       }
//     });
//     // _DashboardScreenBloc.add(CryptoRateEvent());
//     // _priceLoading = true;
//
//     if (Constants.isLogin) {
//       _DashboardScreenBloc.add(CryptoRateEvent());
//       _priceLoading = true;
//       _DashboardScreenBloc.add(NavigateToLoginScreenEvent());
//     }
//
// //    _dropdownItems = [
// //      _l10n.electronics,
// //      _l10n.fashion,
// //      _l10n.DIY,
// //      _l10n.Toys,
// //      _l10n.More
// //    ];
//
//     _dropdownItems = [
//       _l10n.technology,
//       _l10n.womensFashion,
//       _l10n.mensFashion,
//       _l10n.More
//     ];
//
//     _categoriesItems = [
//       _l10n.books,
//       _l10n.Films,
//       _l10n.Games,
//       _l10n.Art,
//       _l10n.Software,
//       _l10n.Music,
//       // _l10n.fashion,
//       _l10n.Beauty,
//       // _l10n.electronics,
//       // _l10n.DIY,
//       _l10n.homeGrd,
//       // _l10n.Toys,
//       _l10n.sportGood,
//       _l10n.Others
//     ];
//
//     _interestingItems = [
//       _l10n.books,
//       _l10n.Films,
//       _l10n.Games,
//       _l10n.Art,
//       _l10n.Software,
//       _l10n.Music,
//       _l10n.fashion,
//       _l10n.Beauty,
//       _l10n.technology,
//       _l10n.DIY,
//       _l10n.homeGrd,
//       _l10n.Toys,
//       _l10n.sportGood,
//       _l10n.Others
//     ];
//
//     // _dropdownItems = [
//     //   "${_l10n.Producttype} *",
//     //   _l10n.Physicalgoods,
//     //   _l10n.Digitalgoods,
//     //   _l10n.Services
//     // ];
//     _booksItems = [_l10n.Fiction, _l10n.NonFiction, _l10n.Others];
//     _filmsItems = ["DVDs & Blu-ray Discs", "${_l10n.Others}"];
//
//     _gamesItems = [
//       "Video ${_l10n.Games}",
//       "Board ${_l10n.Games}",
//       "${_l10n.Others}"
//     ];
//
//     _artsItems = ["${_l10n.Art} Posters", "${_l10n.Others}"];
//     _softwareItems = ["${_l10n.office}", "${_l10n.os}", "${_l10n.Others}"];
//
//     _musicItems = [
//       _l10n.Music,
//       "${_l10n.Music} ${_l10n.CDs}",
//       "${_l10n.records}",
//       "${_l10n.Others}"
//     ];
//
//     _mensFashionItems = [
//       "${_l10n.Tops}",
//       "${_l10n.Jackets}",
//       "${_l10n.Hoodies}",
//       "${_l10n.Formal}",
//       "${_l10n.Work}",
//       "${_l10n.Sportwear}",
//       "${_l10n.Swimwear}",
//       "${_l10n.Underwear}",
//       "${_l10n.Sleepwear}",
//       "${_l10n.More}",
//       "${_l10n.Jeans}",
//       "${_l10n.Boots}",
//       "${_l10n.Sneakers}",
//     ];
//
//     _womensFashionItems = [
//       "${_l10n.Tops}",
//       "${_l10n.Jackets}",
//       "${_l10n.Hoodies}",
//       "${_l10n.Dresses}",
//       "${_l10n.ElegantDresses}",
//       "${_l10n.Sleepwear}",
//       "${_l10n.Sportwear}",
//       "${_l10n.Swimwear}",
//       "${_l10n.Boots}",
//       "${_l10n.More}",
//       "${_l10n.Heels}",
//       "${_l10n.Sneakers}",
//       "${_l10n.Flats}",
//       "${_l10n.Sandals}",
//       "${_l10n.Bottoms}",
//       "${_l10n.Shorts}",
//       "${_l10n.Underwear}"
//     ];
//
//     _homeAndKitchenItems = [
//       "${_l10n.Laundry}",
//       "${_l10n.Bedding}",
//       "${_l10n.Bath}",
//       "${_l10n.Dining}",
//       "${_l10n.Outdoor}",
//       "${_l10n.Storage}",
//       "${_l10n.Kitchenware}",
//       "${_l10n.Furniture}",
//     ];
//
//     _herAccessories = [
//       "${_l10n.Watches}",
//       "${_l10n.Purses}",
//       "${_l10n.Jewellery}",
//       "${_l10n.Hats}",
//       "${_l10n.Belts}",
//       "${_l10n.Sunglasses}",
//       "${_l10n.Handbags}",
//     ];
//
//     _hisAccessories = [
//       "${_l10n.Hats}",
//       "${_l10n.Belts}",
//       "${_l10n.Sunglasses}",
//       "${_l10n.Ties}",
//       "${_l10n.Wallets}"
//     ];
//
//     _office = ["${_l10n.Furniture}", "${_l10n.Chair}", "${_l10n.Desk}"];
//
//     _sports = [
//       "${_l10n.Clothing}",
//       "${_l10n.Equipment}",
//       "${_l10n.Shoes}",
//       "${_l10n.Accessories}",
//     ];
//
//     _beautyItems = [
//       "${_l10n.maleFrag}",
//       "${_l10n.womenFrag}",
//       "${_l10n.unisexFrag}",
//       "${_l10n.Others}"
//     ];
//
//     _technologyItems = [
//       "${_l10n.Mobile}",
//       "${_l10n.Computer}",
//       "${_l10n.Camera}",
//       "${_l10n.Gaming}",
//       "${_l10n.MobileAccessories}",
//       "${_l10n.ComputerAccessories}",
//       "${_l10n.CarAccessories}",
//       "${_l10n.Watches}",
//     ];
//     _conditionItems = [
//       "${_l10n.condition} *",
//       "${_l10n.brandNew}",
//       "${_l10n.Preloved}"
//     ];
//     _subCategoriesItems = ["${_l10n.Software}", "${_l10n.Books}"];
//     _discountDropItems = ["${_l10n.select} *", "15%", "20%", "25%", "50%"];
//
//     _DIYItems = [
//       _l10n.electricalSupplies,
//       _l10n.doorHardware,
//       _l10n.garage,
//       _l10n.homeBuildingHardware,
//       _l10n.FlooringTiles,
//       _l10n.CabinetsCountertopsHardware,
//       _l10n.Others
//     ];
//
//     _homeItems = [
//       _l10n.EquipmentTools,
//       _l10n.Furniture,
//       _l10n.Crafts,
//       _l10n.BuildingMaterials,
//       _l10n.Decor,
//       _l10n.Others
//     ];
//
//     _toysItems = [
//       _l10n.BuildingToys,
//       _l10n.ActionFigures,
//       _l10n.Toys,
//       _l10n.TVMovieCharacterToys,
//       _l10n.Collectables,
//       _l10n.OutdoorToys,
//       _l10n.Puzzles,
//       _l10n.DollsTeddyBears,
//       _l10n.Others
//     ];
//
//     _discountDropItems = [
//       _l10n.CyclingEquipment,
//       _l10n.FitnessRunningYogaEquipment,
//       _l10n.CampingHikingEquipment,
//       _l10n.GolfEquipmentGear,
//       _l10n.FishingEquipmentSupplies,
//       _l10n.HuntingEquipment,
//       _l10n.SportsTradingCardsAccessories,
//       _l10n.Boating,
//       _l10n.SurfingEquipment,
//       _l10n.AFLEquipment,
//       _l10n.MartialArtsEquipment,
//       _l10n.HorseRidingEquipment,
//       _l10n.SkateboardingEquipment,
//       _l10n.SoccerEquipment,
//       _l10n.NRLEquipment,
//       _l10n.SkiingSnowboardingEquipment,
//       _l10n.Others
//     ];
//
//     _DashboardScreenBloc.add(ShowCategoriesEvent());
//     // _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
//     // _selectedItem = _dropdownMenuItems[0].value;
//     _flashController = ScrollController();
//     _flashController.addListener(() {
//       if (_flashController.position.pixels ==
//           _flashController.position.maxScrollExtent) {
//         _DashboardScreenBloc.pageCount = _DashboardScreenBloc.pageCount + 1;
//         // setState(() {
//         //
//         //   _flashLoading = true;
//         //   _tabSelected = true;
//         //
//         // });
//         _DashboardScreenBloc.add(LoadMoreFlashPromoEvent());
//       }
//     });
//
//     // _scrollToEnd() async {
//     //   if (_needScroll) {
//     //     _needScroll = false;
//     //     _singleChildController.animateTo(
//     //         _singleChildController.position.maxScrollExtent,
//     //         duration: Duration(milliseconds: 400),
//     //         curve: Curves.ease);
//     //   }
//     // }
//     // _productLi
//     // _singleChildController = ScrollController();
//
//     _tabController.addListener(() {
//       setState(() {
//         if (_tabController.indexIsChanging) {
//           _productLoading = true;
//           _tabSelected = true;
//           _numRows = 0;
//           _arrowUp = false;
//           _moreSubCategories = false;
//           if (_tabController.index != 0) _noFilterDashboard = false;
//           // _flashList.clear();
//           _productList.clear();
//           _rows.clear();
//           _arrowPath =
//               SvgPicture.asset('assets/images/subcategories/arrowDown.svg');
//           _DashboardScreenBloc.client.setToZero();
//
//           if (_tabController.index == 0) {
//             _DashboardScreenBloc.pageCount = 0;
//             _DashboardScreenBloc.productPageCount = 0;
//             _DashboardScreenBloc.subCatSelected = false;
//             _DashboardScreenBloc.categoryFilter = null;
//             _tabSelected = true;
//             _DashboardScreenBloc.newSubCategoryText = null;
//             _showCatText = null;
//             setState(() {
//               _noFilterDashboard = true;
//             });
//             // _categoriesController.animateTo(0,
//             //     duration: Duration(milliseconds: 200), curve: null);
//           } else if (_tabController.index == 1) {
//             _DashboardScreenBloc.pageCount = 0;
//             _DashboardScreenBloc.productPageCount = 0;
//             _DashboardScreenBloc.subCatSelected = false;
//             _DashboardScreenBloc.categoryFilter = "Technology";
//             _tabSelected = true;
//             _DashboardScreenBloc.newSubCategoryText = null;
//
//             _showSubCat = true;
//             _showCatText = "Technology";
//             _newSubSelected = null;
//             // _categoriesController.animateTo(1,
//             //     duration: Duration(milliseconds: 200), curve: null);
//           }
//         } else if (_tabController.index == 2) {
//           _DashboardScreenBloc.pageCount = 0;
//           _DashboardScreenBloc.productPageCount = 0;
//           _showSubCat = true;
//           _showCatText = "Women's Fashion";
//           _newSubSelected = null;
//           _DashboardScreenBloc.subCatSelected = false;
//           _DashboardScreenBloc.categoryFilter = "Women-s_Fashion";
//           _DashboardScreenBloc.newSubCategoryText = null;
//         } else if (_tabController.index == 3) {
//           _DashboardScreenBloc.pageCount = 0;
//           _DashboardScreenBloc.productPageCount = 0;
//           _showSubCat = true;
//           _showCatText = "Men's Fashion";
//           _newSubSelected = null;
//           _DashboardScreenBloc.subCatSelected = false;
//           _DashboardScreenBloc.categoryFilter = "Men-s_Fashion";
//           _DashboardScreenBloc.newSubCategoryText = null;
//         } else if (_tabController.index == 4) {
//           _DashboardScreenBloc.pageCount = 0;
//           _DashboardScreenBloc.productPageCount = 0;
//           _showSubCat = true;
//           _showCatText = "Her Accessories";
//           _newSubSelected = null;
//           _DashboardScreenBloc.subCatSelected = false;
//           _DashboardScreenBloc.categoryFilter = "Her_Accessories";
//           _DashboardScreenBloc.newSubCategoryText = null;
//         } else if (_tabController.index == 5) {
//           // _showMoreCategoriesDialog();
//           _DashboardScreenBloc.pageCount = 0;
//           _DashboardScreenBloc.productPageCount = 0;
//           _showSubCat = true;
//           _showCatText = "His Accessories";
//           _newSubSelected = null;
//           _DashboardScreenBloc.subCatSelected = false;
//           _DashboardScreenBloc.categoryFilter = "His_Accessories";
//           _DashboardScreenBloc.newSubCategoryText = null;
//         } else if (_tabController.index == 6) {
//           _DashboardScreenBloc.pageCount = 0;
//           _DashboardScreenBloc.productPageCount = 0;
//           _showSubCat = true;
//           _showCatText = "Office";
//           _newSubSelected = null;
//           _DashboardScreenBloc.subCatSelected = false;
//           _DashboardScreenBloc.categoryFilter = "Office";
//         } else if (_tabController.index == 7) {
//           _DashboardScreenBloc.pageCount = 0;
//           _DashboardScreenBloc.productPageCount = 0;
//           _showSubCat = true;
//           _showCatText = "Sports";
//           _newSubSelected = null;
//           _DashboardScreenBloc.subCatSelected = false;
//           _DashboardScreenBloc.categoryFilter = "Sports";
//           _DashboardScreenBloc.newSubCategoryText = null;
//         } else if (_tabController.index == 8) {
//           _DashboardScreenBloc.pageCount = 0;
//           _DashboardScreenBloc.productPageCount = 0;
//           _showSubCat = true;
//           _showCatText = "Home & Kitchen";
//           _newSubSelected = null;
//           _DashboardScreenBloc.subCatSelected = false;
//           _DashboardScreenBloc.categoryFilter = "Home_&_Kitchen";
//           _DashboardScreenBloc.newSubCategoryText = null;
//         }
//         // _DashboardScreenBloc.add(NavigateToLoginScreenEvent());
//         // _flashPromoLoading = true;
//         _DashboardScreenBloc.add(
//             LoadListEvent(category: _DashboardScreenBloc.categoryFilter));
//       });
//
//       // print("Selected Index: " + _tabController.index.toString());
//     });
//     Timer.periodic(Duration(minutes: 30), (Timer t) {
//       _DashboardScreenBloc.add(NavigateToLoginScreenEvent());
//     });
//
//     _currentPage = _pageController.initialPage;
//     super.initState();
//     Timer.periodic(Duration(seconds: 4), (Timer timer) {
//       if (_currentPage < 2) {
//         _currentPage++;
//       } else {
//         _currentPage = 0;
//       }
//
//       _pageController.animateToPage(
//         _currentPage,
//         duration: Duration(milliseconds: 350),
//         curve: _currentPage > 0 ? Curves.easeIn : Curves.easeInBack,
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final Color background = AppColors.toolbarBlue;
//     final Color fill = AppColors.lightgrey;
//     final List<Color> gradient = [
//       background,
//       background,
//       fill,
//       fill,
//     ];
//     final double fillPercent = 39.7; // fills 56.23% for container from bottom
//     final double fillStop = (100 - fillPercent) / 100;
//     final List<double> stops = [0.0, fillStop, fillStop, 1.0];
//     // _productScrollController = ScrollController();
//     return Container(
//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//                 colors: gradient,
//                 stops: stops)),
//         child: Scaffold(
//           // floatingActionButton: FloatingActionButton(
//           //   onPressed: () {
//           //     Navigator.push(context,
//           //         MaterialPageRoute(builder: (c) => DashboardWrapper()));
//           //   },
//           //   child: Icon(Icons.home),
//           // ),
//           backgroundColor: Colors.transparent,
//           body: SafeArea(
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height,
//               color: Colors.white,
//               child: BlocProvider(
//                 create: (_) => _DashboardScreenBloc,
//                 child: BlocListener<DashboardScreenBloc, DashboardScreenState>(
//                   listener: (context, state) {
//                     // print("state is: ${state}");
//                     if ((state is Initial) ||
//                         (state is Loading) ||
//                         (state is LoadListEvent)) {
//                       setState(() {
//                         _isLoading = true;
//                         _flashPromoLoading = true;
//                         _productLoading = true;
//                         _noFilterDashboard = true;
//                       });
//                     }
//
//                     if (state is ShowCategories) {
//                       setState(() {
//                         _isLoading = false;
//                         Constants.cartCount = Constants.cartCount;
//
//                         _showCategories = _DashboardScreenBloc.showCategories;
//                         // if (_showCategories == null ||
//                         //     _showCategories == false) {
//                         //   _showCategoriesDialog();
//                         // }
//                       });
//                     }
//                     if (state is HideCategories) {
//                       setState(() {
//                         Constants.cartCount = Constants.cartCount;
//
//                         // _isLoading = true;
//                         // _DashboardScreenBloc.add(NavigateToLoginScreenEvent());
//
//                         // _DashboardScreenBloc.add(LoadBannerEvent());
//                       });
//                     }
//                     if (state is Loaded) {
//                       setState(() {
//                         _flashList.clear();
//                         // _flashList
//                         //     .addAll(_DashboardScreenBloc.flashLoadMoreList);
//                         _isLoading = false;
//                         _flashPromoLoading = false;
//                         _flashProductLoaded = false;
//                         _prelovedEnable = true;
//                         _digitalEnable = true;
//                         internationalEnable = true;
//                         _localEnable = true;
//                         // if (_flashList != null &&
//                         //     _flashList.isNotEmpty &&
//                         //     _DashboardScreenBloc.userCurrency !=
//                         //         _flashList[0].fiatCurrency) {
//                         //   _DashboardScreenBloc.add(CryptoRateEvent());
//                         //   _priceLoading = true;
//                         // }
//                       });
//                     }
//                     if (state is ProductLoaded) {
//                       setState(() {
//                         valueNotifier.value = _productList.length;
//                         _productLoading = false;
//                       });
//                     }
//
//                     if (state is ProductLoadingFailed) {
//                       setState(() {
//                         _productLoading = false;
//                       });
//                     }
//                     // if (state is ProductLoadingFailed) {
//                     //   setState(() {
//                     //
//                     //     // _productLoading = false;
//                     //     // _prelovedEnable = true;
//                     //     // _digitalEnable = true;
//                     //     // internationalEnable = true;
//                     //     // _localEnable = true;
//                     //     // _tabSelected = false;
//                     //   });
//                     // }
//                     if (state is PromoLiked) {
//                       // Constants.showToast("Item liked");
//                       setState(() {
//                         _isLoading = false;
//                         // _favLoadingItems.clear();
//                         _favProductsList
//                             .addAll(_DashboardScreenBloc.favProductNewList);
//                       });
//                     }
//                     if (state is PromoLikedFailed) {
//                       Constants.showToast("Action failed");
//                       setState(() {
//                         _isLoading = false;
//                         // _favLoadingItems.clear();
//                       });
//                     }
//                     if (state is BannerLoaded) {
//                       setState(() {
//                         _bannerLoading = false;
//                       });
//                     }
//                     if (state is BannerLoadingFailed) {
//                       setState(() {
//                         _bannerLoading = false;
//                       });
//                     }
//
//                     // if (state is AddCategoriesSuccessful) {
//                     //   setState(() {
//                     //     // print("this14");
//                     //     _showToast(
//                     //         _DashboardScreenBloc.addedCategoriesStatus);
//                     //   });
//                     // }
//                     // if (state is AddCategoriesFailed) {
//                     //   setState(() {
//                     //     // print("this15");
//                     //     _showToast(
//                     //         _DashboardScreenBloc.addedCategoriesStatus);
//                     //   });
//                     // }
//                     if (state is LoadingMoreFlashProductsFailed) {
//                       _showToast("No more products..");
//                       setState(() {
//                         _flashLoading = false;
//                         _tabSelected = false;
//                       });
//                     }
//                     if (state is LoadingMoreFlashProducts) {
//                       setState(() {
//                         if (_DashboardScreenBloc.flashLoadMoreList.length <
//                             20) {
//                           // _flashProductLoaded = true;
//                           _flashLoading = false;
//                           _flashList
//                               .addAll(_DashboardScreenBloc.flashLoadMoreList);
//                         } else {
//                           _flashLoading = false;
//                           _flashList
//                               .addAll(_DashboardScreenBloc.flashLoadMoreList);
//                           _flashProductLoaded = false;
//                         }
//                         _prelovedEnable = true;
//                         _digitalEnable = true;
//                         internationalEnable = true;
//                         _localEnable = true;
//                         _tabSelected = false;
//                       });
//                     }
//                     if (state is LoadingMoreProducts) {
//                       setState(() {
//                         valueNotifier.value = _productList.length;
//                         _prelovedEnable = true;
//                         _digitalEnable = true;
//                         internationalEnable = true;
//                         _localEnable = true;
//                         _tabSelected = false;
//                       });
//                     }
//                     if (state is LoadingMoreProductsFailed) {
//                       setState(() {
//                         _productLoadMore = false;
//                         _productLoaded = true;
//                         _tabSelected = false;
//                       });
//                     }
//
//                     if (state is CryptoRateLoadedSuccessfully) {
//                       setState(() {
//                         _ratesModel = DashboardScreenBloc.cryptoValue;
//                         Constants.aud = _ratesModel.fiatRates.aud;
//                         Constants.btc = _ratesModel.cryptoRates.btc;
//                         _priceLoading = false;
//                       });
//                     }
//                   },
//                   child: ListView.builder(
//                       // shrinkWrap: true,
//                       itemCount: 2,
//                       physics: ClampingScrollPhysics(),
//                       controller: _productScrollController,
//                       // addAutomaticKeepAlives: true,
//                       itemBuilder: (BuildContext context, int index) {
//                         if (_productScrollController.offset > 100) {
//                           // 100 is arbitrary
//                           _offset = _productScrollController.offset;
//                         }
//                         return StickyHeader(
//                             header: index == 0
//                                 ? _toolbar(context)
//                                 : Container(height: 0.5),
//                             content: index == 0
//                                 ? CarouselSlider(
//                                     carouselController: _carouselController,
//                                     options: CarouselOptions(
//                                       // enableInfiniteScroll: true,
//                                       // pageSnapping: false,
//                                       // onScrolled: (value) {
//                                       //   Future.delayed(
//                                       //       Duration(milliseconds: 1100));
//                                       //   if (_lastPage == null) {
//                                       //     _lastPage = 10000;
//                                       //   }
//                                       //   if (value - _lastPage > 0) {
//                                       //     // print('right');
//                                       //   } else {
//                                       //     // print('left');
//                                       //   }
//                                       //   return;
//                                       // },
//                                       onPageChanged: (index, reason) {
//                                         _tabController.animateTo(index);
//                                       },
//                                       scrollPhysics: _showCategoriesTabs
//                                           ? AlwaysScrollableScrollPhysics()
//                                           : NeverScrollableScrollPhysics(),
//                                       viewportFraction: 1,
//                                       height:
//                                           MediaQuery.of(context).size.height,
//                                     ),
//                                     items: _buildBaseScreens())
//                                 // .map((e) {
//                                 //   return Builder(
//                                 //     builder: (BuildContext context) {
//                                 //       return Container(
//                                 //           width: MediaQuery.of(context)
//                                 //               .size
//                                 //               .width,
//                                 //           margin: EdgeInsets.symmetric(
//                                 //               horizontal: 5.0),
//                                 //           decoration: BoxDecoration(
//                                 //               color: Colors.amber),
//                                 //           child: Text(
//                                 //             'text ${e}',
//                                 //             style:
//                                 //                 TextStyle(fontSize: 16.0),
//                                 //           ));
//                                 //     },
//                                 //   );
//                                 // }).toList())
//                                 : Container(height: 0.5));
//                       }),
//
//                   // return _baseScreen();
//
//                   // return PageView(
//                   //     scrollDirection: Axis.horizontal,
//                   //     controller: _baseController,
//                   //     children: [
//                   //       Text('page1'),
//                   //       Text('page2'),
//                   //       Text('page3')
//                   //     ]);
//
//                   // return StickyHeader(
//                   //     header: index == 0
//                   //         ? _toolbar(context)
//                   //         : Container(
//                   //             height: 1.0,
//                   //           ),
//                   //     content: index == 0
//                   //         ? PageView(
//                   //             scrollDirection: Axis.horizontal,
//                   //             controller: _baseController,
//                   //             children: [
//                   //                 Text('page1'),
//                   //                 Text('page2'),
//                   //                 Text('page3')
//                   //               ])
//                   // ? GestureDetector(
//                   //     // onHorizontalDragStart: (DragStartDetails details) {
//                   //     //   if (_showCategoriesTabs) {
//                   //     //     // print("Details: ${details.toString()}");
//                   //     //     _tabController.animateTo(1);
//                   //     //   }
//                   //     // },
//                   // onPanUpdate: (details) {
//                   //   _swipeDirection = details.delta.dx < 0
//                   //       ? 'right'
//                   //       : 'left';
//                   // },
//                   // onPanEnd: (details) {
//                   //   if (_showCategoriesTabs) {
//                   //     if (_swipeDirection == 'left' &&
//                   //         _tabController.index > 0) {
//                   //       // print(
//                   //           "Details: ${details.toString()}");
//                   //       _tabController.animateTo(
//                   //           _tabController.index - 1);
//                   //     } else if (_swipeDirection == 'right' &&
//                   //         _tabController.index < 9) {
//                   //       // print(
//                   //           "Details: ${details.toString()}");
//                   //       _tabController.animateTo(
//                   //           _tabController.index + 1);
//                   //     }
//                   //   }
//                   // },
//                   //     child: PageView(
//                   //         scrollDirection: Axis.horizontal,
//                   //         controller: _baseController,
//                   //         children: [
//                   //           Text('page1'),
//                   //           Text('page2'),
//                   //           Text('page3')
//                   //         ]))
//                   // : Container(
//                   //     height: 1.0,
//                   //   ));
//                   // },
//                   // ),
//                 ),
//               ),
//             ),
//           ),
//         ));
//     //   Center(
//     //     child: StreamBuilder<QuerySnapshot>(
//     //     stream: FirebaseFirestore.instance.collection('users').snapshots(),
//     //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//     //       // MessagePackage package = new MessagePackage();
//     //
//     //       if (snapshot.hasError) {
//     //         return Text('Something went wrong');
//     //       }
//     //
//     //       if (snapshot.connectionState == ConnectionState.waiting) {
//     //         return Text("Loading");
//     //       }
//     //       return new ListView(
//     //
//     //         children: snapshot.data.docs.map((DocumentSnapshot document) {
//     //           return new ListTile(
//     //             title: new Text(document.id),
//     //             // subtitle: new Text(document['currentRating'].toString()),
//     //           );
//     //         }).toList(),
//     //       );
//     //     },
//     //   ),
//     // );
//   }
//
//   List<Widget> _buildBaseScreens() {
//     List<Widget> _screens = [];
//     for (int i = 0; i < 9; i++) {
//       _screens.add(Container(
//         child: SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             padding: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 35),
//             controller: _singleChildController,
//             child: _baseScreen()),
//       ));
//     }
//     return _screens;
//   }
//
//   Widget _baseScreen() {
//     return Container(
//       color: Colors.white,
//       child: Stack(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
// //                  ? CrossAxisAlignment.start
// //                  : CrossAxisAlignment.center,
//             // shrinkWrap: true,
//             // physics: BouncingScrollPhysics(),
//             children: [
//               if (_showSubCat && _noFilterDashboard == false)
//                 _newCategoriesList(),
//               if (_noFilterDashboard)
//                 Padding(
//                   padding: EdgeInsets.only(
//                       left: SizeConfig.widthMultiplier * 3.8888888888888884,
//                       top: SizeConfig.heightMultiplier * 3.0129124820659974,
//                       bottom: SizeConfig.heightMultiplier * 1.5),
//                   child: Text(
//                     _l10n.flashPromo,
//                     style: TextStyle(
//                         color: AppColors.app_txt_color,
//                         fontSize: SizeConfig.textMultiplier * 2.887374461979914,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               // if(_flashList != null || _flashList.isNotEmpty)
//               if (_noFilterDashboard) _flashPromo(),
//               if (_noFilterDashboard) _imageBanner(),
//
//               _subCategoriesList(),
//
//               ShouldRebuild<CardList>(
//                   shouldRebuild: (oldWidget, newWidget) =>
//                       oldWidget.notifier.value != newWidget.notifier.value,
//                   child: CardList(
//                     valueNotifier,
//                     productList: _productList,
//                     isLoading: _productLoading,
//                   )),
//               // if (_productLoadMore)
//               //   Center(
//               //     child: Container(
//               //       margin: EdgeInsets.only(
//               //           bottom:
//               //               SizeConfig.heightMultiplier * 10.043041606886657),
//               //       height: SizeConfig.heightMultiplier * 3.7661406025824964,
//               //       width: SizeConfig.widthMultiplier * 7.291666666666666,
//               //       child: LoadingProgress(
//               //         color: AppColors.app_orange,
//               //       ),
//               //     ),
//               //   )
//             ],
//           ),
//           // if (_isLoading)
//           //   BackdropFilter(
//           //       filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
//           //       child: LoadingProgress(
//           //         color: Colors.deepOrangeAccent,
//           //       )),
//         ],
//       ),
//     );
//   }
//
//   Widget _toolbar(BuildContext context) {
//     return SafeArea(
//       bottom: false,
//       child: Container(
//           height: _toolbarExtendHeight,
//           color: AppColors.white,
//           child: Card(
//               elevation: 10,
//               shadowColor: Color.fromRGBO(0, 0, 0, 20),
//               margin: EdgeInsets.zero,
//               clipBehavior: Clip.antiAlias,
//               color: AppColors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.only(
//                     bottomRight: Radius.circular(15),
//                     bottomLeft: Radius.circular(15)),
//               ),
//               child: Container(
//                   height: toolbarHeight * 0.8,
//                   decoration: BoxDecoration(
//                       color: AppColors.lightgrey,
//                       borderRadius: BorderRadius.only(
//                           bottomRight: Radius.circular(15),
//                           bottomLeft: Radius.circular(15))),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             width: SizeConfig.widthMultiplier * 60.277777777,
//                             height: SizeConfig.heightMultiplier * 11.80,
//                             //11.8 works for larger devices 12.8 for smaller?
//                             // decoration: BoxDecoration(
//                             //     color: AppColors.toolbarBlue,
//                             //     borderRadius: BorderRadius.only(
//                             //         bottomRight: Radius.circular(15))),
//                             child: Container(
//                               child: Card(
//                                 elevation: 4,
//                                 shadowColor: AppColors.darkgrey,
//                                 margin: EdgeInsets.only(
//                                     bottom: SizeConfig.heightMultiplier *
//                                         0.25107604017216645),
//                                 clipBehavior: Clip.antiAlias,
//                                 color: AppColors.toolbarBlue,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.only(
//                                   bottomRight: Radius.circular(15),
//                                 )),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Padding(
//                                             padding: EdgeInsets.only(
//                                               left: SizeConfig.widthMultiplier *
//                                                   3.8888888888888884,
//                                               top: SizeConfig.heightMultiplier *
//                                                   2.259684361549498,
//                                               right:
//                                                   SizeConfig.widthMultiplier *
//                                                       22.166666666666664,
//                                             ),
//                                             child: Text(
//                                               "MARKETSPAACE",
//                                               style: GoogleFonts.montserrat(
//                                                 textStyle: TextStyle(
//                                                     color: AppColors.white,
//                                                     fontFamily: 'Montserrat',
//                                                     fontSize: SizeConfig
//                                                             .textMultiplier *
//                                                         1.6319942611190819),
//                                               ),
//                                             )),
//                                       ],
//                                     ),
//                                     GestureDetector(
//                                       onTap: () => RouterService.appRouter
//                                           .navigateTo(SearchRoute.buildPath()),
//                                       child: Container(
//                                         width: SizeConfig.widthMultiplier * 42,
//                                         height: SizeConfig.heightMultiplier *
//                                             4.017216642754663,
//                                         margin: EdgeInsets.only(
//                                             left: SizeConfig.widthMultiplier *
//                                                 3.8888888888888884,
//                                             top: SizeConfig.heightMultiplier *
//                                                 1.3809182209469155,
//                                             right: SizeConfig.widthMultiplier *
//                                                 22.166666666666664,
//                                             bottom:
//                                                 SizeConfig.heightMultiplier *
//                                                     1.757532281205165),
//                                         padding: EdgeInsets.only(
//                                             left: SizeConfig.widthMultiplier *
//                                                 1.9444444444444442,
//                                             top: SizeConfig.heightMultiplier *
//                                                 0.8787661406025825,
//                                             bottom:
//                                                 SizeConfig.heightMultiplier *
//                                                     0.8787661406025825),
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             color: AppColors.toolbarBack),
//                                         child: Row(
//                                           children: [
//                                             Padding(
//                                                 padding: EdgeInsets.only(
//                                                     left: SizeConfig
//                                                             .widthMultiplier *
//                                                         1.9444444444444442),
//                                                 child: Align(
//                                                     alignment:
//                                                         Alignment.centerRight,
//                                                     child: Image.asset(
//                                                       'assets/images/search_icon.png',
//                                                       width: SizeConfig
//                                                               .widthMultiplier *
//                                                           3.5170138888888887,
//                                                       height: SizeConfig
//                                                               .heightMultiplier *
//                                                           1.8165351506456242,
//                                                     ))),
//                                             Padding(
//                                               padding: EdgeInsets.only(
//                                                   left: SizeConfig
//                                                           .widthMultiplier *
//                                                       1.2152777777777777),
//                                               child: Text(
//                                                 _l10n.search,
//                                                 style: GoogleFonts.inter(
//                                                   textStyle: TextStyle(
//                                                       color: AppColors
//                                                           .app_txt_color,
//                                                       letterSpacing: .25,
//                                                       fontWeight:
//                                                           FontWeight.w400,
//                                                       fontSize: SizeConfig
//                                                               .textMultiplier *
//                                                           1.757532281205165),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           // if (_searchClicked)
//                           Spacer(),
//                           Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Container(
//                                 width: SizeConfig.widthMultiplier *
//                                     25.388888888888886,
//                                 height: SizeConfig.heightMultiplier *
//                                     5.0129124820659974,
//                                 alignment: Alignment.center,
//                                 child: InkWell(
//                                     onTap: () {
//                                       OrderCheckoutRoute.isBuyNow = false;
//                                       var route = RouterService.appRouter
//                                           .navigateTo(CartRoute.buildPath())
//                                           .then((value) {
//                                         setState(() {
//                                           if (value != null &&
//                                               value == "Success") {
//                                             Constants.cartCount =
//                                                 Constants.cartCount;
//                                           }
//                                         });
//                                       });
//                                     },
//                                     child: Constants.cartCount == 0
//                                         ? SvgPicture.asset(
//                                             'assets/images/cart.svg',
//                                             height:
//                                                 SizeConfig.heightMultiplier *
//                                                     3.809124820659974,
//                                             width: SizeConfig.widthMultiplier *
//                                                 4.029,
//                                           )
//                                         : Badge(
//                                             badgeContent: Text(
//                                               '${Constants.cartCount}',
//                                               style: GoogleFonts.inter(
//                                                   color: AppColors.white,
//                                                   fontSize: SizeConfig
//                                                           .textMultiplier *
//                                                       2.1),
//                                             ),
//                                             child: SvgPicture.asset(
//                                               'assets/images/cart.svg',
//                                               height:
//                                                   SizeConfig.heightMultiplier *
//                                                       3.809124820659974,
//                                               width:
//                                                   SizeConfig.widthMultiplier *
//                                                       4.029,
//                                             ),
//                                           )),
//                               ),
//                               GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       if (_showCategoriesTabs) {
//                                         _toolbarExtendHeight = SizeConfig
//                                                 .heightMultiplier *
//                                             12.05156250000000050201416015625;
//                                         _showCategoriesTabs = false;
//                                         _prelovedSelected = false;
//                                         _digitalSelected = false;
//                                         _internationalSelected = false;
//                                         _localSelected = false;
//                                         _productLoading = true;
//                                         _noFilterDashboard = false;
//                                         _DashboardScreenBloc.subCatSelected =
//                                             false;
//                                         _DashboardScreenBloc.categoryFilter =
//                                             "";
//                                         _DashboardScreenBloc
//                                             .newSubCategoryText = null;
//
//                                         _DashboardScreenBloc.add(
//                                             NavigateToLoginScreenEvent());
//                                         _flashPromoLoading = true;
//                                         // _DashboardScreenBloc.add(
//                                         //     LoadListEvent());
//                                         _showSubCat = false;
//                                       } else {
//                                         _toolbarExtendHeight =
//                                             SizeConfig.heightMultiplier *
//                                                 16.573750000000001068115234375;
//                                         _showCategoriesTabs = true;
//                                         _prelovedSelected = false;
//                                         _digitalSelected = false;
//                                         _internationalSelected = false;
//                                         _localSelected = false;
//                                         _productLoading = true;
//                                         _DashboardScreenBloc.subCatSelected =
//                                             false;
//                                         _tabController.animateTo(0);
//                                         _DashboardScreenBloc.categoryFilter =
//                                             "";
//                                         _DashboardScreenBloc
//                                             .newSubCategoryText = null;
//                                         // _showSubCat = true;
//                                         // _showCatText = "Technology";
//                                         _showCatText = null;
//                                         _noFilterDashboard = true;
//                                         _newSubSelected = null;
//                                         // if (_showCatText != "") {
//                                         //   _DashboardScreenBloc.add(
//                                         //       NavigateToLoginScreenEvent());
//                                         //   _flashPromoLoading = true;
//                                         //   _DashboardScreenBloc.add(
//                                         //       LoadListEvent());
//                                         // }
//                                       }
//                                     });
//                                   },
//                                   child: Container(
//                                     height: SizeConfig.heightMultiplier *
//                                         6.107604017216643,
//                                     width: SizeConfig.widthMultiplier *
//                                         28.118055555555554,
//                                     // margin: EdgeInsets.only(
//                                     //     left: SizeConfig.widthMultiplier *
//                                     //         2.0736111111111107,
//                                     //     bottom:
//                                     //         SizeConfig.heightMultiplier *
//                                     //             3.51506456241033,
//                                     //     right:
//                                     //         SizeConfig.widthMultiplier *
//                                     //             1.4305555555555554,
//                                     //   top: SizeConfig.widthMultiplier*1
//                                     // ),
//                                     //   alignment: Alignment.centerLeft,
//                                     // margin: EdgeInsets.only(top: SizeConfig.widthMultiplier*0.5),
//                                     child: Row(
//                                       children: [
//                                         Text(_l10n.categories,
//                                             style: GoogleFonts.inter(
//                                               fontSize:
//                                                   SizeConfig.textMultiplier * 2,
//                                               color: AppColors.toolbarBlue,
//                                             )),
//
//                                         // Container(
//                                         //   margin: EdgeInsets.only(
//                                         //       left: SizeConfig
//                                         //               .widthMultiplier *
//                                         //           0.48611111111111105),
//                                         //   child:
//                                         SvgPicture.asset(
//                                           'assets/images/arrowDown.svg',
//                                           color: AppColors.toolbarBlue,
//                                           width: 12,
//                                           height: 7,
//                                         ),
//                                       ],
//                                     ),
//                                   )),
//                             ],
//                           ),
//                         ],
//                       ),
//                       if (_showCategoriesTabs) _tabs(),
//                     ],
//                   )))),
//     );
//   }
//
//   Widget _tabs() {
//     return AnimatedContainer(
//       height: SizeConfig.heightMultiplier * 4.519368723098996,
//       decoration: BoxDecoration(
//           color: AppColors.toolbarBack,
//           borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))),
//       duration: Duration(milliseconds: 200),
//       child: DefaultTabController(
//         length: 9,
//         initialIndex: 0,
//         child: TabBar(
//           isScrollable: true,
//           indicatorColor: AppColors.tab_indicator_color,
//           indicatorSize: TabBarIndicatorSize.label,
//           unselectedLabelColor: AppColors.unselected_tab,
//           labelColor: AppColors.tab_indicator_color,
//           controller: _tabController,
//           onTap: (index) {
//             _carouselController.animateToPage(index,
//                 duration: Duration(milliseconds: 300), curve: Curves.linear);
//           },
//           tabs: [
//             Text(
//               _l10n.main,
//               style: TextStyle(
//                   // color: AppColors.tab_indicator_color,
//                   fontSize: SizeConfig.textMultiplier * 1.757532281205165,
//                   fontWeight: FontWeight.w400),
//             ),
//             Text(
//               _l10n.technology,
//               style: TextStyle(
//                   // color: AppColors.tab_indicator_color,
//                   fontSize: SizeConfig.textMultiplier * 1.757532281205165,
//                   fontWeight: FontWeight.w400),
//             ),
//             Text(
//               _l10n.womensFashion,
//               style: TextStyle(
//                   // color: AppColors.tab_indicator_color,
//                   fontSize: SizeConfig.textMultiplier * 1.757532281205165,
//                   fontWeight: FontWeight.w400),
//             ),
//             Text(
//               _l10n.mensFashion,
//               style: TextStyle(
//                   // color: AppColors.tab_indicator_color,
//                   fontSize: SizeConfig.textMultiplier * 1.757532281205165,
//                   fontWeight: FontWeight.w400),
//             ),
//             Text(
//               _l10n.herAccesssories,
//               style: TextStyle(
//                   // color: AppColors.tab_indicator_color,
//                   fontSize: SizeConfig.textMultiplier * 1.757532281205165,
//                   fontWeight: FontWeight.w400),
//             ),
//             Text(
//               _l10n.hisAccessories,
//               style: TextStyle(
//                   // color: AppColors.tab_indicator_color,
//                   fontSize: SizeConfig.textMultiplier * 1.757532281205165,
//                   fontWeight: FontWeight.w400),
//             ),
//             Text(
//               _l10n.office,
//               style: TextStyle(
//                   // color: AppColors.tab_indicator_color,
//                   fontSize: SizeConfig.textMultiplier * 1.757532281205165,
//                   fontWeight: FontWeight.w400),
//             ),
//             Text(
//               _l10n.sports,
//               style: TextStyle(
//                   // color: AppColors.tab_indicator_color,
//                   fontSize: SizeConfig.textMultiplier * 1.757532281205165,
//                   fontWeight: FontWeight.w400),
//             ),
//             Text(
//               _l10n.homeandKitchen,
//               style: TextStyle(
//                   // color: AppColors.tab_indicator_color,
//                   fontSize: SizeConfig.textMultiplier * 1.757532281205165,
//                   fontWeight: FontWeight.w400),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _flashPromo() {
//     return _productList.isNotEmpty
//         ? Container(
//             height: SizeConfig.heightMultiplier * 25.107604017216644,
//             child: ListView(
//                 controller: _flashController,
//                 physics: ClampingScrollPhysics(),
//                 shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 children: [
//                   Row(
//                     children: _productList
//                         .map<Widget>((e) => _flashPromoCard(e))
//                         ?.toList(),
//                   ),
//                   if (_flashLoading)
//                     Container(
//                       margin: EdgeInsets.only(
//                           right:
//                               SizeConfig.widthMultiplier * 12.152777777777777),
//                       height: SizeConfig.heightMultiplier * 3.7661406025824964,
//                       width: SizeConfig.widthMultiplier * 7.291666666666666,
//                       child: LoadingProgress(
//                         color: AppColors.app_orange,
//                       ),
//                     )
//                 ]),
//           )
//         : _productList.isEmpty && !_flashPromoLoading
//             ? Container(
//                 height: SizeConfig.heightMultiplier * 12.553802008608322,
//                 margin: EdgeInsets.only(
//                     left: (0.3 * MediaQuery.of(context).size.width)),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Image.asset(
//                     //   'assets/images/empty_box.png',
//                     //   fit: BoxFit.contain,
//                     //   height: SizeConfig.heightMultiplier * 18.830703012912483,
//                     //   width: SizeConfig.widthMultiplier * 24.305555555555554,
//                     // ),
//                     Text(
//                       "Flash promo not available..",
//                       style: GoogleFonts.inter(
//                         fontSize: SizeConfig.textMultiplier * 1.757532281205165,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             : Container(
//                 height: SizeConfig.heightMultiplier * 25.107604017216644,
//                 child: ListView(
//                   shrinkWrap: true,
//                   scrollDirection: Axis.horizontal,
//                   children: [
//                     Container(
//                         height: SizeConfig.heightMultiplier * 24.60545193687231,
//                         width: SizeConfig.widthMultiplier * 30.138888888888886,
//                         margin: EdgeInsets.only(
//                             left:
//                                 SizeConfig.widthMultiplier * 2.4305555555555554,
//                             right: SizeConfig.widthMultiplier *
//                                 2.4305555555555554),
//                         child: Lottie.asset('assets/loader/loading_card.json',
//                             width: SizeConfig.widthMultiplier *
//                                 30.138888888888886)),
//                     Container(
//                         height: SizeConfig.heightMultiplier * 24.60545193687231,
//                         width: SizeConfig.widthMultiplier * 30.138888888888886,
//                         margin: EdgeInsets.only(
//                             left:
//                                 SizeConfig.widthMultiplier * 2.4305555555555554,
//                             right: SizeConfig.widthMultiplier *
//                                 2.4305555555555554),
//                         child: Lottie.asset('assets/loader/loading_card.json',
//                             width: SizeConfig.widthMultiplier *
//                                 30.138888888888886)),
//                     Container(
//                         height: SizeConfig.heightMultiplier * 24.60545193687231,
//                         width: SizeConfig.widthMultiplier * 30.138888888888886,
//                         margin: EdgeInsets.only(
//                             left:
//                                 SizeConfig.widthMultiplier * 2.4305555555555554,
//                             right: SizeConfig.widthMultiplier *
//                                 2.4305555555555554),
//                         child: Lottie.asset('assets/loader/loading_card.json',
//                             width: SizeConfig.widthMultiplier *
//                                 30.138888888888886)),
//                     Container(
//                         height: SizeConfig.heightMultiplier * 24.60545193687231,
//                         width: SizeConfig.widthMultiplier * 30.138888888888886,
//                         margin: EdgeInsets.only(
//                             left:
//                                 SizeConfig.widthMultiplier * 2.4305555555555554,
//                             right: SizeConfig.widthMultiplier *
//                                 2.4305555555555554),
//                         child: Lottie.asset('assets/loader/loading_card.json',
//                             width: SizeConfig.widthMultiplier *
//                                 30.138888888888886)),
//                   ],
//                 ));
//   }
//
//   Widget _flashPromoCard(FlashPromoAlgoliaObj model) {
//     double prefCurrency;
//     // cryto;
//     var prefSevenDecimal;
//     // cryptoDecimal;
//     if (Constants.aud != null) {
//       prefCurrency = model.price / double.parse(Constants.aud);
//       // cryto = (model.price / double.parse(Constants.aud)) *
//       //     double.parse(Constants.btc);
//       // if (prefCurrency.toString().length > 7) {
//       //   prefSevenDecimal = double.parse(prefCurrency.toStringAsFixed(7));
//       //   cryptoDecimal = double.parse(cryto.toStringAsFixed(7));
//       // } else {
//       //   prefSevenDecimal = prefCurrency;
//       //   cryptoDecimal = double.parse(cryto.toStringAsFixed(7));
//       // }
//     }
//     // else {
//     //   cryto = (model.price / 1.0) * double.parse(Constants.btc);
//     //   cryptoDecimal = double.parse(cryto.toStringAsFixed(7));
//     // }
//     bool _isLiked = _favLoadingItems.contains(model.productNum.toString());
//     return GestureDetector(
//         onTap: () {
//           ProductLandingRoute.productNum = model.productNum;
//           ProductLandingRoute.productName = model.productName;
//           ProductLandingRoute.isProductLiked = _isLiked;
//           RouterService.appRouter.navigateTo(ProductLandingRoute.buildPath());
//         },
//         child: Container(
//             height: SizeConfig.heightMultiplier * 25.107604017216644,
//             width: SizeConfig.widthMultiplier * 36.45833333333333,
//             margin: EdgeInsets.only(
//                 left: SizeConfig.widthMultiplier * 0.48611111111111105,
//                 right: SizeConfig.widthMultiplier * 0.48611111111111105),
//             child: Card(
//                 elevation: 1,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                 ),
//                 child: Column(
//                   children: [
//                     Stack(
//                       children: [
//                         Container(
//                             height: SizeConfig.heightMultiplier *
//                                 17.319942611190818,
//                             width:
//                                 SizeConfig.widthMultiplier * 36.45833333333333,
//                             // margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 0.6276901004304161),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(10),
//                                   topRight: Radius.circular(10)),
//                               color: AppColors.white,
//                             ),
//                             child: CachedNetworkImage(
//                                 imageUrl: model.imgURL != null
//                                     ? model.imgURL
//                                     : 'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg',
//                                 placeholder: (context, url) => Lottie.asset(
//                                     'assets/loader/image_loading.json'),
//                                 errorWidget: (context, url, error) =>
//                                     Icon(Icons.error),
//                                 fit: BoxFit.cover,
//                                 imageBuilder: (context, imageProvider) =>
//                                     Container(
//                                       decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                           color: AppColors.toolbarBlue,
//                                           image: DecorationImage(
//                                               image: imageProvider,
//                                               fit: BoxFit.cover)),
//                                     ))),
//                         Positioned(
//                             top: SizeConfig.heightMultiplier *
//                                 0.25107604017216645,
//                             right: SizeConfig.widthMultiplier *
//                                 0.48611111111111105,
//                             child: Container(
//                               height: SizeConfig.heightMultiplier *
//                                   4.017216642754663,
//                               padding: EdgeInsets.only(
//                                   left: SizeConfig.widthMultiplier *
//                                       0.48611111111111105,
//                                   right: SizeConfig.widthMultiplier *
//                                       0.48611111111111105),
//                               child: _isLiked
//                                   ? GestureDetector(
//                                       onTap: () {
//                                         _DashboardScreenBloc.liked_deleted =
//                                             int.parse(
//                                                 model.productNum.toString());
//                                         _DashboardScreenBloc.liked_item = 0;
//                                         _DashboardScreenBloc.favProduct = model;
//                                         _DashboardScreenBloc.add(
//                                             LikeDislikeEvent());
//                                         setState(() {
//                                           _favLoadingItems.remove(
//                                               model.productNum.toString());
//                                         });
//                                       },
//                                       child: Container(
//                                         padding: EdgeInsets.all(2),
//                                         child: Image.asset(
//                                           'assets/images/img_fav.png',
//                                           width: SizeConfig.widthMultiplier *
//                                               5.347222222222221,
//                                           height: SizeConfig.heightMultiplier *
//                                               2.761836441893831,
//                                         ),
//                                       ))
//                                   : GestureDetector(
//                                       onTap: () {
//                                         _DashboardScreenBloc.liked_deleted = 0;
//                                         _DashboardScreenBloc.liked_item =
//                                             int.parse(
//                                                 model.productNum.toString());
//                                         _DashboardScreenBloc.favProduct = model;
//                                         _DashboardScreenBloc.add(
//                                             LikeDislikeEvent());
//                                         setState(() {
//                                           _favLoadingItems
//                                               .add(model.productNum.toString());
//                                         });
//                                       },
//                                       child: SvgPicture.asset(
//                                         'assets/images/heart.svg',
//                                         width: SizeConfig.widthMultiplier *
//                                             5.833333333333333,
//                                         height: SizeConfig.heightMultiplier *
//                                             4.017216642754663,
//                                         color: AppColors.nextButtonPrimary,
//                                       )),
//                             )),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                             alignment: Alignment.topLeft,
//                             child: Text(
//                                 _isChinese
//                                     ? model.chineseTitle.length > 14
//                                         ? "${model.chineseTitle.substring(0, 13)}.."
//                                         : model.productName
//                                     : model.productName.length > 14
//                                         ? "${model.productName.substring(0, 13)}.."
//                                         : model.productName,
//                                 style: GoogleFonts.inter(
//                                     fontSize: SizeConfig.textMultiplier *
//                                         2.0086083213773316,
//                                     color: AppColors.app_txt_color,
//                                     fontWeight: FontWeight.w400,
//                                     letterSpacing: 0.15))),
//                         Container(
//                           // margin: EdgeInsets.only(
//                           //     left: SizeConfig.widthMultiplier * 0.5),
//                           child: Text(
//                               Constants.aud == null && _priceLoading
//                                   ? 'Loading...'
//                                   : '\$${model.price}',
//                               style: GoogleFonts.inter(
//                                   fontSize: SizeConfig.textMultiplier *
//                                       1.757532281205165,
//                                   color: AppColors.app_txt_color,
//                                   fontWeight: FontWeight.w700,
//                                   letterSpacing: 0.1)),
//                         ),
//                         // Container(
//                         //     margin: EdgeInsets.only(
//                         //         left: SizeConfig.widthMultiplier *
//                         //             1.2152777777777777),
//                         //     child: Row(
//                         //       children: [
//                         //         Icon(
//                         //           CryptoFontIcons.BTC,
//                         //           size: 12,
//                         //           color: AppColors.app_txt_color,
//                         //         ),
//                         //         Text(
//                         //             Constants.aud == null && _priceLoading
//                         //                 ? 'Loading...'
//                         //                 : '$cryptoDecimal',
//                         //             textAlign: TextAlign.center,
//                         //             style: GoogleFonts.inter(
//                         //                 fontSize: SizeConfig.textMultiplier *
//                         //                     1.5064562410329987,
//                         //                 color: AppColors.app_txt_color,
//                         //                 fontWeight: FontWeight.w400,
//                         //                 letterSpacing: 0.4))
//                         //       ],
//                         //     )),
//                       ],
//                     ),
//                   ],
//                 ))));
//   }
//
//   Widget _productCard(FlashPromoAlgoliaObj model) {
//     // if (model.tags == null) {
//     //   _isTags = false;
//     // } else {
//     //   _isTags = true;
//     // }
//
//     // double prefCurrency, cryto;
//     // var prefSevenDecimal, cryptoDecimal;
//     // if (Constants.aud != null) {
//     //   prefCurrency = model.price / double.parse(Constants.aud);
//     //   cryto = (model.price / double.parse(Constants.aud)) *
//     //       double.parse(Constants.btc);
//     //   if (prefCurrency.toString().length > 7) {
//     //     prefSevenDecimal = double.parse(prefCurrency.toStringAsFixed(7));
//     //     cryptoDecimal = double.parse(cryto.toStringAsFixed(7));
//     //   } else {
//     //     prefSevenDecimal = prefCurrency;
//     //     cryptoDecimal = double.parse(cryto.toStringAsFixed(7));
//     //   }
//     // } else {
//     //   cryto = (model.price / 1.0) * double.parse(Constants.btc);
//     //   cryptoDecimal = double.parse(cryto.toStringAsFixed(7));
//     // }
//
//     // if (model.likedItem == "true") {
//     //   _favLoadingItems.add(model.productNum);
//     // }
//
//     bool _isLiked = _favLoadingItems.contains(model.productNum.toString());
//
//     return GestureDetector(
//         onTap: () {
//           ProductLandingRoute.productNum = model.productNum;
//           ProductLandingRoute.productName = model.productName;
//           ProductLandingRoute.isProductLiked = _isLiked;
//           RouterService.appRouter.navigateTo(ProductLandingRoute.buildPath());
//         },
//         child: Container(
//             padding: EdgeInsets.only(
//                 left: SizeConfig.widthMultiplier * 0.24305555555555552,
//                 top: SizeConfig.heightMultiplier * 0.7532281205164993,
//                 // bottom: SizeConfig.heightMultiplier * 0.7532281205164993,
//                 right: SizeConfig.widthMultiplier * 0.24305555555555552),
//             child: Card(
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                 ),
//                 child: Column(
//                   children: [
//                     Stack(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(10),
//                                 topRight: Radius.circular(10)),
//                             color: AppColors.toolbarBlue,
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(10),
//                                 topRight: Radius.circular(10)),
//                             child: CachedNetworkImage(
//                               imageUrl: model.imgURL != null
//                                   ? model.imgURL
//                                   : 'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg',
//                               placeholder: (context, url) => Lottie.asset(
//                                   'assets/loader/image_loading.json'),
//                               errorWidget: (context, url, error) =>
//                                   Icon(Icons.error),
//                               fit: BoxFit.fitWidth,
//                               // height: _isTags
//                               //     ? SizeConfig.heightMultiplier *
//                               //         31.44531250000000122833251953125
//                               //     : SizeConfig.heightMultiplier *
//                               //         34.17968750000000133514404296875,
//                               width: double.infinity,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           right: SizeConfig.widthMultiplier * 3,
//                           top: SizeConfig.widthMultiplier * 1,
//                           height:
//                               SizeConfig.heightMultiplier * 4.017216642754663,
//                           // padding: EdgeInsets.only(
//                           //     left: SizeConfig.widthMultiplier *
//                           //         1.2152777777777777,
//                           //     right: SizeConfig.widthMultiplier *
//                           //         1.2152777777777777),
//                           child: _isLiked
//                               ? GestureDetector(
//                                   onTap: () {
//                                     _DashboardScreenBloc.liked_deleted =
//                                         int.parse(model.productNum.toString());
//                                     _DashboardScreenBloc.liked_item = 0;
//                                     _DashboardScreenBloc.favProduct = model;
//                                     _DashboardScreenBloc.add(
//                                         LikeDislikeEvent());
//                                     setState(() {
//                                       _favLoadingItems
//                                           .remove(model.productNum.toString());
//                                     });
//                                   },
//                                   child: Container(
//                                     padding: EdgeInsets.all(2),
//                                     child: Image.asset(
//                                       'assets/images/img_fav.png',
//                                       width: SizeConfig.widthMultiplier *
//                                           5.833333333333333,
//                                       height: SizeConfig.heightMultiplier *
//                                           4.017216642754663,
//                                     ),
//                                   ))
//                               : GestureDetector(
//                                   onTap: () {
//                                     _DashboardScreenBloc.liked_deleted = 0;
//                                     _DashboardScreenBloc.liked_item =
//                                         int.parse(model.productNum.toString());
//                                     _DashboardScreenBloc.favProduct = model;
//                                     _DashboardScreenBloc.add(
//                                         LikeDislikeEvent());
//                                     setState(() {
//                                       _favLoadingItems
//                                           .add(model.productNum.toString());
//                                     });
//                                   },
//                                   child: SvgPicture.asset(
//                                     'assets/images/heart.svg',
//                                     width: SizeConfig.widthMultiplier *
//                                         5.833333333333333,
//                                     height: SizeConfig.heightMultiplier *
//                                         4.017216642754663,
//                                     color: AppColors.nextButtonPrimary,
//                                   )),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(
//                                 bottom: SizeConfig.heightMultiplier * 0.75,
//                                 left: SizeConfig.heightMultiplier * 0.55),
//                             child: Text(
//                                 _isChinese
//                                     ? model.chineseTitle
//                                     : model.productName,
//                                 style: GoogleFonts.inter(
//                                     fontSize: SizeConfig.textMultiplier * 1.725,
//                                     color: AppColors.app_txt_color,
//                                     fontWeight: FontWeight.w400,
//                                     letterSpacing: 0.15)),
//                           ),
//                           Padding(
//                               padding: EdgeInsets.only(
//                                 left: SizeConfig.widthMultiplier *
//                                     1.2152777777777777,
//                                 bottom: SizeConfig.heightMultiplier *
//                                     1.2152777777777777,
//                               ),
//                               child: Text(
//                                   Constants.aud == null && _priceLoading
//                                       ? 'Loading...'
//                                       // : Constants.aud == null &&
//                                       // !_productLoading
//                                       : '\$${model.price}',
//                                   // : '\$$prefSevenDecimal',
//                                   overflow: TextOverflow.ellipsis,
//                                   style: GoogleFonts.inter(
//                                       fontSize: SizeConfig.textMultiplier *
//                                           1.757532281205165,
//                                       color: AppColors.app_txt_color,
//                                       fontWeight: FontWeight.w700,
//                                       letterSpacing: 0.1))),
//                           Container(
//                             margin: EdgeInsets.only(
//                                 // right: SizeConfig.widthMultiplier *
//                                 //     3.8888888888888884,
//                                 left: SizeConfig.widthMultiplier * 1),
//                           ),
//                           // Spacer(),
//                           if (_isTags)
//                             Container(
//                                 height: SizeConfig.heightMultiplier *
//                                     6.276901004304161,
//                                 // width: SizeConfig.widthMultiplier * 48.61111111111111,
//                                 child: GridView.count(
//                                     crossAxisCount: 2,
//                                     shrinkWrap: true,
//                                     childAspectRatio: 0.35,
//                                     scrollDirection: Axis.horizontal,
//                                     children: model.tags
//                                         .map((e) => _tags(e))
//                                         ?.toList())),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ))));
//   }
//
//   Widget _tags(String tag) {
//     Color color;
//     if (tag.length <= 3) {
//       color = AppColors.tag_short;
//     } else if (tag.length > 3 && tag.length < 6) {
//       color = AppColors.tag_normal;
//     } else if (tag.length >= 6 && tag.length < 8) {
//       color = AppColors.tag_medium;
//     } else if (tag.length >= 8) {
//       color = AppColors.tag_longest;
//     }
//     return Container(
//       margin: EdgeInsets.only(
//           top: SizeConfig.heightMultiplier * 1.0043041606886658,
//           left: SizeConfig.widthMultiplier * 0.9722222222222221),
//       decoration:
//           BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
//       child: Center(
//         child: Text(
//           tag,
//           textAlign: TextAlign.center,
//           style: GoogleFonts.inter(
//             fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
//             letterSpacing: 0.4,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _imageBanner() {
//     return StreamBuilder(
//       stream: DashboardProvider.bannerStream,
//       builder: (context, stream) {
//         if (stream.connectionState == ConnectionState.done) {}
//
//         if (stream.hasData) {
//           // _promoList = stream.data;
//           return Container(
//               height: SizeConfig.heightMultiplier * 20.71377331420373,
//               width: MediaQuery.of(context).size.width,
//               margin: EdgeInsets.only(
//                   left: SizeConfig.widthMultiplier * 1.9444444444444442,
//                   right: SizeConfig.widthMultiplier * 1.9444444444444442,
//                   top: SizeConfig.heightMultiplier * 4.017216642754663),
//               child: Stack(
//                 children: [
//                   PageView(
//                     controller: _pageController,
//                     allowImplicitScrolling: true,
//                     onPageChanged: (index) {
//                       setState(() {
//                         slideIndex = index;
//                         _currentPage = index;
//                       });
//                     },
//                     children: stream.data
//                         .map<Widget>((e) => _bannerCard(e))
//                         ?.toList(),
//                   ),
//                   Positioned(
//                     bottom: SizeConfig.heightMultiplier * 3.0129124820659974,
//                     left: SizeConfig.widthMultiplier * 36.94444444444444,
//                     child: _bannerSheet(true),
//                   ),
//                 ],
//               ));
//         } else {
//           return Container(
//             height: SizeConfig.heightMultiplier * 20.71377331420373,
//             width: MediaQuery.of(context).size.width,
//             margin: EdgeInsets.only(
//                 left: SizeConfig.widthMultiplier * 1.9444444444444442,
//                 right: SizeConfig.widthMultiplier * 1.9444444444444442,
//                 top: SizeConfig.heightMultiplier * 4.017216642754663),
//             child: Lottie.asset('assets/loader/image_loading.json'),
//           );
//         }
//       },
//     );
//   }
//
//   Widget _bannerCard(String image) {
//     return Container(
//       margin: EdgeInsets.only(
//           left: SizeConfig.widthMultiplier * 2.4305555555555554,
//           right: SizeConfig.widthMultiplier * 2.4305555555555554),
//       child: Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: CachedNetworkImage(
//               imageUrl: image != null
//                   ? image
//                   : 'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg',
//               placeholder: (context, url) =>
//                   Lottie.asset('assets/loader/image_loading.json'),
//               errorWidget: (context, url, error) => Icon(Icons.error),
//               fit: BoxFit.fill,
//               height: SizeConfig.heightMultiplier * 24.354375896700144,
//               width: double.infinity,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _bannerSheet(bool isCurrentPage) {
//     return Container(
//       margin: EdgeInsets.only(
//           right: SizeConfig.widthMultiplier * 1.2152777777777777),
//       child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//         for (int i = 0; i < 3; i++)
//           i == slideIndex
//               ? _bannerSheetContainer(true)
//               : _bannerSheetContainer(false),
//       ]),
//     );
//   }
//
//   Widget _bannerSheetContainer(bool isCurrentPage) {
//     return Container(
//       margin: EdgeInsets.all(5), //I made the decision to ignore this one
//       height: isCurrentPage
//           ? SizeConfig.heightMultiplier * 1.093750000000000042724609375
//           : SizeConfig.heightMultiplier * 0.5468750000000000213623046875,
//       width: isCurrentPage
//           ? 1.9444444444444441068672839506173
//           : 0.97222222222222205343364197530867,
//       decoration: BoxDecoration(
//           color: isCurrentPage ? Color(0xff034AA6) : Color(0xffD4D4D4),
//           shape: BoxShape.circle),
//     );
//   }
//
//   Widget _subCategoriesList() {
//     return Container(
//       height: SizeConfig.heightMultiplier * 12.553802008608322,
//       width: MediaQuery.of(context).size.width,
//       // decoration: BoxDecoration(color: AppColors.catContainerColor),
//       margin: EdgeInsets.only(
//           top: SizeConfig.heightMultiplier * 1.2553802008608321,
//           left: SizeConfig.widthMultiplier * 3.8888888888888884,
//           right: SizeConfig.widthMultiplier * 3.8888888888888884,
//           bottom: SizeConfig.heightMultiplier * 1.2553802008608321),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           InkWell(
//             onTap: () {
//               setState(() {
//                 _prelovedSelected = !_prelovedSelected;
//
//                 // _flashList.clear();
//                 _productList.clear();
//                 valueNotifier.value = _productList.length;
//
//                 _DashboardScreenBloc.client.clickOn(isPreloved: true);
//
//                 _DashboardScreenBloc.add(LoadListEvent());
//               });
//             },
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   height: SizeConfig.heightMultiplier * 7.281205164992826,
//                   width: SizeConfig.widthMultiplier * 14.097222222222221,
//                   margin: EdgeInsets.only(
//                     left: SizeConfig.widthMultiplier * 2.4305555555555554,
//                   ),
//                   child: Card(
//                     elevation: 5,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(100),
//                     ),
//                     child: Container(
//                         height: SizeConfig.heightMultiplier * 4.017216642754663,
//                         width: SizeConfig.widthMultiplier * 7.777777777777777,
//                         margin: EdgeInsets.all(10),
//                         child: Image.asset(
//                           'assets/images/time_revind.png',
//                           width: SizeConfig.widthMultiplier * 7.777777777777777,
//                           height:
//                               SizeConfig.heightMultiplier * 4.017216642754663,
//                           fit: BoxFit.contain,
//                           color: _prelovedSelected
//                               ? AppColors.app_orange
//                               : AppColors.appBlue,
//                         )),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(
//                     left: SizeConfig.widthMultiplier * 2.4305555555555554,
//                   ),
//                   child: Text(_l10n.preloved,
//                       style: GoogleFonts.inter(
//                           fontWeight: FontWeight.w400,
//                           fontSize:
//                               SizeConfig.textMultiplier * 1.757532281205165,
//                           letterSpacing: 0.25)),
//                 ),
//               ],
//             ),
//           ),
//           InkWell(
//               onTap: () {
//                 setState(() {
//                   _digitalSelected = !_digitalSelected;
//                   // if (_digitalEnable) {
//                   //   if (_digitalSelected) {
//                   //     _productLoading = true;
//                   //     _digitalSelected = false;
//                   //     if (_prelovedSelected ||
//                   //         _digitalSelected ||
//                   //         _internationalSelected ||
//                   //         _localSelected) {
//                   //       _DashboardScreenBloc.subCatSelected = true;
//                   //     } else {
//                   //       _DashboardScreenBloc.subCatSelected = false;
//                   //     }
//                   //     _prelovedEnable = false;
//                   //     _digitalEnable = false;
//                   //     internationalEnable = false;
//                   //     _localEnable = false;
//                   //     _flashList.clear();
//                   //     _productList.clear();
//                   //
//                   //     _DashboardScreenBloc.pageCount = 0;
//                   //     _DashboardScreenBloc.productPageCount = 0;
//                   //
//                   //     _DashboardScreenBloc.add(NavigateToLoginScreenEvent());
//                   //     _flashPromoLoading = true;
//                   //     _DashboardScreenBloc.add(LoadListEvent());
//                   //   } else {
//                   //     _digitalSelected = true;
//                   //     _prelovedSelected = false;
//                   //     _productLoading = true;
//                   //     _localSelected = false;
//                   //
//                   //     _internationalSelected = false;
//                   //     _DashboardScreenBloc.subCatText = "Digital product";
//                   //     if (_prelovedSelected ||
//                   //         _digitalSelected ||
//                   //         _internationalSelected ||
//                   //         _localSelected) {
//                   //       _DashboardScreenBloc.subCatSelected = true;
//                   //     } else {
//                   //       _DashboardScreenBloc.subCatSelected = false;
//                   //     }
//                   //     _prelovedEnable = false;
//                   //     _digitalEnable = false;
//                   //     internationalEnable = false;
//                   //     _localEnable = false;
//                   //     _flashList.clear();
//                   //     _productList.clear();
//                   //
//                   //     _DashboardScreenBloc.pageCount = 0;
//                   //     _DashboardScreenBloc.productPageCount = 0;
//                   //
//                   //     _DashboardScreenBloc.add(NavigateToLoginScreenEvent());
//                   //     _flashPromoLoading = true;
//                   //
//                   //     _DashboardScreenBloc.add(LoadListEvent());
//                   //   }
//                   // }
//                 });
//               },
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: SizeConfig.heightMultiplier * 7.281205164992826,
//                     width: SizeConfig.widthMultiplier * 14.097222222222221,
//                     margin: EdgeInsets.only(
//                         left: SizeConfig.widthMultiplier * 4.861111111111111,
//                         top: SizeConfig.heightMultiplier * 1.2553802008608321),
//                     child: Card(
//                         elevation: 5,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(100),
//                         ),
//                         child: Container(
//                           height:
//                               SizeConfig.heightMultiplier * 4.017216642754663,
//                           width: SizeConfig.widthMultiplier * 7.777777777777777,
//                           margin: EdgeInsets.all(10),
//                           child: Image.asset(
//                             'assets/images/cloud.png',
//                             width:
//                                 SizeConfig.widthMultiplier * 7.777777777777777,
//                             height:
//                                 SizeConfig.heightMultiplier * 4.017216642754663,
//                             color: _digitalSelected
//                                 ? AppColors.app_orange
//                                 : AppColors.appBlue,
//                           ),
//                         )),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                         left: SizeConfig.widthMultiplier * 4.861111111111111),
//                     child: Text(_l10n.digital,
//                         style: GoogleFonts.inter(
//                             fontWeight: FontWeight.w400,
//                             fontSize:
//                                 SizeConfig.textMultiplier * 1.757532281205165,
//                             letterSpacing: 0.25)),
//                   ),
//                 ],
//               )),
//           InkWell(
//               onTap: () {
//                 setState(() {
//                   _internationalSelected = !_internationalSelected;
//                   _productList.clear();
//                   valueNotifier.value = _productList.length;
//                   _DashboardScreenBloc.client.clickOn(isInternational: true);
//                   _DashboardScreenBloc.add(LoadListEvent());
//                 });
//               },
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: SizeConfig.heightMultiplier * 7.281205164992826,
//                     width: SizeConfig.widthMultiplier * 14.097222222222221,
//                     margin: EdgeInsets.only(
//                         left: SizeConfig.widthMultiplier * 2.4305555555555554,
//                         top: SizeConfig.heightMultiplier * 1.2553802008608321),
//                     child: Card(
//                       elevation: 5,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(100),
//                       ),
//                       child: Container(
//                           height:
//                               SizeConfig.heightMultiplier * 4.017216642754663,
//                           width: SizeConfig.widthMultiplier * 7.777777777777777,
//                           margin: EdgeInsets.all(10),
//                           child: Image.asset(
//                             'assets/images/globe.png',
//                             width:
//                                 SizeConfig.widthMultiplier * 7.777777777777777,
//                             height:
//                                 SizeConfig.heightMultiplier * 4.017216642754663,
//                             color: _internationalSelected
//                                 ? AppColors.app_orange
//                                 : AppColors.appBlue,
//                           )),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                         left: SizeConfig.widthMultiplier * 2.4305555555555554),
//                     child: Text(_l10n.international,
//                         style: GoogleFonts.inter(
//                             fontWeight: FontWeight.w400,
//                             fontSize:
//                                 SizeConfig.textMultiplier * 1.757532281205165,
//                             letterSpacing: 0.25)),
//                   ),
//                 ],
//               )),
//           InkWell(
//               onTap: () {
//                 setState(() {
//                   _localSelected = !_localSelected;
//                   _productList.clear();
//                   valueNotifier.value = _productList.length;
//                   _DashboardScreenBloc.client.clickOn(isLocal: true);
//                   _DashboardScreenBloc.add(LoadListEvent());
//                 });
//               },
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: SizeConfig.heightMultiplier * 7.281205164992826,
//                     width: SizeConfig.widthMultiplier * 14.097222222222221,
//                     margin: EdgeInsets.only(
//                         left: SizeConfig.widthMultiplier * 2.4305555555555554,
//                         right: SizeConfig.widthMultiplier * 3.8888888888888884,
//                         top: SizeConfig.heightMultiplier * 1.2553802008608321),
//                     child: Card(
//                       elevation: 5,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(100),
//                       ),
//                       child: Container(
//                           height:
//                               SizeConfig.heightMultiplier * 4.017216642754663,
//                           width: SizeConfig.widthMultiplier * 7.777777777777777,
//                           margin: EdgeInsets.all(10),
//                           child: Image.asset(
//                             'assets/images/store.png',
//                             width:
//                                 SizeConfig.widthMultiplier * 7.777777777777777,
//                             height:
//                                 SizeConfig.heightMultiplier * 4.017216642754663,
//                             color: _localSelected
//                                 ? AppColors.app_orange
//                                 : AppColors.appBlue,
//                           )),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                         left: SizeConfig.widthMultiplier * 2.4305555555555554,
//                         right: SizeConfig.widthMultiplier * 3.8888888888888884),
//                     child: Text(_l10n.local,
//                         style: GoogleFonts.inter(
//                             fontWeight: FontWeight.w400,
//                             fontSize:
//                                 SizeConfig.textMultiplier * 1.757532281205165,
//                             letterSpacing: 0.25)),
//                   ),
//                 ],
//               )),
//         ],
//       ),
//     );
//   }
//
//   List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
//     List<DropdownMenuItem<String>> items = List();
//     for (String listItem in listItems) {
//       items.add(
//         DropdownMenuItem(
//           child: Text(
//             listItem,
//             style: GoogleFonts.inter(
//               textStyle: TextStyle(
//                   color: AppColors.catColor,
//                   letterSpacing: .25,
//                   fontWeight: FontWeight.w400,
//                   fontSize: SizeConfig.textMultiplier * 1.757532281205165),
//             ),
//           ),
//           value: listItem,
//         ),
//       );
//     }
//     return items;
//   }
//
//   // _showCategoriesDialog() {
//   //   Constants.selectedChoices.clear();
//   //   showDialog(
//   //       barrierDismissible: false,
//   //       context: context,
//   //       builder: (BuildContext context) {
//   //         //Here we will build the content of the dialog
//   //         return StatefulBuilder(builder: (context, setState) {
//   //           return AlertDialog(
//   //             title: Text("Categories"),
//   //             content: MultiSelectChip(_interestingItems),
//   //             actions: <Widget>[
//   //               GestureDetector(
//   //                 behavior: HitTestBehavior.translucent,
//   //                 onTap: () {
//   //                   _selectedCategories.addAll(Constants.selectedChoices);
//   //                   _DashboardScreenBloc.add(AddInterestedCategoriesEvent());
//   //                   _DashboardScreenBloc.add(NavigateToLoginScreenEvent());
//   //                   _DashboardScreenBloc.add(LoadListEvent());
//   //                   _DashboardScreenBloc.add(LoadBannerEvent());
//   //                   Navigator.pop(context);
//   //                   // Navigator.pop(context);
//   //                 },
//   //                 child: Container(
//   //                   width: MediaQuery.of(context).size.width,
//   //                   height: SizeConfig.heightMultiplier * 6.025824964131995,
//   //                   margin: EdgeInsets.only(
//   //                       top: SizeConfig.heightMultiplier * 2.5107604017216643,
//   //                       left: SizeConfig.widthMultiplier * 3.8888888888888884,
//   //                       right: SizeConfig.widthMultiplier * 3.8888888888888884),
//   //                   child: RaisedGradientButton(
//   //                     gradient: LinearGradient(
//   //                       colors: <Color>[
//   //                         AppColors.gradient_button_light,
//   //                         AppColors.gradient_button_dark,
//   //                       ],
//   //                     ),
//   //                     child: Padding(
//   //                         padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
//   //                         child: Text(
//   //                           'Add Categories',
//   //                           style: GoogleFonts.inter(
//   //                               color: AppColors.white,
//   //                               fontWeight: FontWeight.bold,
//   //                               fontSize: SizeConfig.textMultiplier *
//   //                                   1.757532281205165,
//   //                               letterSpacing: 0.5,
//   //                               textStyle: TextStyle(fontFamily: 'Roboto')),
//   //                         )),
//   //                   ),
//   //                 ),
//   //               ),
//   //             ],
//   //           );
//   //         });
//   //       });
//   // }
//
//   void _showToast(String msg) {
//     Fluttertoast.showToast(
//         msg: msg,
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         timeInSecForIosWeb: 1,
//         backgroundColor: AppColors.appBlue,
//         textColor: AppColors.white,
//         fontSize: SizeConfig.textMultiplier * 2.0086083213773316);
//   }
//
//   _showMoreCategoriesDialog() {
//     showDialog(
//         barrierDismissible: true,
//         context: context,
//         builder: (BuildContext context) {
//           //Here we will build the content of the dialog
//           return StatefulBuilder(builder: (context, setState) {
//             return AlertDialog(
//               title: Text("Categories"),
//               content: _moreCategories(context),
//               // actions: <Widget>[
//               //   GestureDetector(
//               //     behavior: HitTestBehavior.translucent,
//               //     onTap: () {
//               //       // _selectedMoreCategories.addAll(Constants.selectedChoices);
//               //       // _DashboardScreenBloc.add(NavigateToLoginScreenEvent());
//               //       // _DashboardScreenBloc.add(LoadListEvent());
//               //       Navigator.pop(context);
//               //       // Navigator.pop(context);
//               //     },
//               //     child: Container(
//               //       width: MediaQuery.of(context).size.width,
//               //       height: SizeConfig.heightMultiplier * 6.025824964131995,
//               //       margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 2.5107604017216643, left: SizeConfig.widthMultiplier * 3.8888888888888884, right: SizeConfig.widthMultiplier * 3.8888888888888884),
//               //       child: RaisedGradientButton(
//               //         gradient: LinearGradient(
//               //           colors: <Color>[
//               //             AppColors.gradient_button_light,
//               //             AppColors.gradient_button_dark,
//               //           ],
//               //         ),
//               //         child: Padding(
//               //             padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
//               //             child: Text(
//               //               'Add Categories',
//               //               style: GoogleFonts.inter(
//               //                   color: AppColors.white,
//               //                   fontWeight: FontWeight.bold,
//               //                   fontSize: SizeConfig.textMultiplier * 1.757532281205165,
//               //                   letterSpacing: 0.5,
//               //                   textStyle: TextStyle(fontFamily: 'Roboto')),
//               //             )),
//               //       ),
//               //     ),
//               //   ),
//               // ],
//             );
//           });
//         });
//   }
//
//   Widget _moreCategories(BuildContext context) {
//     String _value = "";
//     return Container(
//         width: MediaQuery.of(context).size.width * 0.7,
//         height: MediaQuery.of(context).size.width * 0.7,
//         child: GridView.count(
//             crossAxisCount: 3,
//             crossAxisSpacing: 2,
//             shrinkWrap: true,
//             padding: EdgeInsets.zero,
//             children: _categoriesItems
//                 .map((value) => Container(
//                       width: SizeConfig.widthMultiplier * 9.722222222222221,
//                       height: SizeConfig.heightMultiplier * 2.5107604017216643,
//                       child: ChoiceChip(
//                         label: Container(child: Text(value)),
//                         labelPadding: EdgeInsets.zero,
//                         selected: _value == value,
//                         onSelected: (bool selected) {
//                           setState(() {
//                             _tabSelected = true;
//                             _DashboardScreenBloc.categoryFilter = value;
//                             Navigator.pop(context);
//
//                             _prelovedSelected = false;
//                             _digitalSelected = false;
//                             _internationalSelected = false;
//                             _localSelected = false;
//                             _productLoading = true;
//                             _flashList.clear();
//                             _productList.clear();
//                             _DashboardScreenBloc.pageCount = 0;
//                             _DashboardScreenBloc.productPageCount = 0;
//                             _DashboardScreenBloc.subCatSelected = false;
//                             _DashboardScreenBloc.add(
//                                 NavigateToLoginScreenEvent());
//                             _flashPromoLoading = true;
//                             _DashboardScreenBloc.add(LoadListEvent());
//                           });
//                         },
//                       ),
//                     ))
//                 .toList()));
//   }
//
//   Widget _newCategoriesList() {
//     _secondaryCounter++;
//     List<String> _catList = List();
//     if (_showCatText == "Technology") {
//       _catList = _technologyItems;
//     } else if (_showCatText == "Men's Fashion") {
//       _catList = _mensFashionItems;
//     } else if (_showCatText == "Women's Fashion") {
//       _catList = _womensFashionItems;
//     } else if (_showCatText == "Her Accessories") {
//       _catList = _herAccessories;
//     } else if (_showCatText == "His Accessories") {
//       _catList = _hisAccessories;
//     } else if (_showCatText == "Office") {
//       _catList = _office;
//     } else if (_showCatText == "Sports") {
//       _catList = _sports;
//     } else if (_showCatText == "Home & Kitchen") {
//       _catList = _homeAndKitchenItems;
//     }
// //    return Container(
// //        height: SizeConfig.heightMultiplier * 5.0215208034433285,
// //        child: ListView(
// //          shrinkWrap: true,
// //          controller: _categoriesController,
// //          scrollDirection: Axis.horizontal,
// //          physics: BouncingScrollPhysics(),
// //          children: _catList.map((e) => _newCategoryTile(e)).toList(),
// //        ));
//
//     int _numSubCat = _catList.length;
//     _numRows = (_numSubCat / 5).ceil();
//
//     // if (_arrowUp && _tabController.index == 2) {
//     //   _rows.clear();
//     // } else {
//     //   _rows.clear();
//     // }
//     if (!_arrowUp) {
//       _rows.clear();
//     }
//
//     if (_rows.length > _catList.length) {
//       _rows.clear();
//     }
//
//     double _height =
//         SizeConfig.heightMultiplier * 30.903744619799141756971361172807;
//
//     if (_arrowUp) {
//       switch (_showCatText) {
//         case "Women's Fashion":
//           _height =
//               SizeConfig.heightMultiplier * 46.033715925394551383941528460774 +
//                   (SizeConfig.heightMultiplier *
//                           8.1599713055954096269701672879671 *
//                           (_numRows - 2))
//                       .toDouble();
//           break;
//         case "Men's Fashion":
//           _height =
//               SizeConfig.heightMultiplier * 34.403744619799141756971361172807 +
//                   (SizeConfig.heightMultiplier *
//                           8.1599713055954096269701672879671 *
//                           (_numRows - 2))
//                       .toDouble();
//           break;
//         default:
//           _height =
//               SizeConfig.heightMultiplier * 30.9037446197991417569713611728070;
//           break;
//       }
//     }
//
//     return Material(
//       elevation: 4.0,
//       child: Container(
//         child: Container(
//             height: _moreSubCategories
//                 ? _height
//                 : (_numRows > 1
//                     ? SizeConfig.heightMultiplier *
//                         31.903744619799141756971361172807
//                     : SizeConfig.heightMultiplier *
//                         17.802252510760403128788783246091),
//             width: MediaQuery.of(context).size.width,
//             color: Colors.white,
//             child: Wrap(
//               children: [
//                 Column(
//                     children: (_arrowUp && (_catList.contains(_l10n.More)))
//                         ? _rows
//                         : _subCatRows(_catList, _showCatText, 1, 2, _rows))
//               ],
//             )),
//       ),
//     );
// //
// //    return Container(
// //      height: 200,
// //      child:
// //    )
//   }
//
//   List<Container> _subCatRows(catList, showCatText, int initialRowIndex,
//       int maxRows, List<Container> rows) {
//     _counter++;
//
//     int _maxItemsPerRow = 5;
//     int _maxItemsInFinalRow = maxRows * _maxItemsPerRow;
//     int _maxItemsForRow;
//     GestureDetector _subCatOption;
//
//     for (int i = initialRowIndex; i <= maxRows; i++) {
//       _maxItemsForRow = i * _maxItemsPerRow;
//       Container row;
//       List<Widget> _rowOfCategories = [];
//       int _numSubCategoriesToCreate = (i == maxRows)
//           ? (catList.length < _maxItemsInFinalRow
//               ? catList.length
//               : _maxItemsInFinalRow)
//           : (catList.length < _maxItemsForRow
//               ? catList.length
//               : _maxItemsForRow);
//
//       int rowTracker = i - 1;
//       for (int j = rowTracker * _maxItemsPerRow;
//           j < _numSubCategoriesToCreate;
//           j++) {
//         if (catList[j] != "${_l10n.More}") {
//           String subCategoryImage = catList[j].replaceAll('\n', ' ');
//           String algoliaSubCategorySearchText;
//
//           switch (subCategoryImage) {
//             case "Comp Accs":
//               {
//                 algoliaSubCategorySearchText = "Computer_Accessories";
//               }
//               break;
//
//             case "Mobile Accs":
//               {
//                 algoliaSubCategorySearchText = "Mobile_Accessories";
//               }
//               break;
//
//             case "Car Accs":
//               {
//                 algoliaSubCategorySearchText = "Car_Accessories";
//               }
//               break;
//
//             case "Sleep wear":
//               {
//                 algoliaSubCategorySearchText = "Sleepwear";
//               }
//               break;
//
//             case "Sports wear":
//               {
//                 algoliaSubCategorySearchText = "Sportswear";
//               }
//               break;
//
//             case "Swim wear":
//               {
//                 algoliaSubCategorySearchText = "Swimwear";
//               }
//               break;
//
//             case "Under wear":
//               {
//                 algoliaSubCategorySearchText = "Underwear";
//               }
//               break;
//
//             case "Sun glasses":
//               {
//                 algoliaSubCategorySearchText = "Sunglasses";
//               }
//               break;
//
//             case "Hand bags":
//               {
//                 algoliaSubCategorySearchText = "Handbags";
//               }
//               break;
//
//             case "Kitchen ware":
//               {
//                 algoliaSubCategorySearchText = "Kitchenware";
//               }
//               break;
//
//             default:
//               {
//                 algoliaSubCategorySearchText = subCategoryImage;
//               }
//               break;
//           }
//
//           _subCatOption = GestureDetector(
//               onTap: () {
//                 setState(() {
//                   SubCategoryResultsModel _subCatModel =
//                       SubCategoryResultsRoute.subCategoryResultsModel;
//                   _subCatModel.category = _showCatText;
//                   _subCatModel.algoliaCategorySearch =
//                       _DashboardScreenBloc.categoryFilter;
//
//                   _subCatModel.selectedSubCategory = catList[j];
//                   _subCatModel.subCategories = catList;
//                   _subCatModel.algoliaSubCategorySearch =
//                       algoliaSubCategorySearchText;
//
//                   _newSubSelected = algoliaSubCategorySearchText;
// //                _prelovedSelected = false;
// //                _digitalSelected = false;
// //                _internationalSelected = false;
// //                _localSelected = false;
// //                _productLoading = true;
// //                _flashList.clear();
// //                _productList.clear();
// //                _DashboardScreenBloc.pageCount = 0;
// //                _DashboardScreenBloc.productPageCount = 0;
//                   _DashboardScreenBloc.subCatSelected = false;
//                   // _DashboardScreenBloc.categoryFilter = "Electronics";
// //                _tabSelected = true;
// //                _DashboardScreenBloc.newSubCategoryText = _newSubSelected;
// //                _DashboardScreenBloc.add(NavigateToLoginScreenEvent());
// //                _flashPromoLoading = true;
// //                _DashboardScreenBloc.add(LoadListEvent());
//                   // _showSubCat = true;
//                   // _showCatText = "Electronics";
//                 });
//
//                 RouterService.appRouter
//                     .navigateTo(SubCategoryResultsRoute.buildPath());
//               },
//               child: Column(
//                 children: [
//                   Container(
//                       margin: EdgeInsets.only(
//                           left: SizeConfig.widthMultiplier *
//                               4.0011111111111102671682098765434),
//                       height: SizeConfig.heightMultiplier *
//                           7.5322812051649935018186159581235,
//                       width: SizeConfig.widthMultiplier *
//                           14.58333333333333080150462962963,
//                       child: Image.asset(
//                           'assets/images/subcategories/${_showCatText}/${subCategoryImage}.jpg')
// //                  Image.asset('lib/FLsjEfdw.jpeg')
//                       ),
//                   Container(
//                     margin: EdgeInsets.only(
//                         left: SizeConfig.widthMultiplier *
//                             4.0011111111111102671682098765434,
//                         top: SizeConfig.widthMultiplier *
//                             1.2152777777777775667920524691358),
//                     child: Text(
//                       catList[j],
//                       style: GoogleFonts.inter(
//                         color: AppColors.black,
//                       ),
//                     ),
//                   ),
//                 ],
//               ));
//         } else if (catList[j] == "${_l10n.More}") {
//           _subCatOption = GestureDetector(
//               onTap: () {
//                 setState(() {
//                   if (_arrowUp == false) {
//                     _moreSubCategories = true;
//
//                     _rows.clear();
//
//                     _arrowPath = SvgPicture.asset(
//                         'assets/images/subcategories/arrowUp.svg');
//                     _rows =
//                         _subCatRows(catList, showCatText, 1, _numRows, _rows);
//
//                     _arrowUp = true;
//                   } else {
//                     _moreSubCategories = false;
//                     _arrowUp = false;
//                     _arrowPath = SvgPicture.asset(
//                         'assets/images/subcategories/arrowDown.svg');
//                   }
//                 });
//               },
//               child: Column(
//                 children: [
//                   Container(
//                       margin: EdgeInsets.only(
//                           left: SizeConfig.widthMultiplier *
//                               8.0208333333333319408275462962965,
//                           top: SizeConfig.widthMultiplier *
//                               4.1319444444444437270929783950619),
//                       height: SizeConfig.heightMultiplier *
//                           3.7661406025824967509093079790618,
//                       width: SizeConfig.widthMultiplier *
//                           7.291666666666665400752314814815,
//                       child: _arrowPath),
//                   Container(
//                     margin: EdgeInsets.only(
//                         left: SizeConfig.widthMultiplier *
//                             7.7777777777777764274691358024694,
//                         top: SizeConfig.widthMultiplier *
//                             4.374999999999999240451388888889),
//                     child: Text(
//                       catList[j],
//                       style: GoogleFonts.inter(
//                         color: AppColors.black,
//                       ),
//                     ),
//                   ),
//                 ],
//               ));
//         }
//
//         _rowOfCategories.add(_subCatOption);
//       }
//       row = Container(
//         margin: EdgeInsets.only(
//             top: SizeConfig.heightMultiplier *
//                 2.4305555555555551335841049382717),
//         child: Wrap(children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: _rowOfCategories,
//           ),
//         ]),
//       );
//       rows.add(row);
//     }
//     return rows;
//   }
//
//   Widget _newCategoryTile(String titleText) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _newSubSelected = titleText;
//           _prelovedSelected = false;
//           _digitalSelected = false;
//           _internationalSelected = false;
//           _localSelected = false;
//           _productLoading = true;
//           _flashList.clear();
//           _productList.clear();
//           _DashboardScreenBloc.pageCount = 0;
//           _DashboardScreenBloc.productPageCount = 0;
//           _DashboardScreenBloc.subCatSelected = false;
//           // _DashboardScreenBloc.categoryFilter = "Electronics";
//           _tabSelected = true;
//           _DashboardScreenBloc.newSubCategoryText = _newSubSelected;
//           _DashboardScreenBloc.add(NavigateToLoginScreenEvent());
//           _flashPromoLoading = true;
//           _DashboardScreenBloc.add(LoadListEvent());
//           // _showSubCat = true;
//           // _showCatText = "Electronics";
//         });
//       },
//       child: Container(
//         height: SizeConfig.heightMultiplier * 12.553802008608322,
//         width: SizeConfig.widthMultiplier * 24.305555555555554,
//         alignment: Alignment.center,
//         margin: EdgeInsets.only(
//             right: SizeConfig.widthMultiplier * 1.2152777777777777,
//             top: SizeConfig.heightMultiplier * 1.2553802008608321),
//         padding: EdgeInsets.only(
//             left: SizeConfig.widthMultiplier * 1.9444444444444442,
//             right: SizeConfig.widthMultiplier * 1.9444444444444442,
//             top: SizeConfig.heightMultiplier * 0.25107604017216645,
//             bottom: SizeConfig.heightMultiplier * 0.25107604017216645),
//         decoration: BoxDecoration(
//             border: Border.all(
//                 color: AppColors.seeAllText,
//                 width: SizeConfig.widthMultiplier * 0.24305555555555552),
//             shape: BoxShape.circle,
//             color: _newSubSelected == null
//                 ? AppColors.seeAllBack
//                 : _newSubSelected == titleText
//                     ? AppColors.appBlue
//                     : AppColors.seeAllBack),
//         child: Text(
//           titleText,
//           style: GoogleFonts.inter(
//             color: _newSubSelected == null
//                 ? AppColors.seeAllText
//                 : _newSubSelected == titleText
//                     ? AppColors.white
//                     : AppColors.seeAllText,
//             fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
// }
