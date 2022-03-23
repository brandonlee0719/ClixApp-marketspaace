import 'dart:convert';
import 'dart:io';

import 'package:algolia/algolia.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/model/product_detail_model/product_det_model.dart';
import 'package:market_space/model/recent_product_feedback/recent_product_feedback.dart';
import 'package:market_space/model/shipping_price_model/shipping_price_model.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';

class ProductDetailProvider {
  final _baseUrl =
      'https://australia-southeast1-market-spaace.cloudfunctions.net';
  Dio dio = new Dio();
  final AuthRepository _authRepository = AuthRepository();
  String _token;
  int _status;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool _isChinese = false;
  List<AlgoliaObjectSnapshot> _productSnapshot = [];
  List<AlgoliaObjectSnapshot> _relatedItemsSnapshot = [];

  // Future<ProductDetModel> getProduct(int productNum) async {
  //   _isChinese = await _authRepository.getLanguage()=="chinese"?true:false;
  //   final createUserUrl = '$_baseUrl${Constants.get_product}';
  //   _token = await _authRepository.getUserFirebaseToken();
  //   dio.options.headers['content-Type'] = 'application/json';
  //   dio.options.headers["Authorization"] = "Bearer $_token";
  //   dio.options.baseUrl = _baseUrl;
  //   final Response response = await dio.post(
  //     createUserUrl,
  //     data: {
  //       "productNum": productNum,
  //     },
  //     options: Options(
  //         followRedirects: false,
  //         validateStatus: (status) {
  //           _status = status;
  //           return status <= 500;
  //         }),
  //   );
  //   // print(response.data.toString());
  //   // print(createUserUrl);
  //   // print(response.request.data.toString());
  //   // print(response.headers);
  //
  //   if (_status == 200) {
  //     // print("success ${_status}");
  //     var data = ProductDetModel.fromJson(response.data);
  //     return data;
  //   } else {
  //     if(response.data.toString() == "User is not authorized"){
  //       _token = await firebaseAuth.currentUser.getIdToken(true);
  //       _authRepository.saveUserFirebaseToken(_token);
  //       // print(_token);
  //     }
  //     return null;
  //   }
  // }

  Future<List<RecentFeedback>> getRecentFeedback(
      int productNum, int feedbackID) async {
    final createUserUrl = '$_baseUrl${Constants.get_product_feedback}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"feedbackID": feedbackID, "productNum": productNum},
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
      var data = RecentProductFeedback.fromJson(response.data);
      return data.results;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
      }
      return null;
    }
  }

  Future<ProductDetModel> getProduct(int productNum) async {
    // print('do we actually enter this');
    Algolia algolia = Application.algolia;
    AlgoliaQuery query = algolia.instance.index("fullProductData").search(' ');
    query = query.setFacetFilter('approvalStatus:true');
    query = query.setFacetFilter('productNum:$productNum');

    AlgoliaQuerySnapshot snap = await query.getObjects();
    List<AlgoliaObjectSnapshot> _algoliaSearch = [];

    // Checking if has [AlgoliaQuerySnapshot]
    // print("Snap ${snap.index}");
    // print('Hits count: ${snap.nbHits}');
    _algoliaSearch = (await query.getObjects()).hits;

    _productSnapshot = _algoliaSearch;
    // print(_productSnapshot);
    // List<FlashPromoAlgoliaObj> _flashList = List();
    // for (int i = 0; i < _flashPromo.length; i++) {
    //   AlgoliaObjectSnapshot snap = _flashPromo[i];
    // print(_productSnapshot);
    if (_productSnapshot != null && _productSnapshot.isNotEmpty) {
      // print('confused');
      // print(_productSnapshot[0].data);
      ProductDetModel obj = ProductDetModel.fromJson(_productSnapshot[0].data);
      // print('does the object get completed');
      // print(obj.toJson());
      return obj;
    } else {
      // print('its empty??');
      return null;
    }
  }

  Future<List<RelatedItems>> getRelatedItems(
      String catSelected, int pageCount) async {
    // print('anything weird here??');
    Algolia algolia = Application.algolia;
    AlgoliaQuery query =
        algolia.instance.index("simpleProductData").search(' ');
    query.setHitsPerPage(10);
    query.setPage(pageCount);
    // catSelected = "office";
    catSelected = catSelected.replaceAll(" ", "_");
    catSelected = catSelected.replaceAll("'", "-");
    query = query.setFilters('category:${catSelected}');
    // query.setFacetFilter('category:Technology');
    query = query.setFacetFilter('approvalStatus:true');
    query = query.setNumericFilter('qtyAvail>0');
    // print('this?');
    // catSelected = "office";
    // print(catSelected);
    AlgoliaQuerySnapshot snap =
        await query.getObjects().timeout(Duration(milliseconds: 500));
    // print('error??');
    List<AlgoliaObjectSnapshot> _algoliaSearch = [];
    // print('section of code');
    // Checking if has [AlgoliaQuerySnapshot]
    // print("Snap ${snap.index}");
    // print('Hits count: ${snap.nbHits}');

    _algoliaSearch = snap.hits;
    // print('malo malo malo');
    // AlgoliaIndexSettings settingsRef =
    //     algolia.instance.index('fullProductData').settings;
    //
    // // Get Settings
    // Map<String, dynamic> currentSettings = await settingsRef.getSettings();
    //
    // // Checking if has [Map]
    // print('\n\n');
    // // print(currentSettings);
    //
    // // Set Settings
    // AlgoliaSettings settingsData = settingsRef;
    // settingsData =
    //     settingsData.setReplicas(const ['index_copy_1', 'index_copy_2']);
    // AlgoliaTask setSettings = await settingsData.setSettings();
    // // Checking if has [AlgoliaTask]
    // print('\n\n');
    // // print(setSettings.data);
    _relatedItemsSnapshot = _algoliaSearch;
    // print(_relatedItemsSnapshot);
    // print('hello???');
    List<RelatedItems> _relatedList = List();
    if (_relatedItemsSnapshot != null) {
      for (int i = 0; i < _relatedItemsSnapshot.length; i++) {
        AlgoliaObjectSnapshot snap = _relatedItemsSnapshot[i];
        RelatedItems obj = RelatedItems.fromJson(snap.data);
        _relatedList.add(obj);
      }
      return _relatedList;
    } else {
      return null;
    }
  }

  Future<SellerData> getSellerDetails(int productNum) async {
    final createUserUrl = '$_baseUrl${Constants.get_seller_details}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"productNum": productNum},
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
      var data = SellerData.fromJson(response.data);
      return data;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
      }
      // // print(
      //     "the get userSellerDetails provider is doing wrong, the message from api is:" +
      // response.data.toString());
      return null;
    }
  }

  Future<ShippingPriceModel> calculateShipping(
      int productNum, String zipCode, String country) async {
    final createUserUrl = '$_baseUrl${Constants.shipping_calculator}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"productNum": 50, "postcode": "3752", "country": country},
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
      ShippingPriceModel model = ShippingPriceModel.fromJson(response.data);
      return model;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
      }
      return null;
    }
  }
}
