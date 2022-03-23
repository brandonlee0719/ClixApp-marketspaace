library add_bank;

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/common/util/globalKeys.dart';
import 'package:market_space/profile_settings/logic/check_credit_bloc.dart';
import 'package:market_space/profile_settings/logic/credit_bloc.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'inputContainer.dart';
part 'AddBankWidget.dart';

enum _CheckType {
  name,
  cardNumber,
  expire_date,
  cvv,
}

class _Validator {
  String messgae = "invalid input";

  bool validate(Map<_CheckType, TextEditingController> map) {
    for (var type in _CheckType.values) {
      if (!_checkMessage(map[type].text, type)) {
        return false;
      }
    }
    return true;
  }

  bool _checkMessage(String input, _CheckType type) {
    // print(input);
    if (input.length == 0) {
      messgae = "${type.toString().split('.').last} is empty";
      return false;
    }
    if (type == _CheckType.cardNumber) {
      if (input.length != 16) {
        messgae =
            "invalid card number given, we only accept australia visa or mastercard";
        return false;
      }
      try {
        int _ = int.parse(input);
        return true;
      } catch (e) {
        messgae =
            "invalid card number given, we only accept australia visa or mastercard";
        return false;
      }
    } else if (type == _CheckType.expire_date) {
      try {
        List<String> dateList = input.split("/");
        int _ = int.parse(dateList[0]);
        _ = int.parse(dateList[1]);
        return true;
      } catch (e) {
        messgae = "invalid expire date!";
        return false;
      }
    }

    return true;
  }
}
