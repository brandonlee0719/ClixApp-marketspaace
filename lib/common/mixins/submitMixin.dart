import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/responsive_layout/size_config.dart';

import '../colors.dart';

class CustomizedTextField{
  final String hintText;
  final String placeHolder;
  final TextEditingController controller;
  // miss a validate

  CustomizedTextField(this.hintText, this.placeHolder, this.controller);
}

enum InputState{
  await_loading,

  hasModel,
  noModel,
}

class IInputScreenBloc<T extends Object>{
  // this is an interface, ignore all miss return!
  // ignore: missing_return
  T getModel() {}

  // ignore: missing_return
  Future<T> getModelFromRemote() async{}

  void submit(){}


  // better to have a operator here, but just not enough time to check the operator
  // ignore: missing_return
  List<CustomizedTextField> getFields(){}
  // ignore: missing_return
  Stream<InputState> getStream(){}
}





mixin InputScreenMixin<T extends StatefulWidget> on State<T>{
  Widget buildScreen(IInputScreenBloc bloc){
    return Column(
      children: [
        for(CustomizedTextField field in bloc.getFields())
          _buildInputFields(field.hintText, field.hintText, field.controller)

      ],
    );
  }
  Widget _buildInputFields(String hintText, String labelText, TextEditingController controller){
    return Container(
      padding: EdgeInsets.only(left: SizeConfig.widthMultiplier*3,right:SizeConfig.widthMultiplier*3, top: SizeConfig.heightMultiplier * 2),
      child: TextField(
        style: GoogleFonts.inter(
          color: AppColors.text_field_color,
          fontWeight: FontWeight.w400,
          fontSize: SizeConfig.textMultiplier * 1.757532281205165,
          letterSpacing: 0.25,
        ),
        controller: controller,
        buildCounter: (BuildContext context,
            {int currentLength, int maxLength, bool isFocused}) =>
        null,
        decoration: new InputDecoration(
            border: new OutlineInputBorder(
                borderSide:
                new BorderSide(color: AppColors.text_field_color),
                borderRadius: BorderRadius.circular(10.0)),
            hintText: hintText,
            labelText: labelText,
            contentPadding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884),
            suffixStyle: const TextStyle(color: AppColors.appBlue)),
      ),
    );
  }
}