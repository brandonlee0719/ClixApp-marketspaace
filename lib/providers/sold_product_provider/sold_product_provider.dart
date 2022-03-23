import 'package:dio/dio.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/model/buyer_info_model/buyer_info_model.dart';
import 'package:market_space/model/feedback/feedback_model.dart';
import 'package:market_space/model/seller_option_model/seller_options_model.dart';
import 'package:market_space/model/sold_product_model/sold_product_model.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

class SoldProductProvider {
  final _baseUrl =
      'https://australia-southeast1-market-spaace.cloudfunctions.net';
  Dio dio = new Dio();
  final AuthRepository _authRepository = AuthRepository();
  String _token;
  int _status;
  final BehaviorSubject<List<Orders>> _Ordersink = BehaviorSubject();
  Stream<List<Orders>> get Orderstream => _Ordersink.stream;

  final BehaviorSubject<BuyerInfoModel> _buyerInfosink = BehaviorSubject();
  Stream<BuyerInfoModel> get buyerInfotream => _buyerInfosink.stream;
  bool _isChinese = false;

  Future<int> getOrders() async {
    _isChinese =
        await _authRepository.getLanguage() == "chinese" ? true : false;
    final createUserUrl = '$_baseUrl${Constants.get_seller_orders}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"orderID": "ms5", "chineseLanguage": _isChinese},
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status < 500;
          }),
    );
    // print(response.data.toString());
    // print(response.headers);
    var data = SoldProductModel.fromJson(response.data);
    _Ordersink.add(data.orders);

    if (_status == 200) {
      // print("success ${_status}");
      return _status;
    } else {
      return _status;
    }
  }

  Future<int> updateSellerTracking(String orderId, String shippingCompany,
      String trackingNumber, String shippingDate) async {
    final createUserUrl = '$_baseUrl${Constants.update_seller_tracking}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {
        "orderID": orderId,
        "shippingCompany": shippingCompany,
        "shipmentDate": shippingDate,
        "trackingNumber": trackingNumber
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
      return _status;
    } else {
      return _status;
    }
  }

  Future<BuyerInfoModel> getBuyerInfo(String order) async {
    final createUserUrl = '$_baseUrl${Constants.get_buyer_data}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"orderID": order},
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status < 500;
          }),
    );
    // print(response.data.toString());
    // print(response.headers);
    var data = BuyerInfoModel.fromJson(response.data);
    _buyerInfosink.add(data);

    if (_status == 200) {
      // print("success ${_status}");
      return data;
    } else {
      return data;
    }
  }

  Future<int> cancelOrder(
      String orderId, String reason, String reasonDetails) async {
    final createUserUrl = '$_baseUrl${Constants.get_buyer_data}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {
        "orderID": orderId,
        "reason": reason,
        "detailedReason": reasonDetails
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
      return _status;
    } else {
      return _status;
    }
  }

  Future<int> extendProtection(
      String orderId, String reason, int extensionTime) async {
    final createUserUrl = '$_baseUrl${Constants.get_buyer_data}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {
        "orderID": orderId,
        "reason": reason,
        "extensionTime": extensionTime
      },
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status < 500;
          }),
    );
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      return _status;
    } else {
      return _status;
    }
  }

  Future<int> markItemShipped(String orderId, String shippingDate) async {
    final createUserUrl = '$_baseUrl${Constants.mark_item_shipped}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"orderID": orderId, "shipmentDate": shippingDate},
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status < 500;
          }),
    );
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      await _sendSoldNotification();
      return _status;
    } else {
      return _status;
    }
  }

  Future<SellerOptionsModel> sellerOptions(String orderId) async {
    final createUserUrl = '$_baseUrl${Constants.seller_options}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {
        "orderID": orderId,
      },
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status < 500;
          }),
    );
    // print(response.headers);
    var data = SellerOptionsModel.fromJson(response.data);

    if (_status == 200) {
      // print("success ${_status}");
      // _buyerInfosink.add(data);
      return data;
    } else {
      return data;
    }
  }

  Future<int> raiseClaim(
      String orderId, String reason, String reasonDetails) async {
    final createUserUrl = '$_baseUrl${Constants.get_buyer_data}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {
        "orderID": orderId,
        "reason": reason,
        "detailedReason": reasonDetails
      },
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status < 500;
          }),
    );
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      return _status;
    } else {
      return _status;
    }
  }

  Future<int> leaveFeedback(
      String orderId, double rating, String comment) async {
    final createUserUrl = '$_baseUrl${Constants.get_buyer_data}';
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
            return status < 500;
          }),
    );

    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      return _status;
    } else {
      return _status;
    }
  }

  Future<int> _sendSoldNotification() async {
    final createUserUrl = '$_baseUrl${Constants.test_recently_sold}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    String deviceToken = await _authRepository.getDeviceToken();
    final Response response = await dio.post(
      createUserUrl,
      data: {"deviceTokenID": deviceToken},
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status < 500;
          }),
    );
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      return _status;
    } else {
      return _status;
    }
  }
}
