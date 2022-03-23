import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/pinTextField.dart';

class ConfirmCVVWidget extends StatefulWidget {
  const ConfirmCVVWidget({Key key}) : super(key: key);

  @override
  _ConfirmCVVWidgetState createState() => _ConfirmCVVWidgetState();
}

class _ConfirmCVVWidgetState extends State<ConfirmCVVWidget> {
  final _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
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
      content: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Confirm CVV',
              style: GoogleFonts.inter(
                fontSize: 18,
                letterSpacing: 0.15,
                fontWeight: FontWeight.w500,
                color: const Color(0xff212121),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'CVV (Code at the bank of your card)',
              style: GoogleFonts.inter(
                fontSize: 12,
                letterSpacing: 0.4,
                fontWeight: FontWeight.bold,
                color: const Color(0xff3F3F3F),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: PinTextField(
                autofocus: true,
                maxLength: 3,
                highlight: true,
                highlightColor: Colors.grey,
                pinBoxWidth: 40,
                defaultBorderColor:
                    Theme.of(context).primaryColor.withOpacity(0.6),
                hasTextBorderColor: const Color(0xff1673C5),
                hasError: false,
                wrapAlignment: WrapAlignment.center,
                // onDone: (text) => Navigator.pop(context, text),
                controller: _textEditingController,
                pinBoxDecoration:
                    ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                pinTextStyle: TextStyle(
                  fontSize: 30,
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
            Center(
              child: FlatButton(
                onPressed: () {
                  if (_textEditingController.text.length == 3) {
                    Navigator.pop(context, _textEditingController.text);
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
                    'CONFIRM CVV',
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
}
