import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:market_space/apis/firebaseManager.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/repositories/splash_repository/splash_repository.dart';
import 'package:market_space/splash/splash_screen_event.dart';
import 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc(SplashScreenState initialState) : super(initialState);
  final SplashRepository _splashRepository = SplashRepository();
  String signInType;
  static String notifyTxt = "";
  final AuthRepository _authRepository = AuthRepository();
  final LocalAuthentication auth = LocalAuthentication();
  bool canCheckBiometrics;
  List<BiometricType> availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  bool isAuthorized = false;

  @override
  SplashScreenState get initialState => Initial();

  @override
  Stream<SplashScreenState> mapEventToState(
    SplashScreenEvent event,
  ) async* {
    if (event is NavigateToHomeScreenEvent) {
      // print('splashing....');
      yield Loading();
      Constants.language = 'English';

      // signInType = await _checkSignUp();
      // Future.delayed(Duration(milliseconds: 300));
      if (FirebaseManager.instance.getUID() != null) {
        yield EmailSigned();
        this._splashRepository.splashProvider.token =
            await FirebaseManager.instance.getAuthToken();
        yield NavigateToHome();
      } else {
        yield LoginNeeded();
      }
      yield Loaded();
      // if (signInType == null) {
      //   yield LoginNeeded();
      // } else if (signInType == Constants.googleSigned) {
      //   User user = await _signInWithGoogle();
      //   if (user != null) {
      //     yield GoogleSigned();
      //     yield NavigateToHome();
      //   } else {
      //     yield LoginFailed();
      //   }
      // } else if (signInType == Constants.emailSigned) {
      //   User user = await _loginUser();
      //   if (user != null) {
      //     yield EmailSigned();
      //     yield NavigateToHome();
      //   } else {
      //     yield LoginFailed();
      //   }
      // } else if (signInType == Constants.anonymousSigned) {
      //   yield AnonymousSigned();
      // }
      // yield Loaded(); // In this state we can load the HOME PAGE
    }
    if (event is NavigateToNotificationEvent) {
      yield NotificationNavigate();
    }

    /*if (event is CheckLoginBioMetricAvaiable) {
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
    if(event is LaunchBiometric){
      if (canCheckBiometrics) {
        yield BiometricAuthorizing();
        isAuthorized = await authenticate();
        if (isAuthorized) {
          yield BiometricAuthorized();
        } else {
          yield BiometricAuthorizationFailed();
        }
      }
    }*/
  }

  Future<String> _checkSignUp() async {
    return await _splashRepository.checkSignUpType();
  }

  Future<User> _loginUser() async {
    if (signInType == Constants.emailSigned) {
      String email = await _splashRepository.getEmail();
      String pass = await _splashRepository.getPassword();
      return _splashRepository.signInWithEmail(email, pass);
    }
  }

  Future<User> _signInWithGoogle() async {
    return await _splashRepository.signInWithGoogle();
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
}
