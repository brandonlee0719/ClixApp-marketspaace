import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';
import 'package:market_space/responsive_layout/size_config.dart';


class AddressCardComponent extends StatelessWidget {
  final UpdateAddressModel model;

  const AddressCardComponent({Key key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.heightMultiplier * 12.679340028694405,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
        ),
        padding: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 2.861111111111111,
            top: SizeConfig.heightMultiplier * 2.0086083213773316,
            right: SizeConfig.widthMultiplier * 3.8888888888888884),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.appBlue)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 1.8888888888888884,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884),
              child: Text(
                '${model.firstName + model.lastName ?? ""}',
                style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 2,
                  fontWeight: FontWeight.w700,
                  color: AppColors.app_txt_color,
                  letterSpacing: 0.1,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: SizeConfig.heightMultiplier * 0.5021520803443329,
                  left: SizeConfig.widthMultiplier * 1.8888888888888884,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                  bottom: SizeConfig.heightMultiplier * 2.0086083213773316),
              child: Text(
                '${model.streetAddress ?? ""}\n${model.suburb ?? ""} ${model.state ?? ""} ${model.country ?? ""}',
                style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                  fontWeight: FontWeight.w400,
                  color: AppColors.app_txt_color,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
        ));
  }
}
