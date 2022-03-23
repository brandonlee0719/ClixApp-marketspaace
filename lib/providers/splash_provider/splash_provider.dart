import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

class SplashProvider {
  Dio dio = new Dio();
  PublishSubject _loading = PublishSubject();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _token;
  final AuthRepository authRepository = AuthRepository();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  set token(String value) {
    _token = value;
  }

  Future<User> signInWithEmailPass(String email, String password) async {
    User user;
    try {
      user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      final User currentUser = _firebaseAuth.currentUser;
      assert(user.uid == currentUser.uid);
      _token = await user.getIdToken();
      authRepository.saveEmail(email);
      authRepository.savePassword(password);
      authRepository.saveUserUid(currentUser.uid);
      // print("firebase token $_token");
      // print("Uid : ${currentUser.uid}");
      authRepository.saveUserFirebaseToken(_token);
      if (user.uid == "rPLMag2bJpefZdsmldQ04sKb82U2") {
        authRepository.saveName("Nivasan Babu Srinivasan");
      } else if (user.uid == "39KDGacVoJRkHwEUH9GDl0KmuhF2") {
        authRepository.saveName("Chi Keung Liu");
      } else if (user.uid == "zvuj5aqRt0VKhWm85rtzhyUqKr22") {
        authRepository.saveName("Ankit Chaturvedi");
      }
      return user;
    } catch (signUpError) {
      if (signUpError is PlatformException) {
        if (signUpError.code == 'ERROR_WRONG_PASSWORD') {
          _loading.add(false);
          return user;
        }
      }
    }
    return user;
  }

  Future<User> googleSignIn() async {
    _loading.add(true);
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final User user =
        (await _firebaseAuth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _firebaseAuth.currentUser;
    assert(user.uid == currentUser.uid);
    authRepository.saveSignUpAs(Constants.googleSigned);
    authRepository.saveUserUid(currentUser.uid);
    // print("signed In" + user.toString());
    _loading.add(false);

    return user;
  }
}
