import 'package:firebase_auth/firebase_auth.dart';
import 'package:market_space/providers/login/loginProvider.dart';
import 'package:market_space/providers/signup/SignUp.dart';

class LoginRepository {
  final LoginProvider signUpApiClient = LoginProvider();

  Future<User> signInWithEmail(String email, String pass) async {
    return await signUpApiClient.signInWithEmailPass(email, pass);
  }

  Future<User> signAnonymous() async {
    return await signUpApiClient.signInAnonymously();
  }

  Future<User> signInWithGoogle() async {
    return await signUpApiClient.googleSignIn();
  }
}
