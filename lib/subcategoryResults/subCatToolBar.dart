import 'package:flutter/material.dart';
import 'package:market_space/common/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:market_space/common/colors.dart';

class SubCatToolbar extends StatelessWidget implements PreferredSizeWidget {
  static const Color TOOLBAR_BACKGROUND_COLOR = Colors.white30;
  static const Color TOOLBAR_TITLE_COLOR = Color(0xFF67676A);

  final double height;
  final Color backgroundColor;
  final String title;
  final TextStyle titleStyle;
  final Widget leading;
  final Widget trailing;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final BorderRadius radius;
  final ShapeBorder shape;
  final double elevation;
  final bool iconVisible;
  final OverlayEntry overlayEntry;

  final List<String> subCategories;
  final TabController tabController;
  final List<GestureDetector> subCategoryList;

  static const Color background = AppColors.toolbarBlue;
  static const Color fill = AppColors.lightgrey;
  final List<Color> gradient;

  static const double fillPercent =
      39.49; // fills 56.23% for container from bottom
  static const double fillStop = (100 - fillPercent) / 100;
  final List<double> stops;

  SubCatToolbar({
    Key key,
    this.height = 104,
    this.backgroundColor = TOOLBAR_BACKGROUND_COLOR,
    this.title = "MARKETSPAACE",
    this.titleStyle = const TextStyle(color: TOOLBAR_TITLE_COLOR),
    this.leading,
    this.trailing = const Icon(
      Icons.category,
      color: Colors.grey,
    ),
    this.margin = const EdgeInsets.symmetric(horizontal: 0),
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.radius = const BorderRadius.all(Radius.circular(8)),
    this.shape,
    this.elevation = 0,
    this.iconVisible = false,
    this.overlayEntry = null,
    this.subCategories,
    this.tabController,
    this.subCategoryList,
    this.gradient = const [
      background,
      background,
      fill,
      fill,
    ],
    this.stops = const [0.0, fillStop, fillStop, 1.0],
  }) : super(key: key);

  void onChange(BuildContext context) {
    if (overlayEntry == null) {
      Navigator.pop(context);
    } else {
      overlayEntry.remove();
      overlayEntry == null;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        // child: Container(
        //     width: MediaQuery.of(context).size.width,
        //     height: height,
        //     margin: margin,
        //     decoration: BoxDecoration(
        //         gradient: LinearGradient(
        //             begin: Alignment.centerLeft,
        //             end: Alignment.centerRight,
        //             colors: gradient,
        //             stops: stops)),
        child: Wrap(children: [
      Column(
        children: [
          Row(children: [
            Container(
                child: Card(
                    margin: EdgeInsets.zero,
//                      elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20))),
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 60,
                        decoration: BoxDecoration(
                            color: AppColors.toolbarBlue,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20))),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                      onTap: () => this.onChange(context),
                                      //     () {
                                      //   if(overlayEntry == null) {
                                      //     Navigator.pop(context);
                                      //   }else{
                                      //     overlayEntry.remove();
                                      //     overlayEntry == null;
                                      //     Navigator.pop(context);
                                      //   }
                                      // },
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: SvgPicture.asset(
                                          'assets/images/Back_button.svg',
                                          width: 24,
                                          height: 24,
                                        ),
                                      )),
                                  Flexible(
                                      child: Container(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 5),
                                          child: Text(
                                            title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: AppColors.white,
                                                fontFamily: 'Montserrat',
                                                fontStyle: FontStyle.normal,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500),
                                          ))),
                                ],
                              ),
                            ]))))
          ]),
          AnimatedContainer(
            height: 40,
            decoration: BoxDecoration(
                color: AppColors.toolbarBack,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5))),
            duration: Duration(milliseconds: 200),
            child: DefaultTabController(
              length: subCategories.length,
              initialIndex: 0,
              child: TabBar(
                  isScrollable: true,
                  indicatorColor: AppColors.tab_indicator_color,
                  indicatorSize: TabBarIndicatorSize.label,
                  unselectedLabelColor: AppColors.unselected_tab,
                  labelColor: AppColors.tab_indicator_color,
                  controller: tabController,
                  onTap: (index) {},
                  tabs: subCategoryList),
            ),
          )
        ],
      ),
    ]));
//                      ],
//                    ),
//                  ),
//                ),
//              ),
//            ],
//          )));
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
