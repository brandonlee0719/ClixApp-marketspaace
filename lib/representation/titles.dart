


import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/responsive_layout/size_config.dart';

import 'componentBuilder.dart';


enum TitleSectionType{
  simpleTitle,
}

class TitleSection{
  final TitleSectionType type;
  final String titleString;

  TitleSection(this.type, this.titleString);



}

class TitleBuilder implements ComponentBuilder<TitleSection>{
  @override
  // ignore: missing_return
  Widget build(TitleSection section) {
    switch(section.type){
      case TitleSectionType.simpleTitle:
        return _simpleTitle(section.titleString);
    }

  }


  Widget _simpleTitle( String title){
    return  Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        top: SizeConfig.heightMultiplier * 6.922166427546629,
        bottom: SizeConfig.heightMultiplier * 8.159971305595409,
      ),
      child: Container(
        child: Text(
          title,
          style: GoogleFonts.inter(
              fontSize:
              SizeConfig.textMultiplier * 2.887374461979914,
              fontWeight: FontWeight.w900,
              color: AppColors.app_txt_color),
        ),
      ),
    );
  }

}