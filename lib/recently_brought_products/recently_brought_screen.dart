import 'dart:collection';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/multi_selected_chip.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/model/category/category_model.dart';
import 'package:market_space/model/order_status_model/order_status_model.dart';
import 'package:market_space/model/product_model.dart';
import 'package:market_space/model/recently_product_model/recently_brought_model.dart';
import 'package:market_space/notification/representation/widgets/screen/recentBuywidget.dart';
import 'package:market_space/product_landing_screen/product_landing_route.dart';
import 'package:market_space/recently_brought_details/recently_detail_route.dart';
import 'package:market_space/recently_brought_products/recenlty_brought_products_l10n.dart';
import 'package:market_space/recently_brought_products/recently_brought_bloc.dart';
import 'package:market_space/recently_brought_products/recently_brought_events.dart';
import 'package:market_space/recently_brought_products/recently_brought_state.dart';
import 'package:market_space/recently_brought_products/widgets/order_details_preview_widget.dart';
import 'package:market_space/recently_brought_products/widgets/product_card/product_card_image_widget.dart';
import 'package:market_space/representation/commons/reusanleFonts.dart';
import 'package:market_space/representation/widgets/cardWidgets/recentlyBoughtTextCard.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class RecentlyBroughtScreen extends StatefulWidget {
  @override
  _RecentlyBroughtScreenState createState() => _RecentlyBroughtScreenState();
}

class _RecentlyBroughtScreenState extends State<RecentlyBroughtScreen> {
  final RecentlyBroughtBloc _recentlyBroughtBloc = RecentlyBroughtBloc();
  RecentlyBoughtProductL10n _l10n = RecentlyBoughtProductL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  bool _isLoading = false;
  bool _isOptionLoad = false;
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  String _selectedItem;
  bool _filterSelected = false;
  bool _currentStatus = false;
  List<String> _dropdownItems = ["Filter By"];
  List<String> _categoryList = ["Most recent", "Relevant"];
  final Set<String> _expandedItems = HashSet();
  bool _isTags = false;
  ScrollController _sc = new ScrollController();
  List<RecentlyBrought> _recentlyBoughtList = List();
  OrderStatusModel orderStatusModel;

