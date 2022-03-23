import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:market_space/common/common_widgets.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProductGrid extends StatefulWidget {
  const ShimmerProductGrid({Key key, this.yMargin}) : super(key: key);

  final double yMargin;

  @override
  _ShimmerProductGridState createState() => _ShimmerProductGridState();
}

class _ShimmerProductGridState extends State<ShimmerProductGrid> {
  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    // final double itemWidth = size.width / 2;
    return StaggeredGridView.countBuilder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: widget.yMargin ?? 0),
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        scrollDirection: Axis.vertical,
        itemCount: 20,
        staggeredTileBuilder: (i) {
          return StaggeredTile.count(
            2,
            2.7,
          );
        },
        itemBuilder: (BuildContext ctx, i) {
          return Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    period: Duration(seconds: 2),
                    baseColor: Colors.black.withOpacity(0.1),
                    highlightColor: Colors.white.withOpacity(0.1),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
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
              ));
        });
  }
}
