import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/investment_top_up/investment_top_up_bloc.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class InvestmentTopUpScreen extends StatefulWidget {
  @override
  _InvestmentTopUpScreenState createState() => _InvestmentTopUpScreenState();
}

class _InvestmentTopUpScreenState extends State<InvestmentTopUpScreen> {
  bool _isLoading = false;
  final InvestmentTopUpBloc _investmentTopUpScreen =
  InvestmentTopUpBloc(Initial());

  @override
  void initState() {
    _investmentTopUpScreen.add(InvestmentTopUpScreenEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Toolbar(
        title: 'MARKETSPAACE',
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.white,
        child: BlocProvider(
          create: (_) => _investmentTopUpScreen,
          child: BlocListener<InvestmentTopUpBloc, InvestmentTopUpState>(
              listener: (context, state) {
                if (state is Loading) {
                  setState(() {
                    _isLoading = true;
                  });
                }
                if (state is Loaded) {
                  setState(() {
                    _isLoading = false;
                    // _categoryList = _RecentlyBroughtBloc.categoryList;
                  });
                }
              },
              child: ListView(
                shrinkWrap: true,
                children: [_baseScreen()],
              )),
        ),
      ),
    );
  }

  Widget _baseScreen() {
    return Container(
      color: AppColors.white,
      child: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          children: [
            if (_isLoading)
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.3),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                    child: Lottie.network(
                      'https://assets3.lottiefiles.com/packages/lf20_FVqg63.json',
                      width: SizeConfig.widthMultiplier * 12.152777777777777,
                      height: SizeConfig.heightMultiplier * 6.276901004304161,
                      animate: true,
                    ),
                  )),
            ListView(shrinkWrap: true, children: [_investmentTopUp()]),
          ],
        ),
      ),
    );
  }

  Widget _investmentTopUp() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884, right: SizeConfig.widthMultiplier * 3.8888888888888884, top: SizeConfig.heightMultiplier * 3.89167862266858),
            child: Theme(
              data: ThemeData(
                primaryColor: AppColors.appBlue,
                primaryColorDark: AppColors.appBlue,
              ),
              child: TextField(
                style: GoogleFonts.lato(
                  color: AppColors.text_field_color,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.25,
                ),
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                      borderSide:
                      new BorderSide(color: AppColors.text_field_color),
                      // borderRadius: BorderRadius.circular(10.0)
                    ),
                    hintText: 'Deposit address',
                    contentPadding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884),
                    suffixStyle: const TextStyle(color: AppColors.appBlue)),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: SizeConfig.heightMultiplier * 6.025824964131995,
            margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 2.5107604017216643, left: SizeConfig.widthMultiplier * 3.8888888888888884, right: SizeConfig.widthMultiplier * 3.8888888888888884),
            child: RaisedGradientButton(
              gradient: LinearGradient(
                colors: <Color>[
                  AppColors.gradient_button_light,
                  AppColors.gradient_button_dark,
                ],
              ),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: Text(
                    'COPY TO CLIPBOARD',
                    style: GoogleFonts.lato(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        letterSpacing: 0.5,
                        textStyle: TextStyle(fontFamily: 'Roboto')),
                  )),
              onPressed: () {
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884, top: SizeConfig.heightMultiplier * 3.0129124820659974),
            child: Text(
              'Processing',
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.w700,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.1,
                  color: AppColors.app_txt_color
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884, top: SizeConfig.heightMultiplier * 1.0043041606886658, right: SizeConfig.widthMultiplier * 3.8888888888888884),
            child: Expanded(child: Text(
              'Curabitur aliquet quam id dui posuere blandit. Quisque velit nisi, pretium ut lacinia in, elementum id enim. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec velit neque, auctor sit amet aliquam vel, ullamcorper sit amet ligula. Curabitur aliquet quam id dui posuere blandit. Curabitur arcu erat, accumsan id imperdiet et, porttitor at sem.',
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.w700,
                  fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                  letterSpacing: 0.4,
                  color: AppColors.app_txt_color
              ),
            ),
            ),),
          Container(
            margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884, top: SizeConfig.heightMultiplier * 3.0129124820659974, right: SizeConfig.widthMultiplier * 3.8888888888888884),
            child: Expanded(child: Text(
              '• Curabitur aliquet quam id dui posuere blandit. Curabitur arcu erat, accumsan id imperdiet et, porttitor at sem.',
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                  letterSpacing: 0.4,
                  color: AppColors.app_txt_color
              ),
            ),
            ),),
          Container(
            margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884, top: SizeConfig.heightMultiplier * 3.0129124820659974, right: SizeConfig.widthMultiplier * 3.8888888888888884),
            child: Expanded(child: Text(
              '• Curabitur aliquet quam id dui posuere blandit. Curabitur arcu erat, accumsan id imperdiet et, porttitor at sem.',
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                  letterSpacing: 0.4,
                  color: AppColors.app_txt_color
              ),
            ),
            ),),
          Container(
            margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.8888888888888884, top: SizeConfig.heightMultiplier * 3.0129124820659974, right: SizeConfig.widthMultiplier * 3.8888888888888884),
            child: Expanded(child: Text(
              'Curabitur aliquet quam id dui posuere blandit. ',
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                  letterSpacing: 0.4,
                  decoration: TextDecoration.underline,
                  color: AppColors.appBlue
              ),
            ),
            ),),
        ],
      ),
    );
  }
}
