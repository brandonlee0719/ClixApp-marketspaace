import 'package:flutter/cupertino.dart';

@immutable
abstract class ChangePasswordEvents {}

class NavigateToLoginScreenEvent extends ChangePasswordEvents {}

class ValidateOTPEvent extends ChangePasswordEvents {}
