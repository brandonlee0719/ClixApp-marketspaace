import 'package:flutter/cupertino.dart';

@immutable
abstract class SplashScreenState {}

class Initial extends SplashScreenState {}

class Loading extends SplashScreenState {}

class Loaded extends SplashScreenState {}

class LoginNeeded extends SplashScreenState {}

class GoogleSigned extends SplashScreenState {}

class EmailSigned extends SplashScreenState {}

class AnonymousSigned extends SplashScreenState {}

class NavigateToHome extends SplashScreenState {}

class LoginFailed extends SplashScreenState {}

class NotificationNavigate extends SplashScreenState {}

class BiometricChecking extends SplashScreenState {}

class BiometricChecked extends SplashScreenState {}

class BiometricAuthorized extends SplashScreenState {}

class BiometricAuthorizing extends SplashScreenState {}

class BiometricAuthorizationFailed extends SplashScreenState {}
