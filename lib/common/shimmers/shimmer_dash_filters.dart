import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerDashFilter extends StatelessWidget {
  const ShimmerDashFilter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 100) / 3;
    final double itemWidth = size.width / 2;

    return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 15),
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 0,
          childAspectRatio: (itemWidth / itemHeight),
        ),
        itemCount: 4,
        itemBuilder: (BuildContext ctx, i) {
          return Container(
            width: 70,
            margin: EdgeInsets.only(right: 10),
            child: Column(
              children: [
                Shimmer.fromColors(
                  child: Container(
                    height: 63,
                    width: 63,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(1000))),
                  ),
                  period: Duration(seconds: 2),
                  baseColor: Colors.black.withOpacity(0.1),
                  highlightColor: Colors.white.withOpacity(0.1),
                ),
                SizedBox(
                  height: 6,
                ),
                Shimmer.fromColors(
                  child: Container(
                    width: 40,
                    height: 8,
                    color: Colors.grey,
                  ),
                  period: Duration(seconds: 2),
                  baseColor: Colors.black.withOpacity(0.1),
                  highlightColor: Colors.white.withOpacity(0.1),
                )
              ],
            ),
          );
        });
  }
}
