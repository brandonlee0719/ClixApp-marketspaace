//The name zombieWidgets means that all the widgets are actually stateless and any time we want to find zombie
//widget, we can always type in zombie and find that.

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class ZombieCloudWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Image.asset(
        'assets/images/forgot_pass_top.png',
        fit: BoxFit.fill,
      ),
    );
  }
}

class ZombieRocket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/login_bottom_blue.png',
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * -4.861111111111111,
          top: SizeConfig.heightMultiplier * 15.064562410329986,
          child: Image.asset(
            'assets/images/cld_image.png',
            width: SizeConfig.widthMultiplier * 19.444444444444443,
            height: SizeConfig.heightMultiplier * 10.043041606886657,
          ),
        ),
        Positioned(
          right: SizeConfig.widthMultiplier * 0.0,
          top: SizeConfig.heightMultiplier * 21.969153515064562,
          child: Image.asset(
            'assets/images/cloud_right.png',
            width: SizeConfig.widthMultiplier * 19.444444444444443,
            height: SizeConfig.heightMultiplier * 10.043041606886657,
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 29.166666666666664,
          top: SizeConfig.heightMultiplier * 13.809182209469155,
          child: Image.asset(
            'assets/images/rocket.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 29.166666666666664,
          top: SizeConfig.heightMultiplier * 13.809182209469155,
          child: Image.asset(
            'assets/images/rocket_shade.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 0.0,
          top: SizeConfig.heightMultiplier * 19.4583931133429,
          child: Image.asset(
            'assets/images/rocket_dust1.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * -2.4305555555555554,
          top: SizeConfig.heightMultiplier * 19.4583931133429,
          child: Image.asset(
            'assets/images/rocket_dust.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 24.305555555555554,
          top: SizeConfig.heightMultiplier * 16.319942611190818,
          child: Image.asset(
            'assets/images/left_wing.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 24.305555555555554,
          top: SizeConfig.heightMultiplier * 16.319942611190818,
          child: Image.asset(
            'assets/images/left_wing_shade.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 32.08333333333333,
          top: SizeConfig.heightMultiplier * 19.4583931133429,
          child: Image.asset(
            'assets/images/right_wing.png',
          ),
        ),
        Positioned(
          left: SizeConfig.widthMultiplier * 41.31944444444444,
          top: SizeConfig.heightMultiplier * 15.064562410329986,
          child: Image.asset(
            'assets/images/rocket_window.png',
          ),
        ),
      ],
    );
  }
}

class ZombieLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
        child: LoadingProgress(
          color: Colors.deepOrangeAccent,
        ));
  }
}

class ZombieQuitButton extends StatelessWidget {
  final Function() onPressed;

  const ZombieQuitButton({Key key, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 2.4305555555555554,
            top: SizeConfig.heightMultiplier * 10.043041606886657),
        child: SvgPicture.asset(
          'assets/images/Back_button.svg',
          width: SizeConfig.widthMultiplier * 4.861111111111111,
          height: SizeConfig.heightMultiplier * 2.5107604017216643,
          color: AppColors.toolbarBlue,
        ),
      ),
    );
  }
}





