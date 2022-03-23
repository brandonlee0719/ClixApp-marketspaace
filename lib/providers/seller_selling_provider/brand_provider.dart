import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';

class BrandProvider {
  final AuthRepository _authRepository = AuthRepository();
  final _baseUrl =
      'https://australia-southeast1-market-spaace.cloudfunctions.net';
  Dio dio = new Dio();
  String _token;
  int _status;

  Future<List<String>> getAvailableBrands() async {
    String _uid = await _authRepository.getUserId();
    // print(_uid);
    final createUserUrl = '$_baseUrl${Constants.get_brands}';
    _token = await _authRepository.getUserFirebaseToken();
    // print('token ${_token}');
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    var data = {};

    final Response response = await dio.post(
      createUserUrl,
      data: data,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );

    if (_status == 200) {
      Map<String, dynamic> responseData = response.data;
      // print(responseData.runtimeType);
      // print('success ${responseData["brandNames"]}');
      // print(responseData["brandNames"].runtimeType);
      List<String> brandNames =
          new List<String>.from(responseData["brandNames"]);
      return brandNames;
    } else {
      // print("failure ${response.data}");
      return response.data;
    }
  }
}
