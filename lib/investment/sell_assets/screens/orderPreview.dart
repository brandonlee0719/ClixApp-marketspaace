import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/investment/sell_assets/assetProvider/sellAssetProvider.dart';
import 'package:market_space/investment/sell_assets/models/ConvertModel.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:provider/provider.dart';

class TradeCryptoModel{
  final double _exchangeRate;
  final double _purchaseAmount;
  final String reservationID;
  String srn;
  final double _total;
  final double _transactionFee;

  String get  exchangeRate => round(_exchangeRate);
  String get  purchaseAmount => round(_purchaseAmount);
  String get  total => round(_total);
  String get  transactionFee => round(_transactionFee);

  TradeCryptoModel(this._exchangeRate, this._purchaseAmount, this.reservationID, this.srn, this._total, this._transactionFee);
  TradeCryptoModel.fromSell(this._exchangeRate, this._purchaseAmount, this.reservationID, this._total, this._transactionFee);
  static TradeCryptoModel fromJson(Map<String, dynamic> map,{bool isSell = false}){
    if(isSell){
      return TradeCryptoModel.fromSell(
          double.parse(map["exchangeRate"].toString()),
          double.parse(map["sale"].toString()),
          map["id"],
          double.parse(map["totalPayout"].toString()),
          double.parse(map["wyreFees"].toString())
      );
    }
    return TradeCryptoModel(
      map["exchangeRate"],
        double.parse(map["purchaseAmount"].toString()),
        map["reservationID"],map["srn"],
        double.parse(map["total"].toString()),
        double.parse(map["wyreFees"].toString())
    );
  }



  Map<String, dynamic> getOrderJson(){
    return {

    "reservationID": this.reservationID,
    "srn": this.srn,
    "amount": this._purchaseAmount,

    "sourceCurrency": "AUD",

  };
  }
  String round(double number){
    return number.toStringAsFixed(2);
  }
}

class OderPreview extends StatefulWidget {

  final bool isSell;

  const OderPreview({Key key, this.isSell}) : super(key: key);
  @override
  _OderPreviewState createState() => _OderPreviewState();
}

class _OderPreviewState extends State<OderPreview> {
  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<TradeCryptoModel>(
      future: context.read<SelleAssetProvider>().tradeModel,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          TradeCryptoModel model = snapshot.data;
          return Container(
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 4.017216642754663),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          'Exchange rate',
                          style: GoogleFonts.inter(
                            color: AppColors.sub_text,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Text(
                          'A\$${model.exchangeRate}',
                          style: GoogleFonts.inter(
                            color: AppColors.text_field_container,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 4.017216642754663),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          'Payout method',
                          style: GoogleFonts.inter(
                            color: AppColors.sub_text,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Text(
                          widget.isSell?"Saving account":'Credit card',
                          style: GoogleFonts.inter(
                            color: AppColors.text_field_container,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 4.017216642754663),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          'Sale',
                          style: GoogleFonts.inter(
                            color: AppColors.sub_text,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Text(
                          'A\$${model.purchaseAmount}',
                          style: GoogleFonts.inter(
                            color: AppColors.text_field_container,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 4.017216642754663),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          'Transaction fee',
                          style: GoogleFonts.inter(
                            color: AppColors.sub_text,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Text(
                          'A\$${model.transactionFee}',
                          style: GoogleFonts.inter(
                            color: AppColors.text_field_container,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 4.017216642754663),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          'Total payout',
                          style: GoogleFonts.inter(
                            color: AppColors.app_txt_color,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Text(
                          'A\$${model.total}',
                          style: GoogleFonts.inter(
                            color: AppColors.text_field_container,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 4.017216642754663),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          'Processed by',
                          style: GoogleFonts.inter(
                            color: AppColors.text_field_container,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.widthMultiplier *
                                      1.2152777777777777),
                              child: Text(
                                'Wyre',
                                style: GoogleFonts.inter(
                                    color: AppColors.appBlue,
                                    fontWeight: FontWeight.w400,
                                    fontSize: SizeConfig.textMultiplier *
                                        1.5064562410329987,
                                    letterSpacing: 0.5,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                            // Container(
                            //   height: SizeConfig.heightMultiplier * 0.12553802008608322,
                            //   // width: MediaQuery.of(context).size.width * 0.3,
                            //   color: AppColors.toolbarBlue,
                            // )
                          ],
                        ),
                      ),
                      // Container(
                      //   child: Text(
                      //     ' ',
                      //     style: GoogleFonts.inter(
                      //       color: AppColors.text_field_container,
                      //       fontWeight: FontWeight.w400,
                      //       fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                      //       letterSpacing: 0.5,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),

              ],
            ),
          );
        }
        if(snapshot.connectionState == ConnectionState.done && !snapshot.hasData){
          return Column(children: [Text('error'), FlatButton(onPressed: () async {
             setState(() {});
             context.read<SelleAssetProvider>().reload();

          }, child: Text('reload'))]);
        }

        return Text('loading...');

      }
    );
  }
}

class ConvertPreview extends StatelessWidget {
  final ConvertModel model;

  const ConvertPreview({Key key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Container(
          margin: EdgeInsets.only(
              top: SizeConfig.heightMultiplier * 4.017216642754663),
          child:  Container(
            margin: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884,
                right: SizeConfig.widthMultiplier * 3.8888888888888884),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 4.017216642754663),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          'Exchange rate',
                          style: GoogleFonts.inter(
                            color: AppColors.sub_text,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Text(
                          'A\$${model.exchangeRate}',
                          style: GoogleFonts.inter(
                            color: AppColors.text_field_container,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 4.017216642754663),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          'conversion',
                          style: GoogleFonts.inter(
                            color: AppColors.sub_text,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Text(
                          'A\$${model.conversion}',
                          style: GoogleFonts.inter(
                            color: AppColors.text_field_container,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _row("totalPayout", '${model.totalPayout}'),
                _row("wyreFees", '${model.wyreFees}'),


              ],
            ),
          ));



  }

  _row(String title, String value){
    return Container(
      margin: EdgeInsets.only(
          top: SizeConfig.heightMultiplier * 4.017216642754663),
      child: Row(
        children: [
          Container(
            child: Text(
              title,
              style: GoogleFonts.inter(
                color: AppColors.sub_text,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Spacer(),
          Container(
            child: Text(
              value,
              style: GoogleFonts.inter(
                color: AppColors.text_field_container,
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.textMultiplier * 2.0086083213773316,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

