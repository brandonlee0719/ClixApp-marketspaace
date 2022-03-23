import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_space/notification/logics/blocs/notification_bloc.dart';
import 'package:market_space/representation/listviewScreen/interfaces.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';

class RecentBuyWidget extends StatefulWidget {
  final bool isPart;
  final bool isBuy;

  const RecentBuyWidget({Key key, this.isPart, this.isBuy}) : super(key: key);
  @override
  _RecentBuyWidgetState createState() => _RecentBuyWidgetState();
}

class _RecentBuyWidgetState extends State<RecentBuyWidget> {
  NotificationBloc _bloc;

  @override
  void initState() {
    _bloc = NotificationBloc(Initial(),
        paginateProvider: FireBasePaginateProvider(
            FirebaseFirestore.instance.collection('orders'),
            RecentBuyDecorator(widget.isBuy)),
        simpleTileBuilder: BuyItemBuilder(widget.isPart));
    _bloc.add(NotificationScreenEvent());
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    _bloc.close();
    // TODO: implement dispose
    super.dispose();
  }

  Widget _noRecentlySold() {
    return Container(
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/box.png',
                  fit: BoxFit.contain,
                  height: SizeConfig.heightMultiplier * 18.830703012912483,
                  width: SizeConfig.widthMultiplier * 24.305555555555554,
                ),
                Text(
                  "Hey there, you don't have any recently sold items",
                  style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25,
                    color: AppColors.unselected_tab,
                  ),
                ),
                Text(
                  "I'm sure you'll get your first sale soon!",
                  style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25,
                    color: AppColors.unselected_tab,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _noRecentlyBoughtContainer() {
    return Container(
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/cart(1).png',
                  fit: BoxFit.contain,
                  height: SizeConfig.heightMultiplier * 18.830703012912483,
                  width: SizeConfig.widthMultiplier * 24.305555555555554,
                ),
                Text(
                  "Hey there, you don't have any recently bought items",
                  style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25,
                    color: AppColors.unselected_tab,
                  ),
                ),
                Text(
                  "Let's change that, go on a shopping spree!",
                  style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25,
                    color: AppColors.unselected_tab,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: _bloc.listStream,
        builder: (context, snap) {
          if (snap.hasData) {
            if (snap.data.length == 0) {
              if (widget.isBuy)
                return _noRecentlyBoughtContainer();
              else
                return _noRecentlySold();
            }
            // print(snap.data.length);
            return ListView.builder(
              itemCount: snap.data.length + 1,
              shrinkWrap: true,
              controller: ScrollController(),
              itemBuilder: (context, index) {
                if (index < snap.data.length) {
                  return _bloc.simpleTileBuilder.render(snap.data[index]);
                }
                if (widget.isPart) {
                  return SizedBox();
                }
                return Container(
                  height: SizeConfig.heightMultiplier * 18,
                  alignment: Alignment.topCenter,
                  child: FlatButton(
                      onPressed: () {
                        _bloc.add(LoadMoreNotification());
                      },
                      child: Text('load more')),
                );
              },
            );
          }
          return Container();
        });
  }
}
