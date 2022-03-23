import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:market_space/apis/userApi/models/addressModel.dart';
import 'package:market_space/apis/userApi/models/cardModel.dart';
import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';
import 'package:market_space/providers/marketSpaaceParentProvider.dart';

class UserApi {
  final FirebaseFirestore instance;
  final String uid;
  DocumentReference privateRef;

  UserApi(this.instance, this.uid) {
    privateRef = instance
        .collection('users')
        .doc(uid)
        .collection('privateData')
        .doc('privateDocData');
  }

  Future<List<UpdateAddressModel>> getAddress() async {
    List<UpdateAddressModel> list = List<UpdateAddressModel>();
    QuerySnapshot addresses = await privateRef.collection("addressData").get();
    for (DocumentSnapshot query in addresses.docs) {
      list.add(UpdateAddressModel.fromJson(query.data()));
    }
    return list;
  }

  Future<List<UpdateAddressModel>> getBillingAddress() async {
    List<UpdateAddressModel> list = List<UpdateAddressModel>();
    QuerySnapshot addresses =
        await privateRef.collection("billingAddress").get();
    for (DocumentSnapshot query in addresses.docs) {
      list.add(UpdateAddressModel.fromJson(query.data()));
    }
    return list;
  }

  Future<void> updateAddress(UpdateAddressModel model) async {
    var doc = await privateRef.collection('billingAddress').add(model.toJson());
    // print(doc.toString());
  }

  Future<void> addCard(CardModel model) async {
    await privateRef.collection("card").doc('0').set(model.toJson());
  }

  Future<void> deleteCard() async {
    await privateRef.collection("card").doc('0').delete();
  }

  Future<CardModel> getCard() async {
    var result = await privateRef.collection("card").doc('0').get();
    if (!result.exists) {
      return null;
    }
    return CardModel.fromJson(result.data());
  }

  static Future<bool> emailExist(String emailAddress) async {
    int code = await _OTPApi().emailExist(emailAddress);
    // print(code);
    if (code == 200) {
      // print(" email: email exist");
      return true;
    }

    return false;
  }

  static Future<bool> phoneExist(String phoneNumber) async {
    int code = await _OTPApi().phoneExist(phoneNumber);
    // print(code);
    if (code == 200) {
      // print("phone exist");
      return true;
    }
    return false;
  }

  static Future<void> getOTPFromEmail(
      Function() onSuccess, Function() onFail, String email) async {
    int code = await _OTPApi().sendFromEmail(email);
    if (code == 200) {
      onSuccess();
    } else {
      onFail();
    }
  }
}

class _OTPApi extends MarketSpaceParentProvider {
  String _emailExistEnd = "/check_email";
  String _emailOTPEnd = "/generate_otp_reset";
  String _phoneExistEnd = "/check_phone_number";
  Future<int> sendFromEmail(String emailAddress) async {
    Response res = await post(_emailOTPEnd, {
      "email": emailAddress,
      "isApp": "true",
    });
    // print(res.data);
    return res.statusCode;
  }

  Future<int> phoneExist(String phoneNumber) async {
    Response res = await post(_phoneExistEnd, {
      "phoneNumber": phoneNumber,
    });
    // print(res.data);
    return res.statusCode;
  }

  Future<int> emailExist(String emailAddress) async {
    Response res = await post(_emailExistEnd, {
      "email": emailAddress,
    });

    return res.statusCode;
  }
}
