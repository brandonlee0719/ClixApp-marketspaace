import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class PreviewTitleWidget extends StatelessWidget {
  final String title;

  const PreviewTitleWidget({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 2.0086083213773316,
          bottom: SizeConfig.heightMultiplier * 1.0043041606886658),
      child: Text(
        title,
        style: GoogleFonts.inter(
            fontSize: SizeConfig.textMultiplier * 2.259684361549498,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
            color: AppColors.app_txt_color),
      ),
    );
  }
}

class CryptoAmountWidget extends StatelessWidget {
  final String text;

  const CryptoAmountWidget({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      margin: EdgeInsets.only(
        left: SizeConfig.widthMultiplier * 3.8888888888888884,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 1,
        // softWrap: true,
        // overflow: TextOverflow.ellipsis,
        style: GoogleFonts.inter(
            fontSize: SizeConfig.textMultiplier * 4.527977044476327,
            fontWeight: FontWeight.w200,
            letterSpacing: -0.5,
            color: AppColors.investment_back),
      ),

    );
  }
}

class PreviewRow extends StatelessWidget {
  final String title;
  final String number;

  const PreviewRow({Key key, this.title, this.number}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 4.017216642754663),
      child: Row(
        children: [
          Container(
            child: Text(
              title,
              style: GoogleFonts.inter(
                color: AppColors.sub_text,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Spacer(),
          Container(
            child: Text(
              number,
              style: GoogleFonts.inter(
                color: AppColors.text_field_container,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String title;
  final String number;

  const SummaryRow({Key key, this.title, this.number}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 4.017216642754663),
      child: Row(
        children: [
          Container(
            child: Text(
              title,
              style: GoogleFonts.inter(
                color: AppColors.black,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 2.5086083213773316,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Spacer(),
          Container(
            child: Text(
              number,
              style: GoogleFonts.inter(
                color: AppColors.sub_text,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 2.5086083213773316,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


