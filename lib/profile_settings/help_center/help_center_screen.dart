import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/profile_settings/help_center/help_center_l10n.dart';
import 'package:market_space/responsive_layout/size_config.dart';

import 'help_center_bloc.dart';

class HelpCenterScreen extends StatefulWidget {
  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final HelpCenterBloc _helpCenterBloc = HelpCenterBloc(Initial());
  bool _isLoading = false;
  HelpCenterL10n _l10n =
      HelpCenterL10n(Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  @override
  void initState() {
    _helpCenterBloc.add(HelpCenterScreenEvent());
    if (Constants.language == null || Constants.language == "English") {
      _l10n = HelpCenterL10n(
          Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
    } else {
      _l10n = HelpCenterL10n(Locale.fromSubtags(languageCode: 'zh'));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(
        title: 'HELP CENTER',
      ),
      backgroundColor: AppColors.white,
      // key: _globalKey,
      // bottomNavigationBar: _bottomButtons(),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.white,
        child: BlocProvider(
          create: (_) => _helpCenterBloc,
          child: BlocListener<HelpCenterBloc, HelpCenterState>(
              listener: (context, state) {
                if (state is Loading) {
                  setState(() {
                    _isLoading = true;
                  });
                }
                if (state is Loaded) {
                  _isLoading = false;
                }
              },
              child: _baseScreen()),
        ),
      ),
    );
  }

  Widget _baseScreen() {
    return Container(
        color: Colors.white,
        child: AbsorbPointer(
            absorbing: _isLoading,
            child: Stack(children: [
              if (_isLoading)
                BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                    child: LoadingProgress(
                      color: Colors.deepOrangeAccent,
                    )),
              ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 2.9166666666666665,
                          top:
                              SizeConfig.heightMultiplier * 2.5107604017216643),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return _helpCenterRow(
                              "Lorem ipsum dolor sit amet, consect etur adipiscing elit. Pellentesque in ipsum id orci porta dapibus?",
                              index == 3 ? true : false);
                        },
                      ),
                    ),
                  ])
            ])));
  }

  Widget _helpCenterRow(String helpText, bool isbold) {
    return ListTile(
        title: Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {});
          },
          child: Row(
            children: [
              Expanded(
                  child: Text(
                helpText,
                style: GoogleFonts.lato(
                    fontWeight: isbold ? FontWeight.w700 : FontWeight.w400,
                    fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                    letterSpacing: 0.5,
                    color: AppColors.catTextColor),
              )),
              Container(
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 1.9444444444444442),
                child: Image.asset(
                  'assets/images/chevron_right.png',
                  height: SizeConfig.heightMultiplier * 1.0043041606886658,
                  width: SizeConfig.widthMultiplier * 1.2152777777777777,
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: SizeConfig.heightMultiplier * 2.0086083213773316),
          height: SizeConfig.heightMultiplier * 0.12553802008608322,
          decoration: BoxDecoration(color: AppColors.list_separator2),
        )
      ],
    ));
  }
}
