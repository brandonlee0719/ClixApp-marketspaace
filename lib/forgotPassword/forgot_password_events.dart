import 'package:flutter/cupertino.dart';

@immutable
abstract class ForgotPasswordEvents {}

class NavigateToLoginScreenEvent extends ForgotPasswordEvents {}

class GeneratePasswordEvent extends ForgotPasswordEvents {}
