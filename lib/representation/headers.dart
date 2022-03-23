import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/responsive_layout/size_config.dart';

import 'componentBuilder.dart';
import 'inputBox.dart';

enum HeadersType{
 inputHeader,
}

class HeadersSection{
  final HeadersType type;
  final String text;

  HeadersSection(this.type, this.text);
}

class HeadersBuilder implements ComponentBuilder<HeadersSection>{
  @override
  // ignore: missing_return
    Widget build(HeadersSection section) {
      switch(section.type){
        case HeadersType.inputHeader:
        return inputHeader(section.text);
      }

    }


  Widget inputHeader( String notifyString){
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 4.131944444444444,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
      ),
      child: Text(
        notifyString,
        style: GoogleFonts.inter(
            fontSize: SizeConfig.textMultiplier * 1.757532281205165,
            fontWeight: FontWeight.bold,
            color: AppColors.grey_700,
            letterSpacing: 0.1),
      ),
    );

  }

}