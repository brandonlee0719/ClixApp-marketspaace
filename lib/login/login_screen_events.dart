import 'package:flutter/cupertino.dart';

@immutable
abstract class LoginScreenEvent {}

class NavigateToHomeScreenEvent extends LoginScreenEvent {}

class CheckLoginBioMetricAvaiable extends LoginScreenEvent {}

class LaunchBiometric extends LoginScreenEvent {}

class SignInFirebaseEvent extends LoginScreenEvent {}

class SignInAnonymousEvent extends LoginScreenEvent {}

class SignInGoogleEvent extends LoginScreenEvent {}

class ChangeLanguageEvent extends LoginScreenEvent {}
// class SignInFirebaseSuccessFully extends LoginScreenEvent{}
// class SignInFirebaseFailure extends LoginScreenEvent{}
