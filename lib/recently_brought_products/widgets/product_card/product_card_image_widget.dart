import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/model/recently_product_model/recently_brought_model.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class ProductCardImageWidget extends StatelessWidget {
  const ProductCardImageWidget(
      {Key key, @required this.model, this.isExpanded = false})
      : super(key: key);
  final RecentlyBrought model;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.widthMultiplier * 35,
      height: SizeConfig.heightMultiplier * 17,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
              imageUrl: model?.imgLink != null
                  ? model?.imgLink
                  : 'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg',
              placeholder: (context, url) =>
                  Lottie.asset('assets/loader/image_loading.json'),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.fill,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft:
                        isExpanded ? Radius.zero : Radius.circular(15)),
                    color: AppColors.toolbarBlue,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.fill)),
              )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Chip(
              backgroundColor: model?.shippingStatus?.toLowerCase() == 'shipped'
                  ? const Color(0xffE3FCEC)
                  : const Color(0xffFFFCF4),
              label: model?.shippingStatus?.toLowerCase() == 'awaiting shipping'
                  ? RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'AWAITING ',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(text: 'SHIPPING'),
                  ],
                  style: TextStyle(
                    color: const Color(0xff5C4813),
                    fontSize: 9,
                  ),
                ),
              )
                  : model?.shippingStatus?.toLowerCase() == 'shipped'
                  ? Text(
                'SHIPPED',
                style: TextStyle(
                  color: const Color(0xff155239),
                  fontSize: 9,
                ),
              )
                  : Text(
                model?.shippingStatus,
                style: TextStyle(
                  color: const Color(0xff5C4813),
                  fontSize: 9,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}