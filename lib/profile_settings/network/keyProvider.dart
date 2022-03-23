import 'package:dio/dio.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';

class KeyProvider {
  final _marketSpaaceUrl =
      "https://australia-southeast1-market-spaace.cloudfunctions.net";
  String _uid;
  Dio dio = new Dio();
  final AuthRepository _authRepository = AuthRepository();

  Future<String> getData(String endPoint, String key) async {
    _uid = await _authRepository.getUserId();
    final createUserUrl = _marketSpaaceUrl + endPoint;
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.baseUrl = _marketSpaaceUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {
        "uid": _uid,
      },
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status <= 500;
          }),
    );
    if (response.statusCode != 200) {
      return null;
    }
    // print(response.data[key]);
    return response.data[key];
  }

  Future<String> getToken() async {
    String token = await getData("/get_vault_data", "token");
    // print(token);
    return token;
  }

  Future<bool> hasCredit() async {
    _uid = await _authRepository.getUserId();
    final createUserUrl = _marketSpaaceUrl + "/get_vault_data";
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.baseUrl = _marketSpaaceUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {
        "uid": _uid,
      },
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status <= 500;
          }),
    );
    if (response.statusCode != 200) {
      return false;
    }
    // print(response.data.toString());
    return true;
  }

  Future<String> getKey() async {
    String key = await getData("/get_key_data", "passphrase");
    // print(key);
    return key;
  }
}
