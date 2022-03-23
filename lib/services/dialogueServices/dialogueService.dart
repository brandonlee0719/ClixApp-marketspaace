import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/apis/orderApi/orderManager.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/pinTextField.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/services/dialogueServices/widgets/smsAuthDialogue.dart';
import 'package:market_space/services/locator.dart';
import 'package:market_space/investment/investment_route.dart';
import 'package:market_space/routes/route.dart';
part 'widgets/cardAuthWidget.dart';
part 'widgets/cvvWidget.dart';
part 'widgets/loadingDialogue.dart';
part 'widgets/chooseConvert.dart';

class DialogueService {
  String dialogueButtonText;
  // this is a dialogue service to reuse dialogue every now and then.
  static DialogueService instance = DialogueService();

  Future<void> showErrorDialogue(
      BuildContext context, String error, Function tryAgin,
      {String buttonText, String title = 'Error performing operation'}) {
    if (tryAgin == null) {
      dialogueButtonText = 'OK';
    } else {
      dialogueButtonText = 'OK';
    }

    if (buttonText != null) {
      dialogueButtonText = buttonText;
    }

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(error),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(dialogueButtonText),
            onPressed: () {
              Navigator.of(context).pop();
              tryAgin();
            },
          ),
        ],
      ),
    );
  }

  Future<String> showMyDialogue(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('input mount'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Input the exact amount of BTC you want to buy.'),
              TextField(
                  keyboardType: TextInputType.number,
                  controller: controller,
                  textAlign: TextAlign.right),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop(controller.text);
            },
          ),
        ],
      ),
    );
  }

  Future<String> showSuccessDialogue(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'Withdrawal successful! You should see the payout in your external wallet shortly. \n\nRefresh your wallet by dragging down on the wallet screen. \n\nTap outside this dialog to dismiss it'),
            ],
          ),
        ),
        // actions: <Widget>[
        //   TextButton(
        //     child: const Text('OK'),
        //     onPressed: () {

        //       FocusManager.instance.primaryFocus.unfocus();
        //     },
        //   ),
        // ],
      ),
    );
  }

  Future<String> showCvvDialogue(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) => _ConfirmCVVWidget(),
    );
  }

  Future<String> showCardAuthDialogue(BuildContext context) {
    return showDialog<String>(
      barrierDismissible: true,
      context: context,
      builder: (context) => _Complete2FAWidget(),
    );
  }

  Future<String> showLoadingDialogue(BuildContext context, Function func) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _LoadingDialogue(
        futureFunction: func,
      ),
    );
  }

  Future<String> showSMSAuth(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => SmsAuthDialogue(),
    );
  }

  Future<List<String>> showConvertDialogue(BuildContext context) {
    return showDialog<List<String>>(
        context: context,
        barrierDismissible: true,
        builder: (context) => ChooseConvertDialogue());
  }
}
