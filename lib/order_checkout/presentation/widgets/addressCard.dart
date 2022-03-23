import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/apis/userApi/models/addressModel.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/order_checkout/logic/order_checkout_bloc/order_checkout_bloc.dart';
import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';
import 'package:market_space/responsive_layout/size_config.dart';

enum AddressOptions {
  AddressOne,
  AddressTWO,
  AddressThree,
}

class AddressCard extends StatefulWidget {
  final AddressOptions addressOption;
  final bool isBilling;
  final UserAddress addressModel;

  const AddressCard(
      {Key key, this.addressOption, this.isBilling, this.addressModel})
      : super(key: key);
  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  bool isCardSelected(OrderCheckoutBloc bloc) {
    if (widget.isBilling) {
      return widget.addressOption == bloc.getBillingAddress();
    }

    return widget.addressOption == bloc.getShippingAddress();
  }

  AddressOptions getAdrressValue(OrderCheckoutBloc bloc) {
    if (widget.isBilling) {
      return bloc.getBillingAddress();
    }
    return bloc.getShippingAddress();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final checkoutBloc = BlocProvider.of<OrderCheckoutBloc>(context);
    return BlocListener<OrderCheckoutBloc, OrderCheckoutState>(
      listener: (context, state) {
        if (state is SelectAddress) {
          setState(() {});
        }
      },
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: isCardSelected(checkoutBloc)
                      ? AppColors.appBlue
                      : AppColors.text_field_color)),
          margin: EdgeInsets.only(
              top: SizeConfig.heightMultiplier * 2.0086083213773316,
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884),
          child: Row(
            children: [
              Radio(
                value: widget.addressOption,
                activeColor: isCardSelected(checkoutBloc)
                    ? AppColors.appBlue
                    : AppColors.text_field_color,
                groupValue: getAdrressValue(checkoutBloc),
                onChanged: (AddressOptions value) => {
                  // print('we have been called hee'),
                  setState(() {
                    // checkoutBloc.setShippingAddress(value);
                    checkoutBloc
                        .add(ChooseAddressEvent(widget.isBilling, value));
                  })
                  // // print('heiheihie, wobeianle'),
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.heightMultiplier * 2.0086083213773316,
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                        right: SizeConfig.widthMultiplier * 3.8888888888888884),
                    child: Text(
                      '${widget.addressModel.firstName + " " + widget.addressModel.lastName ?? ""}',
                      style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w700,
                        color: AppColors.app_txt_color,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.heightMultiplier * 0.5021520803443329,
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                        right: SizeConfig.widthMultiplier * 3.8888888888888884,
                        bottom:
                            SizeConfig.heightMultiplier * 2.0086083213773316),
                    child: Text(
                      '${widget.addressModel.streetAddress ?? ""}\n${widget.addressModel.suburb ?? ""} ${widget.addressModel.state ?? ""} ${widget.addressModel.country ?? ""}',
                      style: GoogleFonts.inter(
                        fontSize:
                            SizeConfig.textMultiplier * 1.5064562410329987,
                        fontWeight: FontWeight.w400,
                        color: AppColors.app_txt_color,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
