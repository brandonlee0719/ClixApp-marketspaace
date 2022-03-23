import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/investment/constants/gFonts.dart';
import 'package:market_space/investment/network/cryptoClient.dart';
import 'package:market_space/investment/sell_assets/sell_asset_route.dart';

import 'package:market_space/investment/wigets/textField/basicTextField.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/services/routServiceProvider.dart';
import 'package:provider/provider.dart';

enum CardType {
  BTC,
  ETH,
  USDC,
}

class UniversalCard extends StatefulWidget {
  final Color color;
  final String imageUri;
  final String labelText;
  // final String interestRate;
  final CardType type;
  final String name;

  UniversalCard(
      {this.color,
      this.imageUri,
      this.labelText,
      // this.interestRate,
      this.type,
      this.name});

  @override
  _UniversalCardState createState() => _UniversalCardState();
}

class _UniversalCardState extends State<UniversalCard> {
  CryptoClient client = CryptoClient();
  bool expanded = false;
  @override
  void initState() {
    // client.start();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      margin: EdgeInsets.only(
        left: SizeConfig.widthMultiplier * 3.8888888888888884,
        right: SizeConfig.widthMultiplier * 3.8888888888888884,
        bottom: SizeConfig.heightMultiplier * 1.5064562410329987,
      ),
      child: Container(
        color: AppColors.white,
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 0.9722222222222221),
        child: ExpansionTile(
          onExpansionChanged: (value) {
            setState(() {
              if (widget.type == CardType.BTC) {
                client.isBTCExpend = value;
              }
              if (widget.type == CardType.ETH) {
                client.isETHExpend = value;
              }
              client.start();
              client.dispose();
              expanded = value;
            });
          },
          title: Container(
            height: SizeConfig.heightMultiplier * 7.40674318507891,
            // margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 0.9722222222222221),
            color: AppColors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    // margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 2.9166666666666665, top: SizeConfig.heightMultiplier * 2.0086083213773316, bottom: SizeConfig.heightMultiplier * 2.259684361549498, right: SizeConfig.widthMultiplier * 2.9166666666666665),
                    child: Image.asset(
                  widget.imageUri,
                  height: SizeConfig.heightMultiplier * 3.0129124820659974,
                  width: SizeConfig.widthMultiplier * 5.833333333333333,
                )),
                Container(
                    margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 2.4064562410329987,
                      left: SizeConfig.widthMultiplier * 1,
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BasicText(
                          labelText: widget.labelText,
                          style: labelStyle,
                          isTop: true,
                        ),
                        // BasicText(
                        //   labelText: '${widget.interestRate}% Interest APY',
                        //   style: growthStyle,
                        //   align: TextAlign.start,
                        // ),
                      ],
                    )),
                Spacer(),
                if (!expanded)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ResponseText(
                        labelText: widget.labelText,
                        style: assetStyle,
                        insets: EdgeInsets.only(
                            left:
                                SizeConfig.widthMultiplier * 2.9166666666666665,
                            top: SizeConfig.heightMultiplier *
                                2.0086083213773316,
                            right: SizeConfig.widthMultiplier *
                                2.9166666666666665),
                      ),

                      //to-do: here should be BTC 0.0071

                      ResponseText(
                          labelText: widget.labelText + "_transfer",
                          style: cryptoAssetStyle,
                          insets: EdgeInsets.only(
                            left:
                                SizeConfig.widthMultiplier * 2.9166666666666665,
                            right:
                                SizeConfig.widthMultiplier * 2.9166666666666665,
                          )),
                    ],
                  ),
                if (expanded && widget.type == CardType.USDC)
                  ResponseText(
                      labelText: widget.labelText + "_price",
                      style: cryptoAssetStyle,
                      insets: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 2.9166666666666665,
                        right: SizeConfig.widthMultiplier * 2.9166666666666665,
                      )),
                if (expanded && widget.type == CardType.ETH)
                  StreamBuilder(
                    stream: client.ethcontroller.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        // print("error");
                      }
                      if (snapshot.hasData) {
                        // print("no error");
                      }
                      return Text(snapshot.hasData
                          ? '\$${snapshot.data.toString()}'
                          : '\$${client.lastETH}');
                    },
                  ),
                if (expanded && widget.type == CardType.BTC)
                  StreamBuilder(
                    stream: client.btccontroller.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        // print("error");
                      }
                      if (snapshot.hasData) {
                        // print("no error");
                      }
                      return Text(snapshot.hasData
                          ? '\$${snapshot.data.toString()}'
                          : '\$${client.lastBTC}');
                    },
                  ),
              ],
            ),
          ),
          children: [
            AmountCard(
              title: "Amount in wallet",
              label: widget.labelText,
            ),
            AmountCard(
              title: "Held Funds",
              label: "${widget.labelText}_held",
            ),
            GestureDetector(
              onTap: () {
                context.read<RouteServiceProvider>().transferRoute =
                    CryptoRouteType.buy;
                // print(widget.labelText);
                SellAssetRoute.coinType = widget.labelText;

                // RouterService.appRouter.navigateTo(SellAssetRoute.buildPath());
                RouterService.appRouter
                    .navigateTo(SellAssetRoute.buildPath() + "?isReceive=true");
              },
              child: Container(
                height: SizeConfig.heightMultiplier * 6.025824964131995,
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    bottom: SizeConfig.heightMultiplier * 1.5107604017216643,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884),
                decoration: BoxDecoration(
                    // border: Border.all(color: AppColors.appBlue),
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: [
                      AppColors.gradient_button_light,
                      AppColors.gradient_button_dark
                    ])),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Top Up",
                    style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.white),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.read<RouteServiceProvider>().transferRoute =
                    CryptoRouteType.sell;
                // print(widget.labelText);
                SellAssetRoute.coinType = widget.labelText;
                RouterService.appRouter
                    .navigateTo(SellAssetRoute.buildPath() + "?withDraw=true");
              },
              child: Container(
                height: SizeConfig.heightMultiplier * 6.025824964131995,
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    bottom: SizeConfig.heightMultiplier * 1.5107604017216643,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.toolbarBlue,
                    width: 2,
                  ),

                  // border: Border.all(color: AppColors.appBlue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Withdraw",
                    style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.toolbarBlue),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AmountCard extends StatelessWidget {
  final String title;
  final label;

  const AmountCard({Key key, this.title, this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.heightMultiplier * 7.40674318507891,
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 0.9722222222222221),
      color: AppColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.5064562410329987,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BasicText(
                    labelText: title,
                    style: labelStyle,
                  ),
                ],
              )),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ResponseText(
                labelText: label,
                style: assetStyle,
                insets: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 2.9166666666666665,
                    top: SizeConfig.heightMultiplier * 2.0086083213773316,
                    right: SizeConfig.widthMultiplier * 2.9166666666666665),
              ),

              //to-do: here should be BTC 0.0071

              ResponseText(
                  labelText: '${label}_transfer',
                  style: cryptoAssetStyle,
                  insets: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 2.9166666666666665,
                    right: SizeConfig.widthMultiplier * 2.9166666666666665,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
