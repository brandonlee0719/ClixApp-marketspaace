import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'userApi/UserApi.dart';

class SmsAuthApi {
  static CollectionReference phonesRef =
      FirebaseFirestore.instance.collection('phoneNumbers');

  /// this function is to send verification sms to the user when user forget the password
  /// or when the user register a new account.
  ///
  /// Parameters:
  ///
  /// [func] func parameter is to pass in a function can can store the verificationId in
  ///
  /// [phoneNumber] the phone number taken from the user
  ///
  /// [isForget] if it is the forget password scenario, make sure use it correctly, otherwise
  /// you will be fucked!
  static Future<void> sendSms(
      Function(String verificationId) func, String phoneNumber,
      {bool isForget = false}) async {
    // print("SMS sending...");
    if (isForget) {
      // print(phoneNumber);

      bool phoneExist = await UserApi.phoneExist("+61403208200");
      if (!phoneExist) {
        throw Exception("phone number not exist!");
      }
    }

    // print(FirebaseAuth.instance.currentUser);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        // print("the varification is completed");
      },
      verificationFailed: (FirebaseAuthException e) {
        // print(e.message);
      },
      codeSent: (String verificationId, int resendToken) {
        // print("code is sent");
        func(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // print("time out");
      },
      timeout: Duration(seconds: 35),
    );
    // print("done");
  }

  void onVerificationCompleted() {
    // print("completed");
  }

  void onVerificationFailed() {
    // print("fail");
  }

  void onCodeSent() {
    // print("sent");
  }

  static Future<void> signIn(
    String code,
    String verificationId, {
    Function() onAuthSuccess,
    Function() onAuthFail,
  }) async {
    // print("current user is:");
    // print(FirebaseAuth.instance.currentUser);
    var credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: code);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      // print("done");
      // print(FirebaseAuth.instance.currentUser);
      onAuthSuccess();
    } catch (e) {
      // print("credentialMalformed");
      onAuthFail();
    }
  }

  static Future<bool> verifySMS(String verificationId, String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> auth(
    String code,
    String verificationId, {
    Function() onAuthSuccess,
    Function() onAuthFail,
  }) async {
    // FirebaseAuth.instance.currentUser.unlink("phone");
    // print(FirebaseAuth.instance.currentUser);

    // try{
    var credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: code);
    await FirebaseAuth.instance.currentUser.linkWithCredential(credential);
    onAuthSuccess();
    // }catch(e){
    //   // print(e.toString());
    //   onAuthFail();
    //   // print(e.toString());
    //   return;
    // }
  }

  Future<void> phoneExist() {}
}
