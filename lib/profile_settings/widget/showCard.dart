import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/profile_settings/logic/check_credit_bloc.dart';
import 'package:market_space/profile_settings/logic/credit_bloc.dart';
import 'package:market_space/profile_settings/widget/validator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ShowCardHelper {
  BuildContext context;
  final CheckCreditBloc credit;

  ShowCardHelper(this.context, this.credit);
  // this is for show card in the setting, which helps to show cards
  Future<void> showAddCardSheet() async {
    showMaterialModalBottomSheet(
      context: context,
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30))),
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: BlocProvider<CheckCreditBloc>.value(
            value: credit, child: AddBankWidget()),
      ),
    );
  }
}
