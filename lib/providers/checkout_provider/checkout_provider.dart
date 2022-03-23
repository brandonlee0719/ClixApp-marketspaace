import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/model/address_model/address_model.dart';
import 'package:market_space/model/checkout/wallet_model/wallet_model.dart';
import 'package:market_space/model/notification_model/notification_model.dart';
import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';
import 'package:market_space/profile_settings/model/debit_card_model.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

class CheckoutProvider {
  final _baseUrl =
      'https://australia-southeast1-market-spaace.cloudfunctions.net';
  Dio dio = new Dio();
  final AuthRepository _authRepository = AuthRepository();
  String _token;
  int _status;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final BehaviorSubject<List<UpdateAddressModel>> _addressSink =
      BehaviorSubject();

  Stream<List<UpdateAddressModel>> get addressStream => _addressSink.stream;

  //Credintials for PCI vault API's
  String _username, _password;
  String _uid;

  Future<WalletModel> getWalletBalance() async {
    final createUserUrl = '$_baseUrl${Constants.get_wallet_balance}';
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
            return status <= 500;
          }),
    );
    // print(response.data.toString());
    // print(createUserUrl);
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      WalletModel model = WalletModel.fromJson(response.data);
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

  Future<WalletModel> updateStock(int productNum, String operation,
      String variator, String variationLabel) async {
    final createUserUrl = '$_baseUrl${Constants.update_stock}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {
        "productNum": productNum,
        "operation": operation,
        "variatior": variator,
        "variationLabel": variationLabel
      },
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );
    // print(response.data.toString());
    // print(createUserUrl);
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      return response.data;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
      }
      return null;
    }
  }

  Future<List<UpdateAddressModel>> viewAddresses() async {
    final createUserUrl = '$_baseUrl${Constants.view_address}';
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
            return status <= 500;
          }),
    );
    // print(response.data.toString());
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      AddressModel addressModel = AddressModel.fromJson(response.data);
      _addressSink.add(addressModel.addresses);
      return addressModel.addresses;
    } else {
      if (response.data.toString() == "User is not authorized") {
        _token = await firebaseAuth.currentUser.getIdToken(true);
        _authRepository.saveUserFirebaseToken(_token);
        // print(_token);
        viewAddresses();
      }
      return null;
    }
  }

  Future<int> addNewAddress(UpdateAddressModel addressModel) async {
    final createUserUrl = '$_baseUrl${Constants.add_address}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: jsonEncode(addressModel),
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );
    // print("url: $createUserUrl");
    // print(response.data.toString());
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      return _status;
    } else {
      return _status;
    }
  }

  //Get basic PCI vault credintials from server
  Future<String> getVaultBasicCredentials() async {
    final createUserUrl = '$_baseUrl${Constants.get_vault_creds}';
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
            return status <= 500;
          }),
    );
    // print(response.data.toString());
    // print(createUserUrl);
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      _username = response.data['user'];
      _password = response.data['pass'];
      await _authRepository.saveVaultUsername(response.data['user']);
      await _authRepository.saveVaultPassword(response.data['pass']);
      _uid = await _authRepository.getUserId();

      return response.data['user'];
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

  //PCI vault API
  Future<DebitCardModel> getDebitCard() async {
    final createUserUrl =
        '${Constants.debit_base_url}${Constants.save_debit}?user=$_uid';
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.baseUrl = _baseUrl;
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
    // print(basicAuth);
    dio.options.headers["Authorization"] = "$basicAuth";
    final Response response = await dio.get(
      createUserUrl,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );
    // print(response.data.toString());
    // print(createUserUrl);
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      DebitCardModel model = DebitCardModel.fromJson(response.data);
      return model;
    } else {
      return null;
    }
  }
}
