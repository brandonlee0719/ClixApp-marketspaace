import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/model/order_status_model/order_status_model.dart';
import 'package:market_space/model/recently_product_model/recently_brought_model.dart';
import 'package:market_space/recently_brought_details/recently_detail_route.dart';
import 'package:market_space/recently_brought_products/recenlty_brought_products_l10n.dart';
import 'package:market_space/recently_brought_products/recently_brought_bloc.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class OrderDetailsPreviewWidget extends StatefulWidget {
  const OrderDetailsPreviewWidget(
      {Key key,
        @required this.model,
        @required this.recentlyBrought,
        })
      : super(key: key);
  final OrderStatusModel model;
  final RecentlyBrought recentlyBrought;


  @override
  _OrderDetailsPreviewWidgetState createState() =>
      _OrderDetailsPreviewWidgetState();
}

class _OrderDetailsPreviewWidgetState extends State<OrderDetailsPreviewWidget>
    with SingleTickerProviderStateMixin {
  RecentlyBoughtProductL10n _l10n = RecentlyBoughtProductL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  bool statusTag1 = false, statusTag2 = false, statusTag3 = false;

  AnimationController _animationController;
  Animation<Offset> _animationOffset;

  @override
  void initState() {
    if (widget.model != null) {
      if (widget.model.orderStatus != null ||
          widget.model.orderStatus.toLowerCase() ==
              _l10n.receivedBySeller.toLowerCase()) {
        statusTag1 = true;
        statusTag2 = false;
        statusTag3 = false;
      }
      if (widget.model.orderStatus != null ||
          widget.model.orderStatus.toLowerCase() ==
              _l10n.parcelSent.toLowerCase()) {
        statusTag1 = true;
        statusTag2 = true;
        statusTag3 = false;
      }
      if (widget.model.orderStatus != null ||
          widget.model.orderStatus.toLowerCase() ==
              _l10n.delivered.toLowerCase()) {
        statusTag1 = true;
        statusTag2 = true;
        statusTag3 = true;
      }
    }

    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

    _animationOffset = Tween(begin: Offset(0, -0.1), end: Offset.zero).animate(
        CurvedAnimation(
            parent: _animationController, curve: Curves.fastOutSlowIn));

    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animationOffset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 2.4305555555555554,
                top: SizeConfig.heightMultiplier * 1.5064562410329987),
            child: Text(
              _l10n.OrderStatus,
              style: GoogleFonts.inter(
                  color: AppColors.app_txt_color,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1),
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 1.5064562410329987,
                      right: SizeConfig.widthMultiplier * 0.9163194444444444,
                      left: SizeConfig.widthMultiplier * 8.020833333333332),
                  height: SizeConfig.heightMultiplier * 1.0043041606886658,
                  width: SizeConfig.widthMultiplier * 1.9444444444444442,
                  decoration: BoxDecoration(
                      color: statusTag1 ? Color(0xff034AA6) : Color(0xffD4D4D4),
                      shape: BoxShape.circle),
                ),
                Container(
                  height: SizeConfig.heightMultiplier * 0.12553802008608322,
                  width: MediaQuery.of(context).size.width * 0.30,
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 1.5064562410329987,
                      right: SizeConfig.widthMultiplier * 0.9163194444444444,
                      left: SizeConfig.widthMultiplier * 0.48611111111111105),
                  decoration: BoxDecoration(
                      color: statusTag2 ? Color(0xff034AA6) : Color(0xffD4D4D4),
                      shape: BoxShape.rectangle),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 1.5064562410329987,
                      right: SizeConfig.widthMultiplier * 0.9163194444444444,
                      left: SizeConfig.widthMultiplier * 0.48611111111111105),
                  height: SizeConfig.heightMultiplier * 1.0043041606886658,
                  width: SizeConfig.widthMultiplier * 1.9444444444444442,
                  decoration: BoxDecoration(
                      color: statusTag2 ? Color(0xff034AA6) : Color(0xffD4D4D4),
                      shape: BoxShape.circle),
                ),
                Container(
                  height: SizeConfig.heightMultiplier * 0.12553802008608322,
                  width: MediaQuery.of(context).size.width * 0.30,
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 1.5064562410329987,
                      right: SizeConfig.widthMultiplier * 0.9163194444444444,
                      left: SizeConfig.widthMultiplier * 0.48611111111111105),
                  decoration: BoxDecoration(
                      color: statusTag3 ? Color(0xff034AA6) : Color(0xffD4D4D4),
                      shape: BoxShape.rectangle),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 1.5064562410329987,
                      right: SizeConfig.widthMultiplier * 0.9163194444444444,
                      left: SizeConfig.widthMultiplier * 0.48611111111111105),
                  height: SizeConfig.heightMultiplier * 1.0043041606886658,
                  width: SizeConfig.widthMultiplier * 1.9444444444444442,
                  decoration: BoxDecoration(
                      color: statusTag3 ? Color(0xff034AA6) : Color(0xffD4D4D4),
                      shape: BoxShape.circle),
                ),
              ],
            ),
          ),
          if (widget.model?.orderStatus != null)
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 0.7532281205164993,
                      right: SizeConfig.widthMultiplier * 0.9163194444444444,
                      left: SizeConfig.widthMultiplier * 1.9444444444444442),
                  width: SizeConfig.widthMultiplier * 14.340277777777777,
                  child: Text(statusTag1 ? '${_l10n.receivedBySeller}' : "",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          color: Color(0xff034AA6),
                          fontSize:
                          SizeConfig.textMultiplier * 1.5064562410329987,
                          fontWeight: widget.model?.orderStatus?.toLowerCase() ==
                              _l10n.receivedBySeller
                              ? FontWeight.w700
                              : FontWeight.w400,
                          letterSpacing: 0.4)),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 0.7532281205164993,
                      left: SizeConfig.widthMultiplier * 1.9444444444444442),
                  width: SizeConfig.widthMultiplier * 17.013888888888886,
                  child: Text(_l10n.parcelSent,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          color: Color(0xff034AA6),
                          fontSize:
                          SizeConfig.textMultiplier * 1.5064562410329987,
                          fontWeight: widget.model.orderStatus.toLowerCase() ==
                              _l10n.parcelSent
                              ? FontWeight.w700
                              : FontWeight.w400,
                          letterSpacing: 0.4)),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 0.7532281205164993,
                      left: SizeConfig.widthMultiplier * 1.9444444444444442,
                      right: SizeConfig.widthMultiplier * 1.2152777777777777),
                  // width: SizeConfig.widthMultiplier * 13.854166666666664,
                  child: Text(_l10n.Delivered,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                          color: Color(0xff034AA6),
                          fontSize:
                          SizeConfig.textMultiplier * 1.5064562410329987,
                          fontWeight: widget.model.orderStatus.toLowerCase() ==
                              _l10n.delivered
                              ? FontWeight.w700
                              : FontWeight.w400,
                          letterSpacing: 0.4)),
                ),
              ],
            ),
          Padding(
            padding: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.5064562410329987,
                left: SizeConfig.widthMultiplier * 2.9166666666666665,
                right: SizeConfig.widthMultiplier * 2.9166666666666665),
            child: Row(children: [
              Text('${_l10n.ShippingCompany} :',
                  style: TextStyle(
                      color: AppColors.catTextColor,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165)),
              Spacer(),
              Text(
                  (widget.model?.shippingCompany?.isNotEmpty ?? false)
                      ? widget.model?.shippingCompany
                      : "Regular Mail",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: AppColors.catTextColor,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165)),
            ]),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.5064562410329987,
                left: SizeConfig.widthMultiplier * 2.9166666666666665,
                right: SizeConfig.widthMultiplier * 2.9166666666666665),
            child: Row(children: [
              Text('${_l10n.TrackingNumber} :',
                  style: TextStyle(
                      color: AppColors.catTextColor,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165)),
              Spacer(),
              Text(
                  (widget.model?.trackingNumber?.isNotEmpty ?? false)
                      ? widget.model?.trackingNumber
                      : "Not provided",
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: AppColors.catTextColor,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165)),
            ]),
          ),
          Row(children: [
            FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                RecentlyDetailRoute.recentlyBoughtModel = widget.recentlyBrought;
                RecentlyDetailRoute.orderStatusModel = widget.model;
                RouterService.appRouter
                    .navigateTo(RecentlyDetailRoute.buildPath());
              },
              child: Container(
                margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 2.0086083213773316,
                    left: SizeConfig.widthMultiplier * 2.9166666666666665,
                    right: SizeConfig.widthMultiplier * 2.9166666666666665,
                    bottom: SizeConfig.heightMultiplier * 1.2553802008608321),
                child: Text(_l10n.MOREOPTIONS,
                    style: TextStyle(
                        color: AppColors.appBlue,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Spacer(),
            FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                RecentlyDetailRoute.recentlyBoughtModel = widget.recentlyBrought;
                RecentlyDetailRoute.orderStatusModel = widget.model;
                RouterService.appRouter
                    .navigateTo(RecentlyDetailRoute.buildPath());
              },
              child: Container(
                margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 2.0086083213773316,
                    left: SizeConfig.widthMultiplier * 2.9166666666666665,
                    right: SizeConfig.widthMultiplier * 2.9166666666666665,
                    bottom: SizeConfig.heightMultiplier * 1.2553802008608321),
                child: Text(_l10n.CancelOrder.toUpperCase(),
                    style: TextStyle(
                        color: AppColors.cancel_red,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}