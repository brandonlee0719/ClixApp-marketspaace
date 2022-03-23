import 'package:flutter/cupertino.dart';

@immutable
abstract class ForgotPasswordOtpEvents {}

class NavigateToLoginScreenEvent extends ForgotPasswordOtpEvents {}

class OtpConfirmedEvent extends ForgotPasswordOtpEvents {}
