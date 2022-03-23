import 'package:flutter/cupertino.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/order_checkout/logic/page_bloc.dart';

class CheckOutToolBar extends Toolbar {
  final String title;

  CheckOutToolBar(this.title) : super(title: title);

  @override
  void onChange(BuildContext context) {
    if (BlocProvider.of<PageBloc>(context, listen: false).state ==
        PageState.initial) {
      super.onChange(context);
    }

    if (BlocProvider.of<PageBloc>(context, listen: false).state ==
        PageState.complete) {
      Navigator.pop(context);
    } else {
      BlocProvider.of<PageBloc>(context, listen: false)
          .add(PageEvent.goBackPage);
    }
  }
}
