import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/notification/routes/notification_route.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/RouterServices.dart';

class SellAssetToolBar extends PreferredSize {
  final double height =
      SizeConfig.heightMultiplier * 8.571018651362985704000955107872;
  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: preferredSize.height,
          // margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 4.770444763271162),
          color: AppColors.appBlue,
          child: Row(
            children: [
              Container(
                child: Container(
                  // width: SizeConfig.widthMultiplier * 60.27777777777777,
                  height: kToolbarHeight,
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.widthMultiplier *
                                    2.4305555555555554),
                            child: SvgPicture.asset(
                              'assets/images/Back_button.svg',
                              width: SizeConfig.widthMultiplier *
                                  5.833333333333333,
                              height: SizeConfig.heightMultiplier *
                                  3.0129124820659974,
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier *
                                  2.4305555555555554),
                          child: Text(
                            'MY WALLET',
                            style: TextStyle(
                                color: AppColors.white,
                                fontFamily: 'inter',
                                fontStyle: FontStyle.normal,
                                fontSize: SizeConfig.textMultiplier *
                                    2.0086083213773316,
                                fontWeight: FontWeight.w300),
                          )),
                    ],
                  ),
                ),
              ),
              Spacer(),
              // Container(
              //   margin: EdgeInsets.only(
              //       left: SizeConfig.widthMultiplier * 2.9166666666666665,
              //       top: SizeConfig.heightMultiplier * 1.5064562410329987,
              //       right: SizeConfig.widthMultiplier * 2.9166666666666665,
              //       bottom:
              //       SizeConfig.heightMultiplier * 1.0043041606886658),
              //   child: InkWell(
              //       onTap: () {
              //         RouterService.appRouter
              //             .navigateTo(NotificationRoute.buildPath());
              //       },
              //       child: Badge(
              //         badgeContent: Text(
              //           '12',
              //           style: GoogleFonts.inter(
              //               color: AppColors.white,
              //               fontSize: SizeConfig.textMultiplier *
              //                   1.3809182209469155),
              //         ),
              //         badgeColor: AppColors.gradient_button_light,
              //         child: SvgPicture.asset(
              //           'assets/images/la_bell.svg',
              //           height: SizeConfig.heightMultiplier *
              //               3.0129124820659974,
              //           width:
              //           SizeConfig.widthMultiplier * 5.833333333333333,
              //           color: AppColors.white,
              //         ),
              //       )),
              // ),
            ],
          )),
    );
  }
}
