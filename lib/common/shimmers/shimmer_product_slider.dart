import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../common_widgets.dart';

class ShimmerProductSlider extends StatelessWidget {
  const ShimmerProductSlider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        yHeight2,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Shimmer.fromColors(
            period: Duration(seconds: 2),
            baseColor: Colors.black.withOpacity(0.1),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Container(
              width: 120,
              height: 15,
              color: Colors.grey,
            ),
          ),
        ),
        yHeight2,
        Container(
          height: 210,
          child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 15),
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, i) => Container(
                  width: 140,
                  margin: EdgeInsets.only(right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        period: Duration(seconds: 2),
                        baseColor: Colors.black.withOpacity(0.1),
                        highlightColor: Colors.white.withOpacity(0.1),
                        child: Container(
                          height: 160,
                          width: 140,
                          margin: EdgeInsets.only(top: 3),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                      ),
                      yHeight1,
                      Shimmer.fromColors(
                        period: Duration(seconds: 2),
                        baseColor: Colors.black.withOpacity(0.1),
                        highlightColor: Colors.white.withOpacity(0.1),
                        child: Container(
                          width: 80,
                          height: 8,
                          color: Colors.grey.withOpacity(01),
                        ),
                      ),
                      yHeight1,
                      Shimmer.fromColors(
                        period: Duration(seconds: 2),
                        baseColor: Colors.black.withOpacity(0.1),
                        highlightColor: Colors.white.withOpacity(0.1),
                        child: Container(
                          width: 60,
                          height: 8,
                          color: Colors.grey.withOpacity(01),
                        ),
                      ),
                    ],
                  ))),
        )
      ],
    );
  }
}