  @override
  void initState() {
    _recentlyBroughtBloc.add(RecentlyBroughtScreenEvent());
    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = RecentlyBoughtProductL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n =
            RecentlyBoughtProductL10n(Locale.fromSubtags(languageCode: 'zh'));
      }
    });

    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;
    _sc.addListener(() {
      final recentlyBoughtList = _recentlyBroughtBloc?.recentlyBoughtList;
      if (_sc.position.pixels == _sc.position.maxScrollExtent &&
          recentlyBoughtList.length > 1) {
        _recentlyBroughtBloc.orderId = recentlyBoughtList.last.orderID;
        _recentlyBroughtBloc.add(RecentlyBroughtScreenEvent());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _recentlyBroughtBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.toolbarBlue,
      appBar: Toolbar(
        title: _l10n.RecentlyBought,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.white,
        child: RecentBuyWidget(
          isPart: false,
          isBuy: true,
        ),
        // BlocProvider(
        //   create: (_) => _recentlyBroughtBloc,
        //   child: BlocListener<RecentlyBroughtBloc, RecentlyBroughtState>(
        //     listener: (context, state) {
        //       if (state is Loading &&
        //           (_recentlyBroughtBloc.recentlyBoughtList?.isEmpty ?? true)) {
        //         setState(() {
        //           _isLoading = true;
        //         });
        //       }
        //       if (state is Loaded) {
        //         setState(() {
        //           _isLoading = false;
        //         });
        //       }
        //       if (state is Failed) {
        //         setState(() {
        //           _isLoading = false;
        //         });
        //       }
        //       if (state is OrderStatusSuccessful) {
        //         setState(() {
        //           orderStatusModel = _recentlyBroughtBloc.orderStatus;
        //           _isOptionLoad = false;
        //         });
        //       }
        //       if (state is OrderStatusFailed) {
        //         setState(() {
        //           // orderStatusModel = _recentlyBroughtBloc.orderStatus;
        //           _isOptionLoad = false;
        //         });
        //         _showToast('Order Status load failed');
        //       }
        //     },
        //     child: _baseScreen(),
        //     // Column(
        //     //   // shrinkWrap: true,
        //     //   children: [
        //     //     _filter(),
        //     //     _baseScreen()
        //     //   ],
        //     // ),
        //   ),
        // ),
      ),
    );
  }

  Widget _baseScreen() {
    // print("length of items: ${_recentlyBroughtBloc.recentlyBoughtList.length}");
    return Container(
      color: Colors.white,
      // margin: EdgeInsets.only(
      //     top: SizeConfig.heightMultiplier * 5.0215208034433285),
      child: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          children: [
            if (!_isLoading)
              // _recentlyProductCard(_recentlyBroughtBloc?.recentlyBoughtList[0]),
              Container(
                child: _recentlyBroughtBloc?.recentlyBoughtList?.isEmpty ?? true
                    ? Center(
                        child: Container(
                        child: Lottie.asset('assets/loader/empty_show.json'),
                      ))
                    : Column(
                        children: [
                          Flexible(
                            child: ListView(
                              padding: const EdgeInsets.only(top: 20),
                              shrinkWrap: true,
                              controller: _sc,
                              physics: BouncingScrollPhysics(),
                              children: _recentlyBroughtBloc?.recentlyBoughtList
                                  ?.map<Widget>((e) => _recentlyProductCard(e))
                                  ?.toList(),
                            ),
                          ),
                          if (_recentlyBroughtBloc.state is Loading)
                            CircularProgressIndicator(),
                        ],
                      ),
              ),
            if (_isLoading)
              Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      right: SizeConfig.widthMultiplier * 3.8888888888888884,
                      top: SizeConfig.heightMultiplier * 2.5107604017216643),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      children: [
                        Container(
                          height:
                              SizeConfig.heightMultiplier * 18.830703012912483,
                          width: MediaQuery.of(context).size.width,
                          child: Lottie.asset(
                            'assets/loader/horizontal_card_loding.json',
                          ),
                        ),
                        Container(
                          height:
                              SizeConfig.heightMultiplier * 18.830703012912483,
                          width: MediaQuery.of(context).size.width,
                          child: Lottie.asset(
                              'assets/loader/horizontal_card_loding.json'),
                        ),
                        Container(
                          height:
                              SizeConfig.heightMultiplier * 18.830703012912483,
                          width: MediaQuery.of(context).size.width,
                          child: Lottie.asset(
                              'assets/loader/horizontal_card_loding.json'),
                        ),
                        Container(
                          height:
                              SizeConfig.heightMultiplier * 18.830703012912483,
                          width: MediaQuery.of(context).size.width,
                          child: Lottie.asset(
                              'assets/loader/horizontal_card_loding.json'),
                        ),
                      ])),
          ],
        ),
      ),
    );
  }

  Widget _recentlyProductCard(RecentlyBrought model) {
    bool isExpanded = _expandedItems.contains(model?.orderID);
    return GestureDetector(
      onTap: () {
        setState(() {
          _recentlyBroughtBloc.orderId = model?.orderID;
          _isOptionLoad = true;
          _recentlyBroughtBloc.add(RecentlyOrderStatusEvent());
          if (_expandedItems.contains(model?.orderID)) {
            _expandedItems.remove(model?.orderID);
          } else {
            if (_expandedItems.isNotEmpty) {
              _expandedItems.clear();
              _expandedItems.add(model?.orderID);
            } else {
              _expandedItems.add(model?.orderID);
            }
          }
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
    // model.description = "donglin jieshi yiguancanghai shuihedandan "
    //     "shandaosongchi ";
    return RecentlyBoughtText(
      model: model,
    );
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Row(
            children: [
              Image.asset('assets/images/filter.png'),
              Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  listItem,
                  style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      color: AppColors.toolbarBlue),
                ),
              )
            ],
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  Widget _expandedText(RecentlyBrought model) {
    return Column(
      children: [
        const SizedBox(height: 8),
        if (model.shippingStatus.toLowerCase() != "cancelled")
          _orderStatus(orderStatusModel, model)
        // StreamBuilder(
        //   stream: _recentlyBroughtBloc.orderStatusStream,
        //   builder: (context, stream) {
        //     if (stream.connectionState == ConnectionState.done) {}
        //
        //     if (stream.hasData) {
        //       return _orderStatus(stream.data, model);
        //     } else {
        //       return Container(
        //         child: Center(
        //           child: Lottie.asset('assets/loader/loader_blue.json',
        //               width: SizeConfig.widthMultiplier * 9.722222222222221, height: SizeConfig.heightMultiplier * 5.0215208034433285),
        //         ),
        //       );
        //     }
        //   },
        // ),
      ],
    );
  }

  Widget _orderStatus(OrderStatusModel model, RecentlyBrought recentlyBrought) {
    return _isOptionLoad
        ? Lottie.asset(
            'assets/loader/list_loader.json',
          )
        : OrderDetailsPreviewWidget(
            model: model,
            recentlyBrought: recentlyBrought,
          );
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.appBlue,
        textColor: Colors.white,
        fontSize: SizeConfig.textMultiplier * 2.0086083213773316);
  }
}
