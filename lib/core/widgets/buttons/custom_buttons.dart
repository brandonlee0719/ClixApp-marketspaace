import 'package:flutter/material.dart';

class MSButtons {
  BuildContext context;
  String text;
  double borderRadius, textFontSize, letterSpacing;
  Color color, disabledColor;
  Color textColor;
  FontWeight fontWeight;
  Widget buttonContent;
  TextStyle explicitTextStyle;
  EdgeInsetsGeometry padding;
  Size size;
  void Function() onTap;

  MSButtons(
      {@required this.context,
        this.text = 'BUTTON',
        this.borderRadius = 5,
        this.disabledColor,
        this.color,
        this.textColor = Colors.white,
        this.textFontSize = 16,
        this.letterSpacing,
        this.padding,
        this.size,
        this.fontWeight = FontWeight.normal,
        this.explicitTextStyle,
        this.buttonContent,
        @required this.onTap}) {
    color ??= Theme.of(context).primaryColor;
  }

  Widget normal() {
    return SizedBox(
      height: size?.height,
      width: size?.width,
      child: TextButton(
        onPressed: onTap,
        // disabledColor: disabledColor,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(color),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(padding),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius)))),
        child: buttonContent ??
            Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: explicitTextStyle ??
                  TextStyle(
                    color: textColor,
                    fontSize: textFontSize,
                    letterSpacing: letterSpacing,
                    fontWeight: fontWeight,
                  ),
              textAlign: TextAlign.center,
            ),
      ),
    );
  }

  Widget outline({double borderWidth = 1, Color borderColor}) {
    return SizedBox(
      height: size?.height,
      width: size?.width,
      child: OutlinedButton(
        onPressed: onTap,
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(padding),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius))),
            side: MaterialStateProperty.all<BorderSide>(
                BorderSide(color: borderColor ?? color, width: borderWidth))),
        child: buttonContent ??
            Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: explicitTextStyle ??
                  TextStyle(
                    color: textColor,
                    fontSize: textFontSize,
                    letterSpacing: letterSpacing,
                    fontWeight: fontWeight,
                  ),
              textAlign: TextAlign.center,
            ),
      ),
    );
  }
}