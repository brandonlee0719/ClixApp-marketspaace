import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/model/order_status_model/order_status_model.dart';
import 'package:market_space/model/recently_product_model/recently_brought_model.dart';
import 'package:market_space/recently_brought_products/widgets/product_card/product_card_image_widget.dart';
import 'package:market_space/repositories/profile_repository/profile_repository.dart';
import 'package:market_space/representation/widgets/cardWidgets/recentlyBoughtTextCard.dart';
import 'package:market_space/responsive_layout/size_config.dart';

import 'order_details_preview_widget.dart';

class ExpandableOrderWidget extends StatefulWidget {
  final RecentlyBrought model;

  const ExpandableOrderWidget({Key key, this.model}) : super(key: key);
  @override
  _ExpandableOrderWidgetState createState() => _ExpandableOrderWidgetState();
}

class _ExpandableOrderWidgetState extends State<ExpandableOrderWidget> {
  bool isExpanded = false;
  OrderStatusModel orderStatusModel;
  @override
  Widget build(BuildContext context) {
    return _recentlyProductCard(widget.model);
  }

  Future<OrderStatusModel> getStatusModel() async {
    // print(widget.model.orderID);
    if (orderStatusModel != null) {
      return orderStatusModel;
    }
    orderStatusModel = await ProfileRepository()
        .profileProvider
        .getOrderStatus(widget.model.orderID);
    return orderStatusModel;
  }

  Widget _recentlyProductCard(RecentlyBrought model) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        shadowColor: AppColors.grey_700,
        margin: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
        child: Column(
          children: [
            Row(
              children: [
                ProductCardImageWidget(model: model, isExpanded: isExpanded),
                Flexible(
                  child: Column(
                    children: [
                      _recentlyBroughtTxt(model),
                      if (isExpanded) const Divider(color: Color(0xffD4D4D4)),
                    ],
                  ),
                ),
              ],
            ),
            if (isExpanded) _expandedText(model),
          ],
        ),
      ),
    );
  }

  Widget _recentlyBroughtTxt(RecentlyBrought model) {
    return RecentlyBoughtText(
      model: model,
    );
  }

  Widget _expandedText(RecentlyBrought model) {
    return Column(
      children: [
        const SizedBox(height: 8),
        if (model.shippingStatus.toLowerCase() != "cancelled")
          _orderStatus(model)
      ],
    );
  }

  Widget _orderStatus(RecentlyBrought recentlyBrought) {
    return FutureBuilder<OrderStatusModel>(
        future: getStatusModel(),
        builder: (build, snap) {
          if (!snap.hasData) {
            return Lottie.asset(
              'assets/loader/list_loader.json',
            );
          }
          // print("this is the data");
          // print(snap.data);
          return OrderDetailsPreviewWidget(
            model: snap.data,
            recentlyBrought: recentlyBrought,
          );
        });
  }
}
