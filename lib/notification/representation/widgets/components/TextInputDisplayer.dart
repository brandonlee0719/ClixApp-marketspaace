import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/representation/listviewScreen/interfaces.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class TextInputDisplayer implements IWidgetDisplayer<TextInputViewModel>{
  @override
  Widget render(TextInputViewModel document) {
    // TODO: implement render
    return TextInputWidget(model: document,);
  }
  
}

class TextInputWidget extends StatelessWidget {
  final TextInputViewModel model;

  const TextInputWidget({Key key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(model.instructionText!=null)
          Container(
            alignment: Alignment.centerLeft,
          width: double.infinity,
          margin: EdgeInsets.only(
              top: SizeConfig.heightMultiplier * 1.5064562410329987,
              // left: SizeConfig.widthMultiplier * 3.645833333333333
          ),
          child: Text(
            model.instructionText,
            style: GoogleFonts.inter(
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
                color: AppColors.unselected_tab),
          ),
        ),
        Container(
          height: SizeConfig.heightMultiplier * 8.047345767575324,
          margin: EdgeInsets.only(
              // left: SizeConfig.widthMultiplier * 3.645833333333333,
              // right: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 1.5064562410329987),
          // padding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.645833333333333, right: SizeConfig.widthMultiplier * 3.645833333333333, top: SizeConfig.heightMultiplier * 1.3809182209469155),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: model.controller,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: model.hint,
                  labelText: model.label,
                  contentPadding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.645833333333333,
                      // right: SizeConfig.widthMultiplier * 3.645833333333333,
                      top: SizeConfig.heightMultiplier * 3.1384505021520805),
                  suffixStyle: GoogleFonts.inter(
                    color: AppColors.appBlue,
                    fontWeight: FontWeight.w400,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    letterSpacing: 0.25,
                  )),
            ),
          ),
        ),

      ],
    );
  }
}


class TextInputViewModel {
  final TextEditingController controller = TextEditingController();
  final String labelText;
  final String hintText;
  final String instructionText;

  String get label => this.labelText?? '';
  String get hint => this.hintText?? '';

  TextInputViewModel({

    this.labelText,
    this.hintText,
    this.instructionText}
    );

}