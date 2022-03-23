import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class InputContainer extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final TextEditingController controller;
  final String hintText;
  final double width;

  InputContainer(
      this.margin, this.controller, this.hintText, this.width, this.padding);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: 10,
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: 16),
      height: SizeConfig.heightMultiplier * 5.523672883787662,
      width: width,
      child: Theme(
        data: ThemeData(
          primaryColor: AppColors.appBlue,
          primaryColorDark: AppColors.appBlue,
        ),
        child: TextField(
          keyboardType: TextInputType.text,
          controller: this.controller,
          style: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.textMultiplier * 1.757532281205165,
              letterSpacing: 0.1,
              color: AppColors.app_txt_color),
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.appBlue, width: 0.5),
                  borderRadius: BorderRadius.circular(10.0)),
              contentPadding: padding,
              hintText: hintText,
              suffixStyle: const TextStyle(color: AppColors.appBlue)),
        ),
      ),
    );
  }
}
