import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class ReusableFonts{
  static var priceStyle1 =  GoogleFonts.inter(
      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.1,
  );

  static var cardTitleStyle = GoogleFonts.inter(
      fontSize:
      SizeConfig.textMultiplier * 2.259684361549498,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.15,
  );

  static var cardDescription = GoogleFonts.inter(
      fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
      fontWeight: FontWeight.w400,
      color: AppColors.catTextColor,
      letterSpacing: 0.4

  );

  static var sectionTitle = GoogleFonts.inter(
    color: AppColors.catTextColor,
    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  static var body_one = GoogleFonts.inter(
    color: AppColors.gray_500,
    fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5
  );

}