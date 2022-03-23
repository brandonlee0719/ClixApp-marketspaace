

import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/apis/orderApi/orderApi.dart';
import 'package:market_space/apis/orderApi/orderManager.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/order_checkout/presentation/widgets/paymentCard.dart';
import 'package:market_space/profile_settings/model/debit_card_model.dart';
import 'package:market_space/providers/payment_providers/cardProvider.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/locator.dart';


class PaymentWidget extends StatefulWidget {



  @override
  _PaymentWidgetState createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OrderViewModel>(
      future: locator.get<OrderApi>().getViewModel(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          var data = snapshot.data;
          if(data.paymentMethod == "debitCard")
            return _cardWidget();
          else
            return _walletWidget(data.paymentMethod, data.sourceCurrency);
        }
        return Container();
      }
    );
  }

  Widget _cardWidget(){
    return FutureBuilder<DebitCardModel>(
      future: CardProvider().getCard(),
      builder: (context, snapshot) {


        if(!snapshot.hasData){
          return Container();
        }
        var data = snapshot.data;
        return Container(

            width: MediaQuery.of(context).size.width,
            height: SizeConfig.heightMultiplier * 10.670731707317074,
            margin: EdgeInsets.only(
              left: SizeConfig.widthMultiplier * 3.8888888888888884,
              right: SizeConfig.widthMultiplier * 3.8888888888888884,
            ),
            padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 4.861111111111111,
                top: 16,
                right: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.darkgrey500)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.cardNumber,
                  style: GoogleFonts.inter(
                    color: AppColors.app_txt_color,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '${data.cardHolder} \nDate of expire: ${data.cardExpiry}',
                  style: GoogleFonts.inter(
                    color: AppColors.catTextColor,
                    fontSize: SizeConfig.textMultiplier * 1.5064562410329987,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            )
        );
      }
    );
  }
  Widget _walletWidget(String method, String type){
    return PaymentCard(method: method,currencyType: type,);
  }
}
