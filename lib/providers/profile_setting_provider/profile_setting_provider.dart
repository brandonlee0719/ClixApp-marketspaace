import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/util/creditCardHelper.dart';
import 'package:market_space/model/address_model/address_model.dart';
import 'package:market_space/model/profile_settings/notification_settings_model.dart';

import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';
import 'package:market_space/providers/localDatabaseHelper.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/repositories/paymentRepositrory/card_repository.dart';
import 'package:rxdart/rxdart.dart';

class ProfileSettingProvider {
  final AuthRepository _authRepository = AuthRepository();
  final _baseUrl =
      'https://australia-southeast1-market-spaace.cloudfunctions.net';
  Dio dio = new Dio();
  String _token;
  int _status;

  final BehaviorSubject<List<UpdateAddressModel>> _addressSink =
      BehaviorSubject();

  Stream<List<UpdateAddressModel>> get addressStream => _addressSink.stream;

  Future<void> logout() async {
    await _authRepository.clearAll();
    await FirebaseAuth.instance.signOut();
    CardRepository provider = CardRepository();
    await LocalDataBaseHelper().deleteDB();
    await provider.deleteCard();

    // await LocalDataBaseHelper().deleteDB();
  }

  Future<int> updateEmail(String email, String newEmail) async {
    final createUserUrl = '$_baseUrl${Constants.update_email}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"email": email, "newEmail": newEmail},
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
      await _authRepository.saveEmail(newEmail);
      return _status;
    } else {
      return _status;
    }
  }

  Future<int> updatePassword(String email, String password) async {
    final createUserUrl = '$_baseUrl${Constants.update_password}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"email": email, "password": password},
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
      _authRepository.savePassword(password);
      return _status;
    } else {
      return _status;
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

  Future<int> editAddress(UpdateAddressModel addressModel) async {
    final createUserUrl = '$_baseUrl${Constants.edit_address}';
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

  Future<NotificationSettingsModel> getNotificationSettings() async {
    final createUserUrl = '$_baseUrl${Constants.get_notification_settings}';
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
    // print("url: $createUserUrl");
    // print(response.data.toString());
    // print(response.headers);

    if (_status == 200) {
      // print("success ${_status}");
      NotificationSettingsModel model =
          NotificationSettingsModel.fromJson(response.data);
      return model;
    } else {
      return response.data;
    }
  }

  Future<String> updateNotificationSettings(
      String settingText, String dataText) async {
    final createUserUrl = '$_baseUrl${Constants.update_notification_setting}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {settingText: dataText},
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
      return "Settings updated successfully";
    } else {
      return response.data;
    }
  }
}
