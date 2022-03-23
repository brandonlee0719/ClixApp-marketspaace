import 'dart:convert';

import 'package:algolia/algolia.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/model/flash_promo_model/flash_promo_algolia.dart';
import 'package:market_space/model/flash_promo_model/flash_promo_model.dart';
import 'package:market_space/model/image_banner/image_banner.dart';
import 'package:market_space/model/image_banner/image_banner_model.dart';
import 'package:market_space/model/interestingCategories/interesting_categories_model.dart';
import 'package:market_space/model/product_model/product_model.dart';
import 'package:market_space/model/rates_model/rates_model.dart';
import 'package:market_space/providers/localProvider/localDashboardProvider.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';

class DashboardProvider {
  final _baseUrl =
      'https://australia-southeast1-market-spaace.cloudfunctions.net';
  Dio dio = new Dio();
  final AuthRepository _authRepository = AuthRepository();

  int _status, _productStatus, _bannerStatus;
  final BehaviorSubject<List<FlashPromo>> _flashSink = BehaviorSubject();

  Stream<List<FlashPromo>> get flashStream => _flashSink.stream;

  Stream<List<FlashPromoAlgoliaObj>> get flashAlgoliaStream =>
      _flashAlgoliaSink.stream;
  final BehaviorSubject<List<FlashPromoAlgoliaObj>> _flashAlgoliaSink =
      BehaviorSubject();

  Stream<List<FlashPromoAlgoliaObj>> get productsAlgoliaStream =>
      _flashAlgoliaSink.stream;
  final BehaviorSubject<List<FlashPromoAlgoliaObj>> _productsAlgoliaSink =
      BehaviorSubject();

  final BehaviorSubject<List<Products>> _productSink = BehaviorSubject();

  Stream<List<Products>> get productStream => _productSink.stream;
  String _token;

  static final BehaviorSubject<List<String>> _bannerSink = BehaviorSubject();

  static Stream<List<String>> get bannerStream => _bannerSink.stream;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool _isChinese = false;
  List<AlgoliaObjectSnapshot> _flashPromo = [];
  List<AlgoliaObjectSnapshot> _productList = [];
  final LocalDashBoardProvider localProvider = LocalDashBoardProvider();

