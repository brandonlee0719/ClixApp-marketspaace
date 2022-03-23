import 'package:firebase_auth/firebase_auth.dart';
import 'package:market_space/model/signUp/sign_up_request.dart';
import 'package:market_space/providers/signup/SignUp.dart';
import 'dart:async';

class CreateUserRepository {
  final SignUpApiClient signUpApiClient = SignUpApiClient();

  Future<int> createUser(SignUpRequest signUpRequest) async {
    return await signUpApiClient.createUser(signUpRequest);
  }

  Future<User> createUserFirebase(String email, String pass) async {
    return await signUpApiClient.registerWithEmailAndPassword(email, pass);
  }
}
