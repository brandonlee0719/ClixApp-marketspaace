import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'dart:io';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/dropdownField.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/common/selling_item.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/model/product_model.dart';
import 'package:market_space/model/promo_model.dart';
import 'package:market_space/model/sell_item_req_model/sell_item_req_model.dart';
import 'package:market_space/sell_new_products/add_brand/seller_add_brand_route.dart';
import 'package:market_space/sell_new_products/sell_new_products_page_bloc.dart';
import 'package:market_space/sell_new_products/product_variation/seller_product_variation_route.dart';
import 'package:market_space/sell_new_products/sale_condition/sale_condition_route.dart';
import 'package:market_space/dashboard/dashboard_route.dart';
import 'package:market_space/routes/HomeScreenRoute.dart';
import 'package:market_space/sell_new_products/sell_new_product_l10n.dart';
import 'package:market_space/sell_new_products/sell_new_products_bloc.dart';
import 'package:market_space/sell_new_products/sell_new_products_route.dart';
import 'package:market_space/sell_new_products/sell_new_product_toolbar.dart';
import 'package:market_space/sell_new_products/tags/tags_route.dart';
import 'package:market_space/sell_new_products/upload_product_key/upload_product_key_route.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:market_space/common/loading_progress.dart';

class SellNewProductsScreen extends StatefulWidget {
  @override
  _SellNewProductsScreenState createState() => _SellNewProductsScreenState();
}

class _SellNewProductsScreenState extends State<SellNewProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  final SellNewProductsBloc _sellNewProductsBloc =
      SellNewProductsBloc(Initial());
  final _pageBloc = new SellerPageBloc(SellerPageState.initial);
  SellerSellingL10n _l10n = SellerSellingL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  final _productTypeKey = GlobalKey<ScaffoldState>();
  final _conditionKey = GlobalKey<ScaffoldState>();
  final _categoriesKey = GlobalKey<ScaffoldState>();
  final _subCategoriesKey = GlobalKey<ScaffoldState>();
  final _paymentCurrenciesKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  bool _resize = false;
  List<PromoModel> _promoList = List();
  bool _conditionTapped = false;
  OverlayEntry _overlayEntry;
  // OverlayEntry _conditionOverlayEntry;
  // OverlayEntry _productOverlayEntry;
  // OverlayEntry _subCatOverlayEntry;
  // OverlayEntry _handlingOverlayEntry;

  List<String> _dropdownItems;
  List<String> _categoriesItems;
  List<String> _paymentCurrencies;

  List<String> _booksItems;
  List<String> _filmsItems;
  List<String> _gamesItems;
  List<String> _artsItems;
  List<String> _softwareItems;
  List<String> _musicItems;
  List<String> _fashionItems;
  List<String> _beautyItems;
  List<String> _electronicsItems;
  List<String> _DIYItems;
  List<String> _homeItems;
  List<String> _toysItems;
  List<String> _sportingItems;
  List<String> _mensFashionItems;
  List<String> _womensFashionItems;
  List<String> _hisAccessories;
  List<String> _herAccessories;
  List<String> _homeAndKitchenItems;
  List<String> _sports;
  List<String> _office;
  List<String> _technologyItems;

  List<String> _conditionItems;
  List<String> _subCategoriesItems;
  List<String> _discountDropItems;
  List<String> _handlingTimeItems;

  String _productType;
  String _condition;
  String _paymentCurrency;
  String _fiatCurrency;

  String _selectedItem,
      _catSelected,
      _subCategories,
      _handlingSelected,
      _fileUrl;

  List<DropdownMenuItem<String>> _discountMenuItems;

  int page_number = 0;
  bool _mailCheck = false;
  bool _percentageCheck = false;
  bool _discountCheck = false;
  bool _priceCheck = false;
  bool _isUploading = false;
  String _buttonText = "NEXT";
  String _discountSelected;

  List<String> _courierDropItems;

  List<DropdownMenuItem<String>> _courierMenuItems;
  bool _freeShipping = false;
  List<String> _shippingDropItems = [
    "Standard",
    "Standard with tracking",
    "Express with tracking",
    "Express with insurance and tracking"
  ];

  List<String> _deliveryTimes = [
    "3 days",
    "1 week",
    "2 weeks",
    "3 weeks",
    "4 weeks",
    "5 weeks",
    "6 weeks"
  ];

  final _courierKey = GlobalKey<ScaffoldState>();
  final _shippingKey = GlobalKey<ScaffoldState>();
  final _handlingKey = GlobalKey<ScaffoldState>();

  List<String> _sellerHandlingTimes = [
    "< 1 hr",
    "12 hrs",
    "24 hrs",
    "2 Days",
    "3 Days",
    "5 Days"
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _productKeyController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _handlingController = TextEditingController();
  final TextEditingController _subCategoriesController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String _shippingSelected, _sellerHandlingTime, _selectedDeliveryTime;

  TextEditingController _lenghtController = TextEditingController();
  TextEditingController _widthController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _shippingPriceController = TextEditingController();
  TextEditingController _deliveryInfoController = TextEditingController();
  TextEditingController _courierController = TextEditingController();

  FocusNode _titleFocusNode = FocusNode();
  FocusNode _itemDescFocusNode = FocusNode();
  FocusNode _deliveryInfoFocusNode = FocusNode();
  FocusNode _productTypeFocusNode = FocusNode();
  FocusNode _priceFocusNode = FocusNode(),
      _desiredPaymentCurrencyFocusNode = FocusNode();
  FocusNode _paymentCurrenciesFocusNode = FocusNode();

  final FocusNode _courierServiceFocusNode = FocusNode();
  final FocusNode _shippingMethodFocusNode = FocusNode();
  final FocusNode _heightFocusNode = FocusNode();
  final FocusNode _weightFocusNode = FocusNode();
  final FocusNode _shippingPriceFocusNode = FocusNode();
  final FocusNode _sellerHandlingFocusNode = FocusNode();

  final Color background = AppColors.toolbarBlue;
  final Color fill = AppColors.lightgrey;

  @override
  void initState() {
    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = SellerSellingL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
        _fiatCurrency = "AUD";
      } else {
        _l10n = SellerSellingL10n(Locale.fromSubtags(languageCode: 'zh'));
        _fiatCurrency = "CNY";
      }

      _technologyItems = [
        "${_l10n.Mobile}",
        "${_l10n.Computer}",
        "${_l10n.Camera}",
        "${_l10n.Gaming}",
        "${_l10n.MobileAccessories}",
        "${_l10n.ComputerAccessories}",
        "${_l10n.CarAccessories}",
        "${_l10n.Watches}",
      ];

      _categoriesItems = [
        "${_l10n.Category} *",
        _l10n.womensFashion,
        _l10n.mensFashion,
        _l10n.herAccessories,
        _l10n.hisAccessories,
        _l10n.technology,
        _l10n.office,
        _l10n.sports,
        _l10n.homeAndKitchen
      ];

      _mensFashionItems = [
        "${_l10n.Tops}",
        "${_l10n.Jackets}",
        "${_l10n.Hoodies}",
        "${_l10n.Formal}",
        "${_l10n.Work}",
        "${_l10n.Sportwear}",
        "${_l10n.Swimwear}",
        "${_l10n.Underwear}",
        "${_l10n.Sleepwear}",
        "${_l10n.Jeans}",
        "${_l10n.Boots}",
        "${_l10n.Sneakers}",
      ];

      _womensFashionItems = [
        "${_l10n.Tops}",
        "${_l10n.Jackets}",
        "${_l10n.Hoodies}",
        "${_l10n.Dresses}",
        "${_l10n.ElegantDresses}",
        "${_l10n.Sleepwear}",
        "${_l10n.Sportwear}",
        "${_l10n.Swimwear}",
        "${_l10n.Boots}",
        "${_l10n.Heels}",
        "${_l10n.Sneakers}",
        "${_l10n.Flats}",
        "${_l10n.Sandals}",
        "${_l10n.Bottoms}",
        "${_l10n.Shorts}",
        "${_l10n.Underwear}"
      ];

      _homeAndKitchenItems = [
        "${_l10n.Laundry}",
        "${_l10n.Bedding}",
        "${_l10n.Bath}",
        "${_l10n.Dining}",
        "${_l10n.Outdoor}",
        "${_l10n.Storage}",
        "${_l10n.Kitchenware}",
        "${_l10n.Furniture}",
      ];

      _herAccessories = [
        "${_l10n.Watches}",
        "${_l10n.Purses}",
        "${_l10n.Jewellery}",
        "${_l10n.Hats}",
        "${_l10n.Belts}",
        "${_l10n.Sunglasses}",
        "${_l10n.Handbags}",
      ];

      _hisAccessories = [
        "${_l10n.Hats}",
        "${_l10n.Belts}",
        "${_l10n.Sunglasses}",
        "${_l10n.Ties}",
        "${_l10n.Wallets}"
      ];

      _office = ["${_l10n.Furniture}", "${_l10n.Chair}", "${_l10n.Desk}"];

      _sports = [
        "${_l10n.Clothing}",
        "${_l10n.Equipment}",
        "${_l10n.Shoes}",
        "${_l10n.Accessories}",
      ];

      _dropdownItems = [
        "${_l10n.Producttype} *",
        _l10n.Physicalgoods,
        // _l10n.Digitalgoods,
        // _l10n.Services
      ];
      _booksItems = [
        _l10n.Subcategories,
        _l10n.Fiction,
        _l10n.NonFiction,
        _l10n.Others
      ];
      _filmsItems = [
        "${_l10n.Subcategories} *",
        "DVDs & Blu-ray Discs",
        "${_l10n.Others}"
      ];

      _gamesItems = [
        "${_l10n.Subcategories} *",
        "Video ${_l10n.Games}",
        "Board ${_l10n.Games}",
        "${_l10n.Others}"
      ];

      _artsItems = [
        "${_l10n.Subcategories} *",
        "${_l10n.Art} Posters",
        "${_l10n.Others}"
      ];
      _softwareItems = [
        "${_l10n.Subcategories} *",
        "${_l10n.office}",
        "${_l10n.os}",
        "${_l10n.Others}"
      ];

      _musicItems = [
        _l10n.Music,
        "${_l10n.Music} ${_l10n.CDs}",
        "${_l10n.records}",
        "${_l10n.Others}"
      ];

      _fashionItems = [
        "${_l10n.Subcategories} *",
        "${_l10n.menClothing}",
        "${_l10n.menShoes}",
        "${_l10n.menAccessories}",
        "${_l10n.womenClothing}",
        "${_l10n.menClothing}",
        _l10n.womenBags,
        "${_l10n.womenAccessories}",
        "${_l10n.eyewear}",
        "${_l10n.Others}"
      ];

      _beautyItems = [
        "${_l10n.Subcategories} *",
        "${_l10n.maleFrag}",
        "${_l10n.womenFrag}",
        "${_l10n.unisexFrag}",
        "${_l10n.Others}"
      ];

      _electronicsItems = [
        "${_l10n.Subcategories} *",
        "${_l10n.parts}",
        "${_l10n.Accessories}",
        "${_l10n.Cables}",
        "${_l10n.Laptops}",
        "${_l10n.Desktop}",
        "${_l10n.mobile}",
        "${_l10n.kitchenElectronics}",
        "${_l10n.consumer}",
        "${_l10n.homeEnter}",
        "${_l10n.gamingConsole}",
        "${_l10n.Others}"
      ];
      _conditionItems = [
        "${_l10n.condition} *",
        "${_l10n.brandNew}",
        "${_l10n.Preloved}"
      ];

      _paymentCurrencies = ["AUD", "BTC", "ETH", "USDC"];

      _subCategoriesItems = [
        "${_l10n.Subcategories} *",
        "${_l10n.Software}",
        "${_l10n.Books}"
      ];

      _discountDropItems = ["${_l10n.select} *", "15%", "20%", "25%", "50%"];

      _DIYItems = [
        "${_l10n.Subcategories} *",
        _l10n.electricalSupplies,
        _l10n.doorHardware,
        _l10n.garage,
        _l10n.homeBuildingHardware,
        _l10n.FlooringTiles,
        _l10n.CabinetsCountertopsHardware,
        _l10n.Others
      ];

      _homeItems = [
        "${_l10n.Subcategories} *",
        _l10n.EquipmentTools,
        _l10n.Furniture,
        _l10n.Crafts,
        _l10n.BuildingMaterials,
        _l10n.Decor,
        _l10n.Others
      ];

      _toysItems = [
        "${_l10n.Subcategories} *",
        _l10n.BuildingToys,
        _l10n.ActionFigures,
        _l10n.Toys,
        _l10n.TVMovieCharacterToys,
        _l10n.Collectables,
        _l10n.OutdoorToys,
        _l10n.Puzzles,
        _l10n.DollsTeddyBears,
        _l10n.Others
      ];

      _discountDropItems = [
        "${_l10n.Subcategories} *",
        _l10n.CyclingEquipment,
        _l10n.FitnessRunningYogaEquipment,
        _l10n.CampingHikingEquipment,
        _l10n.GolfEquipmentGear,
        _l10n.FishingEquipmentSupplies,
        _l10n.HuntingEquipment,
        _l10n.SportsTradingCardsAccessories,
        _l10n.Boating,
        _l10n.SurfingEquipment,
        _l10n.AFLEquipment,
        _l10n.MartialArtsEquipment,
        _l10n.HorseRidingEquipment,
        _l10n.SkateboardingEquipment,
        _l10n.SoccerEquipment,
        _l10n.NRLEquipment,
        _l10n.SkiingSnowboardingEquipment,
        _l10n.Others
      ];

      _handlingTimeItems = [
        "${_l10n.HandlingTime} *",
        "${_l10n.Instant}",
        "< 1${_l10n.hour}",
        "12${_l10n.hour}",
        "24${_l10n.hour}"
      ];
    });

    _productTypeFocusNode.addListener(() {
      if (!_productTypeFocusNode.hasFocus) {
        setState(() {
          _productType = _productController.text;
          // print('this is the unfocussed value: ${_productType}');
        });
      }
    });

    // _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    // _categoriesdropdownMenuItems = buildDropDownMenuItems(_categoriesItems);
    // _conditiondropdownMenuItems = buildDropDownMenuItems(_conditionItems);
    // _subCategoriesdropdownMenuItems =
    //     buildDropDownMenuItems(_subCategoriesItems);
    // _handlingTimeMenuItems = buildDropDownMenuItems(_handlingTimeItems);
    _discountMenuItems = buildDropDownMenuItems(_discountDropItems);

    _selectedItem = _dropdownItems[0];
    // _catSelected = _categoriesItems[0];
