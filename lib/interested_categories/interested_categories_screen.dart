import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:market_space/common/colors.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/multi_selected_chip.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/interested_categories/interested_categories_l10n.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/routes/HomeScreenRoute.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'interested_categories_bloc.dart';
import 'interested_categories_events.dart';
import 'interested_categories_state.dart';

class InterestedCategoriesScreen extends StatefulWidget {
  @override
  _InterestedCategoriesScreenState createState() =>
      _InterestedCategoriesScreenState();
}

class _InterestedCategoriesScreenState
    extends State<InterestedCategoriesScreen> {
  final InterestedCategoriesBloc _InterestedCategoriesBloc =
      InterestedCategoriesBloc(Initial());
  final _globalKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  bool _passwordVisible = true;
  bool _passwordInvalid = true;
  bool _email = true;
  bool _emailValid = false;

  InterestedCategoriesBloc _blocObj = InterestedCategoriesBloc(Initial());

  List<String> _interestingItems;
  InterestedCategoriesL10n _l10n =
      Constants.language == null || Constants.language == "English"
          ? InterestedCategoriesL10n(
              Locale.fromSubtags(languageCode: 'en', countryCode: 'US'))
          : InterestedCategoriesL10n(
              Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'));

  @override
  void initState() {
    super.initState();

    _interestingItems = [
      _l10n.technology,
      _l10n.womensFashion,
      _l10n.mensFashion,
      _l10n.herAccessories,
      _l10n.hisAccessories,
      _l10n.office,
      _l10n.sports,
      _l10n.homeandKitchen
    ];

    // _blocObj.add(NavigateToAddInterestedCategoriesEvent());

    _emailController.addListener(() {
      setState(() {
        _emailValid = RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
            .hasMatch(_emailController.text);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.toolbarBlue,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.blue,
          child: BlocProvider(
            create: (_) => _InterestedCategoriesBloc,
            child: BlocListener<InterestedCategoriesBloc,
                InterestedCategoriesState>(
              listener: (context, state) {
                if (state is AddCategoriesSuccessful) {
                  setState(() {
                    _isLoading = false;
                  });
                  RouterService.appRouter
                      .navigateTo(HomeScreenRoute.buildPath());
                } else if (state is AddCategoriesFailed) {
                  SnackBar(
                    content: Text(
                        "Adding interested categories failed please try again"),
                  );
                }
              },
              child: _InterestedCategoriesScreen(),
            ),
          )),
    );
  }

  Widget _InterestedCategoriesScreen() {
    return Container(
      child: Stack(
        children: [
          _baseScreen(),
          Align(
            alignment: Alignment.bottomLeft,
            child: _bottomImage(),
          ),
          if (_isLoading)
            BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                child: LoadingProgress(
                  color: Colors.deepOrangeAccent,
                )),
        ],
      ),
    );
  }

  Widget _baseScreen() {
    return ListView(
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
                child: ListView(
              children: <Widget>[
                Image.asset(
                  'assets/images/forgot_pass_top.png',
                  fit: BoxFit.fill,
                ),
                // Center(
                //   child: Container(
                //     margin: EdgeInsets.only(
                //         top: MediaQuery.of(context).size.height * 0.005),
                //     // left: MediaQuery.of(context).size.width * 0.05),
                //     height: SizeConfig.heightMultiplier * 12.177187948350072,
                //     width: SizeConfig.widthMultiplier * 33.05555555555555,
                //     child: Image.asset(
                //       'assets/images/mkt_space_logo.png',
                //       fit: BoxFit.fill,
                //     ),
                //   ),
                // ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 2.922166427546629),
                  // left: SizeConfig.widthMultiplier * 17.256944444444443,
                  // right: SizeConfig.widthMultiplier * 14.097222222222221),
                  child: Container(
                    child: Text(
                      'Interested Categories',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w900,
                        fontSize: SizeConfig.textMultiplier * 2.887374461979914,
                        color: AppColors.app_txt_color,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      right: SizeConfig.widthMultiplier * 3.8888888888888884,
                      top: SizeConfig.heightMultiplier * 8.159971305595409),
                  child: Text(
                    'Howdy! Go ahead, select the categories you are interested in!',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      color: AppColors.sub_text,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 3,
                      left: SizeConfig.widthMultiplier * 0.5),
                  child: MultiSelectChip(_interestingItems),
                ),

                // Padding(
                //   padding: EdgeInsets.only(
                //       left: SizeConfig.widthMultiplier * 6.8055555555555545,
                //       right: SizeConfig.widthMultiplier * 7.048611111111111,
                //       top: SizeConfig.heightMultiplier * 3.0129124820659974),
                //   child: OTPTextField(
                //     length: 4,
                //     textFieldAlignment: MainAxisAlignment.spaceAround,
                //     fieldWidth: 50,
                //     fieldStyle: FieldStyle.underline,
                //     style: GoogleFonts.lato(
                //       fontWeight: FontWeight.w900,
                //       fontSize: SizeConfig.textMultiplier * 3.7661406025824964,
                //       color: AppColors.app_txt_color,
                //       letterSpacing: 0.25,
                //     ),
                //     onCompleted: (pin) {
                //       ChangePasswordRoute.otp = pin;
                //       // print("Completed: " + pin);
                //     },
                //   ),
                // ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: SizeConfig.heightMultiplier * 6.025824964131995,
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 3.51506456241033,
                      left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      right: SizeConfig.widthMultiplier * 3.8888888888888884),
                  child: RaisedGradientButton(
                    gradient: LinearGradient(
                      colors: <Color>[
                        AppColors.gradient_button_light,
                        AppColors.gradient_button_dark,
                      ],
                    ),
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            SizeConfig.widthMultiplier * 10,
                            SizeConfig.heightMultiplier * 1.75,
                            SizeConfig.widthMultiplier * 10,
                            SizeConfig.heightMultiplier * 2.5),
                        child: Text(
                          'NEXT',
                          style: GoogleFonts.lato(
                              fontSize:
                                  SizeConfig.textMultiplier * 1.757532281205165,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                              letterSpacing: 0.5),
                        )),
                    onPressed: () {
                      _InterestedCategoriesBloc.add(
                          NavigateToAddInterestedCategoriesEvent());
                      setState(() {
                        _isLoading = true;
                      });

                      // RouterService.appRouter
                      //     .navigateTo(ChangePasswordRoute.buildPath());
                    },
                  ),
                ),
              ],
            ))),
      ],
    );
  }

  Widget _bottomImage() {
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
