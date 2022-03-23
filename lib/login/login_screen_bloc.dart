import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:market_space/apis/firebaseManager.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/model/model.dart';
import 'package:market_space/providers/localDatabaseHelper.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/repositories/login/loginRepository.dart';
import 'package:market_space/repositories/signup/create_user_repo.dart';

import 'login_screen_events.dart';
import 'login_screen_states.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  LoginScreenBloc(LoginScreenState initialState) : super(initialState);

  final LocalAuthentication auth = LocalAuthentication();
  bool canCheckBiometrics;
  List<BiometricType> availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  bool isAuthorized = false;
  final LoginRepository loginRepository = LoginRepository();
  User user;
  String email = "", pass = "";
  String lang;
  final AuthRepository _authRepository = AuthRepository();

  @override
  LoginScreenState get initialState => Initial();

  @override
  Stream<LoginScreenState> mapEventToState(LoginScreenEvent event) async* {
    if (event is NavigateToHomeScreenEvent) {
      yield Loading();
      Constants.language = await _authRepository.getLanguage();
      // This is to simulate that above checking process
      yield Loaded(); // In this state we can load the HOME PAGE
    }

    if (event is CheckLoginBioMetricAvaiable) {
      yield BiometricChecking();
      canCheckBiometrics = await checkBiometrics();
      if (canCheckBiometrics) {
        availableBiometrics = await getAvailableBiometrics();
      }
      yield BiometricChecked();

      if (canCheckBiometrics) {
        yield BiometricAuthorizing();
        isAuthorized = await authenticate();
        if (isAuthorized) {
          yield BiometricAuthorized();
        } else {
          yield BiometricAuthorizationFailed();
        }
      }
    }
    if (event is LaunchBiometric) {
      if (canCheckBiometrics) {
        yield BiometricAuthorizing();
        isAuthorized = await authenticate();
        if (isAuthorized) {
          yield BiometricAuthorized();
        } else {
          yield BiometricAuthorizationFailed();
        }
      }
    }
    if (event is SignInFirebaseEvent) {
      yield SignInFirebaseState();
      user = await _signInUsingFirebase();
      // print(user);

      if (user != null) {
        await FirebaseManager.instance.signIn();
        await LocalDataBaseHelper().initializeDatabase();
        await _authRepository.setOtpConfirmed('true');
        yield SignInFirebaseSuccessfully();
      } else {
        yield SignInFirebaseFailure();
      }
    }
    if (event is SignInAnonymousEvent) {
      yield SignInFirebaseState();
      user = await _signAnonymousFirebase();
      if (user != null) {
        yield SignInFirebaseSuccessfully();
      } else {
        yield SignInFirebaseFailure();
      }
    }
    if (event is SignInGoogleEvent) {
      yield SignInGoogleState();
      user = await _signInWithGoogle();
      if (user != null) {
        yield SignInGoogleSuccessfully();
      } else {
        yield SignInGoogleFailure();
      }
    }

    if (event is ChangeLanguageEvent) {
      _authRepository.saveLanguage(lang);
      yield LanguageChangesSuccessfully();
    }
  }

  Future<bool> checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      // print("isBiometricAvailable : $canCheckBiometrics");
      // if(canCheckBiometrics){
      //   getAvailableBiometrics();
      // }
      return canCheckBiometrics;
    } on PlatformException catch (e) {
      // print(e);
    }
    return canCheckBiometrics;
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
      // print("BiometricAvailable : $availableBiometrics");
      return availableBiometrics;
    } on PlatformException catch (e) {
      // print(e);
    }
    return availableBiometrics;
  }

  Future<bool> authenticate() async {
    bool authenticated = false;
    try {
      _isAuthenticating = true;
      _authorized = 'Authenticating';

      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          sensitiveTransaction: true);

      _isAuthenticating = false;
      _authorized = 'Authenticating';
    } on PlatformException catch (e) {
      // print(e);
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    _authorized = message;
    // print("biometric" + _authorized);
    return authenticated;
  }

  Future<User> _signInUsingFirebase() async {
    user = await loginRepository.signInWithEmail(email, pass);
    // print(email);
    // print(pass);
    return user;
  }

  Future<User> _signAnonymousFirebase() async {
    user = await loginRepository.signAnonymous();
    return user;
  }

  Future<User> _signInWithGoogle() async {
    user = await loginRepository.signInWithGoogle();
    return user;
  }
}