  Future<List<FlashPromoAlgoliaObj>> flashWithAlgolia(
      int page,
      String catTypeFilter,
      bool subCatSelected,
      String subCatText,
      String newSubCategories) async {
    Algolia algolia = Application.algolia;

    AlgoliaQuery query =
        algolia.instance.index("simpleProductData").search(' ');
    query = query.setPage(page);
    query = query.setHitsPerPage(5);
    query = query.setFacetFilter('approvalStatus:true');
    // query = query.setFacetFilter('version:full');
    query = query.setFacetFilter(
        ["country: ${Constants.country}", "hasInternationalShipping:true"]);
    query = query.setNumericFilter('qtyAvail > 0');
    if ((catTypeFilter == null || catTypeFilter == "") && !subCatSelected) {
      String interestedCategory =
          await _authRepository.getInterestingCategories();
      // print("hi interested ${interestedCategory}");
      if (interestedCategory != null) {
        // print('tell me this is not entered');
        InterestingCategoriesModel interestedCategories =
            InterestingCategoriesModel.fromJson(jsonDecode(interestedCategory));
        // print('filterCategories $interestedCategory');
        if (interestedCategories.interstingCategories.length == 1) {
          query = query.setFilters(
              'category: ${interestedCategories.interstingCategories[0]}');
          // print(
          // 'filterCategories ${interestedCategories.interstingCategories[0]}');
        } else if (interestedCategories.interstingCategories.length == 2) {
          query = query.setFilters(
              'category: ${interestedCategories.interstingCategories[0]} OR category: ${interestedCategories.interstingCategories[1]}');
        } else if (interestedCategories.interstingCategories.length == 3) {
          query = query.setFilters(
              'category: ${interestedCategories.interstingCategories[0]} OR category: ${interestedCategories.interstingCategories[1]} OR category: ${interestedCategories.interstingCategories[2]}');
        }
      }
      // AlgoliaQuerySnapshot snap = query.getObjects();
      List<AlgoliaObjectSnapshot> _algoliaSearch = [];

      // Checking if has [AlgoliaQuerySnapshot]
      // // print("Snap ${snap.index}");
      // // print('Hits count: ${snap.nbHits}');
      // print('about to run query');
      _algoliaSearch = (await query.getObjects()).hits;
      // print('query has been run');
      // Set Settings
      _flashPromo = _algoliaSearch;
      if (_flashPromo == null || _flashPromo.isEmpty) {
        Algolia algolia = Application.algolia;
        AlgoliaQuery query =
            algolia.instance.index("flashPromoProducts").search(' ');
        query = query.setPage(page);
        query = query.setHitsPerPage(5);
        query = query.setFacetFilter('approvalStatus:true');
        // query = query.setFacetFilter('version:full');
        query = query.setFacetFilter(
            ["country: ${Constants.country}", "hasInternationalShipping:true"]);
        query = query.setNumericFilter('qtyAvail > 0');
        AlgoliaQuerySnapshot snap = await query.getObjects();
        List<AlgoliaObjectSnapshot> _algoliaSearch = [];

        // Checking if has [AlgoliaQuerySnapshot]
        // print("Snap ${snap.index}");
        // print('Hits count: ${snap.nbHits}');
        _algoliaSearch = (await query.getObjects()).hits;
        // Set Settings
        _flashPromo = _algoliaSearch;
      } else {
        AlgoliaQuerySnapshot snap = await query.getObjects();
        List<AlgoliaObjectSnapshot> _algoliaSearch = [];

        // Checking if has [AlgoliaQuerySnapshot]
        // print("Snap ${snap.index}");
        // print('Hits count: ${snap.nbHits}');
        _algoliaSearch = (await query.getObjects()).hits;
        // Set Settings
        _flashPromo = _algoliaSearch;
      }
    } else if ((catTypeFilter == null || catTypeFilter == "") &&
        subCatSelected) {
      if (subCatText == "Preloved") {
        query = query.setFacetFilter('condition: $subCatText');
      } else if (subCatText == "Digital product") {
        query = query.setFacetFilter('productType: $subCatText');
        // print('productType $subCatText');
      } else if (subCatText == "International") {
        query = query.setFacetFilter('country: -${Constants.country}');
        // print('country $subCatText');
      } else if (subCatText == "Local") {
        query = query.setFacetFilter('country: ${Constants.country}');
        // print('country $subCatText');
      }
      AlgoliaQuerySnapshot snap = await query.getObjects();
      List<AlgoliaObjectSnapshot> _algoliaSearch = [];

      // Checking if has [AlgoliaQuerySnapshot]
      // print("Snap ${snap.index}");
      // print('Hits count: ${snap.nbHits}');
      _algoliaSearch = (await query.getObjects()).hits;

      // Set Settings
      _flashPromo = _algoliaSearch;
    } else {
      if (catTypeFilter != "others" && subCatSelected) {
        if (newSubCategories != null) {
          query = query.setFacetFilter('subCategory : $newSubCategories');
        } else {
          query = query.setFacetFilter('category: $catTypeFilter');
        }
        if (subCatText == "Preloved") {
          query = query.setFacetFilter('condition: $subCatText');
          // print('condition $subCatText');
        } else if (subCatText == "Digital product") {
          query = query.setFacetFilter('productType: $subCatText');
          // print('productType $subCatText');
        } else if (subCatText == "International") {
          query = query.setFacetFilter('country: -${Constants.country}');
          // print('country $subCatText');
        } else if (subCatText == "Local") {
          query = query.setFacetFilter('country: ${Constants.country}');
          // print('country $subCatText');
        }
      }
      if (catTypeFilter != "others" && !subCatSelected) {
        if (newSubCategories != null) {
          query = query.setFacetFilter('subCategory : $newSubCategories');
        }
        query = query.setFilters('category: $catTypeFilter');
        // print('filterCategories $catTypeFilter');
      }
      AlgoliaQuerySnapshot snap = await query.getObjects();
      List<AlgoliaObjectSnapshot> _algoliaSearch = [];

      // Checking if has [AlgoliaQuerySnapshot]
      // print("Snap ${snap.index}");
      // print('Hits count: ${snap.nbHits}');
      _algoliaSearch = (await query.getObjects()).hits;

      // Set Settings
      _flashPromo = _algoliaSearch;
    }

    List<FlashPromoAlgoliaObj> _flashList = List();
    for (int i = 0; i < _flashPromo.length; i++) {
      AlgoliaObjectSnapshot snap = _flashPromo[i];
      FlashPromoAlgoliaObj obj = FlashPromoAlgoliaObj.fromJson(snap.data);
      obj.size = await obj.calculateImageDimension();
      _flashList.add(obj);
      // print('flash product name ${obj.productName}');
    }
    _flashAlgoliaSink.add(_flashList);
    return _flashList;
  }

