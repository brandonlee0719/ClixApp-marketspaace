import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/notification/logics/blocs/notification_bloc.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BadgeContent extends StatefulWidget {
  @override
  _BadgeContentState createState() => _BadgeContentState();
}

class _BadgeContentState extends State<BadgeContent> {
  @override
  Widget build(BuildContext context) {
    NotificationBloc noti = context.watch<NotificationBloc>();
    return Builder(
      builder:(context){

      // if(noti.numOfUnread != 0){
      //   return Badge(
      //       badgeContent: Text(
      //         noti.numOfUnread.toString(),
      //       style:
      //       GoogleFonts.inter(color: AppColors.white, fontSize: SizeConfig.textMultiplier * 1.3809182209469155),),
      //       badgeColor: AppColors.gradient_button_light,
      //       child: SvgPicture.asset(
      //         'assets/images/la_bell.svg',
      //         height: SizeConfig.heightMultiplier * 3.0129124820659974,
      //         width: SizeConfig.widthMultiplier * 5.833333333333333,
      //         color: AppColors.white,
      //       ),
      //   );
      // }

      return SvgPicture.asset(
        'assets/images/la_bell.svg',
        height: SizeConfig.heightMultiplier * 3.0129124820659974,
        width: SizeConfig.widthMultiplier * 5.833333333333333,
        color: AppColors.white,
      );
      }
      );
      }
}

