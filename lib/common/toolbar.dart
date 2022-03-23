import 'package:flutter/material.dart';
import 'package:market_space/common/colors.dart';
import 'package:flutter_svg/svg.dart';

class Toolbar extends StatelessWidget implements PreferredSizeWidget {
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

  Toolbar({
    Key key,
    this.height = kToolbarHeight,
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
    this.elevation = 5,
    this.iconVisible = false,
    this.overlayEntry = null,
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
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: height,
            margin: margin,
            color: AppColors.toolbarBack,
            child: Row(
              children: [
                Container(
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: elevation,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20))),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6025,
                      height: height,
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
                                      width: 30,
                                      height: 36,
                                    ),
                                  )),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.only(left: 10, right: 5),
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
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
