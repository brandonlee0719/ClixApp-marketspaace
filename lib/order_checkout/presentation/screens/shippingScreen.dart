import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/apis/orderApi/orderManager.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/order_checkout/logic/order_checkout_bloc/order_checkout_bloc.dart';
import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';
import 'package:market_space/order_checkout/presentation/widgets/addressCard.dart';
import 'package:market_space/profile_settings/add_new_address/add_new_address_route.dart';
import 'package:market_space/profile_settings/profile_setting_route.dart';
import 'package:market_space/representation/buttons.dart';
import 'package:market_space/representation/cards.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/locator.dart';

class ShippingScreen extends StatefulWidget {
  final bool isBilling;

  const ShippingScreen({Key key, this.isBilling}) : super(key: key);
  @override
  _ShippingScreenState createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    // ignore: close_sinks
    OrderCheckoutBloc orderCheckoutBloc =
        BlocProvider.of<OrderCheckoutBloc>(context);

    return BlocListener<OrderCheckoutBloc, OrderCheckoutState>(
      listener: (context, state) {
        if (state is ViewAddressSuccessfully) {
          setState(() {
            locator<OrderManager>().isAddressLoading = false;
            isUpdating = false;
          });
        }
      },
      child: Container(
        color: Colors.white,
        child: Builder(
          builder: (BuildContext context) => Stack(
            children: [
              if (locator<OrderManager>().addressList != null)
                ListView(
                  shrinkWrap: true,
                  children: [
                    for (int i = 0;
                        i < locator<OrderManager>().addressList.length;
                        i++)
                      CardBuilder().build(CardSection(
                        CardSectionType.AddressCard,
                        model: locator<OrderManager>().addressList[i],
                        value: i,
                        groupValue: locator<OrderManager>().value,
                      )),
                    // if (orderCheckoutBloc.addressList.length > 3)
                    //   AddressCard(addressOption: AddressOptions.AddressThree, isBilling: false, addressModel:  orderCheckoutBloc.addressList[3],),
                    if (locator<OrderManager>().addressList.length < 3)
                      _addShippingAddressButton()
                  ],
                ),
              if (locator<OrderManager>().isAddressLoading)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                  child: Align(
                      alignment: Alignment.center,
                      child: LoadingProgress(
                        color: Colors.deepOrangeAccent,
                      )),
                ),
              if (isUpdating)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                  child: Align(
                      alignment: Alignment.center,
                      child: LoadingProgress(
                        color: Colors.deepOrangeAccent,
                      )),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _addShippingFunc() {
    // print("hahahah");
    ProfileSettingRoute.updateAddressModel = null;
    Navigator.pushNamed(context, AddNewAddressRoute.buildPath()).then((value) {
      // print(value);
      isUpdating = true;
      BlocProvider.of<OrderCheckoutBloc>(context).add(ViewAddressesEvent());
    });
  }

  Widget _addShippingAddressButton() {
    return ButtonBuilder().build(ButtonSection(
        ButtonSectionType.responseButton, 'Add new address', _addShippingFunc));
  }
}
