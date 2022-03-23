import 'package:flutter/cupertino.dart';

@immutable
abstract class ForgotPasswordOtpState {}

class Initial extends ForgotPasswordOtpState {}

class Loading extends ForgotPasswordOtpState {}

class Loaded extends ForgotPasswordOtpState {}

class Confirming extends ForgotPasswordOtpState {}

class Confirmed extends ForgotPasswordOtpState {}
