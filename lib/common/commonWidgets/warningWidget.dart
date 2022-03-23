import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:market_space/common/colors.dart';

class WarningWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      padding: EdgeInsets.only(
        left: 14,
        top: 8,
        bottom: 8
      ),
      child: Row(
        children:[
          SvgPicture.asset("assets/images/financials/alert-triangle.svg"),
          SizedBox(width: 10,),
          Text("Can't use card for more than 2 item",
          style: TextStyle(
            color: AppColors.white,
          ),)
        ]

      ),
      decoration: BoxDecoration(
        color: AppColors.cancel_red,
        borderRadius: BorderRadius.circular(12),
      ),


    );
  }
}
