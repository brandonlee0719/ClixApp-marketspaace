import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/order_checkout/model/paymentCurrency.dart';
import 'package:market_space/responsive_layout/size_config.dart';

class CurrencyLine extends StatelessWidget {
  final String currency;
  final Function onTap;
  final String amount;
  final PaymentCurrency currencyType;
  final PaymentCurrency value;

  const CurrencyLine(
      {Key key,
      @required this.currency,
      @required this.onTap,
      @required this.amount,
      @required this.currencyType,
      @required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.88,
        padding: EdgeInsets.all(10),
        color: (value == currencyType)
            ? AppColors.buttonBackground.withOpacity(0.4)
            : AppColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 0,
              child: Text(
                currency,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  color: (value == currencyType)
                      ? AppColors.appBlue
                      : AppColors.text_field_container,
                ),
              ),
            ),
            // Spacer(),
            Flexible(
              flex: 0,
              child: Text(
                amount + ' AUD',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                  color: (value == currencyType)
                      ? AppColors.appBlue
                      : AppColors.text_field_container,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
