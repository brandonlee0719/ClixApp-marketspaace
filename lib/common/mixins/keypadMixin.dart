import 'package:flutter/cupertino.dart';
import 'package:market_space/common/mixins/wrongInputNotifyMixin.dart';

mixin keyPadMixin<T extends StatefulWidget> on WrongInputNotifier<T> {
  String _integerPart = "";
  String _decimalPart = "";
  bool _isIntegerMode = true;
  int _maxDecimalPlace = 2;
  ValueNotifier<String> value = ValueNotifier("0");

  bool isValid() {
    String joinedChar = _integerPart + _decimalPart;
    for (int i = 0; i < joinedChar.length; i++) {
      if (joinedChar[i] != '0') {
        return true;
      }
    }
    return false;
  }

  String getNumber() {
    String a = _integerPart == "" ? "0" : _integerPart;
    String b = _decimalPart == "" ? "" : _decimalPart;

    return _isIntegerMode ? a : "$a.$b";
  }

  void _addToInteger(String num) {
    this._integerPart += num;
  }

  void _addToDecimal(String num) {
    _decimalPart.length == _maxDecimalPlace
        ? notifyWrongInput()
        : this._decimalPart += num;
  }

  void shift() {
    if (_isIntegerMode) {
      this._isIntegerMode = false;
    } else {
      this._isIntegerMode = true;
    }
  }

  void changeDecimalPlace(int num) {
    this._maxDecimalPlace = num;
    if (_decimalPart.length > _maxDecimalPlace) {
      _decimalPart = _decimalPart.substring(0, _maxDecimalPlace);
    }
    value.value = getNumber();
    // print(getNumber());
  }

  void pressNumber(String num) {
    if (_isIntegerMode) {
      if (num == '0' && (_integerPart == '0' || _integerPart == '')) {
        return;
      }
    }
    _isIntegerMode ? _addToInteger(num) : _addToDecimal(num);
    // print(getNumber());
    value.value = getNumber();
  }

  void pressDot() {
    _isIntegerMode ? shift() : notifyWrongInput();
    // print(getNumber());
    value.value = getNumber();
  }

  void delete() {
    if (!_isIntegerMode) {
      if (_decimalPart.length == 0) {
        shift();
      } else {
        _decimalPart = _decimalPart.substring(0, _decimalPart.length - 1);
      }
    } else {
      _integerPart.length > 0
          ? () {
              _integerPart = _integerPart.substring(0, _integerPart.length - 1);
            }()
          : () {
              notifyWrongInput();
            }();
    }
    // print(getNumber());
    value.value = getNumber();
  }
}
