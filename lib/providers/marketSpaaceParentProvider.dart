import 'dart:async';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';

class MarketSpaceParentProvider {
  final _baseUrl =
      'https://australia-southeast1-market-spaace.cloudfunctions.net';
  final AuthRepository _authRepository = AuthRepository();
  String _token;

  Future<Dio> createDio() async {
    Dio dio = new Dio();
    try {
      _token = await _authRepository.getUserFirebaseToken();
    } catch (e) {
      // print("The user is not logged in so they won't be having any id token!");
      _token = "not assigned!";
    }
    // print(_token);
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    return dio;
  }

  Future<Response> post(String endPoint, Map<String, dynamic> data) async {
    Dio dio = await createDio();
    final finalUrl = _baseUrl + endPoint;

    final Response response = await dio.post(
      finalUrl,
      data: data,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            status = status;
            return status < 500;
          }),
    );

    return response;
  }
}
