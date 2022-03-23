import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/common/selling_item.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/sell_new_products/sell_new_products_route.dart';
import 'package:market_space/seller_selling/seller_selling_bloc.dart';
import 'package:market_space/seller_selling/seller_selling_l10n.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class SellerSellingScreen extends StatefulWidget {
  @override
  _SellerSellingScreenState createState() => _SellerSellingScreenState();
}

class _SellerSellingScreenState extends State<SellerSellingScreen> {
  final SellerSellingBloc _sellerSellingBloc = SellerSellingBloc(Initial());
  SellerSellingL10n _l10n = SellerSellingL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  bool _isLoading = false;
  PageController _pageController = PageController(initialPage: 0);
  int slideIndex = 0;
  List<File> _imagesArray = List();

  final Color background = AppColors.toolbarBlue;
  final Color fill = AppColors.lightgrey;
  File asset;

  @override
  void initState() {
    _pageController.addListener(() {});
    _resetData();
    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = SellerSellingL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n = SellerSellingL10n(Locale.fromSubtags(languageCode: 'zh'));
      }
    });
    super.initState();
  }

  _resetData() {
    SellingItems.productTitle = null;
    SellingItems.category = null;
    SellingItems.subCategory = null;
    SellingItems.description = null;
    SellingItems.productType = null;
    SellingItems.condition = null;
    SellingItems.courierServices = null;
    SellingItems.shippingMethod = null;
    SellingItems.handlingTime = null;
    SellingItems.deliveryTime = null;

    SellingItems.freeShipping = true;
    SellingItems.packageLength = null;
    SellingItems.packageWidth = null;
    SellingItems.packageHeight = null;
    SellingItems.packageWeight = null;
    SellingItems.estimatedShippingPrice = null;
    SellingItems.deliveryInfo = null;

    SellingItems.price = null;
    SellingItems.paymentCurrency = null;
    SellingItems.mailCheck = false;
  }

  @override
  Widget build(BuildContext context) {
    // _sellerSellingBloc.add(SellNewProductsImageEvent());

    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];

    final double fillPercent = 39.7; // fills 56.23% for container from bottom
    final double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: gradient,
              stops: stops)),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: Toolbar(
          title: 'Sell item',
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.white,
          child: BlocProvider(
            create: (_) => _sellerSellingBloc,
            child: BlocListener<SellerSellingBloc, SellerSellingState>(
                listener: (context, state) {
                  if (state is Loading) {
                    setState(() {
                      _isLoading = true;
                    });
                  }
                  if (state is Loaded) {
                    setState(() {
                      _isLoading = false;
                      // _categoryList = _RecentlyBroughtBloc.categoryList;
                    });
                  }
                  if (state is ImagePick) {
                    setState(() {
                      _isLoading = false;
                      _imagesArray = _sellerSellingBloc?.imageArray;
                      if (_imagesArray.length > 1) {
                        File _image = _imagesArray[1];
                        _imagesArray.clear();
                        _imagesArray.add(_image);
                      }
                      SellingItems.productImages = _imagesArray;
                      // _dialogImagePick();
                    });
                  }
                  if (state is ImagePickFailed) {
                    setState(() {
                      _isLoading = false;
                      // _imagesArray = _sellerSellingBloc?.imageArray;
                      // _dialogImagePick();
                    });
                    //
                  }
                  if (state is CameraPick) {
                    setState(() {
                      _isLoading = false;
                      _imagesArray = _sellerSellingBloc?.imageArray;
                      if (_imagesArray.length > 1) {
                        File _image = _imagesArray[1];
                        _imagesArray.clear();
                        _imagesArray.add(_image);
                      }
                      SellingItems.productImages = _imagesArray;
                      // print("product images array updated");
                    });
                    // _dialogImagePick();
                  }
                  if (state is CameraPickFailed) {
                    _isLoading = false;
                    // _dialogImagePick();
                  }
                },
                child: ListView(
                  shrinkWrap: true,
                  children: [_baseScreen()],
                )),
          ),
        ),
      ),
    );
  }

  Widget _baseScreen() {
    return Container(
      color: Colors.white,
      child: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          children: [
            if (_isLoading)
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.3),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                    child: Lottie.network(
                      'https://assets3.lottiefiles.com/packages/lf20_FVqg63.json',
                      width: SizeConfig.widthMultiplier * 12.152777777777777,
                      height: SizeConfig.heightMultiplier * 6.276901004304161,
                      animate: true,
                    ),
                  )),
            Column(children: [_sellerSellingScreen()]),
          ],
        ),
      ),
    );
  }

  Widget _sellerSellingScreen() {
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 2.5107604017216643,
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          bottom: SizeConfig.heightMultiplier * 6.276901004304161),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              _l10n.sellNewProducts,
              style: GoogleFonts.inter(
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                fontWeight: FontWeight.w700,
                color: AppColors.app_txt_color,
              ),
            ),
          ),

          // if (_imagesArray.isNotEmpty)
          //   Container(
          //     width: MediaQuery.of(context).size.width,
          //     height: SizeConfig.heightMultiplier * 6.025824964131995,
          //     margin: EdgeInsets.only(
          //       top: SizeConfig.heightMultiplier * 2.1341463414634148,
          //     ),
          //     child: RaisedGradientButton(
          //       gradient: LinearGradient(
          //         colors: <Color>[
          //           AppColors.lightgrey,
          //           AppColors.lightgrey,
          //         ],
          //       ),
          //       child: Padding(
          //           padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          //           child: Text(
          //             'SELECT MORE IMAGES',
          //             style: GoogleFonts.inter(
          //                 color: AppColors.black,
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: SizeConfig.textMultiplier * 1.757532281205165,
          //                 letterSpacing: 0.5,
          //                 textStyle: TextStyle(fontFamily: 'Roboto')),
          //           )),
          //       onPressed: () {
          //         _sellerSellingBloc.add(SellNewProductsImageEvent());
          //       },
          //     ),
          //   ),
          // GestureDetector(
          //   onTap: () {
          //     _sellerSellingBloc.add(SellNewProductsCameraEvent());
          //   },
          //   child: Container(
          //     margin: EdgeInsets.only(
          //         top: SizeConfig.heightMultiplier * 2.385222381635581),
          //     height: SizeConfig.heightMultiplier * 6.276901004304161,
          //     width: MediaQuery.of(context).size.width,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10),
          //         border: Border.all(color: AppColors.appBlue)),
          //     child: Center(
          //       child: Text(
          //         _l10n.useCamera,
          //         style: GoogleFonts.inter(
          //             fontSize: SizeConfig.textMultiplier * 1.757532281205165,
          //             fontWeight: FontWeight.w700,
          //             color: AppColors.appBlue,
          //             textStyle: TextStyle(fontFamily: 'Roboto')),
          //       ),
          //     ),
          //   ),
          // ),
          _photoSelection(),
          Container(
            width: MediaQuery.of(context).size.width,
            height: SizeConfig.heightMultiplier * 6.025824964131995,
            margin: EdgeInsets.only(
              top: SizeConfig.heightMultiplier * 2.1341463414634148,
            ),
            child: RaisedGradientButton(
              gradient: LinearGradient(
                colors: <Color>[
                  AppColors.gradient_button_light,
                  AppColors.gradient_button_dark,
                ],
              ),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: Text(
                    "CONFIRM",
                    style: GoogleFonts.inter(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        letterSpacing: 0.5,
                        textStyle: TextStyle(fontFamily: 'Roboto')),
                  )),
              onPressed: () {
                // _tutorialImagePick();
                if (_imagesArray == null || _imagesArray.isEmpty) {
                  _showToast("Please add product images");
                } else {
                  RouterService.appRouter
                      .navigateTo(SellNewProductsRoute.buildPath());
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 3.0129124820659974,
              ),
              child: Text(
                _l10n.productPic,
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                    fontWeight: FontWeight.w400,
                    color: AppColors.appBlue,
                    letterSpacing: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*void _dialogImagePick() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          title:Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.8,
            // height: SizeConfig.heightMultiplier * 12.553802008608322,
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: SizeConfig.heightMultiplier * 0.6276901004304161, left: SizeConfig.widthMultiplier * 1.2152777777777777, right: SizeConfig.widthMultiplier * 1.2152777777777777, bottom: SizeConfig.heightMultiplier * 1.8830703012912482),
                    child: Text(
                      'Image loaded, Do you want add more',
                      style: GoogleFonts.inter(
                          fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                          fontWeight: FontWeight.w400,
                          color: AppColors.app_txt_color),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            _sellerSellingBloc.add(SellNewProductsImageEvent());
                          },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(color: AppColors.app_orange,
                              borderRadius: BorderRadius.circular(10),),
                              child: Text(
                                'Add more',
                                style: GoogleFonts.inter(
                                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.app_txt_color),
                              ),
                            )),
                        Spacer(),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              SellNewProductsRoute.imageArray = _imagesArray;
                              RouterService.appRouter
                                  .navigateTo(SellNewProductsRoute.buildPath());
                            } ,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(color: AppColors.lightgrey,
                                borderRadius: BorderRadius.circular(10),),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.inter(
                                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.app_txt_color),
                              ),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ));
        });
  }*/

  Widget _photoSelection() {
    if (Platform.isIOS) {
      return CupertinoButton(
        onPressed: () {
          showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) => CupertinoActionSheet(
                    actions: [
                      CupertinoActionSheetAction(
                        child: const Text('Take photo'),
                        onPressed: () {
                          _sellerSellingBloc.add(SellNewProductsCameraEvent());
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoActionSheetAction(
                        child: const Text('Choose from gallery'),
                        onPressed: () {
                          _sellerSellingBloc.add(SellNewProductsImageEvent());
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ));
        },
        child: Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 2.0086083213773316),
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.text_field_container)),
            child: _imagesArray.isEmpty
                ? Container(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/camera.svg',
                        height: 35,
                        width: 35,
                        color: AppColors.text_field_container,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Text(
                          _l10n.addProductPhotos,
                          style: GoogleFonts.inter(
                              fontSize: SizeConfig.textMultiplier *
                                  1.5064562410329987,
                              fontWeight: FontWeight.w400,
                              color: AppColors.text_field_color,
                              letterSpacing: 0.4),
                        ),
                      ),
                    ],
                  ))
                : _buildGridView(context)),
      );
    } else if (Platform.isAndroid) {
      return GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.camera_alt_rounded),
                      title: Text('Take photo'),
                      onTap: () {
                        _sellerSellingBloc.add(SellNewProductsCameraEvent());
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                        leading: Icon(Icons.camera),
                        title: Text('Choose from gallery'),
                        onTap: () {
                          _sellerSellingBloc.add(SellNewProductsImageEvent());
                          Navigator.pop(context);
                        }),
                  ],
                );
              });
        },
        child: Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 2.0086083213773316),
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.text_field_container)),
            child: _imagesArray.isEmpty
                ? Container(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/camera.svg',
                        height: 35,
                        width: 35,
                        color: AppColors.text_field_container,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Text(
                          _l10n.addProductPhotos,
                          style: GoogleFonts.inter(
                              fontSize: SizeConfig.textMultiplier *
                                  1.5064562410329987,
                              fontWeight: FontWeight.w400,
                              color: AppColors.text_field_color,
                              letterSpacing: 0.4),
                        ),
                      ),
                    ],
                  ))
                : _buildGridView(context)),
      );
    }
  }

  void _tutorialImagePick() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.8,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      slideIndex = index;
                    });
                  },
                  children: [
                    _tutorialPage1(),
                    _tutorialPage1(),
                    _tutorialPage1(),
                  ],
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: SizeConfig.heightMultiplier * 6.025824964131995,
                    width: SizeConfig.widthMultiplier * 29.166666666666664,
                    margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 1.2553802008608321,
                    ),
                    child: RaisedGradientButton(
                      gradient: LinearGradient(
                        colors: <Color>[
                          AppColors.gradient_button_light,
                          AppColors.gradient_button_dark,
                        ],
                      ),
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                          child: Text(
                            _l10n.next,
                            style: GoogleFonts.inter(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.textMultiplier *
                                    1.757532281205165,
                                letterSpacing: 0.5,
                                textStyle: TextStyle(fontFamily: 'Roboto')),
                          )),
                      onPressed: () {
                        setState(() {
                          // if(_pageController.page == 0.0) {
                          //   _pageController.jumpToPage(0);
                          // }if(_pageController.page == 1.0) {
                          //   _pageController.jumpToPage(1);
                          // }if(_pageController.page == 2.0) {
                          //   _pageController.jumpToPage(3);
                          // }
                          // else {
                          Navigator.pop(context);

                          // }
                        });
                      },
                    ),
                  ),
                  _bottomSheet(true),
                ],
              ),
            );
          });
        });
  }

  Widget _tutorialPage1() {
    return Container(
        child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(
              top: SizeConfig.heightMultiplier * 12.177187948350072),
          child: Image.asset(
            'assets/images/camera_img.png',
            width: SizeConfig.widthMultiplier * 36.45833333333333,
            height: SizeConfig.heightMultiplier * 17.575322812051652,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.only(
              top: SizeConfig.heightMultiplier * 11.172883787661407,
            ),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin eget tortor risus. Sed porttitor lectus nibh.',
              style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                  fontWeight: FontWeight.w400,
                  color: AppColors.app_txt_color,
                  letterSpacing: 0.4),
              textAlign: TextAlign.center,
              maxLines: 5,
            ),
          ),
        ),
      ],
    ));
  }

  Widget _bottomSheet(bool isCurrentPage) {
    return AnimatedContainer(
      margin: EdgeInsets.only(
          bottom: SizeConfig.heightMultiplier * 3.0129124820659974,
          top: SizeConfig.heightMultiplier * 2.0086083213773316),
      duration: Duration(milliseconds: 500),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (int i = 0; i < 3; i++)
          i == slideIndex
              ? _bottomSheetContainer(true)
              : _bottomSheetContainer(false),
      ]),
    );
  }

  Widget _bottomSheetContainer(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 1.9444444444444442),
      height: isCurrentPage ? 8 : 8,
      width: isCurrentPage ? 8 : 8,
      decoration: BoxDecoration(
          color: isCurrentPage ? Color(0xff034AA6) : Color(0xffD4D4D4),
          shape: BoxShape.circle),
    );
  }

  Widget _buildGridView(BuildContext context) {
    // print('do we actually reach here');
    setState(() {
      asset = _imagesArray[0];
    });
    // print('asset: ${asset.path}');
    return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(10),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Image.file(asset, fit: BoxFit.fill
                    // height: MediaQuery.of(context).size.height * 0.4,
                    // width: MediaQuery.of(context).size.width,
                    ),
              )

              // GestureDetector(
              //   onTap: () {
              //     _sellerSellingBloc.add(SellNewProductsImageEvent());
              //   },
              //   child: Container(
              //       margin: EdgeInsets.all(5.0),
              //       child: Expanded(
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           // crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             Icon(
              //               Icons.add,
              //               color: AppColors.toolbarBlue,
              //               size: 14,
              //             ),
              //             Expanded(
              //                 child: Text(
              //               'Add more',
              //               style: GoogleFonts.inter(
              //                   color: AppColors.toolbarBlue,
              //                   fontSize: SizeConfig.textMultiplier *
              //                       1.757532281205165),
              //             ))
              //           ],
              //         ),
              //       )),
              // ),
            ]));
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
