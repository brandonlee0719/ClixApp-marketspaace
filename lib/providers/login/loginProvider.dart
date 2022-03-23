import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/model/signUp/sign_up_request.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

class LoginProvider {
  final _baseUrl =
      'https://australia-southeast1-market-spaace.cloudfunctions.net';
  Dio dio = new Dio();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  PublishSubject _loading = PublishSubject();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _token = "aWWGjTFm6wcU1U4hLJztzPgpYE53";
  final AuthRepository authRepository = AuthRepository();
  bool _isAnonymous;

  Future<User> signInWithEmailPass(String email, String password) async {
    User user;
    try {
      user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      // assert(user != null);
      // assert(await user.getIdToken() != null);
      // final User currentUser = _firebaseAuth.currentUser;
      // assert(user.uid == currentUser.uid);
      _token = await user.getIdToken();
      authRepository.saveEmail(email);
      authRepository.savePassword(password);
      authRepository.saveSignUpAs(Constants.emailSigned);
      // print("firebase token $_token");
      authRepository.saveUserFirebaseToken(_token);
      authRepository.saveUserUid(user.uid);
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
    authRepository.saveUserUid(user.uid);

//    updateUserData(user);
    // print("signed In" + user.toString());
    _loading.add(false);

    return user;
  }

  Future<User> signInAnonymously() async {
    await Firebase.initializeApp();
    var user;
    try {
      String providerId = await authRepository.getProviderIds();
      if (providerId == null) {
        UserCredential auth = await FirebaseAuth.instance.signInAnonymously();
        int anonymousToken = auth.credential.token;
        user = auth.user;
        _token = await user.getIdToken();
        authRepository.saveAuthCredential(
            anonymousToken.toString(), auth.credential.providerId);
        // print("firebase token $_token");
        authRepository.saveUserFirebaseToken(_token);
        authRepository.saveSignUpAs(Constants.anonymousSigned);
        _isAnonymous = true;
        user = await signInWithCredential();
        authRepository.saveUserUid(user.uid);
        return user;
      } else {
        user = await signInWithCredential();
        return user;
      }
    } catch (e) {
      // print(e);
    }
    return user;
  }

  Future<User> signInWithCredential() async {
    var user;
    try {
      String providerId = await authRepository.getProviderIds();
      String annomousToken = await authRepository.getAnonymousToken();
      AuthCredential credential = AuthCredential(
          providerId: providerId,
          signInMethod: 'Anonymous',
          token: int.parse(annomousToken));
      var auth = await FirebaseAuth.instance.signInWithCredential(credential);
      user = FirebaseAuth.instance.currentUser;
      _token = await user.getIdToken();
      // print("firebase token $_token");
      authRepository.saveUserFirebaseToken(_token);
      authRepository.saveUserUid(user.uid);
      return user;
    } catch (e) {
      // print(e);
    }
    return user;
  }
}
