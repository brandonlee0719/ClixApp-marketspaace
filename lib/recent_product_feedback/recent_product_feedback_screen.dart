import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/model/recent_product_feedback/recent_product_feedback.dart';
import 'package:market_space/product_landing_screen/product_landing_route.dart';
import 'package:market_space/recent_product_feedback/recent_product_feedback_bloc.dart';
import 'package:market_space/recent_product_feedback/recent_product_feedback_l10n.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class RecentProductFeedbackScreen extends StatefulWidget {
  @override
  _RecentProductFeedbackScreenState createState() =>
      _RecentProductFeedbackScreenState();
}

class _RecentProductFeedbackScreenState
    extends State<RecentProductFeedbackScreen> {
  bool _isLoading = false;
  final RecentProductFeedbackBloc _recentProductFeedbackBloc =
      RecentProductFeedbackBloc(Initial());
  RecentlyProductFeedbackL10n _l10n = RecentlyProductFeedbackL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  @override
  void initState() {
    _recentProductFeedbackBloc.productNum = ProductLandingRoute.productNum;
    _recentProductFeedbackBloc.feedbackId = 0;
    _recentProductFeedbackBloc.add(RecentProductFeedbackScreenEvent());
    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = RecentlyProductFeedbackL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n =
            RecentlyProductFeedbackL10n(Locale.fromSubtags(languageCode: 'zh'));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(title: _l10n.RECENTPRODUCTFEEDBACK),
      backgroundColor: AppColors.toolbarBlue,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.white,
        child: BlocProvider(
          create: (_) => _recentProductFeedbackBloc,
          child: BlocListener<RecentProductFeedbackBloc,
              RecentProductFeedbackState>(
            listener: (context, state) {
              if (state is Loading) {
                setState(() {
                  _isLoading = true;
                });
              }
              if (state is Loaded) {
                setState(() {
                  _isLoading = false;
                });
              }
              if (state is Failed) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: _baseScreen(),
          ),
        ),
      ),
    );
  }

  Widget _baseScreen() {
    return Container(
      color: Colors.white,
      child: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          children: [
            if (_isLoading)
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    children: [
                      Lottie.asset(
                        'assets/loader/list_loader.json',
                      ),
                      Lottie.asset(
                        'assets/loader/list_loader.json',
                      ),
                      Lottie.asset(
                        'assets/loader/list_loader.json',
                      ),
                      Lottie.asset(
                        'assets/loader/list_loader.json',
                      ),
                      Lottie.asset(
                        'assets/loader/list_loader.json',
                      ),
                    ],
                  )),
            // BackdropFilter(
            //     filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
            //     child: LoadingProgress(
            //       color: Colors.deepOrangeAccent,
            //     )),
            if (!_isLoading)
              ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return _recentProductFeedbackBloc.recentFeedbackList.length ==
                          0
                      ? Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/empty_box.png',
                                fit: BoxFit.contain,
                                height: SizeConfig.heightMultiplier *
                                    18.830703012912483,
                                width: SizeConfig.widthMultiplier *
                                    24.305555555555554,
                              ),
                              Text(
                                "${_l10n.NoReviews} !!",
                                style: GoogleFonts.inter(
                                  fontSize: SizeConfig.textMultiplier *
                                      2.5107604017216643,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        )
                      : _productReviewCard(_recentProductFeedbackBloc
                          ?.recentFeedbackList[index]);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _productReviewCard(RecentFeedback model) {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 2.0086083213773316),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              model == null
                  ? Container(
                      margin: EdgeInsets.only(
                        right: SizeConfig.widthMultiplier * 3.8888888888888884,
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      ),
                      height: SizeConfig.heightMultiplier * 3.7661406025824964,
                      width: SizeConfig.widthMultiplier * 12.152777777777777,
                      child: Lottie.asset('assets/loader/simple_loading.json'))
                  : Container(
                      child: Text(
                        model?.buyerDisplayName ?? "",
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w700,
                            color: AppColors.app_txt_color,
                            letterSpacing: 0.1),
                      ),
                    ),
              Spacer(),
              model == null
                  ? Container(
                      margin: EdgeInsets.only(
                        right: SizeConfig.widthMultiplier * 3.8888888888888884,
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      ),
                      height: SizeConfig.heightMultiplier * 3.7661406025824964,
                      width: SizeConfig.widthMultiplier * 12.152777777777777,
                      child: Lottie.asset('assets/loader/simple_loading.json'))
                  : Container(
                      margin: EdgeInsets.only(
                          top:
                              SizeConfig.heightMultiplier * 0.5021520803443329),
                      child: RatingBar(
                        itemSize: 16,
                        glow: false,
                        initialRating:
                            double.parse(model?.buyerRating.toString()) ?? 0,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return Image.asset(
                                'assets/images/feedback_star.png',
                                width: SizeConfig.widthMultiplier *
                                    3.8888888888888884,
                                height: SizeConfig.heightMultiplier *
                                    2.0086083213773316,
                              );
                            case 1:
                              return Image.asset(
                                'assets/images/feedback_star.png',
                                width: SizeConfig.widthMultiplier *
                                    3.8888888888888884,
                                height: SizeConfig.heightMultiplier *
                                    2.0086083213773316,
                              );
                            case 2:
                              return Image.asset(
                                'assets/images/feedback_star.png',
                                width: SizeConfig.widthMultiplier *
                                    3.8888888888888884,
                                height: SizeConfig.heightMultiplier *
                                    2.0086083213773316,
                              );
                            case 3:
                              return Image.asset(
                                'assets/images/feedback_star.png',
                                width: SizeConfig.widthMultiplier *
                                    3.8888888888888884,
                                height: SizeConfig.heightMultiplier *
                                    2.0086083213773316,
                              );
                            default:
                              return Image.asset(
                                'assets/images/feedback_star.png',
                                width: SizeConfig.widthMultiplier *
                                    3.8888888888888884,
                                height: SizeConfig.heightMultiplier *
                                    2.0086083213773316,
                              );
                          }
                        },
                        onRatingUpdate: (rating) {
                          setState(() {
                            // _rating = rating;
                          });
                          // print(rating);
                        },
                      ),
                    )
            ],
          ),
          model == null
              ? Container(
                  margin: EdgeInsets.only(
                    right: SizeConfig.widthMultiplier * 3.8888888888888884,
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  ),
                  height: SizeConfig.heightMultiplier * 3.7661406025824964,
                  width: SizeConfig.widthMultiplier * 12.152777777777777,
                  child: Lottie.asset('assets/loader/simple_loading.json'))
              : Container(
                  margin: EdgeInsets.only(
                    top: SizeConfig.heightMultiplier * 0.5021520803443329,
                  ),
                  child: Text(
                    model?.buyerComment ?? "",
                    style: GoogleFonts.inter(
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        fontWeight: FontWeight.w400,
                        color: AppColors.app_txt_color,
                        letterSpacing: 0.25),
                  ),
                ),
          Container(
            height: SizeConfig.heightMultiplier * 0.12553802008608322,
            color: AppColors.text_field_container,
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 0.6276901004304161),
          )
        ],
      ),
    );
  }
}
