import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:market_space/common/constants.dart';
import 'package:market_space/model/signUp/sign_up_request.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/signup/general_info_bloc.dart';
import 'package:rxdart/rxdart.dart';

class SignUpApiClient {
  final _baseUrl =
      'https://australia-southeast1-market-spaace.cloudfunctions.net';
  final http.Client httpClient = http.Client();
  Dio dio = new Dio();

  PublishSubject _loading = PublishSubject();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _token = "aWWGjTFm6wcU1U4hLJztzPgpYE53";
  FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthRepository authRepository = AuthRepository();

  Future<User> registerWithEmailAndPassword(
      String email, String password) async {
    _loading.add(true);
    User user;
    try {
      user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email.toLowerCase(), password: password))
          .user;
      assert(user != null);
      assert(user.email != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      _token = await user.getIdToken();
      // print("firebase token $_token");
      _loading.add(false);
      authRepository.saveUserFirebaseToken(_token);
      authRepository.saveUserUid(user.uid);
      authRepository.saveSignUpAs(Constants.emailSigned);
      GeneralInfoBloc.signUpToast = null;
      // print(user.uid);
      return user;
    } catch (signUpError) {
      // if (signUpError is PlatformException) {
      if (signUpError.code == 'email-already-in-use') {
        _loading.add(false);
        // print(signUpError.code);
        GeneralInfoBloc.signUpToast = "Email already in use";
        // return await signInWithEmailPass(email.toLowerCase(), password);
      }
      // }
      return user;
    }
  }

  Future<User> signInWithEmailPass(String email, String password) async {
    User user;
    try {
      user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email.toLowerCase(), password: password))
          .user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      _token = await user.getIdToken();
      // print("firebase token $_token");
      authRepository.saveUserFirebaseToken(_token);
      authRepository.saveEmail(email.toLowerCase());
      authRepository.savePassword(password);
      authRepository.saveUserUid(user.uid);
      authRepository.saveSignUpAs(Constants.emailSigned);

      return user;
    } catch (signUpError) {
      if (signUpError is PlatformException) {
        if (signUpError.code == 'wrong-password') {
          _loading.add(false);
          return user;
        }
      }
    }
    return user;
  }

  Future<int> createUser(SignUpRequest request) async {
    final createUserUrl = '$_baseUrl/create_user_info';
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: jsonEncode(request),
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            // print(status);
            return status <= 500;
          }),
    );

    // print(response.data.toString());
    // print(response.headers);
    // print(jsonEncode(request));

    if (response.statusCode == 200) {
      // print("success ${response.statusCode}");
      await authRepository.savePrefferedCurrency(request.prefFiat);
      await authRepository.saveCryptoCurrency(request.prefCrypto);
      await authRepository.saveName('${request.firstName} ${request.lastName}');
      return response.statusCode;
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      // return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // throw Exception("Failed ${response.statusCode}");
      return response.statusCode;
    }
  }

  Future<int> deleteUserInfo() async {
    int _status;
    final createUserUrl = '$_baseUrl${Constants.get_active_products}';
    _token = await authRepository.getUserFirebaseToken();
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
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      return _status;
    } else {
      return _status;
    }
  }
}
