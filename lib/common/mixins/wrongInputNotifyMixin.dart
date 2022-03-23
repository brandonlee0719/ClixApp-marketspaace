import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/common/mixins/test_cubit.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

mixin WrongInputNotifier<T extends StatefulWidget> on State<T> {
  /// change this bloc provider to what ever widget that can show some wrong input notification
  /// implement yhe notifyWrongInput with the function.
  Widget wrongInputNotifier({
    @required Widget child,
  }) {
    return BlocListener<WrongInputCubit, WrongInputState>(
      listener: (context, state) {
        // print("your input is wrong!");
      },
      child: child,
    );
  }

  //to-do: implement this function
  void notifyWrongInput() {
    context.read<WrongInputCubit>().notifyWrongInput();
  }

  void show() {
    showMaterialModalBottomSheet(context: null, builder: null);
  }
}