//    _conditionSelected = _conditionItems[0];
    // _subCategories = _subCategoriesItems[0];
    // _handlingSelected = _handlingTimeItems[0];
    _discountSelected = _discountMenuItems[0].value;
    _checkCachedData();
    _sellNewProductsBloc.add(SellNewProductsScreenEvent());
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  // Widget _bottomSheet() {
  //   if (_resize) {
  //     return Container(height: 1.0);
  //   } else {
  //     _bottomButton();
  //   }
  // }

  _checkCachedData() {
//STEP 1 DATA
    _titleController.text = SellingItems.productTitle;
    _catSelected = SellingItems.category;
    if (_catSelected != null)
      _subCategoriesItems = _categorySubCategoryMap[_catSelected];
    _subCategories = SellingItems.subCategory;
    _descriptionController.text = SellingItems.description;
    _condition = SellingItems.condition;
//STEP 2 DATA
    _courierController.text = SellingItems.courierServices;
    // print("courierServicesCache ${SellingItems.courierServices}");
    _shippingSelected = SellingItems.shippingMethod;
    _sellerHandlingTime = SellingItems.handlingTime;
    _selectedDeliveryTime = SellingItems.deliveryTime;

    _freeShipping = SellingItems.freeShipping ?? false;
    _lenghtController.text = SellingItems.packageLength;
    _widthController.text = SellingItems.packageWidth;
    _heightController.text = SellingItems.packageHeight;
    _weightController.text = SellingItems.packageWeight;
    _shippingPriceController.text = SellingItems.estimatedShippingPrice;
    _deliveryInfoController.text = SellingItems.deliveryInfo;
//STEP 3 DATA
    _priceController.text = SellingItems.price;
    _paymentCurrency = SellingItems.paymentCurrency;
    _mailCheck = SellingItems.mailCheck ?? false;
  }

  _scrollToTheTopOfTheList() => _scrollController.animateTo(0,
      duration: Duration(milliseconds: 100), curve: Curves.easeOut);

  Map<String, List<String>> get _categorySubCategoryMap => {
        "${_l10n.womensFashion}": _womensFashionItems,
        "${_l10n.mensFashion}": _mensFashionItems,
        "${_l10n.hisAccessories}": _hisAccessories,
        "${_l10n.herAccessories}": _herAccessories,
        "${_l10n.technology}": _technologyItems,
        "${_l10n.office}": _office,
        "${_l10n.sports}": _sports,
        "${_l10n.homeAndKitchen}": _homeAndKitchenItems,
        "${_l10n.Electronics}": _electronicsItems,
        "${_l10n.HomeGarder}": _homeItems,
        "${_l10n.DIY}": _DIYItems,
        "${_l10n.Toys}": _toysItems,
        "${_l10n.Sportinggoods}": _sportingItems,
        "${_l10n.Others}": ["${_l10n.Subcategories} *", "${_l10n.Others}"]
      };

  _persistStepOneData() {
    SellingItems.productTitle = _titleController.text;
    SellingItems.category = _catSelected;
    SellingItems.subCategory = _subCategories;
    SellingItems.description = _descriptionController.text;
    SellingItems.productType = "Physical Good";
    SellingItems.condition = _condition;
  }

  _persistStepTwoData() {
    SellingItems.courierServices = _courierController.text;
    SellingItems.shippingMethod = _shippingSelected;
    SellingItems.handlingTime = _sellerHandlingTime;
    SellingItems.deliveryTime = _selectedDeliveryTime;

    SellingItems.freeShipping = _freeShipping;
    // print('freeShipping:' + _freeShipping.toString());
    SellingItems.packageLength = _lenghtController.text;
    SellingItems.packageWidth = _widthController.text;
    SellingItems.packageHeight = _heightController.text;
    SellingItems.packageWeight = _weightController.text;
    SellingItems.estimatedShippingPrice = _shippingPriceController.text;
    SellingItems.deliveryInfo = _deliveryInfoController.text;
  }

  _persistStepThreeData() {
    SellingItems.price = _priceController.text;
    SellingItems.paymentCurrency = _paymentCurrency;
    SellingItems.mailCheck = _mailCheck;
  }

  _persistAllData() {
    _persistStepOneData();
    _persistStepTwoData();
    _persistStepThreeData();
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

    final bottom = MediaQuery.of(context).viewInsets.bottom * 0.9;

    // print('how many times are we building when changing?');
    return WillPopScope(
      onWillPop: () async {
        _persistAllData();
        return true;
      },
      child: BlocProvider.value(
        value: _pageBloc,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: gradient,
                  stops: stops)),
          child: Scaffold(
            // resizeToAvoidBottomInset: false,
            // resizeToAvoidBottomPadding: false,
            bottomNavigationBar: !_isUploading
                ? Container(color: Colors.white, child: _bottomButton())
                : null,
            backgroundColor: Colors.transparent,
            appBar:
                SellingToolBar("Sell item", onBackButtonTap: _persistAllData),
            body: Container(
              color: AppColors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  BlocProvider(
                    create: (_) => _sellNewProductsBloc,
                    child:
                        BlocListener<SellNewProductsBloc, SellNewProductsState>(
                            listener: (context, state) {
                              if (state is Loading) {
                                setState(() {
                                  _isLoading = true;
                                });
                              }
                              if (state is Loaded) {
                                setState(() {
                                  _isLoading = false;
                                  _promoList = _sellNewProductsBloc.promoList;
                                  // _categoryList = _RecentlyBroughtBloc.categoryList;
                                });
                              }
                              if (state is ConfirmSellItemUploading) {
                                setState(() {
                                  _isUploading = true;
                                });
                              }
                              if (state is ConfirmSellItemSuccessful) {
                                setState(() {
                                  _isLoading = false;
                                  _isUploading = false;
                                  _showToast("Item saved successfully");
                                  RouterService.appRouter
                                      .navigateTo(HomeScreenRoute.buildPath());
                                  // _pageBloc.add(SellerPageEvent.toNextPage);
                                  // Navigator.pop(context);
                                });
                              }
                              if (state is ConfirmSellItemFailed) {
                                setState(() {
                                  _isLoading = false;
                                  _isUploading = false;
                                  _showToast(
                                      _sellNewProductsBloc.sellAPIStatus);
                                });
                              }

                              if (state is FileUploadSuccessful) {
                                setState(() {
                                  _fileUrl = _sellNewProductsBloc.url;
                                });
                                _showToast("File uploaded");
                              }
                              if (state is FileUploadFailed) {
                                _showToast("File upload failed");
                              }
                            },
                            child: _baseScreen()),
                  ),
                  if (_isUploading)
                    BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                        child: LoadingProgress(color: Colors.deepOrangeAccent)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _baseScreen() {
    // print('page number: ${page_number}');
    // print('pagebloc state: ${_pageBloc.state}');
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      controller: _scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.symmetric(vertical: 25),
      children: [
        if (_isLoading)
          Container(
              // alignment: Alignment.center,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.3),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                child: Lottie.asset(
                  'assets/loader/loader_blue1.json',
                  width: SizeConfig.widthMultiplier * 12.152777777777777,
                  height: SizeConfig.heightMultiplier * 6.276901004304161,
                  animate: true,
                ),
              )),

        // Container(child: Text('chi keung liu')),
        //   child:
        Builder(
          builder: (context) {
            SellerPageState state = context.watch<SellerPageBloc>().state;
            // print('state is ${state}');
            // print('pagebloc state ${_pageBloc.state}');
            if (state == SellerPageState.initial) {
              if (!_isLoading)
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              SizeConfig.widthMultiplier * 3.8888888888888884),
                      child: Text(
                        "Step 1/3",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize:
                                SizeConfig.textMultiplier * 2.259684361549498,
                            letterSpacing: 0.15,
                            color: AppColors.black),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              SizeConfig.widthMultiplier * 3.8888888888888884),
                      child: Text(
                        "Product pictures",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize:
                                SizeConfig.textMultiplier * 2.0086083213773316,
                            letterSpacing: 0.15,
                            color: AppColors.app_txt_color),
                      ),
                    ),
                    _productsView(),
                    _otherDetail()
                  ],
                );
              else {
                return Column(
                  children: [_productsView(), _otherDetail()],
                );
              }
            }
            // else if (state == SellerPageState.otherDetail) {
            //   _otherDetail();
            else if (state == SellerPageState.shippingScreen) {
              // UploadProductKeyRoute.sellerPageBloc = _pageBloc;
              // RouterService.appRouter
              //     .navigateTo(UploadProductKeyRoute.buildPath());
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        SizeConfig.widthMultiplier * 3.8888888888888884),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Step 2/3",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize:
                              SizeConfig.textMultiplier * 2.259684361549498,
                          letterSpacing: 0.15,
                          color: AppColors.black),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Shipping information",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize:
                              SizeConfig.textMultiplier * 2.0086083213773316,
                          letterSpacing: 0.15,
                          color: AppColors.app_txt_color),
                    ),
                    _uploadKeyScreen(),
                  ],
                ),
              );
            } else if (state == SellerPageState.advanceSetting) {
              return _advanceSetting();
            } else if (state == SellerPageState.sellingPage2) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            SizeConfig.widthMultiplier * 3.8888888888888884),
                    child: Text(
                      "Step 3/3",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize:
                              SizeConfig.textMultiplier * 2.259684361549498,
                          letterSpacing: 0.15,
                          color: AppColors.black),
                    ),
                  ),
                  SizedBox(height: 20),
                  _sellingPage2()
                ],
              );
            }
            return Column(children: [_productsView(), _otherDetail()]);
            //     return Text('chi keung liu');
          },
        ),
        // )
        // if (page_number == 0) _productsView(),
        // if (page_number == 0) _otherDetail(),
        // // if (page_number == 2) _sellingPage3(),
        // if (page_number == 1) _advanceSetting(),
        // // if (page_number == 2) _advanceSettings1(),
        // if (page_number == 2) _sellingPage2(),
      ],
    );
  }

  Widget _productsView() {
    // print('products view hit');
    return InkWell(
      onTap: () {
        setState(() {
          _overlayEntry.remove();
          _overlayEntry = null;
          // _categoryOverlayEntry.remove();
          // _conditionOverlayEntry.remove();
          // _handlingOverlayEntry.remove();
          // _productOverlayEntry.remove();
          // _subCatOverlayEntry.remove();
        });
      },
      child: Container(
          height: 100,
          margin: EdgeInsets.only(top: 40.0),
          alignment: Alignment.topLeft,
          child: _isLoading
              ? Lottie.asset(
                  'assets/loader/loader_blue1.json',
                  width: SizeConfig.widthMultiplier * 12.152777777777777,
                  height: SizeConfig.heightMultiplier * 6.276901004304161,
                  animate: true,
                )
              : Container(
                  child: ListView(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              SizeConfig.widthMultiplier * 3.8888888888888884),
                      children: _generateAllProductCards(context)))
          // : Container(
          //     height: SizeConfig.heightMultiplier * 22.59684361549498,
          //     child: Image.asset('assets/images/empty_box.png'),
          //   ),
          ),
    );
  }

  List<Widget> _generateAllProductCards(BuildContext context) {
    List<Widget> imageCardCarousel =
        SellingItems.productImages?.map((e) => _productCardItem(e))?.toList();
    int numberOfCardsCreated = imageCardCarousel.length;
    int totalCardsToBeCreated = 4;
    int remainingCards = totalCardsToBeCreated - numberOfCardsCreated;

    _sellNewProductsBloc.imageArray = SellingItems.productImages;

    for (int i = 0; i < remainingCards; i++) {
      imageCardCarousel.add(Container(
          height: 600.0,
          width: 100.0,
          margin: EdgeInsets.only(left: 10.0),
          padding: EdgeInsets.only(left: 5.0),
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              if (Platform.isAndroid)
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.camera_alt_rounded),
                            title: Text('Take photo'),
                            onTap: () {
                              _sellNewProductsBloc.add(AddFromCameraEvent());
                              if (_sellNewProductsBloc.state ==
                                  CameraUploadSuccessful()) {
                                setState(() {
                                  SellingItems.productImages =
                                      _sellNewProductsBloc.imageArray;
                                });
                              }
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                              leading: Icon(Icons.camera),
                              title: Text('Choose from gallery'),
                              onTap: () {
                                _sellNewProductsBloc.add(UploadFileEvent());
                                if (_sellNewProductsBloc.state ==
                                    FileUploadSuccessful()) {
                                  setState(() {
                                    SellingItems.productImages =
                                        _sellNewProductsBloc.imageArray;
                                  });
                                }
                                Navigator.pop(context);
                              }),
                        ],
                      );
                    });
              else
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => CupertinoActionSheet(
                    actions: [
                      CupertinoActionSheetAction(
                        child: const Text('Take photo'),
                        onPressed: () {
                          _sellNewProductsBloc.add(AddFromCameraEvent());
                          if (_sellNewProductsBloc.state ==
                              CameraUploadSuccessful()) {
                            setState(() {
                              SellingItems.productImages =
                                  _sellNewProductsBloc.imageArray;
                            });
                          }
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoActionSheetAction(
                        child: const Text('Choose from gallery'),
                        onPressed: () {
                          _sellNewProductsBloc.add(UploadFileEvent());
                          if (_sellNewProductsBloc.state ==
                              FileUploadSuccessful()) {
                            setState(() {
                              SellingItems.productImages =
                                  _sellNewProductsBloc.imageArray;
                            });
                          }
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                );
            },
            child: Container(
                decoration: BoxDecoration(
                    color: AppColors.imageCardBlue,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Image.asset('assets/images/add.png',
                    width: 30, height: 30)),
          )));
    }
    return imageCardCarousel;
  }

  Widget _productCardItem(File model) {
    return Container(
        height: 600,
        width: 100,
        // margin: EdgeInsets.only(
        //     left: SizeConfig.widthMultiplier * 1.9444444444444442),
        // color: AppColors.imageCardBlue,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Image.file(
                  model != null
                      ? model
                      : 'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg',
                  alignment: Alignment.topLeft,
                ),
                Positioned(
                  left: 65,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        SellingItems.productImages.remove(model);
                      });
                    },
                    child: Image.asset("assets/images/bin.png",
                        width: 30, height: 30),
                  ),
                ),
              ],
            )));
    // decoration: BoxDecoration(
    //     color: AppColors.imageCardBlue,
    //     image: DecorationImage(
    //       image: FileImage(model != null
    //           ? model
    //           : 'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg'),
    //     ),
    //     border: Border.all(color: AppColors.imageCardBlue, width: 2),
    //     borderRadius: BorderRadius.circular(12)));
    // child: ClipRRect(
    //     borderRadius: BorderRadius.circular(10),
    //     child: Image.file(model != null
    //         ? model
    //         : 'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg')));
    //       placeholder: (context, url) =>
    //           Lottie.asset('assets/loader/image_loading.json'),
    //       errorWidget: (context, url, error) => Icon(Icons.error),
    //       fit: BoxFit.cover,
    //       imageBuilder: (context, imageProvider) => Container(
    //             decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(10),
    // color: AppColors.toolbarBlue,
    //                 image: DecorationImage(
    //                     image: imageProvider, fit: BoxFit.cover)),
    //             height: SizeConfig.heightMultiplier * 10.54519368723099,
    //             width: SizeConfig.widthMultiplier * 20.416666666666664,
    //           )),
    // ));
  }

  Widget _otherDetail() {
    _selectedItem = _l10n.Physicalgoods;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.widthMultiplier * 3.8888888888888884),
      child: Column(
        children: [
          // Container(
          //   margin: EdgeInsets.only(
          //       top: SizeConfig.heightMultiplier * 3.0129124820659974,
          //       left: SizeConfig.widthMultiplier * 3.8888888888888884,
          //       right: SizeConfig.widthMultiplier * 3.8888888888888884),
          //   height: SizeConfig.heightMultiplier * 5.523672883787662,
          //   width: MediaQuery.of(context).size.width,
          //   child: Theme(
          //     data: ThemeData(
          //       primaryColor: AppColors.appBlue,
          //       primaryColorDark: AppColors.appBlue,
          //     ),
          //     child: TextField(
          //       keyboardType: TextInputType.phone,
          //       key: _productTypeKey,
          //       controller: _productController,
          //       focusNode: _productTypeFocusNode,
          //       enabled: _overlayEntry == null ? true : false,
          //       readOnly: true,
          //       showCursor: false,
          //       onTap: () {
          //         _titleFocusNode.unfocus();
          //         _itemDescFocusNode.unfocus();
          //         setState(() {
          //           this._overlayEntry = this._createOverlayEntry(
          //               _dropdownItems, _productTypeKey, _productController);
          //           Overlay.of(context).insert(this._overlayEntry);
          //           _selectedItem = _productController.text;
          //          });
          //       },
          //       style: GoogleFonts.inter(
          //           fontWeight: FontWeight.w400,
          //           fontSize: SizeConfig.textMultiplier * 1.757532281205165,
          //           letterSpacing: 0.1,
          //           color: AppColors.app_txt_color),
          //       decoration: InputDecoration(
          //           suffixIcon: Icon(Icons.keyboard_arrow_down),
          //           border: OutlineInputBorder(
          //               borderSide: BorderSide(
          //                   color: AppColors.appBlue,
          //                   width: SizeConfig.widthMultiplier *
          //                       0.12152777777777776),
          //               borderRadius: BorderRadius.circular(10.0)),
          //           contentPadding: EdgeInsets.only(
          //               left: SizeConfig.widthMultiplier * 3.8888888888888884),
          //           hintText: '${_l10n.Producttype} *',
          //           suffixStyle: const TextStyle(color: AppColors.appBlue)),
          //     ),
          //   ),
          // ),
          Container(
            margin: EdgeInsets.symmetric(
                vertical: SizeConfig.heightMultiplier * 1.5043041606886658),
            child: Theme(
              data: ThemeData(
                primaryColor: AppColors.appBlue,
                primaryColorDark: AppColors.appBlue,
              ),
              child: TextField(
                focusNode: _titleFocusNode,
                controller: _titleController,
                style: GoogleFonts.inter(
                  color: AppColors.text_field_color,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.25,
                ),
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: AppColors.text_field_color,
                            width: SizeConfig.widthMultiplier *
                                0.12152777777777776),
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText: '${_l10n.Title} *',
                    labelText: '${_l10n.Title} *',
                    contentPadding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884),
                    suffixStyle: const TextStyle(color: AppColors.appBlue)),
              ),
            ),
          ),

          /*if (!_conditionTapped)
            GestureDetector(
              onTap: () {
                setState(() {
                  _conditionTapped = true;
                });
              },
              child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 1.0043041606886658, left: SizeConfig.widthMultiplier * 3.8888888888888884, right: SizeConfig.widthMultiplier * 3.8888888888888884),
                  height: SizeConfig.heightMultiplier * 5.523672883787662,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: SizeConfig.widthMultiplier * 2.9166666666666665, right: SizeConfig.widthMultiplier * 2.9166666666666665),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border:
                          Border.all(color: AppColors.text_field_container)),
                  child: Container(
                      margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 1.2152777777777777, top: SizeConfig.heightMultiplier * 0.6276901004304161),
                      child: Row(
                        children: [
                          Text(
                            _conditionSelected,
                            style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                                color: AppColors.text_field_container),
                          ),
                          Spacer(),
                          Container(
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.text_field_container,
                            ),
                          )
                        ],
                      ))),
            ),
          if (_conditionTapped)
            Container(
                margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 1.0043041606886658, left: SizeConfig.widthMultiplier * 3.8888888888888884, right: SizeConfig.widthMultiplier * 3.8888888888888884),
                height: _conditionTapped ? 100 : 44,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: SizeConfig.widthMultiplier * 2.9166666666666665, right: SizeConfig.widthMultiplier * 2.9166666666666665),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AppColors.text_field_container)),
                child: ListView(
                  children: _conditionItems
                      .map((e) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _conditionTapped = false;
                              _conditionSelected = e;
                            });
                          },
                          child: Container(
                                margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 1.2152777777777777, top: SizeConfig.heightMultiplier * 0.6276901004304161),
                                child: Text(
                                  e,
                                  style: GoogleFonts.inter(
                                      fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                                      color: AppColors.text_field_container),
                                ),
                              ),))
                      .toList(),
                )),
*/
          DropdownField<String>(
            bottomMargin: SizeConfig.heightMultiplier * 1.5043041606886658,
            dropdownItems: (_conditionItems ?? [])
                .map(
                  (e) => DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  ),
                )
                .toList(),
            hintText: '${_l10n.condition} *',
            value: _condition,
            onChanged: (val) => setState(() => _condition = val),
          ),

          DropdownField<String>(
            bottomMargin: SizeConfig.heightMultiplier * 1.5043041606886658,
            dropdownItems: (_categoriesItems ?? [])
                .map(
                  (e) => DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  ),
                )
                .toList(),
            hintText: '${_l10n.Category} *',
            value: _catSelected,
            onChanged: (val) => setState(() => _catSelected = val),
          ),

          DropdownField<String>(
            bottomMargin: SizeConfig.heightMultiplier * 1.5043041606886658,
            dropdownItems: _catSelected != null &&
                    _categorySubCategoryMap.containsKey(_catSelected)
                ? _categorySubCategoryMap[_catSelected]
                    .map(
                      (e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      ),
                    )
                    .toList()
                : null,
            hintText: '${_l10n.Subcategories} *',
            value: _catSelected != null &&
                    _categorySubCategoryMap.containsKey(_catSelected) &&
                    _categorySubCategoryMap[_catSelected]
                        .contains(_subCategories)
                ? _subCategories
                : null,
            onChanged: (val) => setState(() => _subCategories = val),
          ),

          /*Container(
            margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 1.0043041606886658, left: SizeConfig.widthMultiplier * 3.8888888888888884, right: SizeConfig.widthMultiplier * 3.8888888888888884),
            height: SizeConfig.heightMultiplier * 5.523672883787662,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: SizeConfig.widthMultiplier * 2.9166666666666665, right: SizeConfig.widthMultiplier * 2.9166666666666665),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: AppColors.text_field_container)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  value: _catSelected,
                  items: _categoriesdropdownMenuItems,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.text_field_container,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _catSelected = value;
                      if (value == "${_l10n.Books}") {
                        _subCategoriesdropdownMenuItems.clear();
                        _subCategoriesdropdownMenuItems =
                            buildDropDownMenuItems(_booksItems);
                        _subCategories =
                            _subCategoriesdropdownMenuItems[0].value;
                      }
                      if (value == "${_l10n.Films}") {
                        _subCategoriesdropdownMenuItems.clear();
                        _subCategoriesdropdownMenuItems =
                            buildDropDownMenuItems(_filmsItems);
                        _subCategories =
                            _subCategoriesdropdownMenuItems[0].value;
                      }
                      if (value == "${_l10n.Games}") {
                        _subCategoriesdropdownMenuItems.clear();
                        _subCategoriesdropdownMenuItems =
                            buildDropDownMenuItems(_gamesItems);
                        _subCategories =
                            _subCategoriesdropdownMenuItems[0].value;
                      }
                      if (value == "${_l10n.Art}") {
                        _subCategoriesdropdownMenuItems.clear();
                        _subCategoriesdropdownMenuItems =
                            buildDropDownMenuItems(_artsItems);
                        _subCategories =
                            _subCategoriesdropdownMenuItems[0].value;
                      }
                      if (value == "${_l10n.Software}") {
                        _subCategoriesdropdownMenuItems.clear();
                        _subCategoriesdropdownMenuItems =
                            buildDropDownMenuItems(_softwareItems);
                        _subCategories =
                            _subCategoriesdropdownMenuItems[0].value;
                      }
                      if (value == "${_l10n.Music}") {
                        _subCategoriesdropdownMenuItems.clear();
                        _subCategoriesdropdownMenuItems =
                            buildDropDownMenuItems(_musicItems);
                        _subCategories =
                            _subCategoriesdropdownMenuItems[0].value;
                      }
                      if (value == "${_l10n.Fashion}") {
                        _subCategoriesdropdownMenuItems.clear();
                        _subCategoriesdropdownMenuItems =
                            buildDropDownMenuItems(_fashionItems);
                        _subCategories =
                            _subCategoriesdropdownMenuItems[0].value;
                      }
                      if (value == "${_l10n.Beauty}") {
                        _subCategoriesdropdownMenuItems.clear();
                        _subCategoriesdropdownMenuItems =
                            buildDropDownMenuItems(_beautyItems);
                        _subCategories =
                            _subCategoriesdropdownMenuItems[0].value;
                      }
                      if (value == "${_l10n.Electronics}") {
                        _subCategoriesdropdownMenuItems.clear();
                        _subCategoriesdropdownMenuItems =
                            buildDropDownMenuItems(_electronicsItems);
                        _subCategories =
                            _subCategoriesdropdownMenuItems[0].value;
                      }
                      if (value == "${_l10n.HomeGarder}") {
                        _subCategoriesdropdownMenuItems.clear();
                        _subCategoriesdropdownMenuItems =
                            buildDropDownMenuItems(_homeItems);
                        _subCategories =
                            _subCategoriesdropdownMenuItems[0].value;
                      }
                      if (value == "${_l10n.DIY}") {
                        _subCategoriesdropdownMenuItems.clear();
                        _subCategoriesdropdownMenuItems =
                            buildDropDownMenuItems(_DIYItems);
                        _subCategories =
                            _subCategoriesdropdownMenuItems[0].value;
                      }
                      if (value == "${_l10n.Toys}") {
                        _subCategoriesdropdownMenuItems.clear();
                        _subCategoriesdropdownMenuItems =
                            buildDropDownMenuItems(_toysItems);
                        _subCategories =
                            _subCategoriesdropdownMenuItems[0].value;
                      }
                      if (value == "${_l10n.Sportinggoods}") {
                        _subCategoriesdropdownMenuItems.clear();
                        _subCategoriesdropdownMenuItems =
                            buildDropDownMenuItems(_sportingItems);
                        _subCategories =
                            _subCategoriesdropdownMenuItems[0].value;
                      }
                      if (value == "${_l10n.Others}") {
                        _subCategoriesdropdownMenuItems.clear();
                        List<String> _other = [
                          "${_l10n.Subcategories} *",
                          "${_l10n.Others}"
                        ];
                        _subCategoriesdropdownMenuItems =
                            buildDropDownMenuItems(_other);
                        _subCategories =
                            _subCategoriesdropdownMenuItems[0].value;
                      }
                    });
                  }),
            ),
          ),*/

          Container(
            margin: EdgeInsets.only(
              bottom: SizeConfig.heightMultiplier * 1.5043041606886658,
            ),
            child: Theme(
              data: ThemeData(
                primaryColor: AppColors.appBlue,
                primaryColorDark: AppColors.appBlue,
              ),
              child: TextField(
                textInputAction: TextInputAction.done,
                maxLines: 6,
                minLines: 4,
                focusNode: _itemDescFocusNode,
                controller: _descriptionController,
                textAlign: TextAlign.start,
                style: GoogleFonts.inter(
                  color: AppColors.text_field_color,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.25,
                ),
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide:
                            new BorderSide(color: AppColors.text_field_color),
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText: '${_l10n.itemDesc} *',
                    labelText: '${_l10n.itemDesc} *',
                    contentPadding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                        top: SizeConfig.heightMultiplier * 1.2553802008608321),
                    suffixStyle: const TextStyle(color: AppColors.appBlue)),
              ),
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     _pageBloc.add(SellerPageEvent.toNextPage);
          //   },
          //   child: Container(
          //       height: SizeConfig.heightMultiplier * 5.523672883787662,
          //       margin: EdgeInsets.only(
          //           left: SizeConfig.widthMultiplier * 3.8888888888888884,
          //           right: SizeConfig.widthMultiplier * 3.8888888888888884,
          //           top: SizeConfig.heightMultiplier * 1.0043041606886658),
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(10),
          //           border: Border.all(color: AppColors.text_field_container)),
          //       child: Row(
          //         children: [
          //           Container(
          //             margin: EdgeInsets.only(
          //               left: SizeConfig.widthMultiplier * 3.8888888888888884,
          //             ),
          //             child: Text(
          //               _selectedItem == "Physical Good"
          //                   ? "Shipping Information *"
          //                   : _selectedItem == "Digital product"
          //                       ? "Product key or file *"
          //                       : _selectedItem == "Services"
          //                           ? "Delivery information *"
          //                           : 'Shipping or product key or file *',
          //               style: GoogleFonts.inter(
          //                   fontSize:
          //                       SizeConfig.textMultiplier * 1.757532281205165,
          //                   fontWeight: FontWeight.w400,
          //                   color: AppColors.text_field_container),
          //             ),
          //           ),
          //           Spacer(),
          //           Container(
          //               margin: EdgeInsets.only(
          //                 right:
          //                     SizeConfig.widthMultiplier * 3.8888888888888884,
          //               ),
          //               child: Icon(
          //                 Icons.chevron_right,
          //                 size: 14,
          //                 color: AppColors.text_field_color,
          //               ))
          //         ],
          //       )),
          // ),

          GestureDetector(
            onTap: () {
              // BlocProvider.of<SellerPageBloc>(context, listen: false)
              //     .add(SellerPageEvent.loadAdvancedSetting);
              _pageBloc.add(SellerPageEvent.loadAdvancedSetting);
              // RouterService.appRouter.navigateTo(TagsRoute.buildPath());
            },
            child: Container(
                height: SizeConfig.heightMultiplier * 5.523672883787662,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.text_field_container)),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      ),
                      child: Text(
                        'Brand, sale conditions and quantities',
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    Spacer(),
                    Container(
                        margin: EdgeInsets.only(
                          right:
                              SizeConfig.widthMultiplier * 3.8888888888888884,
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          size: 14,
                          color: AppColors.text_field_color,
                        ))
                  ],
                )),
          ),

          // GestureDetector(
          //   onTap: () {
          //     RouterService.appRouter.navigateTo(TagsRoute.buildPath());
          //   },
          //   child: Container(
          //       height: SizeConfig.heightMultiplier * 5.523672883787662,
          //       margin: EdgeInsets.only(
          //           left: SizeConfig.widthMultiplier * 3.8888888888888884,
          //           right: SizeConfig.widthMultiplier * 3.8888888888888884,
          //           top: SizeConfig.heightMultiplier * 1.0043041606886658,
          //           bottom: SizeConfig.heightMultiplier * 12.553802008608322),
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(10),
          //           border: Border.all(color: AppColors.text_field_container)),
          //       child: Row(
          //         children: [
          //           Container(
          //             margin: EdgeInsets.only(
          //               left: SizeConfig.widthMultiplier * 3.8888888888888884,
          //             ),
          //             child: Text(
          //               '${_l10n.Tags} (Max 10 chars)',
          //               style: GoogleFonts.inter(
          //                   fontSize:
          //                       SizeConfig.textMultiplier * 1.757532281205165,
          //                   fontWeight: FontWeight.w400,
          //                   color: AppColors.text_field_container),
          //             ),
          //           ),
          //           Spacer(),
          //           Container(
          //               margin: EdgeInsets.only(
          //                 right:
          //                     SizeConfig.widthMultiplier * 3.8888888888888884,
          //               ),
          //               child: Icon(
          //                 Icons.chevron_right,
          //                 size: 14,
          //                 color: AppColors.text_field_color,
          //               ))
          //         ],
          //       )),
          // ),
          // Container(
          //   height: SizeConfig.heightMultiplier * 6.025824964131995,
          //   margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 3.89167862266858, right: SizeConfig.widthMultiplier * 3.8888888888888884, left: SizeConfig.widthMultiplier * 3.8888888888888884),
          //   child: RaisedGradientButton(
          //     gradient: LinearGradient(
          //       colors: <Color>[
          //         AppColors.gradient_button_light,
          //         AppColors.gradient_button_dark,
          //       ],
          //     ),
          //     child: Padding(
          //         padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          //         child: Text(
          //           'NEXT',
          //           style: GoogleFonts.inter(
          //               color: AppColors.white,
          //               fontWeight: FontWeight.bold,
          //               fontSize: SizeConfig.textMultiplier * 1.757532281205165,
          //               letterSpacing: 0.5,
          //               textStyle: TextStyle(fontFamily: 'Roboto')),
          //         )),
          //     onPressed: () {},
          //   ),
          // ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(
            listItem,
            style: TextStyle(color: AppColors.text_field_container),
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  Widget _sellingPage2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              bottom: SizeConfig.heightMultiplier * 1.0043041606886658,
              top: SizeConfig.heightMultiplier * 2.0086083213773316),
          child: Text(_l10n.Pricing,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                  letterSpacing: 0.15,
                  color: AppColors.app_txt_color)),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 1.0043041606886658,
              bottom: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.text_field_container)),
          child: Row(
            children: [
              Theme(
                data: ThemeData(
                  primaryColor: AppColors.appBlue,
                  primaryColorDark: AppColors.appBlue,
                ),
                child: Expanded(
                  child: TextField(
                    textAlign: TextAlign.start,
                    focusNode: _priceFocusNode,
                    controller: _priceController,
                    style: GoogleFonts.inter(
                      color: AppColors.text_field_color,
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      letterSpacing: 0.25,
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: new InputDecoration(
                        hintText: '${_l10n.Price} *',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 3.8888888888888884,
                        ),
                        suffixStyle: const TextStyle(color: AppColors.appBlue)),
                  ),
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                ),
                child: Text(
                  _fiatCurrency ?? '',
                  style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      fontWeight: FontWeight.w400,
                      color: AppColors.text_field_container),
                ),
              ),
            ],
          ),
        ),

        DropdownField<String>(
          bottomMargin: 16,
          leftMargin: SizeConfig.widthMultiplier * 3.8888888888888884,
          rightMargin: SizeConfig.widthMultiplier * 3.8888888888888884,
          focusNode: _desiredPaymentCurrencyFocusNode,
          onTap: () => _priceFocusNode.unfocus(),
          dropdownItems: (_paymentCurrencies ?? [])
              .map(
                (e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ),
              )
              .toList(),
          hintText: 'Desired payment currency *',
          value: _paymentCurrency,
          onChanged: (val) => setState(() => _paymentCurrency = val),
        ),

        Container(
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              bottom: SizeConfig.heightMultiplier * 1.0043041606886658,
              top: SizeConfig.heightMultiplier * 2.0086083213773316),
          child: Text(_l10n.earningPerItemSold,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                  letterSpacing: 0.15,
                  color: AppColors.app_txt_color)),
        ),
        _earningsPerItem(),
        Container(
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 3.0129124820659974,
              right: SizeConfig.widthMultiplier * 3.8888888888888884),
          child: Text(
            '${_l10n.mktSpaceSalePer}(3%)*',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: SizeConfig.textMultiplier * 1.757532281205165,
              letterSpacing: 0.15,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 0.5021520803443329,
              right: SizeConfig.widthMultiplier * 3.8888888888888884),
          child: Text(
            'Market Spaace charges a small sales and transaction fee per item sold. There are no other charges when selling an item.',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                letterSpacing: 0.4,
                color: AppColors.catTextColor),
          ),
        ),
        // Container(
        //   margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884, top: SizeConfig.heightMultiplier * 3.0129124820659974, right: SizeConfig.widthMultiplier * 3.8888888888888884),
        //   child: Text(
        //     'Network fee*',
        //     style: GoogleFonts.inter(
        //       fontWeight: FontWeight.w700,
        //       fontSize: SizeConfig.textMultiplier * 1.757532281205165,
        //       letterSpacing: 0.15,
        //     ),
        //   ),
        // ),
        // Container(
        //   margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884, top: SizeConfig.heightMultiplier * 0.5021520803443329, right: SizeConfig.widthMultiplier * 3.8888888888888884),
        //   child: Text(
        //     'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In amet, id nullam et, nibh. Aliquam nulla eget sit faucibus sollicitudin enim lacus semper egestas. Rhoncus, placerat porttitor.',
        //     style: GoogleFonts.inter(
        //         fontWeight: FontWeight.w400,
        //         fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
        //         letterSpacing: 0.4,
        //         color: AppColors.catTextColor),
        //   ),
        // ),
        // Container(
        //   margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884, top: SizeConfig.heightMultiplier * 3.0129124820659974, right: SizeConfig.widthMultiplier * 3.8888888888888884),
        //   child: Text(
        //     'Paypal fee*',
        //     style: GoogleFonts.inter(
        //       fontWeight: FontWeight.w700,
        //       fontSize: SizeConfig.textMultiplier * 1.757532281205165,
        //       letterSpacing: 0.15,
        //     ),
        //   ),
        // ),
        // Container(
        //   margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884, top: SizeConfig.heightMultiplier * 0.5021520803443329, right: SizeConfig.widthMultiplier * 3.8888888888888884),
        //   child: Text(
        //     'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In amet, id nullam et, nibh. Aliquam nulla eget sit faucibus sollicitudin enim lacus semper egestas. Rhoncus, placerat porttitor.',
        //     style: GoogleFonts.inter(
        //         fontWeight: FontWeight.w400,
        //         fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
        //         letterSpacing: 0.4,
        //         color: AppColors.catTextColor),
        //   ),
        // ),
        GestureDetector(
          onTap: () {
            setState(() {
              _mailCheck = !_mailCheck;
            });
          },
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 4.861111111111111,
                    top: SizeConfig.heightMultiplier * 1.129842180774749),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.appBlue,
                        width:
                            SizeConfig.widthMultiplier * 0.24305555555555552),
                    borderRadius: BorderRadius.circular(3)),
                child: _mailCheck
                    ? Icon(
                        Icons.check,
                        color: AppColors.appBlue,
                        size: 16,
                      )
                    : null,
              ),
              Flexible(
                child: Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 2.9166666666666665,
                        right: SizeConfig.widthMultiplier * 3.159722222222222,
                        top: SizeConfig.heightMultiplier * 1.3809182209469155),
                    child: Text(
                        "By checking this box I agree to Marketspaace's terms and fee policy.",
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.5064562410329987,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.4))),
              ),
            ],
          ),
        ),
        Container(
          height: SizeConfig.heightMultiplier * 0.37661406025824967,
          margin: EdgeInsets.only(
            top: SizeConfig.heightMultiplier * 1.0043041606886658,
          ),
          color: AppColors.lightgrey,
        ),
      ],
    );
  }

  Widget _earningsPerItem() {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.appBlue)),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 1.0043041606886658),
            child: Row(
              children: [
                Container(
                  child: Text(
                    _titleController?.text ?? '',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                      letterSpacing: 0.15,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  child: Text(
                    _priceController?.text ?? '',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                      letterSpacing: 0.15,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: SizeConfig.heightMultiplier * 0.12553802008608322,
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 1.0043041606886658),
            decoration: BoxDecoration(color: AppColors.text_field_container),
          ),
          Container(
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 1.0043041606886658),
            child: Row(
              children: [
                Container(
                  child: Text(
                    '${_l10n.mktSpaceSalePer} (3%)',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                      letterSpacing: 0.15,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  child: Text(
                    (_priceController?.text?.isNotEmpty ?? false)
                        ? '\$${(0.03 * double.parse(_priceController?.text)).toStringAsFixed(2)}'
                        : '',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                      letterSpacing: 0.15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884, right: SizeConfig.widthMultiplier * 3.8888888888888884, top: SizeConfig.heightMultiplier * 1.0043041606886658),
          //   child: Row(
          //     children: [
          //       Container(
          //         child: Text(
          //           'Paypal/ Network fee *',
          //           style: GoogleFonts.inter(
          //             fontWeight: FontWeight.w400,
          //             fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
          //             letterSpacing: 0.15,
          //           ),
          //         ),
          //       ),
          //       Spacer(),
          //       Container(
          //         child: Text(
          //           '0.99\$',
          //           style: GoogleFonts.inter(
          //             fontWeight: FontWeight.w400,
          //             fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
          //             letterSpacing: 0.15,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            height: SizeConfig.heightMultiplier * 0.12553802008608322,
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 1.0043041606886658),
            decoration: BoxDecoration(color: AppColors.text_field_container),
          ),
          Container(
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 1.0043041606886658,
                bottom: SizeConfig.heightMultiplier * 1.2553802008608321),
            child: Row(
              children: [
                Container(
                  child: Text(
                    'Total',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        letterSpacing: 0.1,
                        color: AppColors.app_txt_color),
                  ),
                ),
                Spacer(),
                Container(
                  child: Text(
                    (_priceController?.text?.isNotEmpty ?? false)
                        ? '\$${(double.parse(_priceController.text) - (0.03 * double.parse(_priceController.text))).toStringAsFixed(2)}'
                        : '',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                      letterSpacing: 0.15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _uploadKeyScreen() {
    return Column(
      // shrinkWrap: true,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 24, bottom: 16),
          height: 44,
          width: MediaQuery.of(context).size.width,
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.text_field_container,
              primaryColorDark: AppColors.text_field_container,
            ),
            child: TextField(
              key: _courierKey,
              controller: _courierController,
              focusNode: _courierServiceFocusNode,
              // enabled: _overlayEntry == null ? true : false,
              // readOnly: true,
              // showCursor: false,
              onTap: () {
                _shippingMethodFocusNode.unfocus();
                // setState(() {
                //   this._overlayEntry = this._createOverlayEntry(
                //       _courierDropItems, _courierKey, _courierController);
                //   Overlay.of(context).insert(this._overlayEntry);
                //   _courierSelected = _courierController.text;
                // });
              },
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  letterSpacing: 0.1,
                  color: AppColors.app_txt_color),
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(
                          color: AppColors.text_field_color,
                          width:
                              SizeConfig.widthMultiplier * 0.12152777777777776),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: '${_l10n.courierServices} *',
                  contentPadding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884),
                  suffixStyle: const TextStyle(color: AppColors.appBlue)),
              // decoration: InputDecoration(
              //     suffixIcon: Icon(Icons.keyboard_arrow_down),
              //     border: OutlineInputBorder(
              //         borderSide: BorderSide(
              //             color: AppColors.text_field_container, width: 0.5),
              //         borderRadius: BorderRadius.circular(10.0)),
              //     contentPadding: EdgeInsets.only(left: 16),
              //     hintText: '${_l10n.courierServices} *',
              //     suffixStyle:
              //         const TextStyle(color: AppColors.text_field_container)),
            ),
          ),
        ),
        DropdownField<String>(
          bottomMargin: 16,
          dropdownItems: (_shippingDropItems ?? [])
              .map(
                (e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ),
              )
              .toList(),
          onTap: () => _courierServiceFocusNode.unfocus(),
          focusNode: _shippingMethodFocusNode,
          hintText: '${_l10n.shippingMethod} *',
          value: _shippingSelected,
          onChanged: (val) => setState(() => _shippingSelected = val),
        ),
        DropdownField<String>(
          bottomMargin: 16,
          onTap: () => _courierServiceFocusNode.unfocus(),
          dropdownItems: (_sellerHandlingTimes ?? [])
              .map(
                (e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ),
              )
              .toList(),
          hintText: 'Handling time *',
          value: _sellerHandlingTime,
          onChanged: (val) => setState(() => _sellerHandlingTime = val),
        ),
        DropdownField<String>(
          bottomMargin: 16,
          onTap: () => _courierServiceFocusNode.unfocus(),
          dropdownItems: (_deliveryTimes ?? [])
              .map(
                (e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ),
              )
              .toList(),
          hintText: 'Delivery time *',
          value: _selectedDeliveryTime,
          onChanged: (val) => setState(() => _selectedDeliveryTime = val),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _freeShipping
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        // // print('why is free shipping: ' +
                        //     _freeShipping.toString());
                        _freeShipping = false;
                        // // print('free shipping: ' + _freeShipping.toString());
                      });
                    },
                    child: Container(
                      width: 18,
                      height: 18,
                      margin: EdgeInsets.only(top: 9),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: AppColors.appBlue, width: 1),
                          borderRadius: BorderRadius.circular(3)),
                      child: Icon(
                        Icons.check,
                        color: AppColors.appBlue,
                        size: 16,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        _freeShipping = true;
                        // print("freeshipping: " + _freeShipping.toString());
                      });
                    },
                    child: Container(
                      width: 18,
                      height: 18,
                      margin: EdgeInsets.only(top: 9),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: AppColors.appBlue, width: 1),
                          borderRadius: BorderRadius.circular(3)),
                    ),
                  ),
            Flexible(
              child: Container(
                  margin: EdgeInsets.only(left: 12, right: 13, top: 11),
                  child: Text(_l10n.freeShipping,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.4))),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 16),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              textAlign: TextAlign.start,
              controller: _lenghtController,
              enabled: !_freeShipping,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: AppColors.text_field_color),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: '${_l10n.length} (cm)',
                  contentPadding: EdgeInsets.only(left: 16, top: 10),
                  suffixStyle: const TextStyle(color: AppColors.appBlue)),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              controller: _widthController,
              enabled: !_freeShipping,
              textAlign: TextAlign.start,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: AppColors.text_field_color),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: '${_l10n.width} (cm)',
                  contentPadding: EdgeInsets.only(left: 16, top: 10),
                  suffixStyle: const TextStyle(color: AppColors.appBlue)),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              textAlign: TextAlign.start,
              controller: _heightController,
              focusNode: _heightFocusNode,
              onTap: () {
                FocusScope.of(context).requestFocus(_heightFocusNode);
              },
              enabled: !_freeShipping,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: AppColors.text_field_color),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: '${_l10n.height} (cm)',
                  contentPadding: EdgeInsets.only(left: 16, top: 10),
                  suffixStyle: const TextStyle(color: AppColors.appBlue)),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextFormField(
              controller: _weightController,
              focusNode: _weightFocusNode,
              onTap: () {
                FocusScope.of(context).requestFocus(_weightFocusNode);
              },
              textAlign: TextAlign.start,
              enabled: !_freeShipping,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: AppColors.text_field_color),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: '${_l10n.weight} (kg)',
                  contentPadding: EdgeInsets.only(left: 16, top: 10),
                  suffixStyle: const TextStyle(color: AppColors.appBlue)),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextFormField(
              textAlign: TextAlign.start,
              controller: _shippingPriceController,
              focusNode: _shippingPriceFocusNode,
              onTap: () {
                FocusScope.of(context).requestFocus(_shippingPriceFocusNode);
              },
              enabled: !_freeShipping,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: AppColors.text_field_color),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: '${_l10n.estimatedPrice}',
                  contentPadding: EdgeInsets.only(left: 16, top: 10),
                  suffixStyle: const TextStyle(color: AppColors.appBlue)),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.start,
              controller: _deliveryInfoController,
              focusNode: _deliveryInfoFocusNode,
              onTap: () {
                FocusScope.of(context).requestFocus(_deliveryInfoFocusNode);
              },
              minLines: 4,
              maxLines: 6,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: 14,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: AppColors.text_field_color),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: '${_l10n.deliveryInformation}',
                  contentPadding: EdgeInsets.only(left: 16, top: 10),
                  suffixStyle: const TextStyle(color: AppColors.appBlue)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomButton() {
    return Container(
      height: SizeConfig.heightMultiplier * 6.025824964131995,
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 3.89167862266858,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          bottom: SizeConfig.heightMultiplier * 5.0215208034433285),
      child: BlocBuilder<SellerPageBloc, SellerPageState>(
        builder: (_, state) {
          switch (state) {
            case SellerPageState.initial:
            case SellerPageState.advanceSetting:
            case SellerPageState.shippingScreen:
              _buttonText = 'NEXT';
              break;
            case SellerPageState.sellingPage2:
              _buttonText = 'LIST';
              break;
            default:
              _buttonText = 'NEXT';
          }
          bool showBottomBotton = state == SellerPageState.initial ||
              state == SellerPageState.shippingScreen ||
              state == SellerPageState.sellingPage2;
          return showBottomBotton
              ? RaisedGradientButton(
                  gradient: LinearGradient(
                    colors: <Color>[
                      AppColors.gradient_button_light,
                      AppColors.gradient_button_dark,
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                    child: Text(
                      _buttonText,
                      style: GoogleFonts.roboto(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      if (state == SellerPageState.initial) {
                        // print('does this even hit');
                        _buttonText = "NEXT";
                        // print('selected item: ${_selectedItem}');
                        if (_selectedItem == "${_l10n.Producttype} *") {
                          // print('where');
                          _showToast("${_l10n.select} ${_l10n.Producttype}");
                        } else if (_titleController.text.length == 0) {
                          // print('do');
                          _showToast("Please enter product title");
                        } else if (_condition == null ||
                            _condition == "${_l10n.condition} *") {
                          // print('we');
                          _showToast("${_l10n.select} ${_l10n.condition}");
                        } else if (_catSelected == null ||
                            _catSelected == "${_l10n.Category} *") {
                          // print('fall');
                          _showToast(
                              "Please ${_l10n.select} ${_l10n.Category}");
                        } else if (_subCategories == null ||
                            _subCategories == "${_l10n.Subcategories} *") {
                          // print('subcategories: ${_subCategories}');
                          // print('please');
                          _showToast(
                              "Please ${_l10n.select} ${_l10n.Subcategories}");
                        } else if (_descriptionController.text.length == 0) {
                          // print('tell');
                          _showToast("Please enter ${_l10n.itemDesc}");
                        } else if (SellingItems.productImages.length == 0) {
                          _showToast("Please add product images");
                        }
                        // else if (UploadProductKeyRoute.courierService == null &&
                        //     _selectedItem != "${_l10n.Digitalgoods}") {
                        //   // print('me');
                        //   _showToast("Please ${_l10n.select} ${_l10n.productKey}");
                        // }
                        else {
                          _persistStepOneData();
                          _pageBloc.add(SellerPageEvent.toNextPage);
                          page_number = page_number + 1;
                          _buttonText = "NEXT";
                          _scrollToTheTopOfTheList();
                          // print("page_number $page_number");
                        }
                      }
                      // else if (state == SellerPageState.otherDetail) {
                      //   // print('do we somehow go here');
                      //   _buttonText = "${_l10n.next}";
                      //   _pageBloc.add(SellerPageEvent.toNextPage);
                      //   page_number = page_number + 1;
                      //   _buttonText = "${_l10n.confirm}";
                      // }

                      else if (state == SellerPageState.shippingScreen) {
                        if ((_courierController.text?.isEmpty ?? true) ||
                            _courierController.text == _l10n.courierServices) {
                          _showToast("Please enter a courier service");
                        } else if (_shippingSelected == null) {
                          _showToast("Please select the shipping method");
                        } else if (_sellerHandlingTime == null ||
                            _sellerHandlingTime == "Handling time *") {
                          _showToast("Please select the handling time");
                        } else if (_selectedDeliveryTime == null) {
                          _showToast("Please select the delivery time");
                        } else if (!_freeShipping &&
                            (_lenghtController.text.length == 0 ||
                                _widthController.text.length == 0 ||
                                _heightController.text.length == 0 ||
                                _weightController.text.length == 0 ||
                                _shippingPriceController.text.length == 0 ||
                                _lenghtController.text == _l10n.length ||
                                _widthController.text == _l10n.width ||
                                _heightController.text == _l10n.width ||
                                _weightController.text == _l10n.weight ||
                                _shippingPriceController.text ==
                                    _l10n.estimatedPrice)) {
                          _showToast("Please enter the package descriptions");
                        } else {
                          // print('freeshipping: ' + _freeShipping.toString());
                          // print('shipping method: ' + _shippingSelected);
                          _persistStepTwoData();

                          _pageBloc.add(SellerPageEvent.toNextPage);
                          _scrollToTheTopOfTheList();
                        }
                        _buttonText = "LIST";
                      } else if (state == SellerPageState.sellingPage2) {
                        // // print(
                        //     "_paymentCurrency == null ${_paymentCurrency == null} - $_paymentCurrency == null");
                        if (_paymentCurrency == null) {
                          _showToast(
                              "Please select the desired payment currency");
                        } else if (_priceController.text.length == 0) {
                          _showToast("Please set the price");
                        } else if (!_mailCheck) {
                          _showToast(
                              "You have not agreed with our terms and fee policy");
                        } else {
                          // print('do we somehow go here');
                          SellItemReqModel reqModel = SellItemReqModel();
                          // reqModel.variations = SellingItems.variations;

                          reqModel.description = SellingItems.description;
                          reqModel.category = SellingItems.category;
                          // .replaceAll("'", "-");
                          // reqModel.category =
                          //     reqModel.category.replaceAll(" ", "_");

                          reqModel.subCategory =
                              SellingItems.subCategory.replaceAll("'", "-");
                          reqModel.subCategory =
                              reqModel.subCategory.replaceAll(" ", "-");
                          reqModel.deliveryTime = SellingItems.deliveryTime;
                          reqModel.productTitle = SellingItems.productTitle;
                          reqModel.condition = SellingItems.condition;
                          reqModel.productType = SellingItems.productType;

                          reqModel.freeShipping = _freeShipping.toString();
                          reqModel.courierService = _courierController.text;
                          reqModel.shippingMethod = _shippingSelected;
                          // print('shipping method: ' + reqModel.shippingMethod);
                          if (_freeShipping == false) {
                            reqModel.estimatedShippingPrice =
                                _shippingPriceController.text;
                            reqModel.packageWidth = _widthController.text;
                            reqModel.packageHeight = _heightController.text;
                            reqModel.packageWeight = _weightController.text;
                            reqModel.packageLength = _lenghtController.text;
                            reqModel.packageWeight = _weightController.text;
                          }
                          if (_deliveryInfoController.text != null ||
                              _deliveryInfoController.text != "") {
                            reqModel.deliveryInformation =
                                _deliveryInfoController.text;
                          }
                          reqModel.isCustomBrand =
                              SellerAddBrandRoute.customBrand;
                          if (SellerAddBrandRoute.customBrand != null &&
                              !SellerAddBrandRoute.customBrand) {
                            reqModel.brandName = SellerAddBrandRoute.brandName;
                          } else if (SellerAddBrandRoute.customBrand != null &&
                              SellerAddBrandRoute.customBrand) {
                            reqModel.customBrandName =
                                SellerAddBrandRoute.customBrandName;
                            reqModel.customBrandDescription =
                                SellerAddBrandRoute.customBrandDescription;
                            reqModel.customBrandImg =
                                SellerAddBrandRoute.customBrandImg;
                          }

                          if (SaleConditionRoute.saleCondition != null) {
                            reqModel.saleConditions =
                                SaleConditionRoute.saleCondition;
                          }

                          if (SaleConditionRoute.quantity != null) {
                            reqModel.quantity = SaleConditionRoute.quantity;
                          }

                          reqModel.desiredPaymentCurrency = _paymentCurrency;
                          reqModel.fiatPrice = _priceController.text;
                          reqModel.sellerHandlingTime = _sellerHandlingTime;
                          // reqModel.customBrandName = SellingItems.customBrandName;
                          reqModel.agreeMSPolicy = '$_mailCheck';

                          if (Constants.language == null ||
                              Constants.language == "English") {
                            reqModel.language = "en";
                          } else {
                            reqModel.language = "zh";
                          }

                          reqModel.fiatCurrency = _fiatCurrency;

                          reqModel.productImages = SellingItems.productImages;

                          _persistStepThreeData();

                          // BlocProvider.of<PageBloc>(context, listen: false)
                          // .add(PageEvent.toNextPage);

                          // SellingItems.productImages;
                          _sellNewProductsBloc.sellItemReqModel = reqModel;
                          _sellNewProductsBloc.add(ConfirmSellItemEvent());
                          // _buttonText = "${_l10n.next}";
                          // if (_handlingSelected == "${_l10n.HandlingTime} *") {
                          //   _showToast("Please ${_l10n.select} ${_l10n.HandlingTime}");
                          // } else {
                          //  TODO HANDLING TIME CHECK
                          // SellingItems.handlingTime = _handlingSelected;
                          // page_number = page_number + 1;
                          // }
                        }
                      }
                      // else if (page_number == 3) {
                      //   // print('do we somehow go here');
                      //   //TODO
                      //   page_number = page_number + 1;

                      // }
                      // else if (page_number == 3) {
                      //   // print('do we somehow go here');
                      //   SellItemReqModel reqModel = SellItemReqModel();
                      //   // reqModel.variations = SellingItems.variations;

                      //   reqModel.description = SellingItems.description;
                      //   reqModel.category = SellingItems.category.replaceAll("'", "-");
                      //   reqModel.category = reqModel.category.replaceAll(" ", "_");

                      //   reqModel.subCategory =
                      //       SellingItems.subCategory.replaceAll("'", "-");
                      //   reqModel.subCategory = reqModel.subCategory.replaceAll(" ", "-");

                      //   reqModel.fiatPrice = _fiatPrice;
                      //   reqModel.productTitle = SellingItems.productTitle;
                      //   reqModel.condition = SellingItems.condition;
                      //   reqModel.productType = SellingItems.productType;

                      //   reqModel.freeShipping =
                      //       UploadProductKeyRoute.freeShipping.toString();
                      //   reqModel.courierService = UploadProductKeyRoute.courierService;
                      //   reqModel.shippingMethod = UploadProductKeyRoute.shippingMethod;
                      //   if (UploadProductKeyRoute.freeShipping == false) {
                      //     reqModel.estimatedShippingPrice =
                      //         UploadProductKeyRoute.estimatedShippingPrice;
                      //     reqModel.packageWidth = UploadProductKeyRoute.packageWeight;
                      //     reqModel.packageHeight = UploadProductKeyRoute.packageHeight;
                      //     reqModel.packageWeight = UploadProductKeyRoute.packageWeight;
                      //     reqModel.packageLength = UploadProductKeyRoute.packageLength;
                      //     reqModel.packageWeight = UploadProductKeyRoute.packageWeight;
                      //     reqModel.deliveryInformation =
                      //         UploadProductKeyRoute.deliveryInformation;
                      //   }

                      //   if (!SellerAddBrandRoute.customBrand) {
                      //     reqModel.brandName = SellerAddBrandRoute.brandName;
                      //   } else {
                      //     reqModel.customBrandName = SellerAddBrandRoute.customBrandName;
                      //     reqModel.customBrandDescription =
                      //         SellerAddBrandRoute.customBrandDescription;
                      //     reqModel.customBrandImg = SellerAddBrandRoute.customBrandImg;
                      //   }

                      //   if (SaleConditionRoute.saleCondition != null) {
                      //     reqModel.saleConditions = SaleConditionRoute.saleCondition;
                      //   }

                      //   if (SaleConditionRoute.quantity != null) {
                      //     reqModel.quantity = SaleConditionRoute.quantity;
                      //   }

                      //   reqModel.desiredPaymentCurrency = "AUD";
                      //   reqModel.sellerHandlingTime = SellingItems.handlingTime;
                      //   // reqModel.customBrandName = SellingItems.customBrandName;
                      //   reqModel.agreeMSPolicy = '${_mailCheck}';

                      //   reqModel.productImages = [''];

                      //   // SellingItems.productImages;
                      //   _sellNewProductsBloc.sellItemReqModel = reqModel;
                      //   _sellNewProductsBloc.add(ConfirmSellItemEvent());
                      // }
                    });
                  },
                )
              : SizedBox.shrink();
        },
      ),
    );
  }

  Widget _sellingPage3() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                bottom: SizeConfig.heightMultiplier * 1.0043041606886658,
                top: SizeConfig.heightMultiplier * 2.0086083213773316),
            child: Text(_l10n.digitalProduct,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                    letterSpacing: 0.15,
                    textStyle: TextStyle(fontFamily: 'Inter'),
                    color: AppColors.app_txt_color)),
          ),
          Container(
              margin: EdgeInsets.only(
                  // top: SizeConfig.heightMultiplier * 0.5,
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884),
              height: SizeConfig.heightMultiplier * 5.523672883787662,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: AppColors.text_field_container)),
              child: Theme(
                data: ThemeData(
                  primaryColor: AppColors.text_field_container,
                  primaryColorDark: AppColors.text_field_container,
                ),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  key: _handlingKey,
                  controller: _handlingController,
                  readOnly: true,
                  showCursor: false,
                  onTap: () {
                    setState(() {
                      this._overlayEntry = this._createOverlayEntry(
                        _handlingTimeItems,
                        _handlingKey,
                        _handlingController,
                      );
                      Overlay.of(context).insert(this._overlayEntry);
                      _handlingSelected = _handlingController.text;
                    });
                  },
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      letterSpacing: 0.1,
                      color: AppColors.app_txt_color),
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.keyboard_arrow_down),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.text_field_container),
                          borderRadius: BorderRadius.circular(10.0)),
                      contentPadding: EdgeInsets.only(
                          left:
                              SizeConfig.widthMultiplier * 3.8888888888888884),
                      hintText: 'Handling time *',
                      suffixStyle: const TextStyle(
                          color: AppColors.text_field_container)),
                ),
              )),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.0043041606886658,
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884),
            child: Theme(
              data: ThemeData(
                primaryColor: AppColors.appBlue,
                primaryColorDark: AppColors.appBlue,
              ),
              child: TextField(
                textAlign: TextAlign.start,
                controller: _productKeyController,
                style: GoogleFonts.inter(
                  color: AppColors.text_field_color,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.25,
                ),
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide:
                            new BorderSide(color: AppColors.text_field_color),
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText: _l10n.productKey,
                    labelText: _l10n.productKey,
                    contentPadding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                        top: SizeConfig.heightMultiplier * 1.2553802008608321),
                    suffixStyle: const TextStyle(color: AppColors.appBlue)),
              ),
            ),
          ),
          Container(
              height: SizeConfig.heightMultiplier * 12.553802008608322,
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                  top: SizeConfig.heightMultiplier * 1.0043041606886658),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.text_field_container)),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    ),
                    child: Expanded(
                      child: Text(
                        _fileUrl ?? 'Upload file',
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                            color: AppColors.app_txt_color),
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                      onTap: () {
                        _sellNewProductsBloc.add(UploadFileEvent());
                      },
                      child: Container(
                          margin: EdgeInsets.only(
                            right:
                                SizeConfig.widthMultiplier * 3.8888888888888884,
                          ),
                          child: Image.asset(
                            'assets/images/upload_file.png',
                            width:
                                SizeConfig.widthMultiplier * 4.861111111111111,
                            height: SizeConfig.heightMultiplier *
                                2.5107604017216643,
                          )))
                ],
              )),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.0043041606886658,
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884),
            child: Theme(
              data: ThemeData(
                primaryColor: AppColors.appBlue,
                primaryColorDark: AppColors.appBlue,
              ),
              child: TextField(
                textAlign: TextAlign.start,
                minLines: 4,
                maxLines: 7,
                style: GoogleFonts.inter(
                  color: AppColors.text_field_color,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.25,
                ),
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide:
                            new BorderSide(color: AppColors.text_field_color),
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText: _l10n.deliveryInfo,
                    labelText: _l10n.deliveryInfo,
                    contentPadding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                        top: SizeConfig.heightMultiplier * 1.8830703012912482),
                    suffixStyle: const TextStyle(color: AppColors.appBlue)),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_mailCheck)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _mailCheck = false;
                    });
                  },
                  child: Container(
                    width: SizeConfig.widthMultiplier * 4.374999999999999,
                    height: SizeConfig.heightMultiplier * 2.259684361549498,
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 4.861111111111111,
                        top: SizeConfig.heightMultiplier * 1.129842180774749),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.appBlue,
                            width: SizeConfig.widthMultiplier *
                                0.24305555555555552),
                        borderRadius: BorderRadius.circular(3)),
                    child: Icon(
                      Icons.check,
                      color: AppColors.appBlue,
                      size: 16,
                    ),
                  ),
                ),
              if (!_mailCheck)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _mailCheck = true;
                    });
                  },
                  child: Container(
                    width: SizeConfig.widthMultiplier * 4.374999999999999,
                    height: SizeConfig.heightMultiplier * 2.259684361549498,
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 4.861111111111111,
                        top: SizeConfig.heightMultiplier * 1.129842180774749),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.appBlue,
                            width: SizeConfig.widthMultiplier *
                                0.24305555555555552),
                        borderRadius: BorderRadius.circular(3)),
                  ),
                ),
              Flexible(
                child: Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 2.9166666666666665,
                        right: SizeConfig.widthMultiplier * 3.159722222222222,
                        top: SizeConfig.heightMultiplier * 1.3809182209469155),
                    child: Text(_l10n.certificationText,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.5064562410329987,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.4))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _advanceSetting() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              bottom: SizeConfig.heightMultiplier * 1.0043041606886658,
              top: SizeConfig.heightMultiplier * 2.0086083213773316),
          child: Text('Brand, sale conditions and quantities',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                  letterSpacing: 0.15,
                  textStyle: TextStyle(fontFamily: 'Inter'),
                  color: AppColors.app_txt_color)),
        ),
        GestureDetector(
          onTap: () {
            RouterService.appRouter.navigateTo(SellerAddBrandRoute.buildPath());
          },
          child: Container(
              height: SizeConfig.heightMultiplier * 10.419655667144907,
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                  top: SizeConfig.heightMultiplier * 1.0043041606886658),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.text_field_container)),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    ),
                    child: Text(
                      'Brand',
                      style: GoogleFonts.inter(
                          fontSize:
                              SizeConfig.textMultiplier * 1.757532281205165,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.25,
                          color: AppColors.catTextColor),
                    ),
                  ),
                  Spacer(),
                  Container(
                      margin: EdgeInsets.only(
                        right: SizeConfig.widthMultiplier * 3.8888888888888884,
                      ),
                      child: Image.asset('assets/images/chevron_right.png',
                          width: SizeConfig.widthMultiplier * 4.861111111111111,
                          height:
                              SizeConfig.heightMultiplier * 2.5107604017216643,
                          color: AppColors.catTextColor))
                ],
              )),
        ),
        // GestureDetector(
        //     onTap: () {
        //       RouterService.appRouter
        // .navigateTo(SellerProductVariationRoute.buildPath());
        //     },
        //     child: Container(
        //         height: SizeConfig.heightMultiplier * 10.419655667144907,
        //         margin: EdgeInsets.only(
        //             left: SizeConfig.widthMultiplier * 3.8888888888888884,
        //             right: SizeConfig.widthMultiplier * 3.8888888888888884,
        //             top: SizeConfig.heightMultiplier * 1.0043041606886658),
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(10),
        //             border: Border.all(color: AppColors.text_field_container)),
        //         child: Row(
        //           children: [
        //             Container(
        //               margin: EdgeInsets.only(
        //                 left: SizeConfig.widthMultiplier * 3.8888888888888884,
        //               ),
        //               child: Text(
        //                 '${_l10n.productVariation} ${_l10n.and} ${_l10n.quantity}',
        //                 style: GoogleFonts.inter(
        //                     fontSize:
        //                         SizeConfig.textMultiplier * 1.757532281205165,
        //                     fontWeight: FontWeight.w400,
        //                     letterSpacing: 0.25,
        //                     color: AppColors.catTextColor),
        //               ),
        //             ),
        //             Spacer(),
        //             Container(
        //                 margin: EdgeInsets.only(
        //                   right: SizeConfig.widthMultiplier * 3.8888888888888884,
        //                 ),
        //                 child: Image.asset('assets/images/chevron_right.png',
        //                     width: SizeConfig.widthMultiplier * 4.861111111111111,
        //                     height:
        //                         SizeConfig.heightMultiplier * 2.5107604017216643,
        //                     color: AppColors.catTextColor))
        //           ],
        //         ))),
        GestureDetector(
            onTap: () {
              RouterService.appRouter
                  .navigateTo(SaleConditionRoute.buildPath());
            },
            child: Container(
                height: SizeConfig.heightMultiplier * 10.419655667144907,
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884,
                    top: SizeConfig.heightMultiplier * 1.0043041606886658),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.text_field_container)),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      ),
                      child: Text(
                        "${_l10n.saleCondition} and quantities",
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                            color: AppColors.catTextColor),
                      ),
                    ),
                    Spacer(),
                    Container(
                        margin: EdgeInsets.only(
                          right:
                              SizeConfig.widthMultiplier * 3.8888888888888884,
                        ),
                        child: Image.asset('assets/images/chevron_right.png',
                            width:
                                SizeConfig.widthMultiplier * 4.861111111111111,
                            height: SizeConfig.heightMultiplier *
                                2.5107604017216643,
                            color: AppColors.catTextColor))
                  ],
                ))),
        // Container(
        //        height: SizeConfig.heightMultiplier * 10.419655667144907,
        //        margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884, right: SizeConfig.widthMultiplier * 3.8888888888888884, top: SizeConfig.heightMultiplier * 1.0043041606886658),
        //        decoration: BoxDecoration(
        //            borderRadius: BorderRadius.circular(10),
        //            border: Border.all(color: AppColors.text_field_container)),
        //        child: Row(
        //          children: [
        //            Container(
        //              margin: EdgeInsets.only(
        //                left: SizeConfig.widthMultiplier * 3.8888888888888884,
        //              ),
        //              child: Text(
        //                'Discount price',
        //                style: GoogleFonts.inter(
        //                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
        //                    fontWeight: FontWeight.w400,
        //                    letterSpacing: 0.25,
        //                    color: AppColors.catTextColor),
        //              ),
        //            ),
        //            Spacer(),
        //            Container(
        //                margin: EdgeInsets.only(
        //                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
        //                ),
        //                child: Image.asset('assets/images/chevron_right.png',
        //                    width: SizeConfig.widthMultiplier * 4.861111111111111, height: SizeConfig.heightMultiplier * 2.5107604017216643, color: AppColors.catTextColor))
        //          ],
        //        ))),
      ],
    ));
  }

  Widget _advanceSettings1() {
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            bottom: SizeConfig.heightMultiplier * 1.0043041606886658,
            top: SizeConfig.heightMultiplier * 2.0086083213773316),
        child: Text('Advance settings',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                letterSpacing: 0.15,
                textStyle: TextStyle(fontFamily: 'Inter'),
                color: AppColors.app_txt_color)),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_priceCheck)
            GestureDetector(
              onTap: () {
                setState(() {
                  _priceCheck = false;
                });
              },
              child: Container(
                width: SizeConfig.widthMultiplier * 4.374999999999999,
                height: SizeConfig.heightMultiplier * 2.259684361549498,
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 4.861111111111111,
                    top: SizeConfig.heightMultiplier * 1.129842180774749),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.appBlue,
                        width:
                            SizeConfig.widthMultiplier * 0.24305555555555552),
                    borderRadius: BorderRadius.circular(3)),
                child: Icon(
                  Icons.check,
                  color: AppColors.appBlue,
                  size: 16,
                ),
              ),
            ),
          if (!_priceCheck)
            GestureDetector(
              onTap: () {
                setState(() {
                  _priceCheck = true;
                });
              },
              child: Container(
                width: SizeConfig.widthMultiplier * 4.374999999999999,
                height: SizeConfig.heightMultiplier * 2.259684361549498,
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 4.861111111111111,
                    top: SizeConfig.heightMultiplier * 1.129842180774749),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.appBlue,
                        width:
                            SizeConfig.widthMultiplier * 0.24305555555555552),
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
          Flexible(
            child: Container(
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 2.9166666666666665,
                    right: SizeConfig.widthMultiplier * 3.159722222222222,
                    top: SizeConfig.heightMultiplier * 1.3809182209469155),
                child: Text("${_l10n.Price} ${_l10n.discount}",
                    style: GoogleFonts.inter(
                        fontSize:
                            SizeConfig.textMultiplier * 1.5064562410329987,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.4))),
          ),
        ],
      ),
      Container(
        margin: EdgeInsets.only(
            top: SizeConfig.heightMultiplier * 1.0043041606886658,
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: SizeConfig.widthMultiplier * 3.8888888888888884),
        child: Theme(
          data: ThemeData(
            primaryColor: AppColors.appBlue,
            primaryColorDark: AppColors.appBlue,
          ),
          child: TextField(
            textAlign: TextAlign.start,
            style: GoogleFonts.inter(
              color: AppColors.text_field_color,
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.textMultiplier * 1.757532281205165,
              letterSpacing: 0.25,
            ),
            decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide:
                        new BorderSide(color: AppColors.text_field_color),
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: '${_l10n.priceWhenDicAvailable}',
                labelText: '${_l10n.priceWhenDicAvailable}',
                suffix: Container(
                  margin: EdgeInsets.only(
                      right: SizeConfig.widthMultiplier * 2.4305555555555554),
                  child: Text(
                    'CAD',
                    style: GoogleFonts.inter(
                        fontSize:
                            SizeConfig.textMultiplier * 1.5064562410329987,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                contentPadding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    top: SizeConfig.heightMultiplier * 1.2553802008608321),
                suffixStyle: const TextStyle(color: AppColors.appBlue)),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: SizeConfig.widthMultiplier * 3.8888888888888884,
            top: SizeConfig.heightMultiplier * 1.0043041606886658),
        child: Theme(
          data: ThemeData(
            primaryColor: AppColors.appBlue,
            primaryColorDark: AppColors.appBlue,
          ),
          child: TextField(
            style: GoogleFonts.inter(
              color: AppColors.text_field_color,
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.textMultiplier * 1.757532281205165,
              letterSpacing: 0.25,
            ),
            decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide:
                        new BorderSide(color: AppColors.text_field_color),
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: '${_l10n.discount} code.',
                contentPadding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884),
                suffixStyle: const TextStyle(color: AppColors.appBlue)),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_percentageCheck)
            GestureDetector(
              onTap: () {
                setState(() {
                  _percentageCheck = false;
                });
              },
              child: Container(
                width: SizeConfig.widthMultiplier * 4.374999999999999,
                height: SizeConfig.heightMultiplier * 2.259684361549498,
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 4.861111111111111,
                    top: SizeConfig.heightMultiplier * 1.129842180774749),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.appBlue,
                        width:
                            SizeConfig.widthMultiplier * 0.24305555555555552),
                    borderRadius: BorderRadius.circular(3)),
                child: Icon(
                  Icons.check,
                  color: AppColors.appBlue,
                  size: 16,
                ),
              ),
            ),
          if (!_percentageCheck)
            GestureDetector(
              onTap: () {
                setState(() {
                  _percentageCheck = true;
                });
              },
              child: Container(
                width: SizeConfig.widthMultiplier * 4.374999999999999,
                height: SizeConfig.heightMultiplier * 2.259684361549498,
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 4.861111111111111,
                    top: SizeConfig.heightMultiplier * 1.129842180774749),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.appBlue,
                        width:
                            SizeConfig.widthMultiplier * 0.24305555555555552),
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
          Container(
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 1.9444444444444442,
                top: SizeConfig.heightMultiplier * 1.129842180774749),
            child: Text("Percentage ${_l10n.discount}",
                maxLines: 1,
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.4)),
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.0043041606886658,
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884),
            height: SizeConfig.heightMultiplier * 3.7661406025824964,
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 2.9166666666666665,
                right: SizeConfig.widthMultiplier * 2.9166666666666665),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: AppColors.text_field_container)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  value: _discountSelected,
                  items: _discountMenuItems,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.text_field_container,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _discountSelected = value;
                    });
                  }),
            ),
          ),
        ],
      ),
      Container(
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: SizeConfig.widthMultiplier * 3.8888888888888884,
            top: SizeConfig.heightMultiplier * 1.0043041606886658),
        child: Theme(
          data: ThemeData(
            primaryColor: AppColors.appBlue,
            primaryColorDark: AppColors.appBlue,
          ),
          child: TextField(
            style: GoogleFonts.inter(
              color: AppColors.text_field_color,
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.textMultiplier * 1.757532281205165,
              letterSpacing: 0.25,
            ),
            decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide:
                        new BorderSide(color: AppColors.text_field_color),
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: '${_l10n.discount} code.',
                contentPadding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884),
                suffixStyle: const TextStyle(color: AppColors.appBlue)),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_discountCheck)
            GestureDetector(
              onTap: () {
                setState(() {
                  _discountCheck = false;
                });
              },
              child: Container(
                width: SizeConfig.widthMultiplier * 4.374999999999999,
                height: SizeConfig.heightMultiplier * 2.259684361549498,
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 4.861111111111111,
                    top: SizeConfig.heightMultiplier * 1.129842180774749),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.appBlue,
                        width:
                            SizeConfig.widthMultiplier * 0.24305555555555552),
                    borderRadius: BorderRadius.circular(3)),
                child: Icon(
                  Icons.check,
                  color: AppColors.appBlue,
                  size: 16,
                ),
              ),
            ),
          if (!_discountCheck)
            GestureDetector(
              onTap: () {
                setState(() {
                  _discountCheck = true;
                });
              },
              child: Container(
                width: SizeConfig.widthMultiplier * 4.374999999999999,
                height: SizeConfig.heightMultiplier * 2.259684361549498,
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 4.861111111111111,
                    top: SizeConfig.heightMultiplier * 1.129842180774749),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.appBlue,
                        width:
                            SizeConfig.widthMultiplier * 0.24305555555555552),
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 1.9444444444444442,
                  top: SizeConfig.heightMultiplier * 1.129842180774749),
              child: Text("I want MARKET SPAACE to promote this discount code",
                  style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.4)),
            ),
          ),
        ],
      ),
    ]));
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.appBlue,
        textColor: Colors.white,
        fontSize: SizeConfig.textMultiplier * 2.0086083213773316);
  }

  OverlayEntry _createOverlayEntry(List<String> _dropdownList,
      GlobalKey<ScaffoldState> actionKey, TextEditingController controller) {
    RenderBox renderBox =
        actionKey.currentContext?.findRenderObject(); //EDIT THIS LINE
    var size = renderBox.size;
    var height = renderBox.size.height;
    var width = renderBox.size.width;

    var offset = renderBox.localToGlobal(Offset.zero);
    var xPosition = offset.dx;
    var yPosition = offset.dy;
    // print('xPosition $xPosition');
    // print('yPosition $yPosition');

    return OverlayEntry(
      builder: (context) => Positioned(
          left: xPosition,
          width: width,
          top: yPosition,
          child: Container(
              height: actionKey == _productTypeKey
                  ? SizeConfig.heightMultiplier *
                      27.61836441893830950666825851312
                  : SizeConfig.heightMultiplier *
                      22.596843615494980505455847874371,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.appBlue,
                          width: SizeConfig.widthMultiplier *
                              0.48611111111111105)),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: _dropdownList
                        .map((value) => InkWell(
                              onTap: () {
                                setState(() {
                                  controller.text = value;
                                  _overlayEntry.remove();
                                  _overlayEntry = null;
                                });
                              },
                              child: value == _dropdownList[0]
                                  ? ListTile(
                                      title: Text(
                                        value,
                                        style: GoogleFonts.inter(
                                            color: AppColors.catTextColor,
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    1.757532281205165),
                                      ),
                                      trailing: Icon(Icons.keyboard_arrow_down),
                                    )
                                  : ListTile(
                                      title: Text(
                                        value,
                                        style: GoogleFonts.inter(
                                            color: AppColors.catTextColor,
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    1.757532281205165),
                                      ),
                                    ),
                            ))
                        .toList(),
                  ),
                ),
              ))),
    );
  }
}
