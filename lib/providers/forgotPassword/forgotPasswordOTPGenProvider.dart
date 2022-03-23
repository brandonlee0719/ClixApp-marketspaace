import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

class ForgotPasswordOtpGenProvider {
  final _baseUrl =
      'https://australia-southeast1-market-spaace.cloudfunctions.net';
  Dio dio = new Dio();
  final AuthRepository _authRepository = AuthRepository();

  PublishSubject _loading = PublishSubject();
  int _status;

  Future<String> getOTPFromEmail(String email) async {
    final createUserUrl = '$_baseUrl/generate_otp_reset';
    String _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    // dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"email": email, "isApp": "true"},
      options: Options(
          // headers: {
          //   'Content-type': 'application/json',
          //   "Authorization": "Bearer $_token"
          // },
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
      return response.data.toString();
    } else {
      return response.data.toString();
    }
  }

  Future<String> validateOTP(
      String email, String pass, String confirmPass, String otp) async {
    final createUserUrl = '$_baseUrl/generate_otp_reset';
    String _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    // dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {
        "email": email,
        "password": pass,
        "confirmPass": confirmPass,
        "otp": otp,
        "isApp": "true"
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
      return response.data.toString();
    } else {
      return response.data.toString();
    }
  }
}
