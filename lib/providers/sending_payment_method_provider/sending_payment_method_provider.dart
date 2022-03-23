import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/model/bank_account_model/bank_account_model.dart';
import 'package:market_space/model/bank_account_model/bank_details_request_model.dart';
import 'package:market_space/profile_settings/model/debit_card_model.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

class SendingPaymentMethodProvider {
  final _baseUrl =
      'https://australia-southeast1-market-spaace.cloudfunctions.net';
  Dio dio = new Dio();
  final AuthRepository _authRepository = AuthRepository();
  String _token;
  int _status;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String _uid;
  String username, password;
  String _vaultToken, _passPhrase;

  Future<BankAccountModel> getBankAccount() async {
    final createUserUrl = '$_baseUrl${Constants.get_bank_details}';
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
      var data = BankAccountModel.fromJson(response.data);
      return data;
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

  Future<String> saveBankDetails(BankDetailsRequestModel model) async {
    final createUserUrl = '$_baseUrl${Constants.save_bank}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: jsonEncode(model),
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
        // getActiveProducts();
      }
      return null;
    }
  }

  Future<String> getBankStatus() async {
    final createUserUrl = '$_baseUrl${Constants.get_bank_status}';
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
      return response.data;
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

  Future<String> removeBankAccount() async {
    final createUserUrl = '$_baseUrl${Constants.delete_bank_method}';
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
      return response.data;
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

  Future<String> uploadFile(File file) async {
    final createUserUrl = '$_baseUrl${Constants.upload_bank_statement}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/octet-stream';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.headers["content-length"] = "${file.readAsBytesSync().length}";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: file.readAsBytesSync(),
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
        // getActiveProducts();
      }
      return null;
    }
  }

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
      username = response.data['user'];
      password = response.data['pass'];
      await _authRepository.saveVaultUsername(response.data['user']);
      await _authRepository.saveVaultPassword(response.data['pass']);

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

  Future<String> saveKeyServer() async {
    final createUserUrl = '$_baseUrl${Constants.save_key_server}';
    _token = await _authRepository.getUserFirebaseToken();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"passphrase": _passPhrase, "user": _uid},
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
        // getActiveProducts();
      }
      return null;
    }
  }

  Future<String> getKeyServer() async {
    final createUserUrl = '$_baseUrl${Constants.get_key_data}';
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
      _passPhrase = response.data['passphrase'];
      await _authRepository.savePassPhrase(_passPhrase);
      return response.data;
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

  Future<String> saveVaultDataServer() async {
    final createUserUrl = '$_baseUrl${Constants.save_vault_data}';
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {"reference": _uid, "user": _uid, "token": _vaultToken},
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
        // getActiveProducts();
      }
      return null;
    }
  }

  Future<String> getVaultData() async {
    final createUserUrl = '$_baseUrl${Constants.get_vault_data}';
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
      _vaultToken = response.data['token'];
      await _authRepository.saveVaultToken(response.data['token']);
      return response.data['token'];
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

  Future<String> deleteVaultDataServer() async {
    final createUserUrl = '$_baseUrl${Constants.delete_vault_data}';
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
      return response.data;
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

  Future<String> deleteKeyServer() async {
    final createUserUrl = '$_baseUrl${Constants.delete_key}';
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
      return response.data;
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

  //Debit card API's
  Future<String> getPassPhrase() async {
    final createUserUrl =
        '${Constants.debit_base_url}${Constants.get_pass_phrase}';
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.baseUrl = _baseUrl;
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
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
      _passPhrase = response.data["passphrase"];
      await _authRepository.savePassPhrase(response.data["passphrase"]);
      return response.data["passphrase"];
    } else {
      return null;
    }
  }

  Future<String> addKey(String passPhrase) async {
    final createUserUrl =
        '${Constants.debit_base_url}${Constants.add_key_vault}';
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.baseUrl = _baseUrl;
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    // print(basicAuth);
    dio.options.headers["Authorization"] = "$basicAuth";
    _uid = await _authRepository.getUserId();
    final Response response = await dio.post(
      createUserUrl,
      data: {"passphrase": passPhrase, "user": _uid},
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
      _passPhrase = response.data["passphrase"];
      return _passPhrase;
    } else {
      return null;
    }
  }

  Future<String> saveDebitCard(
      String cardNumber, String name, String expire) async {
    _uid = await _authRepository.getUserId();
    final createUserUrl =
        '${Constants.debit_base_url}${Constants.save_debit}?user=$_uid&key=$_passPhrase';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    // print(basicAuth);
    dio.options.headers["Authorization"] = "$basicAuth";
    // dio.options.headers["user"] = "${_uid}";
    // dio.options.headers["passphrase"] = "$_passPhrase";
    // dio.options.headers["reference"] = "$_uid}";
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.baseUrl = _baseUrl;

    final Response response = await dio.post(
      createUserUrl,
      data: {
        "card_expiry": expire,
        "card_holder": name,
        "card_number": int.parse(cardNumber),
        "reference": _uid
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
      await _authRepository.saveVaultToken(response.data["token"]);
      return response.data["token"];
    } else {
      return null;
    }
  }

  Future<DebitCardModel> getDebitCard() async {
    // _vaultToken = await _authRepository.getVaultToken();
    // _passPhrase = await _authRepository.getPassPhrase();

    final createUserUrl =
        '${Constants.debit_base_url}${Constants.save_debit}?user=$_uid';
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.baseUrl = _baseUrl;
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
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

  Future<String> removeDebitCard() async {
    _vaultToken = await _authRepository.getVaultToken();
    _passPhrase = await _authRepository.getPassPhrase();

    final createUserUrl =
        '${Constants.debit_base_url}${Constants.save_debit}?user=$_uid&token=$_vaultToken';
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.baseUrl = _baseUrl;
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
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
      return response.data;
    } else {
      return null;
    }
  }
}
