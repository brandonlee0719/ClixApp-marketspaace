import 'package:dio/dio.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/model/active_products_model/active_product_model.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

class ActiveProductProvider {
  final _baseUrl =
      'https://australia-southeast1-market-spaace.cloudfunctions.net';
  Dio dio = new Dio();
  final AuthRepository _authRepository = AuthRepository();
  String _token;
  int _status;
  final BehaviorSubject<List<ActiveProducts>> _activeProductSink =
      BehaviorSubject();

  Stream<List<ActiveProducts>> get activeProductStream =>
      _activeProductSink.stream;
  bool _isChinese = false;

  Future<int> getActiveProducts() async {
    _isChinese =
        await _authRepository.getLanguage() == "chinese" ? true : false;
    final createUserUrl = '$_baseUrl${Constants.get_active_products}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"chineseLanguage": _isChinese},
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );
    // print(response.data.toString());

    var data = ActiveProductModel.fromJson(response.data);
    _activeProductSink.add(data.activeProducts);

    if (_status == 200) {
      // print("success ${_status}");
      if (response != null && response.data != null) {
        var data = ActiveProductModel.fromJson(response.data);
        _activeProductSink.add(data.activeProducts);
      }
      return _status;
    } else {
      return _status;
    }
  }

  Future<int> getActiveSingleProduct(
    int productNum,
  ) async {
    final createUserUrl = '$_baseUrl${Constants.get_active_products}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {
        "productNum": productNum,
        "cryptoCurrency": "ETH",
        "currency": "USD",
        "chineseLanguage": _isChinese
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
    var data = ActiveProductModel.fromJson(response.data);
    _activeProductSink.add(data.activeProducts);

    if (_status == 200) {
      // print("success ${_status}");
      return _status;
    } else {
      return _status;
    }
  }
}
