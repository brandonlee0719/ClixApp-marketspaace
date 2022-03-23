import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/apis/orderApi/orderManager.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/pinTextField.dart';
import 'package:market_space/services/locator.dart';

class Complete2FAWidget extends StatefulWidget {
  const Complete2FAWidget({Key key}) : super(key: key);

  @override
  _Complete2FAWidgetState createState() => _Complete2FAWidgetState();
}

class _Complete2FAWidgetState extends State<Complete2FAWidget> {
  final _card2FATextEditingController = TextEditingController();
  final _smsTextEditingController = TextEditingController();

  @override
  void dispose() {
    _card2FATextEditingController.dispose();
    _smsTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      titlePadding: EdgeInsets.zero,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 8,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: const Color(0xff1673C5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Authorize and complete order',
              style: GoogleFonts.inter(
                fontSize: 18,
                letterSpacing: 0.15,
                fontWeight: FontWeight.w500,
                color: const Color(0xff212121),
              ),
            ),
            const SizedBox(height: 15),
            if (locator<OrderManager>().cardAuth["type"] == "ALL" ||
                locator<OrderManager>().cardAuth["type"] == "CARD2FA") ...[
              Text(
                'CARD 2FA (6 Digit Code Sent To Bank Account)',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  letterSpacing: 0.4,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff3F3F3F),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: PinTextField(
                  autofocus: true,
                  maxLength: 6,
                  highlight: true,
                  highlightColor: Colors.grey,
                  pinBoxWidth: 30,
                  defaultBorderColor:
                      Theme.of(context).primaryColor.withOpacity(0.6),
                  hasTextBorderColor: const Color(0xff1673C5),
                  hasError: false,
                  wrapAlignment: WrapAlignment.center,
                  controller: _card2FATextEditingController,
                  pinBoxDecoration:
                      ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                  pinTextStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.25,
                  ),
                  pinTextAnimatedSwitcherTransition:
                      ProvidedPinBoxTextAnimation.scalingTransition,
                  pinTextAnimatedSwitcherDuration: Duration(milliseconds: 100),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 40),
            ],
            if (locator<OrderManager>().cardAuth["type"] == "ALL" ||
                locator<OrderManager>().cardAuth["type"] == "SMS") ...[
              Text(
                'SMS CODE (6 Digit Code Sent To Mobile)',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  letterSpacing: 0.4,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff3F3F3F),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: PinTextField(
                  autofocus: true,
                  maxLength: 6,
                  highlight: true,
                  highlightColor: Colors.grey,
                  pinBoxWidth: 30,
                  defaultBorderColor:
                      Theme.of(context).primaryColor.withOpacity(0.6),
                  hasTextBorderColor: const Color(0xff1673C5),
                  hasError: false,
                  wrapAlignment: WrapAlignment.center,
                  controller: _smsTextEditingController,
                  pinBoxDecoration:
                      ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                  pinTextStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.25,
                  ),
                  pinTextAnimatedSwitcherTransition:
                      ProvidedPinBoxTextAnimation.scalingTransition,
                  pinTextAnimatedSwitcherDuration: Duration(milliseconds: 100),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 40),
            ],
            Center(
              child: FlatButton(
                onPressed: () {
                  if ((_card2FATextEditingController.text?.isNotEmpty ??
                          false) &&
                      (_smsTextEditingController.text?.isNotEmpty ?? false)) {
                    setData();
                    Navigator.pop(context);
                  }
                },
                padding: EdgeInsets.zero,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 13),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.gradient_button_light,
                        AppColors.gradient_button_dark
                      ],
                    ),
                  ),
                  child: Text(
                    'FINALISE ORDER',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                        color: AppColors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void setData() {
    if (locator<OrderManager>().cardAuth["type"] == "ALL" ||
        locator<OrderManager>().cardAuth["type"] == "SMS") {
      locator<OrderManager>().cardAuth["sms"] = _smsTextEditingController.text;
    }
    if (locator<OrderManager>().cardAuth["type"] == "ALL" ||
        locator<OrderManager>().cardAuth["type"] == "CARD2FA") {
      locator<OrderManager>().cardAuth["card2fa"] =
          _card2FATextEditingController.text;
    }
  }
}
