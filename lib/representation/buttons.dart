


import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/responsive_layout/size_config.dart';

import 'componentBuilder.dart';


enum ButtonSectionType{
  confirmButton,
  responseButton,
  blueButton,
  redButton
}

class ButtonSection{
  final ButtonSectionType type;
  final String buttonString;
  final Function() onPressed;

  ButtonSection(this.type, this.buttonString, this.onPressed);


}

class ButtonBuilder implements ComponentBuilder<ButtonSection>{
  @override
  // ignore: missing_return
  Widget build(ButtonSection section) {
    switch(section.type){
      case ButtonSectionType.confirmButton:
        return _confirmButton(section.buttonString,section.onPressed);
      case ButtonSectionType.responseButton:
        return _ResponseButton(
          buttonString: section.buttonString,
          onPressed: section.onPressed,);
      case ButtonSectionType.blueButton:
        return _blueButton(section.buttonString, section.onPressed);
      case ButtonSectionType.redButton:
        return _redButton(section.buttonString, section.onPressed);
    }

  }

  Widget _redButton(String buttonString, Function() onPressed){
    return GestureDetector(
        onTap: onPressed,
        child: Container(
            width:  SizeConfig.widthMultiplier * 79.72222222222221,
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(
                bottom: 40,
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cancel_red),
            ),
            child: Center(
              child: Text(
                buttonString,
                style: TextStyle(
                    fontSize: SizeConfig.textMultiplier *
                        1.757532281205165,
                    color: AppColors.cancel_red,
                    fontWeight: FontWeight.w700),
              ),
            )));
  }

  Widget _blueButton(String buttonString, Function() onPressed){
    return GestureDetector(
        onTap: onPressed,
        child: Container(
            width: double.infinity,
            height: 50.0,
            padding: EdgeInsets.all(15),
            // margin: EdgeInsets.only(
            //     bottom: 12,
            //     left: SizeConfig.widthMultiplier * 3.8888888888888884,
            //     right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.appBlue),
            ),
            child: Center(
              child:  Text(
                buttonString,
                style: TextStyle(
                    fontSize: SizeConfig.textMultiplier *
                        1.757532281205165,
                    color: AppColors.appBlue,
                    fontWeight: FontWeight.w700),
              ),
            )
        )
    );
  }

  Widget _confirmButton( String buttonString, Function() onPressed){
    return Container(
      // width: SizeConfig.widthMultiplier * 79.72222222222221,
      // height: SizeConfig.heightMultiplier * 6.025824964131995,
      // margin: EdgeInsets.only(
      //     top: SizeConfig.heightMultiplier * 2.5107604017216643,
      //     left: SizeConfig.widthMultiplier * 3.8888888888888884,
      //     right: SizeConfig.widthMultiplier * 3.8888888888888884),
      // padding: EdgeInsets.all(SizeConfig.widthMultiplier*3),
      child: RaisedGradientButton(
        gradient: LinearGradient(
          colors: <Color>[
            AppColors.gradient_button_light,
            AppColors.gradient_button_dark,
          ],
        ),
        child: Text(
          buttonString,
          style: GoogleFonts.inter(
              fontSize:
              SizeConfig.textMultiplier * 1.757532281205165,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
              letterSpacing: 0.1),
        ),
        onPressed: onPressed,

      ),
    );
  }

}

class _ResponseButton extends StatefulWidget {
  final String buttonString;
  final Function() onPressed;


  const _ResponseButton({Key key, this.buttonString, this.onPressed}) : super(key: key);
  @override
  _ResponseButtonState createState() => _ResponseButtonState();
}

class _ResponseButtonState extends State<_ResponseButton> {
  Color _color = AppColors.app_txt_color;
  Color _borderColor = AppColors.text_field_container;
  
  Future<void> _colorFunction() async {
    setState(() {
      _color = AppColors.appBlue;
      _borderColor = AppColors.appBlue;
    });
    await Future.delayed(const Duration(milliseconds: 800), (){});
    setState(() {
      _color = AppColors.app_txt_color;
      _borderColor = AppColors.text_field_container;
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       widget.onPressed();
       _colorFunction();
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _borderColor)),
        margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 2.0086083213773316, left: SizeConfig.widthMultiplier * 3.8888888888888884, right: SizeConfig.widthMultiplier * 3.8888888888888884),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 1.8830703012912482, left: SizeConfig.widthMultiplier * 4.618055555555555, right: SizeConfig.widthMultiplier * 4.131944444444444, bottom: SizeConfig.heightMultiplier * 1.5064562410329987),
              child: Icon(
                Icons.add,
                color: _borderColor,
                size: 24,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 1.8830703012912482, bottom: SizeConfig.heightMultiplier * 1.5064562410329987),
              child: Text(
                widget.buttonString,
                style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  fontWeight: FontWeight.w400,
                  color: _color,
                  letterSpacing: 0.25,
                ),
              ),
            ),
          ],
        ),
      ),
    );;
  }
}
