import 'package:flutter/cupertino.dart';

@immutable
abstract class ChangePasswordState {}

class Initial extends ChangePasswordState {}

class Loading extends ChangePasswordState {}

class Loaded extends ChangePasswordState {}

class ValidateOTP extends ChangePasswordState {}

class OtpValidationFailure extends ChangePasswordState {}

class OtpValidationSuccessful extends ChangePasswordState {}
