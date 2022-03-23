import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/sell_new_products/product_variation/edit_variator/add_additional_variator/add_additional_variator_l10n.dart';
import 'package:market_space/sell_new_products/product_variation/edit_variator/add_additional_variator/add_additional_vatiator_bloc.dart';

class AddAdditionalScreen extends StatefulWidget {
  @override
  _AddAdditionalScreenState createState() => _AddAdditionalScreenState();
}

class _AddAdditionalScreenState extends State<AddAdditionalScreen> {
  final AddAdditionalVatiatorBloc _addAdditionalVatiatorBloc =
      AddAdditionalVatiatorBloc(Initial());
  bool _isLoading = false;
  AddAdditionalVariatorL10n _l10n = AddAdditionalVariatorL10n(
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
  List<String> _discountDropItems = [
    "Variator *",
    "Color/size%",
    "Product brand"
  ];
  String _selectedItem;
  List<DropdownMenuItem<String>> _discountMenuItems;

  @override
  void initState() {
    _discountMenuItems = buildDropDownMenuItems(_discountDropItems);
    _selectedItem = _discountMenuItems[0].value;
    setState(() {
      if (Constants.language == null || Constants.language == "English") {
        _l10n = AddAdditionalVariatorL10n(
            Locale.fromSubtags(languageCode: 'en', countryCode: 'US'));
      } else {
        _l10n =
            AddAdditionalVariatorL10n(Locale.fromSubtags(languageCode: 'zh'));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomSheet: _bottomButton(),
      backgroundColor: AppColors.toolbarBlue,
      appBar: Toolbar(
        title: 'MARKETSPAACE',
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.white,
        child: BlocProvider(
          create: (_) => _addAdditionalVatiatorBloc,
          child: BlocListener<AddAdditionalVatiatorBloc,
                  AddAdditionalVatiatorState>(
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
                children: [_variationScreen()],
              )),
        ),
      ),
    );
  }

  Widget _bottomButton() {
    return Container(
      height: 48,
      margin: EdgeInsets.only(top: 31.0, right: 16, left: 16, bottom: 40),
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
                  fontSize: 14,
                  letterSpacing: 0.5,
                  textStyle: TextStyle(fontFamily: 'Roboto')),
            )),
        onPressed: () {
          setState(() {});
        },
      ),
    );
  }

  Widget _variationScreen() {
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        margin: EdgeInsets.only(left: 16, bottom: 8, top: 16),
        child: Text(_l10n.Addnewvariation,
            maxLines: 2,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 0.15,
                color: AppColors.app_txt_color)),
      ),
      Container(
        margin: EdgeInsets.only(top: 16, left: 16, right: 16),
        height: 48,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: AppColors.text_field_container)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
              value: _selectedItem,
              items: _discountMenuItems,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.text_field_container,
              ),
              onChanged: (value) {
                setState(() {
                  _selectedItem = value;
                });
              }),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Theme(
          data: ThemeData(
            primaryColor: AppColors.appBlue,
            primaryColorDark: AppColors.appBlue,
          ),
          child: TextField(
            textAlign: TextAlign.start,
            style: GoogleFonts.inter(
              color: AppColors.text_field_color,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              letterSpacing: 0.25,
            ),
            decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide:
                        new BorderSide(color: AppColors.text_field_color),
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: '${_l10n.Variation} (e.g Black/M)',
                labelText: '${_l10n.Variation}',
                contentPadding: EdgeInsets.only(left: 16, top: 10),
                suffixStyle: const TextStyle(color: AppColors.appBlue)),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Theme(
          data: ThemeData(
            primaryColor: AppColors.appBlue,
            primaryColorDark: AppColors.appBlue,
          ),
          child: TextField(
            textAlign: TextAlign.start,
            style: GoogleFonts.inter(
              color: AppColors.text_field_color,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              letterSpacing: 0.25,
            ),
            decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide:
                        new BorderSide(color: AppColors.text_field_color),
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: '${_l10n.Quantity} (e.g 10)',
                labelText: '${_l10n.Quantity}',
                contentPadding: EdgeInsets.only(left: 16, top: 10),
                suffixStyle: const TextStyle(color: AppColors.appBlue)),
          ),
        ),
      ),
      GestureDetector(
          onTap: () {
            // RouterService.appRouter.navigateTo(AddNewVariationRoute.buildPath());
          },
          child: Container(
              margin: EdgeInsets.only(top: 16, left: 16, right: 16),
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.text_field_container)),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    margin: EdgeInsets.only(top: 10, left: 15, bottom: 10),
                    child: Icon(
                      Icons.add,
                      color: AppColors.text_field_container,
                      size: 20,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 12, left: 11, bottom: 12),
                      child: Text(
                        _l10n.AddAdditionalVariationforVariator,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.text_field_container,
                            letterSpacing: 0.25,
                            textStyle: TextStyle(fontFamily: 'Roboto')),
                      )),
                ],
              ))),
      Container(
          margin: EdgeInsets.only(top: 16, left: 16, bottom: 12),
          child: Text(
            _l10n.Othervariatorsvariator,
            style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.text_field_color,
                letterSpacing: 0.25,
                textStyle: TextStyle(fontFamily: 'Roboto')),
          )),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _otherVariator(),
        ],
      )
    ]));
  }

  Widget _otherVariator() {
    return Container(
      child: Container(
        margin: EdgeInsets.only(left: 16.0, right: 16, top: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.appBlue)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 12, top: 8),
                    child: Text('Color/Size',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.grey_700)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 12, bottom: 8, top: 5),
                    child: Text('White/S/4',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.text_field_container)),
                  ),
                ],
              ),
            ],
          ),
        ]),
      ),
    );
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(
            listItem,
            style: TextStyle(color: AppColors.text_field_container),
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }
}
