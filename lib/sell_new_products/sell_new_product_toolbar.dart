import 'package:flutter/cupertino.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/sell_new_products/sell_new_products_page_bloc.dart';

class SellingToolBar extends Toolbar {
  final String title;
  final Function() onBackButtonTap;

  SellingToolBar(this.title, {this.onBackButtonTap}) : super(title: title, elevation: 0);

  @override
  void onChange(BuildContext context) {
    if (BlocProvider.of<SellerPageBloc>(context, listen: false).state ==
        SellerPageState.initial) {
      if (onBackButtonTap != null) onBackButtonTap();
      super.onChange(context);
    } else if (BlocProvider.of<SellerPageBloc>(context, listen: false).state ==
        SellerPageState.shippingScreen) {
      if (onBackButtonTap != null) onBackButtonTap();
      BlocProvider.of<SellerPageBloc>(context, listen: false)
          .add(SellerPageEvent.goBackPage);
    } else {
      if (onBackButtonTap != null) onBackButtonTap();
      BlocProvider.of<SellerPageBloc>(context, listen: false)
          .add(SellerPageEvent.goBackPage);
    }
  }
}
