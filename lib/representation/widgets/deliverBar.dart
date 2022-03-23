import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:market_space/apis/orderApi/orderApi.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/locator.dart';

class DeliverBarManager{
  final bool statusTag1;
  final bool statusTag2;
  final bool statusTag3;

  DeliverBarManager(this.statusTag1, this.statusTag2, this.statusTag3);
}

class DeliverBar extends StatefulWidget {


  @override
  _DeliverBarState createState() => _DeliverBarState();
}

class _DeliverBarState extends State<DeliverBar> {



  @override
  void initState() {



    


    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  ValueListenableBuilder<DeliverBarManager>(
        valueListenable: locator.get<OrderApi>().manager,

      builder: (context, value,child) {


        if (value == null) {
          return Text("Loading");
        }


        return Column(
          children: [
            Container(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: 12,
                      right: 3.77,
                      left: SizeConfig.widthMultiplier * 8.020833333333332),
                  height: SizeConfig.heightMultiplier * 1.0043041606886658,
                  width: 8,
                  decoration: BoxDecoration(
                      color: value.statusTag1 ? Color(0xff034AA6) : Color(0xffD4D4D4),
                      shape: BoxShape.circle),
                ),
                Container(
                  height: SizeConfig.heightMultiplier * 0.12553802008608322,
                  width: MediaQuery.of(context).size.width * 0.35,
                  margin: EdgeInsets.only(
                      top: 12,
                      right: 3.77,
                      left: SizeConfig.widthMultiplier * 0.48611111111111105),
                  decoration: BoxDecoration(
                      color: value.statusTag2 ? Color(0xff034AA6) : Color(0xffD4D4D4),
                      shape: BoxShape.rectangle),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 12,
                      right: 3.77,
                      left: SizeConfig.widthMultiplier * 0.48611111111111105),
                  height: SizeConfig.heightMultiplier * 1.0043041606886658,
                  width: 8,
                  decoration: BoxDecoration(
                      color: value.statusTag2 ? Color(0xff034AA6) : Color(0xffD4D4D4),
                      shape: BoxShape.circle),
                ),
                Container(
                  height: SizeConfig.heightMultiplier * 0.12553802008608322,
                  width: MediaQuery.of(context).size.width * 0.35,
                  margin: EdgeInsets.only(
                      top: 12,
                      right: 3.77,
                      left: SizeConfig.widthMultiplier * 0.48611111111111105),
                  decoration: BoxDecoration(
                      color: value.statusTag3 ? Color(0xff034AA6) : Color(0xffD4D4D4),
                      shape: BoxShape.rectangle),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 12,
                      right: 3.77,
                      left: SizeConfig.widthMultiplier * 0.48611111111111105),
                  height: SizeConfig.heightMultiplier * 1.0043041606886658,
                  width: 8,
                  decoration: BoxDecoration(
                      color: value.statusTag3 ? Color(0xff034AA6) : Color(0xffD4D4D4),
                      shape: BoxShape.circle),
                ),
              ],
            ),
          ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: 6,
                      right: 3.77,
                      left: SizeConfig.widthMultiplier * 1.9444444444444442),
                  width: 59,
                  child: Text("Recieved by sellers",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: GoogleFonts.inter(
                          color: Color(0xff034AA6),
                          fontSize:
                          SizeConfig.textMultiplier * 1.5064562410329987,
                          fontWeight: value.statusTag1
                              ? FontWeight.w700
                              : FontWeight.w400,
                          letterSpacing: 0.4)),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(
                      top: 6,
                      left: SizeConfig.widthMultiplier * 1.9444444444444442),
                  width: 50,
                  child: Text("Parcel sent",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: GoogleFonts.inter(
                          color: Color(0xff034AA6),
                          fontSize:
                          SizeConfig.textMultiplier * 1.5064562410329987,
                          fontWeight: value.statusTag2
                              ? FontWeight.w700
                              : FontWeight.w400,
                          letterSpacing: 0.4)),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(
                      top: 6,
                      left: SizeConfig.widthMultiplier * 1.9444444444444442,
                      right: 12),
                  // width: 57,
                  child: Text("Delivered",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          color: Color(0xff034AA6),
                          fontSize:
                          SizeConfig.textMultiplier * 1.5064562410329987,
                          fontWeight:value.statusTag3
                              ? FontWeight.w700
                              : FontWeight.w400,
                          letterSpacing: 0.4)),
                ),
              ],
            )
          ],
        );
      }
    );
  }
}
