import 'package:flutter/cupertino.dart';

@immutable
abstract class LoginScreenState {}

class Initial extends LoginScreenState {}

class Loading extends LoginScreenState {}

class Loaded extends LoginScreenState {}

class BiometricChecking extends LoginScreenState {}

class BiometricChecked extends LoginScreenState {}

class BiometricAuthorized extends LoginScreenState {}

class BiometricAuthorizing extends LoginScreenState {}

class BiometricAuthorizationFailed extends LoginScreenState {}

class SignInFirebaseState extends LoginScreenState {}

class SignInFirebaseSuccessfully extends LoginScreenState {}

class SignInFirebaseFailure extends LoginScreenState {}

class SignInGoogleState extends LoginScreenState {}

class SignInGoogleSuccessfully extends LoginScreenState {}

class SignInGoogleFailure extends LoginScreenState {}

class LanguageChangesSuccessfully extends LoginScreenState {}

class LanguageChangesFailure extends LoginScreenState {}
