import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:market_space/active_products/active_product_route.dart';
import 'package:market_space/apis/firebaseManager.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/feedback/feedback_route.dart';
import 'package:market_space/main.dart';
import 'package:market_space/model/active_products_model/active_product_model.dart';
import 'package:market_space/model/conversationModels/userModel.dart';
import 'package:market_space/model/feedback/buyer_feedback_model.dart';
import 'package:market_space/model/feedback/feedback_model.dart';
import 'package:market_space/model/product_model.dart';
import 'package:market_space/model/profile_model/profile_model.dart';
import 'package:market_space/model/promo_model.dart';
import 'package:market_space/model/recently_product_model/recently_brought_model.dart';
import 'package:market_space/model/sold_product_model/sold_product_model.dart';
import 'package:market_space/notification/representation/widgets/screen/recentBuywidget.dart';
import 'package:market_space/notification/routes/notification_route.dart';
import 'package:market_space/product_landing_screen/product_landing_route.dart';
import 'package:market_space/profile/profile_bloc.dart';
import 'package:market_space/profile/profile_events.dart';
import 'package:market_space/profile/profile_l10n.dart';
import 'package:market_space/profile/profile_state.dart';
import 'package:market_space/profile_settings/profile_setting_route.dart';
import 'package:market_space/providers/conversationProviders/conversationProvider.dart';
import 'package:market_space/recently_brought_details/recently_detail_route.dart';
import 'package:market_space/recently_brought_products/recently_brought_route.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/services/routServiceProvider.dart';
import 'package:market_space/sold_products/sold_product_route.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileBloc _ProfileBloc = ProfileBloc(Initial());
  final _globalKey = GlobalKey<ScaffoldState>();
  ProfileL10n _l10n =
      ProfileL10n(Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  bool _isLoading = true;
  bool _aboutEnabled = false, _feedbackEmpty = true;
  double _rating = 0;

  final TextEditingController _aboutController = TextEditingController();
  String _broughtTxt;
  String _feedbackTxt;
  File _image, _back_image;
  List<Orders> _productList = List<Orders>();
  List<PromoModel> _promoList = List<PromoModel>();
  bool _isBuyer = true;
  String _aboutText;
  Uint8List _bytesImage;
  bool _isTags = false;
  List<Results> _resultList = List();
  List<BuyerFeedback> _buyerFeedbackList = List();
  String _userName;
  AuthRepository _authRepository = AuthRepository();

  @override
  void initState() {
    _ProfileBloc.add(ProfileScreenEvent());
    // print('executed profile screen');
    _ProfileBloc.add(ProfileScreenActiveEvent());
    _ProfileBloc.add(ProfileScreenOrderEvent());

    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = ProfileL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n = ProfileL10n(Locale.fromSubtags(languageCode: 'zh'));
      }
      _broughtTxt = _l10n.RecentlyBought;
      _feedbackTxt = _l10n.RecentlyFeedbackGiven;
    });
    _getName();
    // _aboutController.text =
    //     'Donec sollicitudin molestie malesuada. Cras ultricies ligula sed magna dictum porta. Curabitur aliquet quam id dui posuere blandit.';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: Toolbar(
      //   title: "Profile",
      // ),
      key: _globalKey,
      resizeToAvoidBottomInset: false,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.white,
          child: BlocProvider(
              create: (_) => _ProfileBloc,
              child: BlocListener<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is Loading) {
                    setState(() {
                      _isLoading = true;
                    });
                  }
                  if (state is Loaded) {
                    setState(() {
                      _isLoading = false;
                      // _productList = _ProfileBloc.productList;
                      _promoList = _ProfileBloc.promoList;
                      _aboutText = _ProfileBloc?.profileModel?.bio;
                    });
                  }
                  if (state is ProfileFailed) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                  if (state is ImagePicked) {
                    setState(() {
                      _image = _ProfileBloc.image;
                    });
                  }
                  if (state is ImagePicFailed) {
                    setState(() {});
                  }
                  if (state is EditBioSuccessful) {
                    setState(() {
                      // _aboutText = _ProfileBloc?.profileModel?.bio;
                      _isLoading = false;
                    });
                    Fluttertoast.showToast(
                        msg: _l10n.profileEditSuccessful,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: AppColors.appBlue,
                        textColor: Colors.white,
                        fontSize:
                            SizeConfig.textMultiplier * 2.0086083213773316);
                  }
                  if (state is EditBioFailed) {
                    setState(() {
                      _isLoading = false;
                    });
                    Fluttertoast.showToast(
                        msg: _l10n.editProfileFailed,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: AppColors.appBlue,
                        textColor: Colors.white,
                        fontSize:
                            SizeConfig.textMultiplier * 2.0086083213773316);
                  }
                  if (state is SetBackgroundUrlSuccessful) {
                    setState(() {
                      _back_image = _ProfileBloc.background_img;
                    });
                    Fluttertoast.showToast(
                        msg: _l10n.backgroundImageSuccessful,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: AppColors.appBlue,
                        textColor: Colors.white,
                        fontSize:
                            SizeConfig.textMultiplier * 2.0086083213773316);
                  }
                  if (state is SetBackgroundUrlFailed) {
                    Fluttertoast.showToast(
                        msg: _l10n.backgroundImageFailed,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: AppColors.appBlue,
                        textColor: Colors.white,
                        fontSize:
                            SizeConfig.textMultiplier * 2.0086083213773316);
                  }
                },
                child: ListView(
                  padding: EdgeInsets.zero,
                  // shrinkWrap: true,
                  children: [
                    FutureBuilder<UserModel>(
                        future: ConversationProvider()
                            .getUser(FirebaseManager.instance.getUID()),
                        builder: (context, snap) {
                          if (!snap.hasData) {
                            return _profileUI(
                                UserModel("User", "loading....", null, null));
                          }
                          return _profileUI(snap.data);
                        }),
                  ],
                ),
              ))
          // StreamBuilder(
          //   stream: _ProfileBloc.profileStream,
          //   builder: (context, stream) {
          //     if (stream.connectionState == ConnectionState.done) {}
          //
          //     if (stream.hasData) {
          //       ProfileModel model = stream.data;
          //       return ListView(
          //         padding: EdgeInsets.zero,
          //         // shrinkWrap: true,
          //         children: [_profileUI(model)],
          //       );
          //     } else {
          //       return Container(
          //         width: MediaQuery.of(context).size.height,
          //         height: MediaQuery.of(context).size.width,
          //         child: Lottie.asset('assets/loader/list_loader.json'),
          //       );
          //     }
          //   },
          // ))),
          ),
    );
  }

  Widget _profileUI(UserModel model) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            _ProfileBloc.add(ProfileBackgroundEvent());
          },
          child: Container(
            height: SizeConfig.heightMultiplier * 14.43687230989957,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/deaultBack.png',
              fit: BoxFit.cover,
            ),
            // _back_image == null
            //     ? CachedNetworkImage(
            //   imageUrl: model?.backgroundPictureURL != null
            //       ? model?.backgroundPictureURL
            //       : 'assets/images/deaultBack.png',
            //   placeholder: (context, url) =>
            //       Lottie.asset('assets/loader/image_loading.json'),
            //   errorWidget: (context, url, error) => Image.asset(
            //     'assets/images/profile_back.png',
            //     fit: BoxFit.fill,
            //     height: SizeConfig.heightMultiplier * 14.43687230989957,
            //     width: double.infinity,
            //   ),
            //   fit: BoxFit.fill,
            //   height: SizeConfig.heightMultiplier * 14.43687230989957,
            //   width: double.infinity,
            // )
            //     : Image.file(
            //   _back_image,
            //   fit: BoxFit.fill,
          ),
        ),
        // ),
        // if (_isBuyer)
        if (_image == null)
          GestureDetector(
              onTap: () {
                _ProfileBloc.add(ProfileImagePickerEvent());
              },
              child: Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.395,
                      // right: SizeConfig.widthMultiplier * 31.840277777777775,
                      top: SizeConfig.heightMultiplier * 8.285509325681492),
                  width: SizeConfig.widthMultiplier * 20.819444444444443,
                  height: SizeConfig.heightMultiplier * 12.302725968436155,
                  child: SvgPicture.asset(
                    'assets/images/user.svg',
                    // imageUrl: model?.profilePictureURL != null
                    //     ? model?.profilePictureURL
                    //     : 'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg',
                    // placeholder: (context, url) =>
                    //     Lottie.asset('assets/loader/image_loading.json'),
                    // errorWidget: (context, url, error) => Image.network(
                    //     'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg'),
                    fit: BoxFit.fill,
                  ))),
        if (_image != null)
          GestureDetector(
              onTap: () {
                _ProfileBloc.add(ProfileImagePickerEvent());
              },
              child: Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.37,
                      // right: SizeConfig.widthMultiplier * 31.840277777777775,
                      top: SizeConfig.heightMultiplier * 8.285509325681492),
                  width: SizeConfig.widthMultiplier * 23.819444444444443,
                  height: SizeConfig.heightMultiplier * 12.302725968436155,
                  child: ClipOval(
                    child: Image.file(
                      _image,
                      fit: BoxFit.fill,
                    ),
                  ))),

        GestureDetector(
          onTap: () {
            _ProfileBloc.add(ProfileImageCameraEvent());
          },
          child: Container(
            margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.52,
                // right: SizeConfig.widthMultiplier * 31.840277777777775,
                top: SizeConfig.heightMultiplier * 17.575322812051652),
            width: SizeConfig.widthMultiplier * 5.833333333333333,
            height: SizeConfig.heightMultiplier * 3.0129124820659974,
            child: ClipOval(
              child: Image.asset('assets/images/change_photo.png'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: EdgeInsets.only(
                bottom: SizeConfig.heightMultiplier * 10.419655667144907,
                top: SizeConfig.heightMultiplier * 3.0030703012912482,
                right: SizeConfig.widthMultiplier * 3.8888888888888884),
            padding: EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () => RouterService.appRouter
                  .navigateTo(ProfileSettingRoute.buildPath()),
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Icon(
                  Icons.settings_sharp,
                  color: AppColors.toolbarBlue,
                  size: SizeConfig.heightMultiplier * 4,
                ),
              ),
            ),
          ),
        ),
        _baseScreen(model),
      ],
    );
  }

  Widget _baseScreen(UserModel model) {
    return Container(
      margin:
          EdgeInsets.only(top: SizeConfig.heightMultiplier * 21.34146341463415),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          children: [
            if (_isLoading)
              BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                  child: Center(
                      child: LoadingProgress(
                    color: Colors.deepOrangeAccent,
                  ))),
            Center(
              child: _profileScreenBase(model),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileScreenBase(UserModel model) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        // shrinkWrap: true,
        children: [
          _name(model),
          _about(model),
          _toggleButtons(),
          // _toggle(),
          // _cardLikedList(),
          if (!_isBuyer) _activeProducts(),
          // if (!_isBuyer) _overallRating(model),
          if (_isBuyer) _recentlyBrought(),
          _recentFeedback(),
          if (!_isBuyer) _recentlyBrought(),
          _helpCenter(),
        ],
      ),
    );
  }

  Widget _name(UserModel model) {
    if (model?.name != null) {
      int index = model?.name.indexOf(' ', model?.name.indexOf(' ') + 1);
      if (index > 0)
        _userName = model?.name.substring(0, index);
      else
        _userName = model?.name;
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _userName ?? "name",
            style: GoogleFonts.inter(
              fontSize: SizeConfig.textMultiplier * 2.259684361549498,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.15,
              color: AppColors.black,
            ),
          ),
          if (!_isBuyer)
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.34,
              ),
              child: Row(
                children: [
                  Text(
                    "",
                    style: GoogleFonts.inter(
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.25,
                      color: Color.fromRGBO(0, 0, 0, 70),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _about(UserModel model) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 4.131944444444444,
                  top: SizeConfig.heightMultiplier * 1.0043041606886658),
              child: Text(
                _l10n.about,
                style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                  color: AppColors.app_txt_color,
                ),
              ),
            ),
            if (!_aboutEnabled)
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_aboutEnabled) {
                      _aboutEnabled = false;
                    } else {
                      _aboutEnabled = true;
                    }
                  });
                },
                child: Container(
                  width: SizeConfig.widthMultiplier * 4.374999999999999,
                  height: SizeConfig.heightMultiplier * 2.259684361549498,
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 0.9722222222222221,
                      top: SizeConfig.heightMultiplier * 0.8787661406025825),
                  child: Image.asset(
                    'assets/images/icon_edit.png',
                    width: SizeConfig.widthMultiplier * 3.2763888888888886,
                    height: SizeConfig.heightMultiplier * 1.6922525107604018,
                  ),
                ),
              ),
          ],
        ),
        Row(children: [
          if (_aboutEnabled)
            Expanded(
              child: Container(
                // height: SizeConfig.heightMultiplier * 3.7661406025824964,
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884,
                    top: SizeConfig.heightMultiplier * 1.0043041606886658),
                child: TextField(
                  controller: _aboutController,
                  enabled: _aboutEnabled,
                  // decoration: new InputDecoration(
                  //     border: new OutlineInputBorder(
                  //         borderSide: new BorderSide(color: Colors.transparent),
                  //         borderRadius: BorderRadius.circular(10.0)),
                  //     hintText: 'About',
                  //     suffixStyle: const TextStyle(color: Colors.blue)),
                ),
              ),
            ),
          if (_aboutEnabled)
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (_aboutEnabled) {
                      setState(() {
                        _aboutEnabled = false;
                        _isLoading = true;
                        _aboutText = _aboutController.text;
                        _ProfileBloc.bio = _aboutController.text;
                        _ProfileBloc.add(ProfileEditBioEvent());
                      });
                    } else {
                      setState(() {
                        _isLoading = true;
                        _aboutEnabled = true;
                        _ProfileBloc.bio = _aboutController.text;
                        _aboutText = _aboutController.text;
                        _ProfileBloc.add(ProfileEditBioEvent());
                      });
                    }
                  },
                  child: Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 1.9444444444444442,
                          right:
                              SizeConfig.widthMultiplier * 1.9444444444444442,
                          top:
                              SizeConfig.heightMultiplier * 1.0043041606886658),
                      child: Icon(
                        Icons.check_outlined,
                        color: Colors.green,
                        size: 20,
                      )),
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_aboutEnabled) {
                          _aboutEnabled = false;
                        } else {
                          _aboutEnabled = true;
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 1.9444444444444442,
                          right:
                              SizeConfig.widthMultiplier * 1.9444444444444442,
                          top:
                              SizeConfig.heightMultiplier * 1.0043041606886658),
                      child: Icon(
                        Icons.close_outlined,
                        color: Colors.red,
                        size: 20,
                      ),
                    )),
              ],
            ),
          if (!_aboutEnabled)
            Expanded(
                child: Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 4.131944444444444,
                  right: SizeConfig.widthMultiplier * 3.8888888888888884,
                  top: SizeConfig.heightMultiplier * 0.5021520803443329),
              child: Text(
                model.myBio,
                // _aboutText == null
                //     ? 'Hey there user! Come on, add a cool bio!'
                //     : _aboutText,
                style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.25,
                  color: AppColors.unselected_tab,
                ),
              ),
            )),
        ])
      ]),
    );
  }

  Widget _toggleButtons() {
    return Container(
        margin: EdgeInsets.only(
            top: SizeConfig.heightMultiplier * 2.5107604017216643,
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: SizeConfig.widthMultiplier * 3.8888888888888884),
        height: SizeConfig.heightMultiplier * 4.770444763271162,
        width: SizeConfig.widthMultiplier * 79.72222222222221,
        decoration: BoxDecoration(
            color: AppColors.lightgrey,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              const BoxShadow(
                color: AppColors.text_field_container,
              ),
              const BoxShadow(
                color: AppColors.text_field_container,
                spreadRadius: -20.0,
                blurRadius: 15.0,
              ),
            ]),
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (_isBuyer) {
                _isBuyer = false;
                _feedbackTxt = _l10n.RecentlyFeedbackReceived;
                _broughtTxt = _l10n.SoldItems;
                _ProfileBloc.sellerData = true;
                _ProfileBloc.add(ProfileScreenEvent());
                _ProfileBloc.add(ProfileScreenActiveEvent());
                _ProfileBloc.add(ProfileScreenOrderEvent());
              } else {
                _isBuyer = true;
                _feedbackTxt = _l10n.RecentlyFeedbackGiven;
                _broughtTxt = _l10n.RecentlyBought;
                _ProfileBloc.sellerData = false;
                _ProfileBloc.add(ProfileScreenEvent());
                _ProfileBloc.add(ProfileScreenActiveEvent());
                _ProfileBloc.add(ProfileScreenOrderEvent());
              }
            });
          },
          child: Card(
            elevation: 0,
            color: AppColors.lightgrey,
            margin: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                if (_isBuyer)
                  Container(
                      width: SizeConfig.widthMultiplier * 38.40277777777777,
                      child: Center(
                        child: Text(
                          _l10n.sellerProfile,
                          style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                            color: _isBuyer
                                ? AppColors.text_field_container
                                : AppColors.white,
                          ),
                        ),
                      )),
                Spacer(),
                if (!_isBuyer)
                  Container(
                      height: SizeConfig.heightMultiplier * 4.770444763271162,
                      width: SizeConfig.widthMultiplier * 41.31944444444444,
                      child: Card(
                        elevation: 2,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: _isBuyer
                            ? AppColors.text_field_container
                            : AppColors.app_orange,
                        child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.gradient_button_light,
                                  AppColors.gradient_button_dark,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                _l10n.sellerProfile,
                                style: GoogleFonts.inter(
                                  fontSize: SizeConfig.textMultiplier *
                                      1.757532281205165,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.25,
                                  color: _isBuyer
                                      ? AppColors.text_field_container
                                      : AppColors.white,
                                ),
                              ),
                            )),
                      )),
                Spacer(),
                if (_isBuyer)
                  Container(
                    height: SizeConfig.heightMultiplier * 4.770444763271162,
                    width: SizeConfig.widthMultiplier * 41.31944444444444,
                    child: Card(
                        elevation: 2,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: _isBuyer
                            ? AppColors.app_orange
                            : AppColors.text_field_container,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.gradient_button_light,
                                AppColors.gradient_button_dark,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              _l10n.buyerProfile,
                              style: GoogleFonts.inter(
                                fontSize: SizeConfig.textMultiplier *
                                    1.757532281205165,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                                color: _isBuyer
                                    ? AppColors.white
                                    : AppColors.text_field_container,
                              ),
                            ),
                          ),
                        )),
                  ),
                Spacer(),
                if (!_isBuyer)
                  Container(
                    width: SizeConfig.widthMultiplier * 38.40277777777777,
                    child: Center(
                      child: Text(
                        _l10n.buyerProfile,
                        style: GoogleFonts.inter(
                          fontSize:
                              SizeConfig.textMultiplier * 1.757532281205165,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.25,
                          color: _isBuyer
                              ? AppColors.white
                              : AppColors.text_field_container,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }

  Widget _cardLikedList() {
    return _isBuyer
        ? Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 4.017216642754663,
                left: SizeConfig.widthMultiplier * 1.9444444444444442,
                right: SizeConfig.widthMultiplier * 1.7013888888888886),
            height: SizeConfig.heightMultiplier * 15.19010043041607,
            // width: SizeConfig.widthMultiplier * 83.6111111111111,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(
                        right: SizeConfig.widthMultiplier * 2.9166666666666665),
                    height: SizeConfig.heightMultiplier * 15.064562410329986,
                    width: SizeConfig.widthMultiplier * 26.006944444444443,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
                    child: _cardLiked('assets/images/item_brought.png',
                        _l10n.ItemsBought, '873')),
                Container(
                  margin: EdgeInsets.only(
                      right: SizeConfig.widthMultiplier * 2.9166666666666665),
                  height: SizeConfig.heightMultiplier * 15.064562410329986,
                  width: SizeConfig.widthMultiplier * 26.006944444444443,
                  child: _cardLiked(
                      'assets/images/Investment.png', 'Items on the ways', '3'),
                ),
                Container(
                  height: SizeConfig.heightMultiplier * 15.064562410329986,
                  width: SizeConfig.widthMultiplier * 26.006944444444443,
                  child: _cardLiked(
                      'assets/images/recent_view.png', 'Recent views', '256'),
                ),
              ],
            ))
        : Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 4.017216642754663,
                left: SizeConfig.widthMultiplier * 1.9444444444444442,
                right: SizeConfig.widthMultiplier * 1.7013888888888886),
            height: SizeConfig.heightMultiplier * 15.19010043041607,
            // width: SizeConfig.widthMultiplier * 83.6111111111111,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(
                        right: SizeConfig.widthMultiplier * 2.9166666666666665),
                    height: SizeConfig.heightMultiplier * 15.064562410329986,
                    width: SizeConfig.widthMultiplier * 26.006944444444443,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
                    child: _cardLiked('assets/images/item_brought.png',
                        _l10n.Revenuetodata, '0,010')),
                Container(
                  margin: EdgeInsets.only(
                      right: SizeConfig.widthMultiplier * 2.9166666666666665),
                  height: SizeConfig.heightMultiplier * 15.064562410329986,
                  width: SizeConfig.widthMultiplier * 26.006944444444443,
                  child: _cardLiked('assets/images/Investment.png',
                      _l10n.Investmentearnings, '0,033'),
                ),
                Container(
                  height: SizeConfig.heightMultiplier * 15.064562410329986,
                  width: SizeConfig.widthMultiplier * 26.006944444444443,
                  child: _cardLiked(
                      'assets/images/recent_view.png', 'Recent views', '256'),
                ),
              ],
            ),
          );
  }

  Widget _cardLiked(String image, String txt, String no) {
    return Card(
      color: AppColors.appBlue,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Container(
        color: AppColors.white,
        margin: EdgeInsets.only(
            top: SizeConfig.heightMultiplier * 0.6276901004304161),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 1.5064562410329987,
              ),
              child: Image.asset(
                image,
                width: SizeConfig.widthMultiplier * 5.833333333333333,
                height: SizeConfig.heightMultiplier * 3.0129124820659974,
                color: AppColors.black,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 0.5021520803443329,
              ),
              child: Text(
                txt,
                style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 0.5021520803443329,
              ),
              child: Text(
                no,
                style: GoogleFonts.inter(
                    fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                    color: AppColors.app_txt_color),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _recentlyBrought() {
    // print("length recent: ${_ProfileBloc.recentlyBoughtList.length}");
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  top: SizeConfig.heightMultiplier * 4.142754662840746),
              child: Text(
                _broughtTxt,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                  color: AppColors.app_txt_color,
                ),
              ),
            ),
            Spacer(),
            // _ProfileBloc?.recentlyBoughtList != null &&
            //     !_ProfileBloc?.recentlyBoughtList?.isEmpty
            //     ?
            // if (_ProfileBloc?.recentlyBoughtList != null &&
            //     _ProfileBloc?.recentlyBoughtList?.isNotEmpty)
            GestureDetector(
              onTap: () {
                if (_broughtTxt == _l10n.SoldItems) {
                  RouterService.profileRouter
                      .navigateTo(SoldProductRoute.buildPath());
                } else {
                  RouterService.profileRouter
                      .navigateTo(RecentlyBroughtRoute.buildPath());
                }
              },
              child: Container(
                height: SizeConfig.heightMultiplier * 2.5107604017216643,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    right: SizeConfig.widthMultiplier * 3.645833333333333,
                    top: SizeConfig.heightMultiplier * 4.017216642754663),
                padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 1.9444444444444442,
                    right: SizeConfig.widthMultiplier * 1.9444444444444442,
                    top: SizeConfig.heightMultiplier * 0.25107604017216645,
                    bottom: SizeConfig.heightMultiplier * 0.25107604017216645),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.seeAllText,
                        width:
                            SizeConfig.widthMultiplier * 0.24305555555555552),
                    color: AppColors.seeAllBack),
                child: Text(
                  _l10n.seeAll,
                  style: TextStyle(
                    color: AppColors.seeAllText,
                    fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                  ),
                ),
              ),
            )
            //     : Container(
            //   height: 1.0,
            // )
          ],
        ),
        if (_isBuyer)
          Container(
              child: RecentBuyWidget(
            isBuy: true,
            isPart: true,
          )),
        // if (_isBuyer &&
        //     (_ProfileBloc?.recentlyBoughtList == null ||
        //         _ProfileBloc.recentlyBoughtList.isEmpty))

        //     : ListView.builder(
        //   padding: EdgeInsets.zero,
        //   physics: BouncingScrollPhysics(),
        //   shrinkWrap: true,
        //   scrollDirection: Axis.vertical,
        //   itemCount:
        //   (_ProfileBloc?.recentlyBoughtList?.length ?? 0) > 3
        //       ? 3
        //       : (_ProfileBloc?.recentlyBoughtList?.length ?? 0),
        //   itemBuilder: (context, index) {
        //     return _recentlyBroughtCard(
        //         _ProfileBloc?.recentlyBoughtList[index]);
        //   },
        // ),
        // ),
        if (!_isBuyer)
          Container(
              child:
                  // _ProfileBloc?.orders == null || _ProfileBloc?.orders?.isEmpty
                  //     ? Container(
                  //   child: Column(
                  //     children: [
                  //       Center(
                  //         child: Column(
                  //           children: [
                  //             Image.asset(
                  //               'assets/images/box.png',
                  //               fit: BoxFit.contain,
                  //               height: SizeConfig.heightMultiplier *
                  //                   18.830703012912483,
                  //               width: SizeConfig.widthMultiplier *
                  //                   24.305555555555554,
                  //             ),
                  //             Text(
                  //               "Hey there, you don't have any recently sold items",
                  //               style: GoogleFonts.inter(
                  //                 fontSize: SizeConfig.textMultiplier *
                  //                     1.757532281205165,
                  //                 fontWeight: FontWeight.w400,
                  //                 letterSpacing: 0.25,
                  //                 color: AppColors.unselected_tab,
                  //               ),
                  //             ),
                  //             Text(
                  //               "I'm sure you'll get your first sale soon!",
                  //               style: GoogleFonts.inter(
                  //                 fontSize: SizeConfig.textMultiplier *
                  //                     1.757532281205165,
                  //                 fontWeight: FontWeight.w400,
                  //                 letterSpacing: 0.25,
                  //                 color: AppColors.unselected_tab,
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )
                  //     :
                  RecentBuyWidget(
            isPart: true,
            isBuy: false,
          )),
        // StreamBuilder(
        //   stream: _ProfileBloc.orderStream,
        //   builder: (context, stream) {
        //     if (stream.connectionState == ConnectionState.done) {}
        //
        //     if (stream.hasData) {
        //       return Container(
        //         child: ListView.builder(
        //           physics: BouncingScrollPhysics(),
        //           shrinkWrap: true,
        //           scrollDirection: Axis.vertical,
        //           itemCount: 3,
        //           itemBuilder: (context, index) {
        //             return stream.data == null
        //                 ? Container(
        //               height: SizeConfig.heightMultiplier * 25.107604017216644,
        //               child:
        //               Lottie.asset('assets/loader/empty_show.json'),
        //             )
        //                 : _soldSellerCard(stream.data[index]);
        //           },
        //         ),
        //       );
        //     } else {
        //       return Container(
        //         child: Lottie.asset('assets/loader/list_loader.json'),
        //       );
        //     }
        //   },
        // ),
      ],
    );
  }

  Widget _soldSellerCard(Orders model) {
    // if(_productList[3]==model)
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 2.5107604017216643),
      // height: SizeConfig.heightMultiplier * 16.947632711621235,
      child: Card(
          margin: EdgeInsets.zero,
          child: Row(
            children: [
              Container(
                child: _soldSellerImage(model),
              ),
              Container(
                child: _soldSellerTxt(model),
              )
            ],
          )),
    );
  }

  Widget _soldSellerImage(Orders model) {
    return Stack(
      children: [
        Container(
            height: SizeConfig.heightMultiplier * 16.947632711621235,
            width: SizeConfig.widthMultiplier * 30.138888888888886,
            child: CachedNetworkImage(
                imageUrl: model?.imgLink != null
                    ? model?.imgLink
                    : 'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg',
                placeholder: (context, url) =>
                    Lottie.asset('assets/loader/image_loading.json'),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: AppColors.toolbarBlue,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ))),
      ],
    );
  }

  Widget _soldSellerTxt(Orders model) {
    if (model.tags == null) {
      _isTags = false;
    } else {
      _isTags = true;
    }
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 2.9166666666666665,
                      top: SizeConfig.heightMultiplier * 1.0043041606886658),
                  child: Text(model?.title,
                      maxLines: 1,
                      style: GoogleFonts.inter(
                          fontSize:
                              SizeConfig.textMultiplier * 2.259684361549498,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.15)),
                ),
                Spacer(),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig.heightMultiplier * 1.5064562410329987,
                          right:
                              SizeConfig.widthMultiplier * 1.9444444444444442,
                          left: SizeConfig.widthMultiplier * 3.645833333333333),
                      child: Text(
                        '\$${model?.fiatPrice}',
                        maxLines: 1,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.1),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //       right:
                    //           SizeConfig.widthMultiplier * 1.9444444444444442,
                    //       left: SizeConfig.widthMultiplier * 3.645833333333333),
                    //   child: Row(children: [
                    //     Icon(
                    //       CryptoFontIcons.BTC,
                    //       size: 14,
                    //     ),
                    //     // Text(
                    //     //   model?.destAmount ?? "0.00",
                    //     //   maxLines: 1,
                    //     //   style: GoogleFonts.inter(
                    //     //       fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                    //     //       fontWeight: FontWeight.w400,
                    //     //       letterSpacing: 0.4),
                    //     // ),
                    //   ]),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          if (_isTags)
            Container(
                height: SizeConfig.heightMultiplier * 6.276901004304161,
                width: SizeConfig.widthMultiplier * 37.43055555555555,
                child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: 0.34,
                    scrollDirection: Axis.horizontal,
                    children: model?.tags?.map((e) => _tags(e))?.toList())),
          Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 2.9166666666666665,
                top: SizeConfig.heightMultiplier * 1.0043041606886658,
                right: SizeConfig.widthMultiplier * 1.9444444444444442,
                bottom: SizeConfig.heightMultiplier * 0.6276901004304161),
            child: Text(
              model?.description ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                  fontWeight: FontWeight.w400,
                  color: AppColors.catTextColor,
                  letterSpacing: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentlyBroughtCard(RecentlyBrought model) {
    // if(_productList[3]==model)
    return InkResponse(
      onTap: () {
        RecentlyDetailRoute.recentlyBoughtModel = model;
        // RecentlyDetailRoute.orderStatusModel = model;
        RouterService.appRouter.navigateTo(RecentlyDetailRoute.buildPath());
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
            left: SizeConfig.widthMultiplier * 3.8888888888888884,
            right: SizeConfig.widthMultiplier * 3.8888888888888884,
            top: SizeConfig.heightMultiplier * 2.5107604017216643),
        // height: SizeConfig.heightMultiplier * 16.947632711621235,
        child: Card(
            margin: EdgeInsets.zero,
            elevation: 6,
            child: Row(
              children: [
                Container(
                  child: _recentlyImage(model),
                ),
                Container(
                  child: _recentlyBroughtTxt(model),
                )
              ],
            )),
      ),
    );
  }

  Widget _recentlyImage(RecentlyBrought model) {
    return Stack(
      children: [
        Container(
            height: SizeConfig.heightMultiplier * 16.947632711621235,
            width: SizeConfig.widthMultiplier * 30.138888888888886,
            child: CachedNetworkImage(
                imageUrl: model?.imgLink != null
                    ? model?.imgLink
                    : 'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-image-icon-isolated-png-image_5045508.jpg',
                placeholder: (context, url) =>
                    Lottie.asset('assets/loader/image_loading.json'),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: AppColors.toolbarBlue,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ))),
      ],
    );
  }

  Widget _recentlyBroughtTxt(RecentlyBrought model) {
    if (model.tags == null) {
      _isTags = false;
    } else {
      _isTags = true;
    }
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 2.9166666666666665,
                      top: SizeConfig.heightMultiplier * 1.0043041606886658),
                  child: Text(model?.title,
                      style: GoogleFonts.inter(
                          fontSize:
                              SizeConfig.textMultiplier * 2.259684361549498,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.15)),
                ),
                Spacer(),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig.heightMultiplier * 1.5064562410329987,
                          right:
                              SizeConfig.widthMultiplier * 1.9444444444444442,
                          left: SizeConfig.widthMultiplier * 3.645833333333333),
                      child: Text(
                        '\$${model?.fiatPrice}',
                        maxLines: 1,
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.1),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //       right:
                    //           SizeConfig.widthMultiplier * 1.9444444444444442,
                    //       left: SizeConfig.widthMultiplier * 3.645833333333333),
                    //   child: Row(children: [
                    //     Icon(
                    //       CryptoFontIcons.BTC,
                    //       size: 12,
                    //     ),
                    //     // Text(
                    //     //   model?.cryptoCheckoutPriceSeller ?? "0.00",
                    //     //   maxLines: 1,
                    //     //   style: GoogleFonts.inter(
                    //     //       fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                    //     //       fontWeight: FontWeight.w400,
                    //     //       letterSpacing: 0.4),
                    //     // ),
                    //   ]),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          if (_isTags)
            Container(
                height: SizeConfig.heightMultiplier * 6.276901004304161,
                width: SizeConfig.widthMultiplier * 37.43055555555555,
                child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: 0.35,
                    scrollDirection: Axis.horizontal,
                    children: model?.tags?.map((e) => _tags(e))?.toList())),
          Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 2.9166666666666665,
                top: SizeConfig.heightMultiplier * 1.0043041606886658,
                right: SizeConfig.widthMultiplier * 1.9444444444444442,
                bottom: SizeConfig.heightMultiplier * 0.6276901004304161),
            child: Text(
              model?.description ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                  fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                  fontWeight: FontWeight.w400,
                  color: AppColors.catTextColor,
                  letterSpacing: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _tags(ProductModel model) {
  //   return Container(
  //     padding: EdgeInsets.all(5),
  //     decoration: BoxDecoration(
  //       color: AppColors.app_orange,
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Text(
  //       model.tags[0],
  //       softWrap: false,
  //       style: TextStyle(
  //         color: AppColors.catTextColor,
  //         fontSize: SizeConfig.textMultiplier * 1.757532281205165,
  //         fontWeight: FontWeight.bold,
  //       ),
  //       maxLines: 3,
  //       textAlign: TextAlign.start,
  //     ),
  //   );
  // }

  Widget _recentFeedback() {
    return Column(
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884,
                      top: SizeConfig.heightMultiplier * 4.142754662840746),
                  child: Text(
                    _feedbackTxt,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                      color: AppColors.app_txt_color,
                    ),
                  ),
                ),
              ],
            ),

            // Spacer(),
            // if (!_feedbackEmpty)
            //   GestureDetector(
            //     onTap: () {
            //       if (!_isBuyer) {
            //         FeedbackRoute.isSeller = true;
            //         RouterService.appRouter
            //             .navigateTo(FeedbackRoute.buildPath());
            //       } else {
            //         FeedbackRoute.isSeller = false;
            //         RouterService.appRouter
            //             .navigateTo(FeedbackRoute.buildPath());
            //       }
            //     },
            //     child: Container(
            //       height: SizeConfig.heightMultiplier * 2.5107604017216643,
            //       alignment: Alignment.center,
            //       margin: EdgeInsets.only(
            //           // right: SizeConfig.widthMultiplier * 7.645833333333333,
            //           top: SizeConfig.heightMultiplier * 4.017216642754663,
            //           left: SizeConfig.heightMultiplier * 6.3),
            //       padding: EdgeInsets.only(
            //           left: SizeConfig.widthMultiplier * 1.9444444444444442,
            //           right: SizeConfig.widthMultiplier * 1.9444444444444442,
            //           top: SizeConfig.heightMultiplier * 0.25107604017216645,
            //           bottom:
            //               SizeConfig.heightMultiplier * 0.25107604017216645),
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10),
            //           border: Border.all(
            //               color: AppColors.seeAllText,
            //               width:
            //                   SizeConfig.widthMultiplier * 0.24305555555555552),
            //           color: AppColors.seeAllBack),
            //       child: Text(
            //         _l10n.seeAll,
            //         style: TextStyle(
            //           color: AppColors.seeAllText,
            //           fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        ),
        if (_feedbackEmpty && !_isBuyer)
          Container(
              padding: EdgeInsets.only(left: SizeConfig.heightMultiplier * 0.5),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/Stars.png',
                    fit: BoxFit.contain,
                    height: SizeConfig.heightMultiplier * 18.830703012912483,
                    width: SizeConfig.widthMultiplier * 24.305555555555554,
                  ),
                  Column(
                    children: [
                      Text(
                        "Stars are for our best sellers.",
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                            color: AppColors.unselected_tab),
                      ),
                      Text(
                        "Receive ratings from buyers when you sell items.",
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                            color: AppColors.unselected_tab),
                      )
                    ],
                  ),
                ],
              )),
        if (!_isBuyer)
          StreamBuilder(
            stream: _ProfileBloc.feedbackStream,
            builder: (context, stream) {
              if (stream.connectionState == ConnectionState.done) {}

              if (stream.hasData && stream.data.length != 0) {
                _resultList.addAll(stream.data);
                _feedbackEmpty = false;

                return Container(
                    child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: _resultList.length > 3 ? 3 : _resultList.length,
                  itemBuilder: (context, index) {
                    return _recentlyFeedbackCard(stream.data[index]);
                  },
                ));
              } else {
                _feedbackEmpty = true;
                return Container(height: 1.0);
              }
            },
          ),
        if (_isBuyer)
          StreamBuilder(
            stream: _ProfileBloc.feedbackBuyerStream,
            builder: (context, stream) {
              if (stream.connectionState == ConnectionState.done) {}
              if (stream.hasData && stream.data.length != 0) {
                _buyerFeedbackList.clear();
                _buyerFeedbackList.addAll(stream.data);
                return Container(
                    child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: _buyerFeedbackList.length > 3
                      ? 3
                      : _buyerFeedbackList.length,
                  itemBuilder: (context, index) {
                    return _recentlyFeedbackBuyerCard(stream.data[index]);
                  },
                ));
              } else {
                return SizedBox();
              }
            },
          ),
        if (_feedbackEmpty && _isBuyer)
          Container(
              padding: EdgeInsets.only(left: SizeConfig.heightMultiplier * 0.5),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/Stars.png',
                    fit: BoxFit.contain,
                    height: SizeConfig.heightMultiplier * 18.830703012912483,
                    width: SizeConfig.widthMultiplier * 24.305555555555554,
                  ),
                  Column(
                    children: [
                      Text(
                        "Stars are for our best buyers.",
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                            color: AppColors.unselected_tab),
                      ),
                      Text(
                        "Receive ratings from sellers when you purchase items.",
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 1.757532281205165,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                            color: AppColors.unselected_tab),
                      )
                    ],
                  ),
                ],
              ))
      ],
    );
  }

  Widget _recentlyFeedbackCard(Results model) {
    // print(model.toJson().toString());
    return Container(
      width: MediaQuery.of(context).size.width,
      height: SizeConfig.heightMultiplier * 10.419655667144907,
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 2.0086083213773316),
      child: Container(
        child: Row(
          children: [
            _feedbackImage(model),
            _feedbackTexts(model),
          ],
        ),
      ),
    );
  }

  Widget _feedbackImage(Results model) {
    return Container(
        width: SizeConfig.widthMultiplier * 16.28472222222222,
        height: SizeConfig.heightMultiplier * 8.411047345767576,
        margin: EdgeInsets.only(
            right: SizeConfig.widthMultiplier * 4.861111111111111),
        child: ClipOval(
            child: CachedNetworkImage(
          imageUrl: model.buyerProfileURL != null
              ? model.buyerProfileURL
              : 'https://www.dovercourt.org/wp-content/uploads/2019/11/610-6104451_image-placeholder-png-user-profile-placeholder-image-png.jpg',
          placeholder: (context, url) =>
              Lottie.asset('assets/loader/image_loading.json'),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.fill,
        )));
  }

  Widget _feedbackTexts(Results model) {
    _rating = double.parse(model.buyerRating.toString());
    return Expanded(
      child: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isBuyer)
            Row(
              children: [
                Text(
                  _l10n.to,
                  style: GoogleFonts.inter(
                    color: AppColors.catTextColor,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                  ),
                  // ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 0.48611111111111105),
                  child: Text(
                    '${model.buyerDisplayName}',
                    style: GoogleFonts.inter(
                      color: AppColors.catTextColor,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
          if (!_isBuyer)
            Text(
              '${model.buyerDisplayName}',
              style: GoogleFonts.inter(
                color: AppColors.catTextColor,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
              ),
            ),
          Padding(
            padding: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 0.37661406025824967),
            child: Text(
              '${model.buyerComment}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: AppColors.catTextColor,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 0.5021520803443329),
            child: RatingBar(
              itemSize: 16,
              glow: false,
              initialRating: _rating,
              itemCount: 5,
              allowHalfRating: true,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return Image.asset(
                      'assets/images/feedback_star.png',
                      width: SizeConfig.widthMultiplier * 3.8888888888888884,
                      height: SizeConfig.heightMultiplier * 2.0086083213773316,
                    );
                  case 1:
                    return Image.asset(
                      'assets/images/feedback_star.png',
                      width: SizeConfig.widthMultiplier * 3.8888888888888884,
                      height: SizeConfig.heightMultiplier * 2.0086083213773316,
                    );
                  case 2:
                    return Image.asset(
                      'assets/images/feedback_star.png',
                      width: SizeConfig.widthMultiplier * 3.8888888888888884,
                      height: SizeConfig.heightMultiplier * 2.0086083213773316,
                    );
                  case 3:
                    return Image.asset(
                      'assets/images/feedback_star.png',
                      width: SizeConfig.widthMultiplier * 3.8888888888888884,
                      height: SizeConfig.heightMultiplier * 2.0086083213773316,
                    );
                  default:
                    return Image.asset(
                      'assets/images/feedback_star.png',
                      width: SizeConfig.widthMultiplier * 3.8888888888888884,
                      height: SizeConfig.heightMultiplier * 2.0086083213773316,
                    );
                }
              },
              // onRatingUpdate: (rating) {
              //   setState(() {
              //     // _rating = rating;
              //   });
              //   // print(rating);
              // },
            ),
          )
        ],
      )),
    );
  }

  Widget _recentlyFeedbackBuyerCard(BuyerFeedback model) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: SizeConfig.heightMultiplier * 10.419655667144907,
      margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          top: SizeConfig.heightMultiplier * 2.0086083213773316),
      child: Container(
        child: Row(
          children: [
            _feedbackBuyerImage(model),
            _feedbackBuyerTexts(model),
          ],
        ),
      ),
    );
  }

  Widget _feedbackBuyerImage(BuyerFeedback model) {
    return Container(
        width: SizeConfig.widthMultiplier * 16.28472222222222,
        height: SizeConfig.heightMultiplier * 8.411047345767576,
        margin: EdgeInsets.only(
            right: SizeConfig.widthMultiplier * 4.861111111111111),
        child: ClipOval(
            child: CachedNetworkImage(
          imageUrl: model.sellerProfileURL != null
              ? model.sellerProfileURL
              : 'https://www.dovercourt.org/wp-content/uploads/2019/11/610-6104451_image-placeholder-png-user-profile-placeholder-image-png.jpg',
          placeholder: (context, url) =>
              Lottie.asset('assets/loader/image_loading.json'),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.fill,
        )));
  }

  Widget _feedbackBuyerTexts(BuyerFeedback model) {
    _rating = double.parse(model.sellerRating.toString());
    return Expanded(
      child: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isBuyer)
            Row(
              children: [
                Text(
                  _l10n.to,
                  style: GoogleFonts.inter(
                    color: AppColors.catTextColor,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                  ),
                  // ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 0.48611111111111105),
                  child: Text(
                    '${model.sellerDisplayName}',
                    style: GoogleFonts.inter(
                      color: AppColors.catTextColor,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
          Padding(
            padding: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 0.37661406025824967),
            child: Text(
              '${model.sellerComment}',
              style: GoogleFonts.inter(
                color: AppColors.catTextColor,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 0.5021520803443329),
            child: RatingBar(
              itemSize: 16,
              glow: false,
              initialRating: _rating,
              itemCount: 5,
              allowHalfRating: true,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return Image.asset(
                      'assets/images/feedback_star.png',
                      width: SizeConfig.widthMultiplier * 3.8888888888888884,
                      height: SizeConfig.heightMultiplier * 2.0086083213773316,
                    );
                  case 1:
                    return Image.asset(
                      'assets/images/feedback_star.png',
                      width: SizeConfig.widthMultiplier * 3.8888888888888884,
                      height: SizeConfig.heightMultiplier * 2.0086083213773316,
                    );
                  case 2:
                    return Image.asset(
                      'assets/images/feedback_star.png',
                      width: SizeConfig.widthMultiplier * 3.8888888888888884,
                      height: SizeConfig.heightMultiplier * 2.0086083213773316,
                    );
                  case 3:
                    return Image.asset(
                      'assets/images/feedback_star.png',
                      width: SizeConfig.widthMultiplier * 3.8888888888888884,
                      height: SizeConfig.heightMultiplier * 2.0086083213773316,
                    );
                  default:
                    return Image.asset(
                      'assets/images/feedback_star.png',
                      width: SizeConfig.widthMultiplier * 3.8888888888888884,
                      height: SizeConfig.heightMultiplier * 2.0086083213773316,
                    );
                }
              },
              // onRatingUpdate: (rating) {
              //   setState(() {
              //     // _rating = rating;
              //   });
              //   // print(rating);
              // },
            ),
          )
        ],
      )),
    );
  }

  Widget _helpCenter() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 3.389526542324247),
            child: Text(
              _l10n.needHelp,
              style: GoogleFonts.inter(
                color: AppColors.black,
                fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.15,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<RouteServiceProvider>().type =
                  NotificationType.order;
              RouterService.appRouter.navigateTo(NotificationRoute.buildPath());
            },
            child: Container(
                height: SizeConfig.heightMultiplier * 6.276901004304161,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884,
                    right: SizeConfig.widthMultiplier * 3.8888888888888884,
                    top: SizeConfig.heightMultiplier * 2.6362984218077474,
                    bottom: SizeConfig.heightMultiplier * 5.649210903873745),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.appBlue),
                ),
                child: Center(
                  child: Text(
                    _l10n.visit,
                    style: GoogleFonts.inter(
                      color: AppColors.appBlue,
                      fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }

  Widget _activeProducts() {
    // print(
    //     'activeproduct list defined: ${_ProfileBloc.activeProductList == null}');
    // // print(
    //     'active product list empty: ${_ProfileBloc.activeProductList.isEmpty}');
    return Container(
        // height: SizeConfig.heightMultiplier * 31.384505021520805,
        // width: SizeConfig.widthMultiplier * 36.45833333333333,
        child: Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3.8888888888888884,
                  top: SizeConfig.heightMultiplier * 4.142754662840746),
              child: Text(
                _l10n.activeProducts,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                  color: AppColors.app_txt_color,
                ),
              ),
            ),
            Spacer(),
            if (_ProfileBloc?.activeProductList != null &&
                !_ProfileBloc?.activeProductList.isEmpty)
              GestureDetector(
                onTap: () {
                  RouterService.profileRouter
                      .navigateTo(ActiveProductRoute.buildPath());
                },
                child: Container(
                  height: SizeConfig.heightMultiplier * 2.5107604017216643,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      right: SizeConfig.widthMultiplier * 3.645833333333333,
                      top: SizeConfig.heightMultiplier * 4.017216642754663),
                  padding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 1.9444444444444442,
                      right: SizeConfig.widthMultiplier * 1.9444444444444442,
                      top: SizeConfig.heightMultiplier * 0.25107604017216645,
                      bottom:
                          SizeConfig.heightMultiplier * 0.25107604017216645),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.seeAllText,
                          width:
                              SizeConfig.widthMultiplier * 0.24305555555555552),
                      color: AppColors.seeAllBack),
                  child: Text(
                    _l10n.seeAll,
                    style: TextStyle(
                      color: AppColors.seeAllText,
                      fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (_isLoading)
          Container(
              height: SizeConfig.heightMultiplier * 25.107604017216644,
              child: ListView(
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      height: SizeConfig.heightMultiplier * 24.60545193687231,
                      width: SizeConfig.widthMultiplier * 30.138888888888886,
                      margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 2.4305555555555554,
                        right: SizeConfig.widthMultiplier * 2.4305555555555554,
                      ),
                      child: Lottie.asset('assets/loader/loading_card.json'),
                    ),
                    Container(
                      height: SizeConfig.heightMultiplier * 24.60545193687231,
                      width: SizeConfig.widthMultiplier * 30.138888888888886,
                      margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 2.4305555555555554,
                        right: SizeConfig.widthMultiplier * 2.4305555555555554,
                      ),
                      child: Lottie.asset('assets/loader/loading_card.json'),
                    ),
                    Container(
                      height: SizeConfig.heightMultiplier * 24.60545193687231,
                      width: SizeConfig.widthMultiplier * 30.138888888888886,
                      margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 2.4305555555555554,
                        right: SizeConfig.widthMultiplier * 2.4305555555555554,
                      ),
                      child: Lottie.asset('assets/loader/loading_card.json'),
                    ),
                    Container(
                      height: SizeConfig.heightMultiplier * 24.60545193687231,
                      width: SizeConfig.widthMultiplier * 30.138888888888886,
                      margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 2.4305555555555554,
                        right: SizeConfig.widthMultiplier * 2.4305555555555554,
                      ),
                      child: Lottie.asset('assets/loader/loading_card.json'),
                    ),
                  ])),
        if (!_isLoading)
          Container(
            height: SizeConfig.heightMultiplier * 25.107604017216644,
            child: _ProfileBloc?.activeProductList == null ||
                    _ProfileBloc?.activeProductList.isEmpty
                ? Container(
                    child: Wrap(children: [
                      Column(
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/cart(1).png',
                                  fit: BoxFit.contain,
                                  height: SizeConfig.heightMultiplier *
                                      18.830703012912483,
                                  width: SizeConfig.widthMultiplier *
                                      24.305555555555554,
                                ),
                                Text(
                                  "Hey there, you don't have any active items",
                                  style: GoogleFonts.inter(
                                    fontSize: SizeConfig.textMultiplier *
                                        1.757532281205165,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.25,
                                    color: AppColors.unselected_tab,
                                  ),
                                ),
                                Text(
                                  "Let's change that, hit the '+' button",
                                  style: GoogleFonts.inter(
                                    fontSize: SizeConfig.textMultiplier *
                                        1.757532281205165,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.25,
                                    color: AppColors.unselected_tab,
                                  ),
                                ),
                                Text(
                                  "to list your very first item!",
                                  style: GoogleFonts.inter(
                                    fontSize: SizeConfig.textMultiplier *
                                        1.757532281205165,
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
                    ]),
                  )
                : Container(
                    alignment: Alignment.topLeft,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        if (index > _ProfileBloc.activeProductList.length - 1) {
                          return Container();
                        } else {
                          return _activeProductCard(
                              _ProfileBloc?.activeProductList[index]);
                        }
                      },
                    ),
                  ),
          ),
        // StreamBuilder(
        //   stream: _ProfileBloc.activeProductStream,
        //   builder: (context, stream) {
        //     if (stream.connectionState == ConnectionState.done) {}
        //
        //     if (stream.hasData) {
        //       return Container(
        //         height: SizeConfig.heightMultiplier * 25.107604017216644,
        //         child: ListView.builder(
        //           physics: BouncingScrollPhysics(),
        //           shrinkWrap: true,
        //           scrollDirection: Axis.horizontal,
        //           itemCount: 5,
        //           itemBuilder: (context, index) {
        //             return _activeProductCard(stream.data[index]);
        //           },
        //         ),
        //       );
        //     } else {
        //       return Container(
        //         child: Lottie.asset('assets/loader/list_loader.json'),
        //       );
        //     }
        //   },
        // ),
        //
      ],
    ));
  }

  Widget _activeProductCard(ActiveProducts model) {
    return GestureDetector(
      onTap: () {
        ProductLandingRoute.productNum = model.productNum;
        ProductLandingRoute.productName = model.title;
        RouterService.appRouter.navigateTo(ProductLandingRoute.buildPath());
      },
      child: Container(
        height: SizeConfig.heightMultiplier * 24.60545193687231,
        width: SizeConfig.widthMultiplier * 30.138888888888886,
        margin: EdgeInsets.only(
          left: SizeConfig.widthMultiplier * 2.4305555555555554,
          right: SizeConfig.widthMultiplier * 2.4305555555555554,
        ),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Stack(
            children: [
              Container(
                  // margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 0.6276901004304161),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: AppColors.toolbarBlue,
                  ),
                  child: CachedNetworkImage(
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
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: AppColors.toolbarBlue,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.fill)),
                    ),
                    height: SizeConfig.heightMultiplier * 14.181492109038738,
                  )),
              Positioned(
                top: SizeConfig.heightMultiplier * 15.185796269727405,
                left: SizeConfig.widthMultiplier * 2.4305555555555554,
                right: SizeConfig.widthMultiplier * 2.1874999999999996,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        model.title.length < 10
                            ? model.title
                            : model.title.substring(0, 10),
                        style: GoogleFonts.inter(
                            fontSize:
                                SizeConfig.textMultiplier * 2.0086083213773316,
                            color: AppColors.app_txt_color,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.15)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text('\$${model?.fiatPrice}',
                          maxLines: 1,
                          style: GoogleFonts.inter(
                              fontSize: SizeConfig.textMultiplier *
                                  2.0086083213773316,
                              color: AppColors.app_txt_color,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.15)),
                    ),
                    // Row(
                    //   children: [
                    //     Icon(
                    //       CryptoFontIcons.BTC,
                    //       size: 14,
                    //     ),
                    //     Text(model?.destAmount,
                    //         maxLines: 1,
                    //         style: GoogleFonts.inter(
                    //             fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    //             color: AppColors.app_txt_color,
                    //             fontWeight: FontWeight.w700,
                    //             letterSpacing: 0.1)),
                    //   ],
                    // ),
                    // Text(model?.description ?? "",
                    //     maxLines: 1,
                    //     overflow: TextOverflow.ellipsis,
                    //     style: GoogleFonts.inter(
                    //         fontSize:
                    //             SizeConfig.textMultiplier * 1.5064562410329987,
                    //         color: AppColors.app_txt_color,
                    //         fontWeight: FontWeight.w400,
                    //         letterSpacing: 0.4)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _overallRating(ProfileModel model) {
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 4.131944444444444,
                  top: SizeConfig.heightMultiplier * 4.017216642754663),
              child: Text(
                _l10n.overAllRating,
                style: GoogleFonts.inter(
                    color: AppColors.app_txt_color,
                    fontSize: SizeConfig.textMultiplier * 2.259684361549498,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15),
              ),
            ),
            Spacer(),
            Container(
                margin: EdgeInsets.only(
                    right: SizeConfig.widthMultiplier * 3.645833333333333,
                    top: SizeConfig.heightMultiplier * 4.017216642754663),
                child: RatingBar(
                  itemSize: 24,
                  glow: false,
                  allowHalfRating: true,
                  initialRating: model?.currentRating ?? 0,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Image.asset(
                          'assets/images/feedback_star.png',
                          width:
                              SizeConfig.widthMultiplier * 3.8888888888888884,
                          height:
                              SizeConfig.heightMultiplier * 2.0086083213773316,
                        );
                      case 1:
                        return Image.asset(
                          'assets/images/feedback_star.png',
                          width:
                              SizeConfig.widthMultiplier * 3.8888888888888884,
                          height:
                              SizeConfig.heightMultiplier * 2.0086083213773316,
                        );
                      case 2:
                        return Image.asset(
                          'assets/images/feedback_star.png',
                          width:
                              SizeConfig.widthMultiplier * 3.8888888888888884,
                          height:
                              SizeConfig.heightMultiplier * 2.0086083213773316,
                        );
                      case 3:
                        return Image.asset(
                          'assets/images/feedback_star.png',
                          width:
                              SizeConfig.widthMultiplier * 3.8888888888888884,
                          height:
                              SizeConfig.heightMultiplier * 2.0086083213773316,
                        );
                      default:
                        return Image.asset(
                          'assets/images/feedback_star.png',
                          width:
                              SizeConfig.widthMultiplier * 3.8888888888888884,
                          height:
                              SizeConfig.heightMultiplier * 2.0086083213773316,
                        );
                    }
                  },
                  // onRatingUpdate: (rating) {
                  //   setState(() {
                  //     // _rating = rating;
                  //   });
                  //   // print(rating);
                  // },
                )),
          ],
        ),
        // Spacer(),
        Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 0.12553802008608322,
                left: SizeConfig.widthMultiplier * 48.61111111111111),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                '${model?.currentRating ?? 0}/5 ${_l10n.outOf} ${model?.numRaters ?? 0} ${_l10n.reviews}.',
                style: TextStyle(
                  color: AppColors.catTextColor,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                ),
              ),
            )),
      ],
    ));
  }

  _showSnackBar(String snackText) {
    final snackBar = SnackBar(
      content: Text(snackText),
    );
    _globalKey.currentState.showSnackBar(snackBar);
  }

  Widget _tags(String tag) {
    Color color;
    if (tag.length <= 3) {
      color = AppColors.tag_short;
    } else if (tag.length > 3 && tag.length <= 6) {
      color = AppColors.tag_normal;
    } else if (tag.length > 6 && tag.length <= 8) {
      color = AppColors.tag_medium;
    } else if (tag.length >= 8) {
      color = AppColors.tag_longest;
    }
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 1.0043041606886658,
          left: SizeConfig.widthMultiplier * 0.9722222222222221),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
      child: Center(
        child: Text(
          tag,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: SizeConfig.textMultiplier * 1.2553802008608321,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }

  Future<String> _getName() async {
    String name = await _authRepository.getName();
    setState(() {
      _userName = name;
    });
    return _userName;
  }
}
