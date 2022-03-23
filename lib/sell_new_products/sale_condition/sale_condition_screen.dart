import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/common/selling_item.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/sell_new_products/sale_condition/sale_condition_bloc.dart';
import 'package:market_space/sell_new_products/sale_condition/sale_condition_l10n.dart';
import 'package:market_space/sell_new_products/sale_condition/sale_condition_route.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class SaleConditionScreen extends StatefulWidget {
  @override
  _SaleConditionScreenState createState() => _SaleConditionScreenState();
}

class _SaleConditionScreenState extends State<SaleConditionScreen> {
  final SaleConditionBloc _saleConditionBloc = SaleConditionBloc(Initial());
  bool _isLoading = false;
  SaleConditionL10n _l10n = SaleConditionL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));

  TextEditingController _conditionController = TextEditingController(),
      _quantityController = TextEditingController();

  FocusNode _conditionFocusNode = FocusNode(), _quantityFocusNode = FocusNode();

  final Color background = AppColors.toolbarBlue;
  final Color fill = AppColors.lightgrey;

  @override
  void initState() {
    if (SaleConditionRoute.saleCondition != null) {
      _conditionController.text = SaleConditionRoute.saleCondition;
    }
    // print("WQQQQ ${SaleConditionRoute.quantity}");
    if (SaleConditionRoute.quantity != null) {
      _quantityController.text = SaleConditionRoute.quantity.toString();
    }

    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = SaleConditionL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n = SaleConditionL10n(Locale.fromSubtags(languageCode: 'zh'));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _conditionController?.dispose();
    _quantityController?.dispose();

    _conditionFocusNode?.dispose();
    _quantityFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        bottomSheet: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: _bottomButton()),
        backgroundColor: Colors.transparent,
        appBar: Toolbar(title: 'Sell item'),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.white,
          child: BlocProvider(
            create: (_) => _saleConditionBloc,
            child: BlocListener<SaleConditionBloc, SaleConditionState>(
                listener: (context, state) {
                  if (state is Loading) {
                    setState(() {
                      _isLoading = true;
                    });
                  }
                  if (state is Loaded) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                child: ListView(
                  shrinkWrap: true,
                  children: [_saleConditionWidget()],
                )),
          ),
        ),
      ),
    );
  }

  Widget _bottomButton() {
    return Container(
      height: SizeConfig.heightMultiplier * 6.025824964131995,
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 3.89167862266858,
          right: SizeConfig.widthMultiplier * 3.8888888888888884,
          left: SizeConfig.widthMultiplier * 3.8888888888888884,
          bottom: SizeConfig.heightMultiplier * 5.0215208034433285),
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
                _l10n.CONFIRM,
                style: GoogleFonts.inter(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    letterSpacing: 0.5,
                    textStyle: TextStyle(fontFamily: 'Roboto')),
              )),
          onPressed: _handleFormSubmission),
    );
  }

  Widget _saleConditionWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                bottom: SizeConfig.heightMultiplier * 1.0043041606886658,
                top: SizeConfig.heightMultiplier * 2.0086083213773316),
            child: Text('${_l10n.Sale} ${_l10n.condition}',
                maxLines: 2,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                    letterSpacing: 0.15,
                    textStyle: GoogleFonts.inter(
                        fontSize:
                            SizeConfig.textMultiplier * 2.0086083213773316,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4),
                    color: AppColors.app_txt_color)),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 2.0086083213773316,
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884),
            child: Theme(
              data: ThemeData(
                primaryColor: AppColors.appBlue,
                primaryColorDark: AppColors.appBlue,
              ),
              child: TextField(
                controller: _conditionController,
                textAlign: TextAlign.start,
                maxLines: 6,
                minLines: 4,
                style: GoogleFonts.inter(
                  color: AppColors.text_field_color,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.25,
                ),
                focusNode: _conditionFocusNode,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  _conditionFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(_quantityFocusNode);
                },
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide:
                            new BorderSide(color: AppColors.text_field_color),
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText: '${_l10n.Sale} ${_l10n.condition}',
                    labelText: '${_l10n.Sale} ${_l10n.condition}',
                    contentPadding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                        top: SizeConfig.heightMultiplier * 1.2553802008608321),
                    suffixStyle: const TextStyle(color: AppColors.appBlue)),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 2.0086083213773316,
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884),
            child: Theme(
              data: ThemeData(
                primaryColor: AppColors.appBlue,
                primaryColorDark: AppColors.appBlue,
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.start,
                controller: _quantityController,
                style: GoogleFonts.inter(
                  color: AppColors.text_field_color,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.25,
                ),
                textInputAction: TextInputAction.done,
                focusNode: _quantityFocusNode,
                onSubmitted: (_) => _handleFormSubmission(),
                onChanged: (String val) {
                  int number = int.parse(val);
                  if (number == 0)
                    _quantityController.text = "";
                  else if (number > 100) _quantityController.text = "100";
                },
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide:
                            new BorderSide(color: AppColors.text_field_color),
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText: '${_l10n.Quantity}',
                    labelText: '${_l10n.Quantity}',
                    contentPadding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                        top: SizeConfig.heightMultiplier * 1.2553802008608321),
                    suffixStyle: const TextStyle(color: AppColors.appBlue)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _handleFormSubmission() {
    if (_conditionController.text.length == 0 ||
        _quantityController.text.length == 0) {
      _showToast("${_l10n.pleseEnter} ${_l10n.condition} or quantity");
    } else {
      if (_conditionController.text.length > 0) {
        SaleConditionRoute.saleCondition = _conditionController.text;
      }
      if (_quantityController.text.length > 0) {
        SaleConditionRoute.quantity = int.parse(_quantityController.text);
      }
      _showToast("${_l10n.Sale} ${_l10n.condition} ${_l10n.confirmed} ");
      Navigator.pop(context);
    }
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
