import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:market_space/feedback/feedback_bloc.dart';
import 'package:market_space/feedback/feedback_route.dart';
import 'package:market_space/model/feedback/buyer_feedback_model.dart';
import 'package:market_space/model/feedback/feedback_model.dart';
import 'package:market_space/responsive_layout/size_config.dart';

import 'feedback_l10n.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final FeedbackBloc _feedbackBloc = FeedbackBloc(Initial());
  FeedbackL10n _l10n =
      FeedbackL10n(Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  bool _isLoading = false;
  List<Results> _feedbackList = List();
  List<BuyerFeedback> _buyerFeedbackList = List();
  ScrollController _sc = new ScrollController();

  @override
  void initState() {
    _feedbackBloc.add(FeedbackScreenEvent());
    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = FeedbackL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n = FeedbackL10n(Locale.fromSubtags(languageCode: 'zh'));
      }
    });
    super.initState();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        // _feedbackBloc.feedbackId = 1;
        _feedbackBloc.feedbackId = _feedbackList[0].feedbackID;
        _feedbackBloc.add(FeedbackScreenEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.toolbarBlue,
        appBar: Toolbar(
          title: _l10n.Feedback,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.white,
          child: BlocProvider(
            create: (_) => _feedbackBloc,
            child: BlocListener<FeedbackBloc, FeedbackState>(
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
                child: _isLoading
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Lottie.asset('assets/loader/loading_icon.json',
                              width: SizeConfig.widthMultiplier *
                                  24.305555555555554,
                              height: SizeConfig.heightMultiplier *
                                  12.553802008608322),
                        ),
                      )
                    : _baseScreen()),
          ),
        ));
  }

  Widget _baseScreen() {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          if (!_isLoading)
            FeedbackRoute.isSeller
                ? StreamBuilder(
                    stream: _feedbackBloc.feedbackStream,
                    builder: (context, stream) {
                      if (stream.connectionState == ConnectionState.done) {}

                      if (stream.hasData) {
                        _feedbackList.addAll(stream.data);
                        if (_feedbackList.length > 0 &&
                            _feedbackList.length < 9) {
                          _feedbackBloc.feedbackId =
                              _feedbackList[0].feedbackID;
                          _feedbackBloc.add(FeedbackScreenEvent());
                        }
                        return Container(
                          child: ListView(
                              shrinkWrap: true,
                              controller: _sc,
                              physics: BouncingScrollPhysics(),
                              children: stream.data
                                  .map<Widget>((e) => _feedbackCard(e))
                                  .toList()),
                        );
                      } else {
                        return Container(
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
                            ));
                      }
                    },
                  )
                : StreamBuilder(
                    stream: _feedbackBloc.feedbackBuyerStream,
                    builder: (context, stream) {
                      if (stream.connectionState == ConnectionState.done) {}

                      if (stream.hasData) {
                        _buyerFeedbackList.addAll(stream.data);
                        if (_buyerFeedbackList.length > 0 &&
                            _buyerFeedbackList.length < 9) {
                          _feedbackBloc.feedbackId =
                              _buyerFeedbackList[0].feedbackID;
                          _feedbackBloc.add(FeedbackScreenEvent());
                        }
                        return Container(
                          child: ListView(
                              shrinkWrap: true,
                              controller: _sc,
                              physics: BouncingScrollPhysics(),
                              children: stream.data
                                  .map<Widget>((e) => _feedbackBuyerCard(e))
                                  .toList()),
                        );
                      } else {
                        return Container(
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
                            ));
                      }
                    },
                  ),
        ],
      ),
    );
  }

  Widget _feedbackCard(Results model) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 2.5107604017216643),
      child: Card(
          child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(
                bottom: SizeConfig.heightMultiplier * 0.6276901004304161),
            width: SizeConfig.widthMultiplier * 29.166666666666664,
            child: _feedbackImage(model),
          ),
          Container(
            // margin: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 0.6276901004304161),
            child: _feedbackTexts(model),
          )
        ],
      )),
    );
  }

  Widget _feedbackImage(Results model) {
    return Container(
        width: SizeConfig.widthMultiplier * 16.28472222222222,
        height: SizeConfig.heightMultiplier * 8.411047345767576,
        margin: EdgeInsets.only(
            right: SizeConfig.widthMultiplier * 4.861111111111111,
            left: SizeConfig.widthMultiplier * 0.9722222222222221),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: model.buyerProfileURL != null
                ? model.buyerProfileURL
                : 'https://www.dovercourt.org/wp-content/uploads/2019/11/610-6104451_image-placeholder-png-user-profile-placeholder-image-png.jpg',
            placeholder: (context, url) =>
                Lottie.asset('assets/loader/image_loading.json'),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.fill,
          ),
        ));
  }

  Widget _feedbackTexts(Results model) {
    return Expanded(
      child: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                _l10n.to,
                style: GoogleFonts.inter(
                  color: AppColors.catTextColor,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1,
                ),
                // ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 0.48611111111111105),
                child: Text(
                  '${model.buyerDisplayName}',
                  style: GoogleFonts.inter(
                    color: AppColors.catTextColor,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 0.37661406025824967),
            child: Text(
              '${model.buyerComment}',
              style: GoogleFonts.inter(
                color: AppColors.catTextColor,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 0.5021520803443329,
                bottom: SizeConfig.heightMultiplier * 0.6276901004304161),
            child: RatingBar(
              itemSize: 16,
              glow: false,
              allowHalfRating: true,
              initialRating: double.parse(model.buyerRating.toString()) ?? 0.0,
              itemCount: 5,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return Image.asset(
                      'assets/images/feedback_star.png',
                      width: SizeConfig.widthMultiplier * 3.8888888888888884,
                      height: SizeConfig.heightMultiplier * 2.0086083213773316,
                    );
                  case 1:
                    return Image.asset(
                      'assets/images/feedback_star.png',
                      width: SizeConfig.widthMultiplier * 3.8888888888888884,
                      height: SizeConfig.heightMultiplier * 2.0086083213773316,
                    );
                  case 2:
                    return Image.asset(
                      'assets/images/feedback_star.png',
                      width: SizeConfig.widthMultiplier * 3.8888888888888884,
                      height: SizeConfig.heightMultiplier * 2.0086083213773316,
                    );
                  case 3:
                    return Image.asset(
                      'assets/images/feedback_star.png',
                      width: SizeConfig.widthMultiplier * 3.8888888888888884,
                      height: SizeConfig.heightMultiplier * 2.0086083213773316,
                    );
                  default:
                    return Image.asset(
                      'assets/images/feedback_star.png',
                      width: SizeConfig.widthMultiplier * 3.8888888888888884,
                      height: SizeConfig.heightMultiplier * 2.0086083213773316,
                    );
                }
              },
              // onRatingUpdate: (rating) {
              //   setState(() {
              //     // _rating = rating;
              //   });
              //   // print(rating);
              // },
            ),
          )
        ],
      )),
    );
  }

  Widget _feedbackBuyerCard(BuyerFeedback model) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 2.5107604017216643),
      child: Card(
          child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(
                bottom: SizeConfig.heightMultiplier * 0.6276901004304161),
            width: SizeConfig.widthMultiplier * 29.166666666666664,
            child: _feedbackBuyerImage(model),
          ),
          Container(
            // margin: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 0.6276901004304161),
            child: _feedbackBuyerTexts(model),
          )
        ],
      )),
    );
  }

  Widget _feedbackBuyerImage(BuyerFeedback model) {
    return Container(
        width: SizeConfig.widthMultiplier * 16.28472222222222,
        height: SizeConfig.heightMultiplier * 8.411047345767576,
        margin: EdgeInsets.only(
            right: SizeConfig.widthMultiplier * 4.861111111111111,
            left: SizeConfig.widthMultiplier * 0.9722222222222221),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: model.sellerProfileURL != null
                ? model.sellerProfileURL
                : 'https://www.dovercourt.org/wp-content/uploads/2019/11/610-6104451_image-placeholder-png-user-profile-placeholder-image-png.jpg',
            placeholder: (context, url) =>
                Lottie.asset('assets/loader/image_loading.json'),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.fill,
          ),
        ));
  }

  Widget _feedbackBuyerTexts(BuyerFeedback model) {
    return Expanded(
      child: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                _l10n.to,
                style: GoogleFonts.inter(
                  color: AppColors.catTextColor,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1,
                ),
                // ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 0.48611111111111105),
                child: Text(
                  '${model.sellerDisplayName}',
                  style: GoogleFonts.inter(
                    color: AppColors.catTextColor,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 0.37661406025824967),
            child: Text(
              '${model.sellerComment}',
              style: GoogleFonts.inter(
                color: AppColors.catTextColor,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 0.5021520803443329,
                bottom: SizeConfig.heightMultiplier * 0.6276901004304161),
            child: RatingBar(
              itemSize: 16,
              glow: false,
              allowHalfRating: true,
              initialRating: double.parse(model.sellerRating.toString()) ?? 0.0,
              itemCount: 5,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return Image.asset(
                      'assets/images/feedback_star.png',
                      width: SizeConfig.widthMultiplier * 3.8888888888888884,
                      height: SizeConfig.heightMultiplier * 2.0086083213773316,
                    );
                  case 1:
                    return Image.asset(
                      'assets/images/feedback_star.png',
                      width: SizeConfig.widthMultiplier * 3.8888888888888884,
                      height: SizeConfig.heightMultiplier * 2.0086083213773316,
                    );
                  case 2:
                    return Image.asset(
                      'assets/images/feedback_star.png',
                      width: SizeConfig.widthMultiplier * 3.8888888888888884,
                      height: SizeConfig.heightMultiplier * 2.0086083213773316,
                    );
                  case 3:
                    return Image.asset(
                      'assets/images/feedback_star.png',
                      width: SizeConfig.widthMultiplier * 3.8888888888888884,
                      height: SizeConfig.heightMultiplier * 2.0086083213773316,
                    );
                  default:
                    return Image.asset(
                      'assets/images/feedback_star.png',
                      width: SizeConfig.widthMultiplier * 3.8888888888888884,
                      height: SizeConfig.heightMultiplier * 2.0086083213773316,
                    );
                }
              },
              // onRatingUpdate: (rating) {
              //   setState(() {
              //     // _rating = rating;
              //   });
              //   // print(rating);
              // },
            ),
          )
        ],
      )),
    );
  }
}
