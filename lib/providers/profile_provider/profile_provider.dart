import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/model/active_products_model/active_product_model.dart';
import 'package:market_space/model/feedback/buyer_feedback_model.dart';
import 'package:market_space/model/feedback/feedback_model.dart';
import 'package:market_space/model/order_status_model/order_status_model.dart';
import 'package:market_space/model/profile_model/profile_model.dart';
import 'package:market_space/model/recently_bought_options/buyer_options.dart';
import 'package:market_space/model/recently_product_model/recently_brought_model.dart';
import 'package:market_space/model/sold_product_model/sold_product_model.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

class ProfileProvider {
  final _baseUrl =
      'https://australia-southeast1-market-spaace.cloudfunctions.net';
  Dio dio = new Dio();
  final AuthRepository _authRepository = AuthRepository();
  String _token;
  int _status;
  final BehaviorSubject<ProfileModel> _profileSink = BehaviorSubject();
  Stream<ProfileModel> get profileStream => _profileSink.stream;

  final BehaviorSubject<List<Orders>> _Ordersink = BehaviorSubject();

  Stream<List<Orders>> get Orderstream => _Ordersink.stream;

  final BehaviorSubject<OrderStatusModel> _orderStatusSink = BehaviorSubject();

  Stream<OrderStatusModel> get orderStatusStream => _orderStatusSink.stream;

  final BehaviorSubject<List<RecentlyBrought>> _recentlyBoughtSink =
      BehaviorSubject();

  Stream<List<RecentlyBrought>> get recentlyBought =>
      _recentlyBoughtSink.stream;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final BehaviorSubject<List<ActiveProducts>> _activeProductSink =
      BehaviorSubject();
  final BehaviorSubject<List<Results>> _feedbackSink = BehaviorSubject();
  final BehaviorSubject<List<BuyerFeedback>> _feedbackBuyerSink =
      BehaviorSubject();
  final BehaviorSubject<List<Order_overview>> _orderOverViewSink =
      BehaviorSubject();
  final BehaviorSubject<ShippingAddress> _shipingAddressSink =
      BehaviorSubject();
  final BehaviorSubject<PaymentMethod> _paymentSink = BehaviorSubject();
  final BehaviorSubject<ClaimOptions> _claimOptionsSink = BehaviorSubject();

  Stream<List<ActiveProducts>> get activeProductStream =>
      _activeProductSink.stream;

  Stream<List<Results>> get feedbackStream => _feedbackSink.stream;

  Stream<List<BuyerFeedback>> get feedbackBuyerStream =>
      _feedbackBuyerSink.stream;

  Stream<List<Order_overview>> get orderOverviewStream =>
      _orderOverViewSink.stream;

  Stream<PaymentMethod> get paymentMethodStream => _paymentSink.stream;

  Stream<ClaimOptions> get claimOptionStream => _claimOptionsSink.stream;