  Future<List<FlashPromoAlgoliaObj>> getProducts(
      int pageCount,
      String catTypeFilter,
      bool subCatSelected,
      String subCatText,
      String newSubCategories) async {
    Algolia algolia = Application.algolia;
    // print('this algolia method');
    AlgoliaQuery query = algolia.instance
        .index("simpleProductData")
        .search('')
        .setPage(pageCount)
        .setHitsPerPage(5);

    query = query.setFacetFilter('approvalStatus:true');
    // query = query.setFacetFilter('version:full');
    query = query.setFacetFilter(
        ["country: ${Constants.country}", "hasInternationalShipping:true"]);
    query = query.setNumericFilter('qtyAvail > 0');

    if ((catTypeFilter == null || catTypeFilter == "") && !subCatSelected) {
      String interestedCategory = null;
      // await _authRepository.getInterestingCategories();
      if (interestedCategory != null) {
        InterestingCategoriesModel interestedCategories =
            InterestingCategoriesModel.fromJson(jsonDecode(interestedCategory));
        // print('filterCategories $interestedCategory');
        // print('length???');
        // print('length: ${interestedCategories.interstingCategories.length}');
        if (interestedCategories.interstingCategories.length == 1) {
          query = query.setFilters(
              'category: ${interestedCategories.interstingCategories[0]}');
          // print(
          // 'filterCategories ${interestedCategories.interstingCategories[0]}');
          // print('this just executed');
        } else if (interestedCategories.interstingCategories.length == 2) {
          query = query.setFilters(
              'category: ${interestedCategories.interstingCategories[0]} OR category: ${interestedCategories.interstingCategories[1]}');
        } else if (interestedCategories.interstingCategories.length == 3) {
          query = query.setFilters(
              'category: ${interestedCategories.interstingCategories[0]} OR category: ${interestedCategories.interstingCategories[1]} OR category: ${interestedCategories.interstingCategories[2]}');
        }
      }
//      // print(query.toString());
      AlgoliaQuerySnapshot snap = await query.getObjects();
      List<AlgoliaObjectSnapshot> _algoliaSearch = [];

      // Checking if has [AlgoliaQuerySnapshot]
      // print("Snap ${snap.index}");
      // print('Hits count num 1: ${snap.nbHits}');
      _algoliaSearch = (await query.getObjects()).hits;
      // Set Settings
      _productList = _algoliaSearch;
      // print('this part hit');
      if (_productList == null || _productList.isEmpty) {
        // print('nooo why we searchin again');
        Algolia algolia = Application.algolia;
        AlgoliaQuery query =
            algolia.instance.index("simpleProductData").search('');
        query = query.setPage(pageCount);
        query = query.setHitsPerPage(5);
        query = query.setFacetFilter('approvalStatus:true');
        // query = query.setFacetFilter('version:full');
        query = query.setFacetFilter(
            ["country: ${Constants.country}", "hasInternationalShipping:true"]);
        query = query.setNumericFilter('qtyAvail > 0');
        AlgoliaQuerySnapshot snap = await query.getObjects();
        List<AlgoliaObjectSnapshot> _algoliaSearch = [];

        // Checking if has [AlgoliaQuerySnapshot]
        // print("Snap ${snap.index}");
        // print('Hits count 2: ${snap.nbHits}');

        for (int i = 0; i < snap.hits.length; i++) {
          // print('hit: ${snap.hits[i].data.toString()}');
        }
        _algoliaSearch = snap.hits;
        // Set Settings
        _productList = _algoliaSearch;
        // print('length of product list at the start: ${_productList.length}');
      } else {
        // print('oh no no no no no');
        AlgoliaQuerySnapshot snap = await query.getObjects();
        List<AlgoliaObjectSnapshot> _algoliaSearch = [];

        // Checking if has [AlgoliaQuerySnapshot]
        // print("Snap ${snap.index}");
        // print('Hits count 3: ${snap.nbHits}');
        _algoliaSearch = (await query.getObjects()).hits;
        // Set Settings
        _productList = _algoliaSearch;
      }
    } else if ((catTypeFilter == null || catTypeFilter == "") &&
        subCatSelected) {
      // print('god god god god god god');
      if (subCatText == "Preloved") {
        query = query.setFacetFilter('condition: $subCatText');
      } else if (subCatText == "Digital product") {
        query = query.setFacetFilter('productType: $subCatText');
        // print('productType $subCatText');
      } else if (subCatText == "International") {
        query = query.setFacetFilter('country: -${Constants.country}');
        // print('country $subCatText');
      } else if (subCatText == "Local") {
        query = query.setFacetFilter('country: ${Constants.country}');
        // print('country $subCatText');
      }
      AlgoliaQuerySnapshot snap = await query.getObjects();
      List<AlgoliaObjectSnapshot> _algoliaSearch = [];

      // Checking if has [AlgoliaQuerySnapshot]
      // print("Snap ${snap.index}");
      // print('Hits count 4: ${snap.nbHits}');
      _algoliaSearch = (await query.getObjects()).hits;

      _productList = _algoliaSearch;
    } else {
      // print('some error');
      if (catTypeFilter != "others" && subCatSelected) {
        if (newSubCategories != null) {
          query = query.setFacetFilter('subCategory : $newSubCategories');
        } else {
          query = query.setFacetFilter('category: $catTypeFilter');
        }
        if (subCatText == "Preloved") {
          query = query.setFacetFilter('condition: $subCatText');
          // print('condition $subCatText');
        } else if (subCatText == "Digital product") {
          query = query.setFacetFilter('productType: $subCatText');
          // print('productType $subCatText');
        } else if (subCatText == "International") {
          query = query.setFacetFilter('country: -${Constants.country}');
          // print('country $subCatText');
        } else if (subCatText == "Local") {
          query = query.setFacetFilter('country: ${Constants.country}');
          // print('country $subCatText');
        }
      }
      if (catTypeFilter != "others" && !subCatSelected) {
        if (newSubCategories != null) {
          query = query.setFacetFilter('subCategory : $newSubCategories');
        }
        query = query.setFilters('category: $catTypeFilter');
        // print('we\'re actually here');
        // print('filterCategories $catTypeFilter');
        // print(query.parameters);
      }
      AlgoliaQuerySnapshot snap = await query.getObjects();
      List<AlgoliaObjectSnapshot> _algoliaSearch = [];

      // Checking if has [AlgoliaQuerySnapshot]
      // print("Snap ${snap.index}");
      // print('Hits count 5: ${snap.nbHits}');
      _algoliaSearch = (await query.getObjects()).hits;

      _productList = _algoliaSearch;
    }

    // print('length of product list here: ${_productList.length}');
    List<FlashPromoAlgoliaObj> _productsList = List();
    try {
      for (int i = 0; i < _productList.length; i++) {
        AlgoliaObjectSnapshot snap = _productList[i];
        FlashPromoAlgoliaObj obj = FlashPromoAlgoliaObj.fromJson(snap.data);
        obj.size = await obj.calculateImageDimension();
        _productsList.add(obj);
        // print('simple product name ${obj.productName}');
      }
    } on Exception catch (e) {
      // print(e.toString());
      // print("there is an error!");
    }
    _productsAlgoliaSink.add(_productsList);
    return _productsList;
  }

