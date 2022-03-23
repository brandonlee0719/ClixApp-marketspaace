import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/apis/orderApi/orderApi.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/representation/commons/reusanleFonts.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/locator.dart';

class Review {
  final String reviewContent;
  final double reviewRate;

  Review(this.reviewContent, this.reviewRate);
  static Review fromJson(Map<String, dynamic> map) {
    return Review(
      map["reviewContent"],
      map["reviewRate"].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "reviewContent": reviewContent,
      "reviewRate": reviewRate,
    };
  }
}

class ReviewPart extends StatefulWidget {
  final String reviewId;
  final String reviewContent;
  final double reviewRate;
  final bool isBuyer;

  const ReviewPart(
      {Key key,
        this.reviewId,
        this.reviewContent,
        this.reviewRate,
        this.isBuyer = false})
      : super(key: key);

  @override
  _ReviewPartState createState() => _ReviewPartState();
}

class _ReviewPartState extends State<ReviewPart> {
  double _rating = 0;
  TextEditingController _about = TextEditingController();
  bool isUpdating = false;
  Review _review;
  @override
  void initState() {
    // if(widget.reviewId!=null){
    //   _review = Review( widget.reviewContent, widget.reviewRate);
    // }
    // TODO: implement initState
    // _about.text ="hahaha";
    super.initState();
  }

  Future<void> onTap() async {
    // if (_about.text?.isEmpty ?? true) {
    //   Fluttertoast.showToast(
    //       msg:
    //       'Please enter your comment about the ${widget.isBuyer ? 'seller' : 'buyer'}');
    // } else {
      if (!isUpdating) {
        setState(() {
          isUpdating = true;
        });

        var review = Review(_about.text??"empty review", _rating);

        await locator.get<OrderApi>().uploadReview(review);
        setState(() {
          _review = review;
          _rating = _review.reviewRate;
        });
      }

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Review>(
        future: locator.get<OrderApi>().getReview(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _review = snapshot.data;
            if (_review != null) {
              _rating = snapshot.data.reviewRate;
              this._about.text = snapshot.data.reviewContent;
            }
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<Review>(
                  stream: null,
                  builder: (context, snapshot) {
                    return Container(
                      margin: EdgeInsets.only(
                          top: 20,
                          bottom: 12,
                          left:
                          SizeConfig.widthMultiplier * 3.8888888888888884),
                      child: Text(
                        "Leave a feedback to ${widget.isBuyer ? 'seller' : 'buyer'}",
                        style: GoogleFonts.inter(
                          color: AppColors.app_txt_color,
                          fontSize:
                          SizeConfig.textMultiplier * 1.757532281205165,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    );
                  }),
              Container(
                margin: EdgeInsets.only(
                    bottom: 12,
                    left: SizeConfig.widthMultiplier * 3.8888888888888884),
                child: RatingBar(
                  allowHalfRating: true,
                  ignoreGestures: _review != null,
                  itemSize: SizeConfig.textMultiplier * 4.5,
                  glow: false,
                  initialRating: _rating,
                  itemCount: 5,
                  ratingWidget: RatingWidget(
                      full: Icon(Icons.star, color: AppColors.app_orange),
                      half: Icon(Icons.star_half, color: AppColors.app_orange),
                      empty: Icon(Icons.star_border,
                          color: const Color(0xff9E9E9E))),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    bottom: 12,
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    right: 16),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  controller: _about,
                  style: TextStyle(
                      color: _review == null ? Colors.black : Colors.grey),
                  decoration: InputDecoration(
                      enabled: _review == null,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: const Color(0xffD5D5D5)),
                          borderRadius: BorderRadius.circular(10.0)),
                      border: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: const Color(0xffD5D5D5)),
                          borderRadius: BorderRadius.circular(10.0)),
                      hintText:
                      "What did you like (or not) about the ${widget.isBuyer ? 'seller' : 'buyer'}?",
                      suffixStyle: const TextStyle(color: Colors.blue)),
                ),
              ),
              if (_review == null)
                GestureDetector(
                    onTap: () {
                      onTap();
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.only(
                            bottom: 12,
                            left:
                            SizeConfig.widthMultiplier * 3.8888888888888884,
                            right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.appBlue),
                        ),
                        child: Center(
                          child: Text(
                            !isUpdating ? "LEAVE FEEDBACK" : "...",
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier *
                                    1.757532281205165,
                                color: AppColors.appBlue,
                                fontWeight: FontWeight.w700),
                          ),
                        ))),
            ],
          );
        });
  }
}