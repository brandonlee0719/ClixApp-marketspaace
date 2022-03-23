import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class ChooseCoinScreen extends StatelessWidget {
  final Color background = AppColors.toolbarBlue;
  final Color fill = AppColors.lightgrey;

  @override
  Widget build(BuildContext context) {
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];

    final double fillPercent = 39.7; // fills 56.23% for container from bottom
    final double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: gradient,
              stops: stops)),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: Toolbar(
            title: "Crypto selection",
          ),
          // bottomNavigationBar: Container(
          //   color: AppColors.white,
          // ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  top: SizeConfig.heightMultiplier * 4.0086083213773316,
                  bottom: SizeConfig.heightMultiplier * 2.0086083213773316,
                ),
                child: Text(
                  'Choose a Crypto',
                  style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.15,
                      color: AppColors.app_txt_color),
                ),
              ),
              _bitcoinCard(
                  'Bitcoin (BTC)',
                  Image.asset(
                    'assets/images/logos_bitcoin.png',
                    height: SizeConfig.heightMultiplier * 3.0129124820659974,
                    width: SizeConfig.widthMultiplier * 5.833333333333333,
                  ),
                  AppColors.bitcoin_orange),
              _bitcoinCard(
                'Ethereum (ETH)',
                Image.asset(
                  'assets/images/ethereum_logo.png',
                  height: SizeConfig.heightMultiplier * 3.0129124820659974,
                  width: SizeConfig.widthMultiplier * 4.861111111111111,
                ),
                AppColors.black,
              ),
              _bitcoinCard(
                'USD coin (USDC)',
                Image.asset(
                  'assets/images/cryptocurrency_usdc.png',
                  height: SizeConfig.heightMultiplier * 3.0129124820659974,
                  width: SizeConfig.widthMultiplier * 5.833333333333333,
                ),
                AppColors.toolbarBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bitcoinCard(String title, Image image, Color color) {
    return Builder(builder: (context) {
      return Card(
        color: color,
        margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          bottom: SizeConfig.widthMultiplier * 3.8888888888888884,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context, title);
          },
          child: Container(
            height: SizeConfig.heightMultiplier * 7.40674318507891,
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 0.9722222222222221),
            color: AppColors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 2.9166666666666665,
                        top: SizeConfig.heightMultiplier * 2.0086083213773316,
                        bottom: SizeConfig.heightMultiplier * 2.259684361549498,
                        right: SizeConfig.widthMultiplier * 2.9166666666666665),
                    child: image),
                Container(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                    ),
                  ),
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Container(
                    //   margin: EdgeInsets.only(
                    //       left: SizeConfig.widthMultiplier * 2.9166666666666665,
                    //       top: SizeConfig.heightMultiplier * 2.0086083213773316,
                    //       right: SizeConfig.widthMultiplier * 2.9166666666666665),
                    //   child: Text(
                    //     'A\$60,609.42',
                    //     style: GoogleFonts.inter(
                    //       fontWeight: FontWeight.w700,
                    //       fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(
                    //       left: SizeConfig.widthMultiplier * 2.9166666666666665,
                    //       right: SizeConfig.widthMultiplier * 2.9166666666666665),
                    //   child: Text(
                    //     '-1.23%',
                    //     style: GoogleFonts.inter(
                    //         fontWeight: FontWeight.w400,
                    //         fontSize:
                    //         SizeConfig.textMultiplier * 1.5064562410329987,
                    //         color: AppColors.red_text,
                    //         letterSpacing: 0.4),
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
