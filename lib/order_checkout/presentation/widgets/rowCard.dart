import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/model/product_detail_model/product_det_model.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class RowWidget extends StatelessWidget {
  final String _title;
  final double _price;

  const RowWidget(
    this._title,
    this._price, {
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 0.5021520803443329),
      child: Row(
        children: [
          Text(_title,
              style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                  color: AppColors.catTextColor,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.4)),
          Spacer(),
          Text("\$$_price",
              style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                  color: AppColors.catTextColor,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.4)),
        ],
      ),
    );
    ;
  }
}
