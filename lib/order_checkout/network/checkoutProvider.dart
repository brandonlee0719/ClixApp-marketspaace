import 'package:dio/dio.dart';
import 'package:market_space/apis/orderApi/orderManager.dart';
import 'package:market_space/investment/sell_assets/screens/orderPreview.dart';
import 'package:market_space/order_checkout/model/chekout_mode.dart';
import 'package:market_space/order_checkout/order_checkout_route.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/services/locator.dart';

class CheckoutProvider {
  final _marketSpaaceUrl =
      "https://australia-southeast1-market-spaace.cloudfunctions.net";
  Dio _dio = new Dio();

  final _checkoutEndPoint = "/checkout_order";
  final _authEndPoint = "/authorize_card_order";
  final _createCryptoOrderEndpoint = "/create_wallet_order";
  final _sellCryptoEndpoint = "/create_sell_order";
  final _buyCryptoEndPoint = "/buy_asset";
  final _finalizeCryptoPurchase = "/authorise_asset_order";
  final _confirmSellEndPoint = "/confirm_sell_order";

  Future<TradeCryptoModel> createCryptoOrder(
      String useSourceOrDest, String destCurrency, String destAmount) async {
    // print("creating buying crypto order...");
    var data = {
      "destCurrency": destCurrency,
      "sourceCurrency": "AUD",
      if (useSourceOrDest == "dest") "destAmount": destAmount,
      if (useSourceOrDest == "source") "sourceAmount": destAmount,
      "useSourceOrDest": useSourceOrDest,
      "billingFirstName": "Nivasan",
      "billingLastName": "Babu Srinivasan",
      "phoneNumber": "+61481320052",
      "email": "nivasan.bs@gmail.com",
      "countryCode": "AU",
      "billingPostCode": "3752",
      "billingStreetAddressTwo": "Melbourne",
      "billingStreetAddress": "20 Greenhaven Gardens",
      "billingState": "Victoria"
    };
    // print(data);
    final AuthRepository _authRepository = AuthRepository();
    String finalUrl = _marketSpaaceUrl + _createCryptoOrderEndpoint;
    String _token = await _authRepository.getUserFirebaseToken();
    _dio.options.headers['content-Type'] = 'application/json';
    _dio.options.headers['Authorization'] = 'Bearer $_token';
    final Response response = await _dio.post(
      finalUrl,
      data: data,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status <= 500;
          }),
    );
    // print(response.data);
    if (response.statusCode == 200) {
      return TradeCryptoModel.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<TradeCryptoModel> sellCrypto(
      String source, String amount, String currencyOfSale) async {
    final url = _marketSpaaceUrl + _sellCryptoEndpoint;
    Map<String, dynamic> map = {
      "sourceCurrency": source,
      "sourceAmount": amount,
      "currencyOfSale": currencyOfSale
    };
    // print(map);
    final response = await _sendRequest(url, map);
    // print(response.data);
    if (response.statusCode == 200) {
      return TradeCryptoModel.fromJson(response.data, isSell: true);
    } else {
      return null;
    }
  }

  Future<int> confirmSell(String id) async {
    final url = _marketSpaaceUrl + _confirmSellEndPoint;
    Map<String, dynamic> data = {"transferID": id};
    final response = await _sendRequest(url, data);
    return response.statusCode;
  }

  Future<Response> _sendRequest(String url, Map<String, dynamic> data) async {
    final AuthRepository _authRepository = AuthRepository();
    String _token = await _authRepository.getUserFirebaseToken();
    _dio.options.headers['content-Type'] = 'application/json';
    _dio.options.headers['Authorization'] = 'Bearer $_token';
    // print(data);
    final Response response = await _dio.post(
      url,
      data: data,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status <= 500;
          }),
    );
    // print(response.data);
    return response;
  }

  Future<Map<String, dynamic>> buyCrypto(Map<String, dynamic> map) async {
    // print("creating buying crypto order...");

    String finalUrl = _marketSpaaceUrl + _buyCryptoEndPoint;

    final Response response = await _sendRequest(finalUrl, map);
    // print(response.data);
    if (response.statusCode == 200) {
      // print(response.data);
      return response.data;
    } else {
      return null;
    }
  }

  Future<int> finalizePurchase(Map<String, dynamic> map) async {
    // print("creating buying crypto order...");
    final AuthRepository _authRepository = AuthRepository();
    String finalUrl = _marketSpaaceUrl + _finalizeCryptoPurchase;
    String _token = await _authRepository.getUserFirebaseToken();
    _dio.options.headers['content-Type'] = 'application/json';
    _dio.options.headers['Authorization'] = 'Bearer $_token';
    final Response response = await _dio.post(
      finalUrl,
      data: map,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status <= 500;
          }),
    );
    // print(response.data);
    return response.statusCode;
  }

  Future<int> checkOut(CheckModel check) async {
    check.ip = await getPublicIP();
    // print(check.toJson());
    String finalUrl = _marketSpaaceUrl + _checkoutEndPoint;
    final AuthRepository _authRepository = AuthRepository();
    String _token = await _authRepository.getUserFirebaseToken();
    _dio.options.headers['content-Type'] = 'application/json';
    _dio.options.headers['Authorization'] = 'Bearer $_token';

    final Response response = await _dio.post(
      finalUrl,
      data: check.toJson(),
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status <= 500;
          }),
    );
    // print("response data is: " + response.data.toString());
    if (response.statusCode == 200) {
      if (locator<OrderManager>().paymentMethod == PaymentMethodType.card) {
        locator<OrderManager>().orderId = response.data["unauthCardOrderID"];
        locator<OrderManager>().cardAuth = response.data;
      }
    }
    return response.statusCode;
  }

  Future<int> authenticateCard(Map data) async {
    // print(data);
    String finalUrl = _marketSpaaceUrl + _authEndPoint;
    final AuthRepository _authRepository = AuthRepository();
    String _token = await _authRepository.getUserFirebaseToken();
    _dio.options.headers['content-Type'] = 'application/json';
    _dio.options.headers['Authorization'] = 'Bearer $_token';

    final Response response = await _dio.post(
      finalUrl,
      data: data,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status <= 500;
          }),
    );
    // print("response data is: " + response.data.toString());

    return response.statusCode;
  }

  Future<String> getPublicIP() async {
    try {
      const url = 'https://api.ipify.org';
      var response = await _dio.get(url);
      if (response.statusCode == 200) {
        // The response body is the IP in plain text, so just
        // return it as-is.
        return response.data;
      } else {
        // The request failed with a non-200 code
        // The ipify.org API has a lot of guaranteed uptime
        // promises, so this shouldn't ever actually happen.
        // print(response.statusCode);
        // print(response.data);
        return null;
      }
    } catch (e) {
      // Request failed due to an error, most likely because
      // the phone isn't connected to the internet.
      // print(e);
      return null;
    }
  }
}
