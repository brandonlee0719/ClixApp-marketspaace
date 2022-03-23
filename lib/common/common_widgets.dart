import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/responsive_layout/size_config.dart';

var yHeight05 = SizedBox(
  height: 0.5 * SizeConfig.heightMultiplier,
);

var yHeight1 = SizedBox(
  height: 1 * SizeConfig.heightMultiplier,
);
var yHeight2 = SizedBox(
  height: 2 * SizeConfig.heightMultiplier,
);
var yHeight3 = SizedBox(
  height: 3 * SizeConfig.heightMultiplier,
);
var yHeight4 = SizedBox(
  height: 4 * SizeConfig.heightMultiplier,
);
var yHeight5 = SizedBox(
  height: 5 * SizeConfig.heightMultiplier,
);
var yHeight6 = SizedBox(
  height: 6 * SizeConfig.heightMultiplier,
);
var yHeight7 = SizedBox(
  height: 7 * SizeConfig.heightMultiplier,
);
var yHeight8 = SizedBox(
  height: 8 * SizeConfig.heightMultiplier,
);
var yHeight9 = SizedBox(
  height: 9 * SizeConfig.heightMultiplier,
);
var yHeight10 = SizedBox(
  height: 10 * SizeConfig.heightMultiplier,
);

// Spacing Widgets (Horizontal)
var xWidth05 = SizedBox(
  width: 0.5 * SizeConfig.widthMultiplier,
);
var xWidth1 = SizedBox(
  width: 1 * SizeConfig.widthMultiplier,
);
var xWidth2 = SizedBox(
  width: 2 * SizeConfig.widthMultiplier,
);
var xWidth3 = SizedBox(
  width: 3 * SizeConfig.widthMultiplier,
);
var xWidth4 = SizedBox(
  width: 4 * SizeConfig.widthMultiplier,
);
var xWidth5 = SizedBox(
  width: 5 * SizeConfig.widthMultiplier,
);
var xWidth6 = SizedBox(
  width: 6 * SizeConfig.widthMultiplier,
);
var xWidth7 = SizedBox(
  width: 7 * SizeConfig.widthMultiplier,
);
var xWidth8 = SizedBox(
  width: 8 * SizeConfig.widthMultiplier,
);
var xWidth9 = SizedBox(
  width: 9 * SizeConfig.widthMultiplier,
);
var xWidth10 = SizedBox(
  width: 10 * SizeConfig.widthMultiplier,
);

// Gradient button
Widget btnGradient(String text, Function onTap, {gColor1, gColor2}) {
  return RaisedGradientButton(
    gradient: LinearGradient(
      colors: [
        gColor1 ?? AppColors.gradient_button_light,
        gColor2 ?? AppColors.gradient_button_dark,
      ], // Here it is
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    onPressed: onTap,
    // textColor: Colors.white,
    // padding: EdgeInsets.all(0.0),
    // elevation: 0,
    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 14),
      child: Text(text,
          style: GoogleFonts.inter(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.textMultiplier * 1.757532281205165,
              letterSpacing: 0.5,
              textStyle: TextStyle(fontFamily: 'Roboto'))),
    ),
  );
}

//// retry btn Error widget
Widget retryErrorBtn(String error, Function onTap, {double xMargin, double yMargin}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: xMargin ?? 15, vertical: yMargin ?? 0),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10)),
    child: Row(
      children: [
        Expanded(
          child: Text(
            '$error',
            style: TextStyle(
                color: Colors.red, fontSize: 1.8 * SizeConfig.textMultiplier),
          ),
        ),
        InkWell(
            onTap: onTap,
            child: Icon(
              Icons.refresh,
              color: Colors.red,
              size: 8 * SizeConfig.imageSizeMultiplier,
            ))
      ],
    ),
  );
}
