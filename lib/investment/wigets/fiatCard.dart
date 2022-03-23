import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/investment/logic/investment_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class FiatCard extends StatefulWidget {
  final Color color;
  final String imageUri;
  final String labelText;

  FiatCard({this.color, this.imageUri, this.labelText});

  @override
  _FiatCardState createState() => _FiatCardState();
}

class _FiatCardState extends State<FiatCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884, right: SizeConfig.widthMultiplier * 3.8888888888888884, top: SizeConfig.heightMultiplier * 1.5064562410329987),
      child: Container(
        height: SizeConfig.heightMultiplier * 7.40674318507891,
        margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 0.9722222222222221),
        color: AppColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin:
                EdgeInsets.only(left: SizeConfig.widthMultiplier * 2.9166666666666665, top: SizeConfig.heightMultiplier * 2.0086083213773316, bottom: SizeConfig.heightMultiplier * 2.259684361549498, right: SizeConfig.widthMultiplier * 2.9166666666666665),
                child: Image.asset(
                  widget.imageUri,
                  height: SizeConfig.heightMultiplier * 3.0129124820659974,
                  width: SizeConfig.widthMultiplier * 5.833333333333333,
                )),
            Container(
              child: Text(
                widget.labelText,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                ),
              ),
            ),
            Spacer(),
            Container(
                margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 2.9166666666666665, right: SizeConfig.widthMultiplier * 2.9166666666666665),
                child: Builder(builder: (context){
                  final state = context.watch<InvestmentBloc>().state;
                  final wallet = context.watch<InvestmentBloc>().walletRepository.wallet;
                  if(state == InvestmentState.reloadSuccess){
                    return Text(wallet.disPlayMap[widget.labelText], style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    ),);
                  }
                  //give a default value here
                  return Text('loading....', style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  ),);
                })
              //Builder(
              //   child: Text(
              //     "\$8888",
              //     style: GoogleFonts.inter(
              //       fontWeight: FontWeight.w700,
              //       fontSize: SizeConfig.textMultiplier * 1.757532281205165,
              //     ),
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
