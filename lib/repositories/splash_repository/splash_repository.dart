import 'package:firebase_auth/firebase_auth.dart';
import 'package:market_space/providers/splash_provider/splash_provider.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';

class SplashRepository {
  final SplashProvider _splashProvider = SplashProvider();
  final AuthRepository _authRepository = AuthRepository();


  SplashProvider get splashProvider => _splashProvider;

  Future<User> signInWithEmail(String email, String pass) async {
    return await _splashProvider.signInWithEmailPass(email, pass);
  }

  Future<String> checkSignUpType() async {
    return await _authRepository.getSignUpType();
  }

  Future<String> getEmail() async {
    return await _authRepository.getEmail();
  }

  Future<String> getPassword() async {
    return await _authRepository.getPassword();
  }

  Future<User> signInWithGoogle() async {
    return await _splashProvider.googleSignIn();
  }
}
