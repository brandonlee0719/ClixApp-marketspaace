import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:market_space/common/util/commonBlocs.dart';
import 'package:market_space/common/util/creditCardHelper.dart';
import 'package:market_space/investment/logic/investment_bloc.dart';
import 'package:market_space/repositories/paymentRepositrory/card_repository.dart';

class FirebaseManager {
  static final instance = FirebaseManager();
  String token;
  Stream<String> refreshStream;
  FirebaseManager() {
    if (FirebaseAuth.instance.currentUser != null) {
      listenToStream();
    }
  }

  String getUID() {
    if (FirebaseAuth.instance.currentUser == null) {
      return null;
    }
    return FirebaseAuth.instance.currentUser.uid;
  }

  Future<String> getAuthToken() async {
    String token = await FirebaseAuth.instance.currentUser.getIdToken();
    // print('token: ${token.toString()}');
    return token;
  }

  Future<void> signIn() async {
    if (FirebaseAuth.instance.currentUser != null) {
      String token = await FirebaseMessaging.instance.getToken();
      uploadToken(token);
      listenToStream();
      CardRepository provider = CardRepository();
      await provider.deleteCard();
      investmentBloc.add(InvestmentEvent.InvestmentScreenEvent);
    }
    // dp the upload token stuff and then finish this function
  }

  Future<void> uploadToken(String token) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({"deviceIdToken": token});
  }

  listenToStream() {
    refreshStream = FirebaseMessaging.instance.onTokenRefresh;
    refreshStream.listen((event) {
      // print(event);
    });
  }
}