  Future<int> addLikedItem(int productItem) async {
    final createUserUrl = '$_baseUrl${Constants.add_liked_item}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {
        "productNum": productItem.toString(),
      },
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status < 500;
          }),
    );
    // print(response.data.toString());
    // print(createUserUrl);

    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      // getProducts();
      return _status;
    } else {
      return _status;
    }
  }

  Future<int> deleteLikedItem(int productItem) async {
    final createUserUrl = '$_baseUrl${Constants.delete_liked_item}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {
        "productNum": productItem.toString(),
      },
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status < 500;
          }),
    );
    // print(response.data.toString());
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      // getProducts();
      return _status;
    } else {
      return _status;
    }
  }

  Future<BannerImagesModel> getBannersList() async {
    String banner = await _authRepository.getBanner();
    BannerImagesModel ibanner;
    String bannerDateStr = await _authRepository.getBannerDate();
    var difference;
    var currentDate;

    //check if a day has passed since the last banners have loaded
    if (bannerDateStr != null) {
      currentDate = DateTime.now();
      difference = currentDate.difference(DateTime.parse(bannerDateStr)).inDays;
    }

    //lood from database if no banners saved or last banners loaded has been more than a day - otherwise load the saved image urls locally
    if (banner == null || difference != null && difference > 1) {
      ibanner = await loadBannersFromNetwork();
      // print("Load banners from Network");
      _bannerSink.add(ibanner.imgUrLs);
      // print(jsonEncode(ibanner.toJson()));
      _authRepository.saveBanner(ibanner.toJson());
      currentDate = DateTime.now();
      _authRepository.saveBannerDate(currentDate.toString());
    } else {
      // print("Load banners from Local Response");
      Map<String, dynamic> constructedBanner = jsonDecode(banner);
      ibanner = BannerImagesModel.fromJson(constructedBanner);
      // currentDate = DateTime.now();
      // print('current date' + currentDate.toString());
    }
    return ibanner;
  }

  Future<String> getBannerImages() async {
    String banner = await _authRepository.getBanner();
    String bannerDateStr = await _authRepository.getBannerDate();
    var difference;
    if (bannerDateStr != null) {
      final date2 = DateTime.now();
      // print(DateTime.parse(bannerDateStr));
      // print(date2);
      difference = date2.difference(DateTime.parse(bannerDateStr)).inDays;
      // print('difference: ' + difference.toString());
    }
    if (difference != null && difference < 1) {
      if (banner != null) {
        ImageBanner imageBanner = ImageBanner.fromJson(jsonDecode(banner));
        _bannerSink.add(imageBanner.imgURLs);
        // print(bannerDateStr);
        // print('here');
        return null;
      }
    } else {
      // print('we are obtaining new images');
      final createUserUrl = '$_baseUrl${Constants.get_banner}';
      _token = await _authRepository.getUserFirebaseToken();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["Authorization"] = "Bearer $_token";
      dio.options.baseUrl = _baseUrl;
      final Response response = await dio.get(
        createUserUrl,
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              _bannerStatus = status;
              return status < 500;
            }),
      );
      // print(response.data);
      // print(createUserUrl);
      // print(response.headers);

      var banner = ImageBanner.fromJson(response.data);
      var urls = banner.imgURLs;
      for (var i = 0; i < urls.length; i++) {
        // print('banner img: ' + urls[i]);
      }

      // print(banner.imgURLs);
      _bannerSink.add(banner.imgURLs);
      if (_bannerStatus == 200) {
        // print("success ${_bannerStatus}");
        // final birthday = DateTime(1967, 10, 12);
        final date2 = DateTime.now();
        // final difference = date2.difference(birthday).inDays;
        _authRepository.saveBannerDate(date2.toString());
        _authRepository.saveBanner(banner);
        return banner.imgURLs.toString();
      } else {
        return banner.imgURLs.toString();
      }
    }
  }

  Future<BannerImagesModel> loadBannersFromNetwork() async {
    {
      // print('we are obtaining new images');
      final createUserUrl = '$_baseUrl${Constants.get_banner}';
      _token = await _authRepository.getUserFirebaseToken();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["Authorization"] = "Bearer $_token";
      dio.options.baseUrl = _baseUrl;
      final Response response = await dio.get(
        createUserUrl,
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              _bannerStatus = status;
              return status < 500;
            }),
      );
      // print(response.data);
      // print(createUserUrl);
      // print(response.headers);

      var banner = BannerImagesModel.fromJson(response.data);
      var urls = banner.imgUrLs;
      for (var i = 0; i < urls.length; i++) {
        // print('banner img: ' + urls[i]);
      }

      // print(banner.imgUrLs);

      if (_bannerStatus == 200) {
        // print("success ${_bannerStatus}");
        // final birthday = DateTime(1967, 10, 12);
        final date2 = DateTime.now();
        // final difference = date2.difference(birthday).inDays;
        _authRepository.saveBannerDate(date2.toString());
        _authRepository.saveBanner(banner);
        return banner;
      } else {
        return banner;
      }
    }
  }

  Future<String> addInterestedItems(List<String> itemList) async {
    final createUserUrl = '$_baseUrl${Constants.add_interested_categories}';
    _token = await _authRepository.getUserFirebaseToken();
    // _token = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjNlNTQyN2NkMzUxMDhiNDc2NjUyMDhlYTA0YjhjYTZjODZkMDljOTMiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vbWFya2V0LXNwYWFjZSIsImF1ZCI6Im1hcmtldC1zcGFhY2UiLCJhdXRoX3RpbWUiOjE2MDU2OTQxNzcsInVzZXJfaWQiOiJ6dnVqNWFxUnQwVktoV204NXJ0emh5VXFLcjIyIiwic3ViIjoienZ1ajVhcVJ0MFZLaFdtODVydHpoeVVxS3IyMiIsImlhdCI6MTYwNTY5NDE3NywiZXhwIjoxNjA1Njk3Nzc3LCJlbWFpbCI6ImVyYW5raXQ0dXVAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImVtYWlsIjpbImVyYW5raXQ0dXVAZ21haWwuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.Ke9F3mdtfM1qN2Qwr1sjve0H1jlZ35PsRx7a__nwdwHrtaUGfE-93qgpJO-EOGUE_4YNEbSCKfGNIrACPlxjwBYSKh7IsjPr22lUlztcxiAZGTeKFAj8B6pOi0IHZLrE0sPnwsKEIoI_iItBQIuOFlApkJuAet34F9tPibxcF1mrURxTtkqZzfVppTs2FTl_ivzkaUqx4WilKpWmMYbZHAuzcQmLsDLlubeEbgvOU4X-fV4KKrpkF6a53YTkUMZR3BuatQ-dUuBGpESF5Ler5BI83h_5HcpJ6z8zEVsP_qwXhh_o_vtdDMVAzCPB90jF2nRt6v9QPIH3Be7wzwjvQQ";
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"interestedCategories": itemList},
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _productStatus = status;
            return status < 500;
          }),
    );
    // print(response.data.toString());
    // print(createUserUrl);
    // print(response.headers);

    if (_productStatus == 200) {
      await _authRepository.saveCategoryAdded("true");
      InterestingCategoriesModel model = InterestingCategoriesModel();
      model.interstingCategories = List();
      model.interstingCategories.addAll(Constants.selectedChoices);
      // HashMap<String, InterestingCategoriesModel> intMap = HashMap();
      // intMap["interestingCategories"] = model;
      // var cat = InterestingCategoriesModel.fromJson('');
      await _authRepository.saveInterestingCategories(model);
      // print("success ${_productStatus}");
      return response.data.toString();
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
        // getActiveProducts();
      }
      return response.data.toString();
    }
  }

  Future<RatesModel> getCryptoRate() async {
    String prefCurrency = "AUD";
    // await _authRepository.getPrefferedCurrency();
    // // print('what is prefCurrency: ${prefCurrency}');
    // prefCurrency = "AUD";
    final createUserUrl = '$_baseUrl${Constants.get_rates}';
    try {
      _token = await _authRepository.getUserFirebaseToken();
    } catch (e) {
      // print("not logged!");
      _token = "emty token";
    }
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {
        "fiatCurrency": prefCurrency,
      },
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status <= 500;
          }),
    );
    // print(response.data.toString());
    // print(createUserUrl);
    // print(response.headers);
    if (response.statusCode == 200) {
      RatesModel model = RatesModel.fromJson(response.data);
      localProvider.storeRate(json.encode(response.data));
      // print('have we entered here');
      // print("success ${response.statusCode}");
      Constants.aud = model.fiatRates.aud;
      Constants.btc = model.cryptoRates.btc;

      return model;
    } else {
      // print('or did we actually enter here');
      Constants.aud = "1.00";
      Constants.btc = "1.00";
      return null;
    }
  }
}
