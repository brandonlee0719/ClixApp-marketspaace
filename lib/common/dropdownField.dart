import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class DropdownField<T> extends StatelessWidget {
  final String hintText;
  final FocusNode focusNode;
  Widget icon;
  final List<DropdownMenuItem<T>> dropdownItems;
  final T value;
  final void Function(T) onChanged;void Function() onTap;
  final Color dropdownColor, borderColor;
  final double leftMargin,
      rightMargin,
      topMargin,
      bottomMargin,
      borderRadius,
      iconSize;
  TextStyle textStyle, hintTextStyle;
  bool isExpanded;

  DropdownField({
    Key key,
    @required this.dropdownItems,
    @required this.onChanged,
    @required this.hintText,
    this.onTap,
    this.textStyle,
    this.hintTextStyle,
    this.isExpanded = false,
    this.focusNode,
    this.value,
    this.icon,
    this.rightMargin = 0,
    this.leftMargin = 0,
    this.topMargin = 0,
    this.bottomMargin = 0,
    this.borderRadius = 10,
    this.iconSize = 24.0,
    this.dropdownColor,
    this.borderColor = AppColors.text_field_container,
  }) : super(key: key) {
    this.icon = icon ??
        Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.darkgrey500,
        );
    this.textStyle = textStyle ??
        GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: SizeConfig.textMultiplier * 1.757532281205165,
            letterSpacing: 0.1,
            color: AppColors.app_txt_color);
    this.hintTextStyle =
        hintTextStyle ?? TextStyle(color: Colors.black.withOpacity(0.6));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: bottomMargin,
          left: leftMargin,
          right: rightMargin,
          top: topMargin),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(borderRadius)),
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
              key: key,
              onTap: onTap,
              focusNode: focusNode,
              hint: Text(hintText, style: hintTextStyle),
              icon: icon,
              iconSize: iconSize,
              dropdownColor: dropdownColor,
              value: value,
              style: textStyle,
              items: dropdownItems,
              isExpanded: isExpanded,
              onChanged: onChanged),
        ),
      ),
    );
  }
}
