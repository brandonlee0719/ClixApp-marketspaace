import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHomeBanner extends StatelessWidget {
  const ShimmerHomeBanner({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: Duration(seconds: 2),
      baseColor: Colors.black.withOpacity(0.1),
      highlightColor: Colors.white.withOpacity(0.1),
      child: CarouselSlider.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int i, int pageViewIndex) =>
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20)),
              ),
          options: CarouselOptions(
            height: 190,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
          )),
    );
  }
}
