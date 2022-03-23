import 'package:flutter/cupertino.dart';

@immutable
abstract class ForgotPasswordState {}

class Initial extends ForgotPasswordState {}

class Loading extends ForgotPasswordState {}

class Loaded extends ForgotPasswordState {}

class GenrateOTP extends ForgotPasswordState {}

class OTPGenratedSuccessfully extends ForgotPasswordState {}

class OTPGenrationFailure extends ForgotPasswordState {}