  Future<List<ActiveProducts>> getActiveProducts() async {
    final createUserUrl = '$_baseUrl${Constants.get_active_products}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {},
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
      var data = ActiveProductModel.fromJson(response.data);
      // _activeProductSink.add(data.activeProducts);
      return data.activeProducts;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
        // getActiveProducts();
      }
      return null;
    }
  }

  Future<int> editBio(String bio, bool isSeller) async {
    final createUserUrl = '$_baseUrl${Constants.edit_bio}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {
        "bio": bio,
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
      getProfileData(isSeller);
      return _status;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
        // getActiveProducts();
      }
      return _status;
    }
  }

  Future<ProfileModel> getProfileData(bool isSeller) async {
    final createUserUrl = '$_baseUrl${Constants.get_profile_data}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"sellerData": isSeller.toString()},
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );
    // print(response.data.toString());
    // print(response.headers);
    var profileData;
    if (_status == 200) {
      // print("success ${_status}");
      if (response.data == "OK") {
        profileData = null;
        _profileSink.add(null);
      } else {
        profileData = ProfileModel.fromJson(response.data);
        _profileSink.add(profileData);
      }
      return profileData;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
        // getActiveProducts();
      }
      return profileData;
    }
  }

  Future<int> setProfileUrl(String url, bool isSeller) async {
    final createUserUrl = '$_baseUrl${Constants.set_profile_url}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"profileURL": url},
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
      getProfileData(isSeller);
      return _status;
    } else {
      return _status;
    }
  }

  Future<int> setBackgroundUrl(String url, bool isSeller) async {
    final createUserUrl = '$_baseUrl${Constants.set_background_url}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"backgroundURL": url},
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
      getProfileData(isSeller);
      return _status;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
        // getActiveProducts();
      }
      return _status;
    }
  }

  Future<List<Orders>> getOrders() async {
    final createUserUrl = '$_baseUrl${Constants.get_seller_orders}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"orderID": "ms5"},
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );
    // print(response.data.toString());
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      var data = SoldProductModel.fromJson(response.data);
      _Ordersink.add(data.orders);
      return data.orders;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
        // getActiveProducts();
      }
      return null;
    }
  }

  Future<int> getFeedback(int feedbackId, bool isSeller) async {
    String createUserUrl;
    if (isSeller) {
      createUserUrl = '$_baseUrl${Constants.get_seller_feedback}';
    } else {
      createUserUrl = '$_baseUrl${Constants.get_buyer_feedback}';
    }
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    if (feedbackId == 0) {
      final Response response = await dio.post(
        createUserUrl,
        data: {},
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
        if (isSeller) {
          var feedback = FeedbackModel.fromJson(response.data);
          _feedbackSink.add(feedback.results);
        } else {
          var feedback = BuyerFeedbackModel.fromJson(response.data);
          _feedbackBuyerSink.add(feedback.results);
        }
        // print("success ${_status}");
        return _status;
      } else {
        if (response.data.toString() == "User is not authorized") {
          _token = await firebaseAuth.currentUser.getIdToken(true);
          _authRepository.saveUserFirebaseToken(_token);
          // print(_token);
          // getActiveProducts();
        }
        return _status;
      }
    } else {
      final Response response = await dio.post(
        createUserUrl,
        data: {"feedbackID": feedbackId},
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
        if (isSeller) {
          var feedback = FeedbackModel.fromJson(response.data);
          _feedbackSink.add(feedback.results);
        } else {
          var feedback = BuyerFeedbackModel.fromJson(response.data);
          _feedbackBuyerSink.add(feedback.results);
        }
        // print("success ${_status}");
        return _status;
      } else {
        if (response.data.toString() == "User is not authorized") {
          _token = await firebaseAuth.currentUser.getIdToken(true);
          _authRepository.saveUserFirebaseToken(_token);
          // print(_token);
          // getActiveProducts();
        }
        return _status;
      }
    }
  }

  Future<List<RecentlyBrought>> getRecentBrought(String orderId) async {
    String createUserUrl;
    createUserUrl = '$_baseUrl${Constants.get_recently_bought}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    // print('getrecent bought hit');
    // print('orderID from api' + orderId);
    final Response response = await dio.post(
      createUserUrl,
      data: orderId == null || orderId == "0" ? {} : {"orderID": orderId},
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );
    // print(response.data.toString());
    // print(response.headers);
    // print("did this succeed: ${_status}");
    // print(response.data.toString());
    if (_status == 200) {
      // print('in this????');
      var orders = RecentlyBroughtModel.fromJson(response.data);
      // print("orders at api: ${orders.orders}");
      _recentlyBoughtSink.add(orders.orders);
      // print("success recent bought ${_status}");
      return orders.orders;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
        // getActiveProducts();
      }
      return null;
    }
  }

  Future<OrderStatusModel> getOrderStatus(String orderID) async {
    final createUserUrl = '$_baseUrl${Constants.get_order_status}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"orderID": orderID},
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );
    // print(response.data.toString());
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      var data = OrderStatusModel.fromJson(response.data);
      _orderStatusSink.add(data);
      return data;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
        // getActiveProducts();
      }
      return null;
    }
  }

  Future<int> confirmReceptionOfItem(String orderId) async {
    final createUserUrl = '$_baseUrl${Constants.confirm_reception_item}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"orderID": orderId},
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );
    // print(response.data.toString());
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      return _status;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
        // getActiveProducts();
      }
      return _status;
    }
  }

  Future<BuyerOptions> getBuyerOptions(String orderId) async {
    final createUserUrl = '$_baseUrl${Constants.get_buyer_options}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"orderID": orderId},
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );
    // print('response: ' + response.data.toString());
    // print(response.headers);

    if (_status == 200) {
      BuyerOptions options = BuyerOptions.fromJson(response.data);
      // Order_overview.fromJson(options.orderOverview);
      // ShippingAddress.fromJson(options.shippingAddress);
      // _orderOverViewSink.add(options.orderOverview);
      // _shipingAddressSink.add(options.shippingAddress);
      // _paymentSink.add(options.paymentMethod);
      // _claimOptionsSink.add(options.claimOptions);
      // print('buyer options $options');
      // print("success ${_status}");
      return options;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
        // getActiveProducts();
      }
      return null;
    }
  }

  Future<int> cancelBuyerOrder(
      String orderId, String reason, String detailReason) async {
    final createUserUrl = '$_baseUrl${Constants.buyer_cancel_order}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {
        "orderID": orderId,
        "reason": reason,
        "detailedReason": detailReason
      },
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );
    // print(response.data.toString());
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      return _status;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
        // getActiveProducts();
      }
      return _status;
    }
  }

  Future<int> buyerRaiseClaim(
      String orderId, String reason, String detailReason) async {
    final createUserUrl = '$_baseUrl${Constants.buyer_raise_claim}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {
        "orderID": orderId,
        "reason": reason,
        "detailedReason": detailReason
      },
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );
    // print(response.data.toString());
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      return _status;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
        // getActiveProducts();
      }
      return _status;
    }
  }

  Future<int> leaveSellerFeedback(
      String orderId, int rating, String comment) async {
    final createUserUrl = '$_baseUrl${Constants.leave_seller_feedback}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {
        "orderID": orderId,
        "feedbackStars": rating,
        "feedbackComment": comment
      },
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );
    // print(response.data.toString());
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      return _status;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
        // getActiveProducts();
      }
      return _status;
    }
  }
}
