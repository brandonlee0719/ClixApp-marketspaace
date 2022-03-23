import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/apis/orderApi/orderModel.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';
import 'package:market_space/responsive_layout/size_config.dart';

import 'componentBuilder.dart';

enum CardSectionType {
  AddressCard,
}

class CardSection {
  final CardSectionType type;
  List<LineModel> productLines;
  List<LineModel> shippingLines;
  List<LineModel> taxLines;
  final UpdateAddressModel model;
  int value;
  ValueNotifier<int> groupValue;

  CardSection(this.type, {this.model, this.value, this.groupValue});
}

class CardBuilder implements ComponentBuilder<CardSection> {
  @override
  // ignore: missing_return
  Widget build(CardSection section) {
    return AddressCard(
      section: section,
    );
  }
}

class AddressCard extends StatefulWidget {
  final CardSection section;

  const AddressCard({Key key, this.section}) : super(key: key);
  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  bool isSelected() {
    if (widget.section.groupValue.value == widget.section.value) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: widget.section.groupValue,
        builder: (BuildContext context, int value, Widget child) {
          return GestureDetector(
            onTap: () {
              widget.section.groupValue.value = widget.section.value;
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: isSelected()
                            ? AppColors.appBlue
                            : AppColors.text_field_color)),
                margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 2.0086083213773316,
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884),
                child: Row(
                  children: [
                    Radio(
                      value: widget.section.value,
                      activeColor: isSelected()
                          ? AppColors.appBlue
                          : AppColors.text_field_color,
                      groupValue: widget.section.groupValue.value,
                      onChanged: (value) => {
                        widget.section.groupValue.value = value,
                      }
                      //  // print('heiheihie, wobeianle'),

                      ,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.heightMultiplier *
                                  2.0086083213773316,
                              left: SizeConfig.widthMultiplier *
                                  3.8888888888888884,
                              right: SizeConfig.widthMultiplier *
                                  3.8888888888888884),
                          child: Text(
                            '${widget.section.model.firstName + " " + widget.section.model.lastName ?? ""}',
                            style: GoogleFonts.inter(
                              fontSize:
                                  SizeConfig.textMultiplier * 1.757532281205165,
                              fontWeight: FontWeight.w700,
                              color: AppColors.app_txt_color,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.heightMultiplier *
                                  0.5021520803443329,
                              left: SizeConfig.widthMultiplier *
                                  3.8888888888888884,
                              right: SizeConfig.widthMultiplier *
                                  3.8888888888888884,
                              bottom: SizeConfig.heightMultiplier *
                                  2.0086083213773316),
                          child: Text(
                            '${widget.section.model.streetAddress ?? ""}\n${widget.section.model.suburb ?? ""} ${widget.section.model.state ?? ""} ${widget.section.model.country ?? ""}',
                            style: GoogleFonts.inter(
                              fontSize: SizeConfig.textMultiplier *
                                  1.5064562410329987,
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
        });
  }
}
