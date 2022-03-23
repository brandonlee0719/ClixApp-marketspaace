import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:market_space/apis/userApi/UserApi.dart';
import 'package:market_space/apis/userApi/models/cardModel.dart';
import 'package:market_space/profile_settings/model/debit_card_model.dart';
import 'package:market_space/providers/localProvider/localCardProvider.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';

//to-do still unstable in some point
class VaultProvider {
  final _debitAPIUrl = "https://api.pcivault.io/v1";
  final _marketSpaaceUrl =
      "https://australia-southeast1-market-spaace.cloudfunctions.net";
  Dio dio = new Dio();
  String _username = "wyrems2021";
  String _password = "GearsofWar@2021";
  int _status = 0;
  String _passPhrase;
  String _uid;
  String _key;
  String _token;
  String _expiryDate;
  String _cardHolderName;
  String _cardNumber;
  final int maxTry = 15;
  final AuthRepository _authRepository = AuthRepository();

  void setBankDetails(
      String expiryDate, String cardHolderName, String cardNumber) {
    this._expiryDate = expiryDate;
    this._cardHolderName = cardHolderName;
    this._cardNumber = cardNumber;
  }

  Future<String> getUid() async {
    _uid = await _authRepository.getUserId();
    return _uid + "_ankit_love";
  }

  Future<int> deleteKey({int recursiveKey = 0}) async {
    if (recursiveKey == maxTry) {
      return 412;
    }
    _uid = await getUid();
    final createUserUrl = _debitAPIUrl + "/key?user=$_uid";
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.baseUrl = _debitAPIUrl;
    dio.options.headers["Authorization"] = "$basicAuth";
    final Response response = await dio.delete(
      createUserUrl,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );
    // print(response.statusCode);
    // print("the delete data is: " + response.data.toString());
    if (response.statusCode == 500) {
      return deleteKey(recursiveKey: recursiveKey + 1);
    }
    return response.statusCode;
  }

  Future<int> _getPassPhrase() async {
    _uid = await getUid();
    final createUserUrl = _debitAPIUrl + "/passphrase";
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.baseUrl = "https://api.pcivault.io/v1";

    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
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
    // print("the phrass data is: " + response.data.toString());

    if (_status == 200) {
      // print("success $_status");
      _passPhrase = response.data["passphrase"];
    }

    return response.statusCode;
  }

  Future<int> _addKey(int recursiveKey) async {
    if (recursiveKey == maxTry) {
      return 420;
    }
    final createUserUrl = _debitAPIUrl + '/key';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.baseUrl = _debitAPIUrl;
    dio.options.headers["Authorization"] = "$basicAuth";

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
    // print("the add key data is: " + response.data.toString());
    if (_status == 200) {
      // print("success $_status");
      _key = response.data["passphrase"];
    } else {
      return _addKey(recursiveKey + 1);
    }

    return response.statusCode;
  }

  Future<int> _saveDebitCard(int recursiveKey) async {
    _uid = await getUid();
    if (recursiveKey == maxTry) {
      return 420;
    }
    final createUserUrl =
        'https://api.pcivault.io/v1/vault?user=$_uid&key=$_key';
    // print(createUserUrl);
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
    dio.options.headers["Authorization"] = "$basicAuth";
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.baseUrl = _debitAPIUrl;

    final Response response = await dio.post(
      createUserUrl,
      data: {
        "card_expiry": _expiryDate,
        "card_holder": _cardHolderName,
        "card_number": int.parse(_cardNumber),
      },
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );
    // print("online card");
    // print(response.data);
    DebitCardModel card = DebitCardModel.fromJson(response.data);

    LocalCardProvider local = new LocalCardProvider();
    local.storeCreditCard(jsonEncode(card.toJson()));

    // print("final response: " + response.statusCode.toString());
    // print(response.statusMessage);

    if (_status == 200) {
      // print("success $_status");

      // print("saved credit card:" + response.data["token"]);
      _token = response.data["token"];
    } else {
      return _saveDebitCard(recursiveKey + 1);
    }
    return response.statusCode;
  }

  Future<int> _uploadKey() async {
    String id = await _authRepository.getUserId();
    final createUserUrl = _marketSpaaceUrl + "/save_key";
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.baseUrl = _marketSpaaceUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {
        "uid": id,
        "user": id,
        "passphrase": _key,
      },
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );

    if (response.statusCode == 200) {
      // print(response.data.toString());
    }
    // print(response.statusCode);
    // print(response.statusMessage);
    return response.statusCode;
  }

  Future<int> uploadVaultData() async {
    String uid = await _authRepository.getUserId();
    _uid = await getUid();
    UserApi api = UserApi(FirebaseFirestore.instance, uid);
    int _ = await _getPassPhrase();
    _ = await _addKey(0);
    _ = await _saveDebitCard(0);
    _ = await _uploadKey();
    await api.addCard(CardModel(_cardHolderName, _expiryDate,
        _cardNumber.substring(_cardNumber.length - 4)));

    String id = await _authRepository.getUserId();
    // int status5 = await _deleteKey();

    final createUserUrl = _marketSpaaceUrl + "/save_vault_data";
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.baseUrl = _marketSpaaceUrl;
    final Response response = await dio.post(
      createUserUrl,
      data: {
        "uid": id,
        "user": _uid,
        "token": _token,
      },
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );

    if (response.statusCode == 200) {
      // print(response.data.toString());
    }
    // print(response.statusCode);
    // print(response.statusMessage);
    return response.statusCode;
  }

  Future<DebitCardModel> getCredit(
      int recursiveKey, String key, String token) async {
    if (recursiveKey == maxTry) {
      return null;
    }
    _uid = await _authRepository.getUserId();
    final createUserUrl =
        'https://api.pcivault.io/v1/vault?user=$_uid&passphrase=$key&token=$token';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
    dio.options.headers["Authorization"] = "$basicAuth";
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.baseUrl = _debitAPIUrl;

    final Response response = await dio.get(
      createUserUrl,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );

    // print("final response: " + response.statusCode.toString());
    // print(response.statusMessage);

    if (_status == 200) {
      // print("success $_status");

      // print("saved credit card:" + response.data.toString());
      // _token =  response.data["token"];
    } else if (response.statusCode != 200) {
      return getCredit(recursiveKey + 1, key, token);
    }
    Map<String, dynamic> map = jsonDecode(response.data);
    return DebitCardModel.fromJson(map);
  }
}
