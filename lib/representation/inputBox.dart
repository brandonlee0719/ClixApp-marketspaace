import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/representation/componentBuilder.dart';
import 'package:market_space/responsive_layout/size_config.dart';

enum InputSectionType{
  inputBox,
}

class InputSection{
  final InputSectionType type;
  final String notifyString;
  final String placeHolder;
  final TextEditingController controller;

  InputSection(this.type, this.notifyString, this.placeHolder,this.controller);
}

class InputBuilder implements ComponentBuilder<InputSection>{
  @override
  // ignore: missing_return
  Widget build(InputSection section) {
    switch(section.type){
      case InputSectionType.inputBox:
        return _inputBox(section.controller,section.notifyString,section.placeHolder);
    }

  }


  Widget _inputBox(TextEditingController controller, String notifyString, String placeHolder){
    return TextField(
        keyboardType: TextInputType.text,
        controller: controller,
        style: GoogleFonts.inter(
            fontSize:
                SizeConfig.textMultiplier * 1.757532281205165,
            fontWeight: FontWeight.w400,
            color: AppColors.grey_700,
            letterSpacing: 0.25),
        decoration: new InputDecoration(
            border: new OutlineInputBorder(
                borderSide:
                    new BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10.0)),
            hintText: notifyString,
            labelText: placeHolder,
            contentPadding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier *
                    3.8888888888888884),
            suffixStyle:
                const TextStyle(color: AppColors.appBlue)),
      );
  }

}