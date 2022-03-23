import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:market_space/apis/userApi/UserApi.dart';
import 'package:market_space/apis/userApi/models/cardModel.dart';
import 'package:market_space/profile_settings/model/debit_card_model.dart';
import 'package:market_space/providers/localProvider/localCardProvider.dart';
import 'package:market_space/providers/marketSpaaceParentProvider.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';

class CardProvider extends MarketSpaceParentProvider {
  final String _tokenEndpoint = "/get_vault_data";
  final AuthRepository _authRepository = AuthRepository();
  final String _keyEndpoint = "/get_key_data";
  String _username = "wyrems2021";
  String _password = "GearsofWar@2021";
  final _debitAPIUrl = "https://api.pcivault.io/v1";

  Future<String> getKey() async {
    final String uid = await _authRepository.getUserId();
    final Response response = await post(_keyEndpoint, {"uid": uid});
    if (response.statusCode == 200) {
      // print("load key successfully!");
      return response.data['passphrase'];
    }
    return null;
  }

  Future<String> getToken() async {
    final String uid = await _authRepository.getUserId();
    final Response response = await post(_tokenEndpoint, {"uid": uid});
    if (response.statusCode == 200) {
      // print("load key success");
      return response.data['token'];
    } else {
      // print('fail to load token!');
    }
    return null;
  }

  Future<DebitCardModel> getCard({bool isMasked = true}) async {
    String uid = await _authRepository.getUserId();
    CardModel card = await UserApi(FirebaseFirestore.instance, uid).getCard();
    if (card == null) {
      return null;
    }
    return card.toDebit();
  }

  // Future<DebitCardModel> getCard({bool isMasked = true}) async{
  //   Dio dio = new Dio();
  //   String key = await getKey();
  //   if(key == null){
  //     return  null;
  //   }
  //   // print("key is $key");
  //   String token = await getToken();
  //   // print("token is $token");
  //   String _uid= await _authRepository.getUserId() +  "_ankit";
  //   final createUserUrl = 'https://api.pcivault.io/v1/vault?user=$_uid&passphrase=$key&token=$token';
  //   String basicAuth =
  //       'Basic ' + base64Encode(utf8.encode('$_username:$_password'));
  //   dio.options.headers["Authorization"] = "$basicAuth";
  //   dio.options.headers['content-Type'] = 'application/json';
  //   dio.options.baseUrl = _debitAPIUrl;
  //
  //   final Response response = await dio.get(
  //     createUserUrl,
  //     options: Options(
  //         followRedirects: false,
  //         validateStatus: (status) {
  //           return status <= 500;
  //         }),
  //   );
  //   if(response.statusCode == 200){
  //     Map data = jsonDecode(response.data);
  //     // print("online card");
  //     // print(data);
  //     DebitCardModel card = DebitCardModel.fromJson(data);
  //     if(isMasked){
  //       LocalCardProvider local = new LocalCardProvider();
  //       local.storeCreditCard(jsonEncode(card.toJson()));
  //     }
  //     return card;
  //   }
  //   return null;
  //
  //
  //
  // }
}
