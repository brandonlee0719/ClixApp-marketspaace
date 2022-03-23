import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';
import 'package:market_space/profile_settings/model/debit_card_model.dart';
import 'package:market_space/responsive_layout/size_config.dart';

import 'package:market_space/profile_settings/add_new_address/add_new_address_bloc.dart';

import '../profile_setting_route.dart';
import 'add_new_address_l10n.dart';

class AddNewAddressScreen extends StatefulWidget {
  final bool isBilling;

  AddNewAddressScreen({this.isBilling});

  @override
  _AddNewAddressScreenState createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final AddNewAddressBloc _addNewAddressBloc = AddNewAddressBloc(Initial());
  AddNewAddressL10n _l10n = AddNewAddressL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  bool _isLoading = false;
  bool _phoneValidate = false;
  bool _fNameValidate = false;
  bool _lNameValidate = false;
  bool _addressValidate = false;
  bool _countryValidate = false, _cityValidate = false;
  bool _stateValidate = false;
  bool _zipValidate = false;
  bool _suburbValidate = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _suburbController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _toolbarText;
  UpdateAddressModel updateAddressModel;

  static final Color background = AppColors.toolbarBlue;
  static final Color fill = AppColors.lightgrey;

  @override
  void initState() {
    _addNewAddressBloc.add(AddNewAddressScreenEvent());
    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = AddNewAddressL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n = AddNewAddressL10n(Locale.fromSubtags(languageCode: 'zh'));
      }
      _toolbarText = _l10n.addNewAddress;
    });
    if (ProfileSettingRoute.updateAddressModel != null) {
      updateAddressModel = ProfileSettingRoute.updateAddressModel;
      setState(() {
        _toolbarText = '${_l10n.edit} ${_l10n.address.toUpperCase()}';
        _phoneController.text = updateAddressModel.phoneNumber;
        _addressController.text = updateAddressModel.streetAddress;
        _apartmentController.text = updateAddressModel.streetAddressTwo;
        _stateController.text = updateAddressModel.state;
        _countryController.text = updateAddressModel.country;
        _zipController.text = updateAddressModel.postcode == null
            ? ""
            : updateAddressModel.postcode.toString();
        _fNameController.text = updateAddressModel.firstName;
        _lNameController.text = updateAddressModel.lastName;
        _suburbController.text = updateAddressModel.suburb;
      });
    }
    super.initState();
  }

  static final List<Color> gradient = [
    background,
    background,
    fill,
    fill,
  ];

  static final double fillPercent =
      39.7; // fills 56.23% for container from bottom
  static final double fillStop = (100 - fillPercent) / 100;
  final List<double> stops = [0.0, fillStop, fillStop, 1.0];

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom * 0.9;

    return AbsorbPointer(
      absorbing: _addNewAddressBloc.state is Loading,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: gradient,
                stops: stops)),
        child: Scaffold(
          appBar: Toolbar(
            title: 'Add new address',
          ),
          backgroundColor: Colors.transparent,
          bottomSheet: BlocProvider<AddNewAddressBloc>.value(
              value: _addNewAddressBloc, child: _bottomButton()),
          // key: _globalKey,
          // bottomNavigationBar: _bottomButtons(),
          resizeToAvoidBottomInset: false,
          // resizeToAvoidBottomPadding: false,
          body: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottom),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: AppColors.white,
                child: BlocProvider(
                  create: (_) => _addNewAddressBloc,
                  child: BlocListener<AddNewAddressBloc, AddNewAddressState>(
                      listener: (context, state) {
                        if (state is Loading) {
                          setState(() {
                            _isLoading = true;
                          });
                        }
                        if (state is Loaded) {
                          _isLoading = false;
                        }
                        if (state is AddNewAddressSuccessfully) {
                          Navigator.pop(context,
                              this._addNewAddressBloc.updateAddressModel);
                          _showToast("Address successfully updated");
                        }
                        if (state is AddNewAddressFailed) {
                          Navigator.pop(
                              context, DebitCardModel(cardNumber: "1234"));
                          _showToast("Address failed to update");
                        }
                      },
                      child: ListView(
                          shrinkWrap: true,
                          controller: _scrollController,
                          children: [_baseScreen()])),
                ),
              ),
            ),
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
            child: Stack(children: [
              // if (_isLoading)
              //   BackdropFilter(
              //       filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
              //       child: LoadingProgress(
              //         color: Colors.deepOrangeAccent,
              //       )),
              ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: [
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 12,
                    ),
                    _editEmail(),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 12,
                    )
                  ])
            ])));
  }

  Widget _editEmail() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: SizeConfig.heightMultiplier * 6.276901004304161,
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 2.5107604017216643),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.25,
              ),
              controller: _countryController,
              buildCounter: (BuildContext context,
                      {int currentLength, int maxLength, bool isFocused}) =>
                  null,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: AppColors.text_field_color),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: '${_l10n.country}*',
                  labelText: '${_l10n.country}*',
                  contentPadding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884),
                  errorText: _countryValidate ? 'Value Can\'t Be Empty' : null,
                  suffixStyle: const TextStyle(color: AppColors.appBlue)),
            ),
          ),
        ),
        Container(
          height: SizeConfig.heightMultiplier * 6.276901004304161,
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 1.5064562410329987),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.25,
              ),
              controller: _fNameController,
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide:
                        new BorderSide(color: AppColors.text_field_color),
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: '${_l10n.firstName}*',
                labelText: '${_l10n.firstName}*',
                contentPadding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884),
                suffixStyle: const TextStyle(color: AppColors.appBlue),
                errorText: _fNameValidate ? 'Value Can\'t Be Empty' : null,
              ),
            ),
          ),
        ),
        Container(
          height: SizeConfig.heightMultiplier * 6.276901004304161,
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 1.5064562410329987),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.25,
              ),
              controller: _lNameController,
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide:
                        new BorderSide(color: AppColors.text_field_color),
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: '${_l10n.lastName}*',
                labelText: '${_l10n.lastName}*',
                contentPadding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884),
                suffixStyle: const TextStyle(color: AppColors.appBlue),
                errorText: _lNameValidate ? 'Value Can\'t Be Empty' : null,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 1.5064562410329987),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              onTap: () => {_scrollController.jumpTo(0)},
              keyboardType: TextInputType.text,
              controller: _addressController,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: '${_l10n.address}*',
                labelText: '${_l10n.address}*',
                contentPadding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884),
                suffixStyle: GoogleFonts.inter(
                  color: AppColors.appBlue,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.25,
                ),
                errorText: _addressValidate ? 'Value Can\'t Be Empty' : null,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 1.5064562410329987),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _apartmentController,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: '${_l10n.line2}',
                  labelText: '${_l10n.line2}',
                  contentPadding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.8888888888888884),
                  suffixStyle: GoogleFonts.inter(
                    color: AppColors.appBlue,
                    fontWeight: FontWeight.w400,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    letterSpacing: 0.25,
                  )),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 1.5064562410329987),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _cityController,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: '${_l10n.city}*',
                labelText: '${_l10n.city}*',
                contentPadding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884),
                suffixStyle: GoogleFonts.inter(
                  color: AppColors.appBlue,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.25,
                ),
                errorText: _cityValidate ? 'Value Can\'t Be Empty' : null,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 1.5064562410329987),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _suburbController,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: '${_l10n.suburb}*',
                labelText: '${_l10n.suburb}*',
                contentPadding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884),
                suffixStyle: GoogleFonts.inter(
                  color: AppColors.appBlue,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.25,
                ),
                errorText: _suburbValidate ? 'Value Can\'t Be Empty' : null,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 1.5064562410329987),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _stateController,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: '${_l10n.state}*',
                labelText: '${_l10n.state}*',
                contentPadding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884),
                suffixStyle: GoogleFonts.inter(
                  color: AppColors.appBlue,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.25,
                ),
                errorText: _stateValidate ? 'Value Can\'t Be Empty' : null,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 1.5064562410329987),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              onTap: () {
                // print("hahahaha");
                // print(_scrollController.position);
                _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent);
              },
              keyboardType: TextInputType.phone,
              maxLength: 10,
              controller: _phoneController,
              buildCounter: (BuildContext context,
                      {int currentLength, int maxLength, bool isFocused}) =>
                  null,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: '${_l10n.pNumber}*',
                labelText: '${_l10n.pNumber}*',
                contentPadding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884),
                suffixStyle: GoogleFonts.inter(
                  color: AppColors.appBlue,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.25,
                ),
                errorText: _phoneValidate ? 'Value Can\'t Be Empty' : null,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 1.5064562410329987),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _zipController,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: '${_l10n.zipCode}*',
                labelText: '${_l10n.zipCode}*',
                contentPadding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 3.8888888888888884),
                suffixStyle: GoogleFonts.inter(
                  color: AppColors.appBlue,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.25,
                ),
                errorText: _zipValidate ? 'Value Can\'t Be Empty' : null,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: SizeConfig.heightMultiplier * 1.5064562410329987,
              left: SizeConfig.widthMultiplier * 3.645833333333333),
          child: Text(
            '${_l10n.shippingInst}',
            style: GoogleFonts.inter(
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
                color: AppColors.unselected_tab),
          ),
        ),
        Container(
          // height: SizeConfig.heightMultiplier * 11.047345767575324,
          margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.645833333333333,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
              top: SizeConfig.heightMultiplier * 1.5064562410329987),
          // padding: EdgeInsets.only(left: SizeConfig.widthMultiplier * 3.645833333333333, right: SizeConfig.widthMultiplier * 3.645833333333333, top: SizeConfig.heightMultiplier * 1.3809182209469155),
          child: Theme(
            data: ThemeData(
              primaryColor: AppColors.appBlue,
              primaryColorDark: AppColors.appBlue,
            ),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _usernameController,
              minLines: 4,
              maxLines: 5,
              style: GoogleFonts.inter(
                color: AppColors.text_field_color,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                letterSpacing: 0.25,
              ),
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: _l10n.doorText,
                  labelText: _l10n.doorText,
                  contentPadding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier * 3.645833333333333,
                      right: SizeConfig.widthMultiplier * 3.645833333333333,
                      top: SizeConfig.heightMultiplier * 3.1384505021520805),
                  suffixStyle: GoogleFonts.inter(
                    color: AppColors.appBlue,
                    fontWeight: FontWeight.w400,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    letterSpacing: 0.25,
                  )),
            ),
          ),
        ),
      ],
    ));
  }

  Widget _bottomButton() {
    return Container(
      height: SizeConfig.heightMultiplier * 6.025824964131995,
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 2.5107604017216643,
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          right: SizeConfig.widthMultiplier * 3.8888888888888884),
      child: RaisedGradientButton(
        gradient: LinearGradient(
          colors: <Color>[
            AppColors.gradient_button_light,
            AppColors.gradient_button_dark,
          ],
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          child: BlocBuilder<AddNewAddressBloc, AddNewAddressState>(
              builder: (context, state) {
            if (state is Loading) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                child: Align(
                    alignment: Alignment.center,
                    child: LoadingProgress(
                      color: Colors.white,
                    )),
              );
            }
            return Text(
              _l10n.confirmAdd,
              style: GoogleFonts.inter(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.5,
                  textStyle: TextStyle(fontFamily: 'Roboto')),
            );
          }),
        ),
        onPressed: () {
          setState(() {
            AddNewAddressState state = _addNewAddressBloc.state;
            if (state != Loading()) {
              _countryValidate = _countryController.text.isEmpty;

              if (_fNameController.text.isEmpty) {
                _fNameValidate = true;
              } else {
                _fNameValidate = false;
              }
              if (_lNameController.text.isEmpty) {
                _lNameValidate = true;
              } else {
                _lNameValidate = false;
              }
              if (_addressController.text.isEmpty) {
                _addressValidate = true;
              } else {
                _addressValidate = false;
              }
              if (_cityController.text.isEmpty) {
                _cityValidate = true;
              } else {
                _cityValidate = false;
              }
              if (_stateController.text.isEmpty) {
                _stateValidate = true;
              } else {
                _stateValidate = false;
              }

              if (_zipController.text.isEmpty) {
                _zipValidate = true;
              } else {
                _zipValidate = false;
              }
              if (_suburbController.text.isEmpty) {
                _suburbValidate = true;
              } else {
                _suburbValidate = false;
              }
              if (!_fNameValidate &&
                  !_lNameValidate &&
                  !_addressValidate &&
                  !_cityValidate &&
                  !_stateValidate &&
                  !_phoneValidate &&
                  !_zipValidate &&
                  !_suburbValidate &&
                  !_countryValidate) {
                UpdateAddressModel model = UpdateAddressModel();
                model.state = _stateController.text;
                model.streetAddress = _addressController.text;
                model.country = _countryController.text;
                model.postcode = _zipController.text;
                model.phoneNumber = _phoneController.text;
//                        // print('routed address num: ' + updateAddressModel.addressNum.toString());
                if (updateAddressModel != null) {
                  model.addressNum = updateAddressModel.addressNum;
                }
                model.instructions = _usernameController.text;
                model.suburb = _suburbController.text;
                if (_apartmentController.text.length > 0) {
                  model.streetAddressTwo =
                      _apartmentController.text + ' ${_cityController.text}';
                } else {
                  model.streetAddressTwo = _cityController.text;
                }
                model.firstName = _fNameController.text;
                model.lastName = _lNameController.text;

                _addNewAddressBloc.updateAddressModel = model;
                if (widget.isBilling == false) {
                  _addNewAddressBloc.add(AddNewAddressButtonEvent());
                } else if (widget.isBilling == true) {
                  _addNewAddressBloc.add(UploadingBillingAddress());
                } else {
                  _addNewAddressBloc.add(EditAddressButtonEvent());
                }
                FocusScope.of(context).unfocus();
                return "aaa";
              }
            }
          });
        },
      ),
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
