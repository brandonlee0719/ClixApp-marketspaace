import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/raised_gradient_button.dart';
import 'package:market_space/common/selling_item.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/sell_new_products/tags/tags_bloc.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class TagsScreen extends StatefulWidget {
  @override
  _TagsScreenState createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  final TagsBloc _tagsBloc = TagsBloc(Initial());
  bool _isLoading = false;
  String _shippingSelected;
  TextEditingController _lenghtController = TextEditingController();
  List<String> _tagList = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // bottomSheet: _bottomButton(),
      backgroundColor: AppColors.toolbarBlue,
      appBar: Toolbar(
        title: 'MARKETSPAACE',
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.white,
        child: BlocProvider(
          create: (_) => _tagsBloc,
          child: BlocListener<TagsBloc, TagsState>(
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
                children: [_baseScreen()],
              )),
        ),
      ),
    );
  }

  Widget _baseScreen() {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884,
                top: SizeConfig.heightMultiplier * 2.0086083213773316),
            child: Theme(
              data: ThemeData(
                primaryColor: AppColors.appBlue,
                primaryColorDark: AppColors.appBlue,
              ),
              child: TextField(
                textAlign: TextAlign.start,
                controller: _lenghtController,
                maxLength: 20,
                // enabled: _freeShipping,
                style: GoogleFonts.inter(
                  color: AppColors.text_field_color,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.25,
                ),
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide:
                            new BorderSide(color: AppColors.text_field_color),
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText: 'Enter tag',
                    contentPadding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 3.8888888888888884,
                        top: SizeConfig.heightMultiplier * 1.2553802008608321),
                    suffixStyle: const TextStyle(color: AppColors.appBlue)),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: SizeConfig.heightMultiplier * 6.025824964131995,
            margin: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 2.5107604017216643,
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884,
                bottom: SizeConfig.heightMultiplier * 2.0086083213773316),
            child: RaisedGradientButton(
              gradient: LinearGradient(
                colors: <Color>[
                  AppColors.nextButtonPrimary,
                  AppColors.nextButtonSecondary,
                ],
              ),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: Text(
                    'Save tags',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                        letterSpacing: 0.5,
                        color: AppColors.white),
                  )),
              onPressed: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  _tagList.add(_lenghtController.text);
                  _lenghtController.text = "";
                });
              },
            ),
          ),
          if (_tagList.isNotEmpty)
            Container(
                height: MediaQuery.of(context).size.height * 0.45,
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AppColors.text_field_container)),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children: _tagList.map((e) => _tags(e)).toList(),
                )),
        ],
      ),
    );
  }

  Widget _tags(String tag) {
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 0.6276901004304161,
          left: SizeConfig.widthMultiplier * 2.4305555555555554,
          right: SizeConfig.widthMultiplier * 2.4305555555555554,
          bottom: SizeConfig.heightMultiplier * 0.6276901004304161),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.tag_longest),
      child: Center(
        child: Container(
          height: SizeConfig.heightMultiplier * 2.5107604017216643,
          child: Text(
            tag,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: SizeConfig.textMultiplier * 1.757532281205165,
              letterSpacing: 0.4,
            ),
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
              'CONFIRM',
              style: GoogleFonts.inter(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  letterSpacing: 0.5,
                  textStyle: TextStyle(fontFamily: 'Roboto')),
            )),
        onPressed: () {
          SellingItems.tagList.addAll(_tagList);
          Navigator.pop(context);
        },
      ),
    );
  }
}
