import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';
import 'package:market_space/apis/localPassWordApi.dart';

import '../authApi.dart';

enum PasswordState {
  initial,
  readingBioKind,
  bioKindRead,
  pinPressing,
  pinPressed,
  passWordRight,
  passWordWrong,
  passWordSetSuccess,
  passwordNotMatch,
  firstPasswordSet,
}

class PasswordCubit extends Cubit<PasswordState> {
  final bool isPass;
  String password1;
  String password2;
  IconData iconData;

  PasswordCubit(this.isPass) : super(PasswordState.initial) {
    initialize();
  }

  List<String> currentPin = ["", "", "", ""];
  int pinIndex = 0;

  void goBack() {
    emit(PasswordState.pinPressing);
    pinIndex = 4;
    currentPin = password1.split("");
    password1 = null;
    emit(PasswordState.pinPressed);
  }

  void clear() {
    currentPin = ["", "", "", ""];
    pinIndex = 0;
    emit(PasswordState.pinPressing);
    emit(PasswordState.pinPressed);
    emit(PasswordState.initial);
  }

  Future<void> setPin(String number) async {
    emit(PasswordState.pinPressing);
    if (pinIndex < 4) {
      // print(number);
      currentPin[pinIndex] = number;
      pinIndex++;
    }

    if (pinIndex == 4) {
      var stringList = currentPin.join("");
      if (!isPass) {
        bool result = await LocalPasswordApi.authenticate(stringList);
        if (result) {
          // print("match");
          emit(PasswordState.passWordRight);
        } else {
          // print("mismatch");

          emit(PasswordState.passWordWrong);
        }
      }
      // print(stringList);
    }
    emit(PasswordState.pinPressed);
  }

  Future<void> confirmPin() async {
    emit(PasswordState.pinPressing);
    // print(password1);
    if (pinIndex != 4) {
      // print("Wrong!");
      return;
    }
    if (password1 == null) {
      password1 = currentPin.join("");
      currentPin = ["", "", "", ""];
      pinIndex = 0;
      emit(PasswordState.pinPressed);
      emit(PasswordState.firstPasswordSet);
      return;
    }
    if (password1 != null) {
      password2 = currentPin.join("");
      if (password2 == password1) {
        bool _ = await LocalPasswordApi.setPassword(password1);
        // print("done!");
        emit(PasswordState.passWordSetSuccess);
      } else {
        password1 = null;
        password2 = null;
        currentPin = ["", "", "", ""];
        pinIndex = 0;
        // print("password not match");
        emit(PasswordState.pinPressed);
        emit(PasswordState.passwordNotMatch);
      }
    }
  }

  void deletePin() {
    emit(PasswordState.pinPressing);
    if (pinIndex > 0) {
      pinIndex--;
      currentPin[pinIndex] = "";
    }
    emit(PasswordState.pinPressed);
  }

  Future<void> initialize() async {
    if (isPass == false) {
      emit(PasswordState.readingBioKind);
      BiometricType type = await LocalAuthApi.getBioType();
      // print(type.toString());
      iconData = type.getIcon();
      emit(PasswordState.bioKindRead);
    }
  }
}
