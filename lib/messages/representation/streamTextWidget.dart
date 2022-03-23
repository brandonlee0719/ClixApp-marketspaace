import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/responsive_layout/size_config.dart';

enum SelectTextStyle { name, date, unreadMessage, content }

extension _SelectTextExtension on SelectTextStyle {
  TextStyle getStyle() {
    switch (this) {
      case SelectTextStyle.name:
        return _fontForName;
      default:
        return _fontForDate;
    }
  }
}

//font for name
TextStyle _fontForName = GoogleFonts.inter(
  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
  fontWeight: FontWeight.w700,
  color: AppColors.app_txt_color,
);

TextStyle _fontForDate = GoogleFonts.inter(
  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
  fontWeight: FontWeight.w400,
  color: AppColors.app_txt_color,
);

class StreamTextWidget extends StatefulWidget {
  final String text;
  final SelectTextStyle style;

  const StreamTextWidget({Key key, this.text, this.style}) : super(key: key);

  @override
  _StreamTextWidgetState createState() => _StreamTextWidgetState();
}

class _StreamTextWidgetState extends State<StreamTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      maxLines: 1,
      style: widget.style.getStyle(),
    );
  }
}

class StreamIMageWidget extends StatefulWidget {
  final String imgUrl;

  const StreamIMageWidget({Key key, this.imgUrl}) : super(key: key);
  @override
  _StreamIMageWidgetState createState() => _StreamIMageWidgetState();
}

class _StreamIMageWidgetState extends State<StreamIMageWidget> {
  @override
  void initState() {
    // print(widget.imgUrl);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.imgUrl[0] == 'a')
        ? Image.asset(
            widget.imgUrl,
            width: SizeConfig.widthMultiplier * 14.583333333333332,
            height: SizeConfig.heightMultiplier * 7.532281205164993,
          )
        : Image.network(
            widget.imgUrl,
            width: SizeConfig.widthMultiplier * 14.583333333333332,
            height: SizeConfig.heightMultiplier * 7.532281205164993,
          );
  }
}
