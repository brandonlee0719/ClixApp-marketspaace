import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_space/apis/orderApi/walletApi.dart';
import 'package:market_space/authScreen/authApi.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/proxy/Icacher.dart';
import 'package:market_space/investment/models/wallet.dart';
import 'package:market_space/investment/sell_assets/routes/chooseCoinRoute.dart';
import 'package:market_space/representation/buttons.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/RouterServices.dart';
import 'package:market_space/services/dialogueServices/dialogueService.dart';
import 'package:market_space/services/locator.dart';

extension compatreble on String {
  /// this operator is only for double string now!!!!!!
  /// make sure the string is double before compare
  double toDouble() {
    double double1;
    try {
      double1 = int.parse(this).toDouble();
    } catch (e) {
      // print(e);
      try {
        double1 = double.parse(this);
      } catch (e) {}
    } finally {
      if (double1 == null) {
        double1 = 0.0;
      }
    }
    return double1;
  }

  operator >(String s) {
    // print(this);
    // print(s);
    if (this.toDouble() > s.toDouble()) {
      return true;
    }
    return false;
  }
}

class _CustomizedTextFieldComponent extends StatelessWidget {
  final String hint;
  final String label;
  final TextEditingController controller;
  final bool isReadOnly;
  final bool isNumeric;
  final bool suffixNeeded;

  const _CustomizedTextFieldComponent(
      {Key key,
      this.hint,
      this.label,
      this.controller,
      this.isReadOnly,
      this.suffixNeeded = false,
      this.isNumeric = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _copyEnabled = false;
    return Container(
      padding: EdgeInsets.all(SizeConfig.widthMultiplier * 3),
      child: TextField(
        keyboardType: isNumeric
            ? TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        controller: controller,
        style: GoogleFonts.inter(
          color: AppColors.text_field_color,
          fontWeight: FontWeight.w400,
          fontSize: SizeConfig.textMultiplier * 1.757532281205165,
          letterSpacing: 0.25,
        ),
        enabled: true,
        readOnly:
            suffixNeeded, //properties are only true if receiving customizable text widget
        autofocus:
            suffixNeeded, //properties are only true if receiving customizable text widget
        decoration: new InputDecoration(
            border: new OutlineInputBorder(
              borderSide: new BorderSide(color: AppColors.text_field_color),
            ),
            suffixIcon: suffixNeeded
                ? IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: hint));
                      final snackBar = SnackBar(
                        content: const Text('Copied successfully'),
                        // action: SnackBarAction(
                        //   // label: 'Undo',
                        //   onPressed: () {
                        //     // Some code to undo the change.
                        //   },
                        // ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      // setState(() {
                      //   title = "btcAddress";
                      // });
                      // showDialog(
                      //     context: context,
                      //     builder: (context) => SimpleDialog(
                      //           backgroundColor: Color.fromRGBO(r, g, b, 0),
                      //           children: [Text("Successfully copied")],
                      //         ));
                    },
                    icon: Icon(Icons.copy,
                        color: _copyEnabled
                            ? AppColors.catContainerColor
                            : AppColors.darkgrey),
                  )
                : null,
            hintText: hint,
            labelText: label,
            contentPadding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 3.8888888888888884),
            suffixStyle: const TextStyle(color: AppColors.appBlue)),
      ),
    );
  }
}

class ReceiveCryptoScreen extends StatefulWidget {
  @override
  _ReceiveCryptoScreenState createState() => _ReceiveCryptoScreenState();
}

class _ReceiveCryptoScreenState extends State<ReceiveCryptoScreen> {
  String title = "ethAddress";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    popChoice();
  }

  popChoice() async {
    String result =
        await RouterService.appRouter.navigateTo(ChooseCoinRoute.buildPath());
    // print(result);
    if (result == "Bitcoin (BTC)") {
      setState(() {
        title = "btcAddress";
      });
    }
    if (result == null) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FutureBuilder<Map>(
          future: locator.get<CacheableManager>().getBTCAddress(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return Container(
                padding: EdgeInsets.all(SizeConfig.widthMultiplier * 3),
                child: Text("Your address is loading.."),
              );
            }
            return _CustomizedTextFieldComponent(
              hint: snap.data[title],
              label: "Crypto Address",
              controller: TextEditingController(),
              isReadOnly: true,
              suffixNeeded: true,
            );
          }),
      Container(
          padding: EdgeInsets.all(SizeConfig.widthMultiplier * 3),
          child: Text(
            "Send your crypto from your wallet to this address to access your funds on Market Spaace",
            style: GoogleFonts.inter(
              color: AppColors.text_field_color,
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.textMultiplier * 1.757532281205165,
              letterSpacing: 0.25,
            ),
            textAlign: TextAlign.left,
          )),
    ]);
  }
}

class WithdrawBTCScreen extends StatefulWidget {
  @override
  _WithdrawBTCScreenState createState() => _WithdrawBTCScreenState();
}

class _WithdrawBTCScreenState extends State<WithdrawBTCScreen> {
  final TextEditingController addressController = new TextEditingController();

  final TextEditingController amountController = new TextEditingController();
  String amount;
  String title = "";
  String result = "";
  String _availableBalance;
  @override
  void initState() {
    pop();
    // TODO: implement initState
    super.initState();
  }

  Future<void> pop() async {
    result = "";
    result =
        await RouterService.appRouter.navigateTo(ChooseCoinRoute.buildPath());
    // print(result);
    if (result == "Bitcoin (BTC)") {
      title = "btc";
    } else if (result == 'Ethereum (ETH)') {
      title = "eth";
    } else {
      title = "usdc";
    }
    setState(() {});
  }

  double getAmount(Wallet wallet) {
    if (title == "btc") {
      return wallet.BTC;
    }
    if (title == "eth") {
      return wallet.ETH;
    }
    return wallet.USDC;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _CustomizedTextFieldComponent(
        isNumeric: true,
        hint: "Amount",
        label: "Amount",
        controller: amountController,
        isReadOnly: false,
        suffixNeeded: false,
      ),
      Container(
          width: double.infinity,
          padding: EdgeInsets.only(right: SizeConfig.widthMultiplier * 3),
          child: ValueListenableBuilder<Wallet>(
              valueListenable: locator.get<WalletApi>().wallet,
              builder: (context, snapshot, chilad) {
                if (snapshot == null) {
                  return Text("Awaiting loading from server");
                } else {
                  if (title == 'btc') {
                    _availableBalance = snapshot.BTC.toStringAsFixed(5);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(('Available balance: ' +
                            (snapshot.BTC - (0.0125 * snapshot.BTC))
                                .toStringAsFixed(5) +
                            ' BTC')),
                      ],
                    );
                  }
                  if (title == 'eth') {
                    _availableBalance = snapshot.ETH.toStringAsFixed(5);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(('Available balance: ' +
                            (snapshot.ETH).toStringAsFixed(5) +
                            ' ETH')),
                      ],
                    );
                  }
                  if (title == 'usdc') {
                    _availableBalance = snapshot.USDC.toStringAsFixed(2);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(('Available balance: ' +
                            (snapshot.USDC).toStringAsFixed(2) +
                            ' USDC')),
                      ],
                    );
                  }
                }
                return Text('');
              })),
      _CustomizedTextFieldComponent(
        hint: "Deposit address",
        label: "Deposit address",
        controller: addressController,
        isReadOnly: false,
      ),
      Container(
        padding: EdgeInsets.all(SizeConfig.widthMultiplier * 3),
        child: ButtonBuilder().build(
            ButtonSection(ButtonSectionType.confirmButton, 'WITHDRAW', () {
          if (amountController.text.toDouble() <=
                  _availableBalance.toDouble() &&
              amountController.text.toDouble() > 0) {
            bool validAddress = false;
            PayPreviewRoute.number = amountController.text;
            PayPreviewRoute.coinType = title;
            PayPreviewRoute.address = addressController.text;

            if (title == 'btc') {
              validAddress = RegExp(r"^[13][a-km-zA-HJ-NP-Z1-9]{25,34}$")
                  .hasMatch(addressController.text);
            } else {
              validAddress = RegExp(r"/^0x[a-fA-F0-9]{40}$/")
                  .hasMatch(addressController.text);
            }
            if (validAddress) {
              RouterService.appRouter.navigateTo(PayPreviewRoute.buildPath());
            } else {
              DialogueService.instance.showErrorDialogue(
                  context,
                  "You have entered an invalid address, please check the address and try again",
                  () {});
            }
          } else {
            DialogueService.instance.showErrorDialogue(
                context,
                "You have entered an invalid amount, please ensure it is not over your available balance",
                () {});
          }
        })),
      ),
      Container(
        padding: EdgeInsets.all(SizeConfig.widthMultiplier * 3),
        child: Column(children: [
          Text(
            "\nEnter the amount of cryptocurrency you wish to withdraw and the address you wish to withdraw to.\n\nTransaction details are summarised in the next screen and you are prompted in this next screen if you wish to confirm your withdrawal.",
            style: GoogleFonts.inter(
              color: AppColors.text_field_color,
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.textMultiplier * 1.757532281205165,
              letterSpacing: 0.25,
            ),
            textAlign: TextAlign.left,
          ),
          title == 'btc'
              ? Text(
                  "\n\nPlease only send to legacy bitcoin address, do not send Bech32. For your protection, we will validate if it is a legacy address when you click withdraw.",
                  style: GoogleFonts.inter(
                    color: AppColors.text_field_color,
                    fontWeight: FontWeight.w400,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    letterSpacing: 0.25,
                  ),
                  textAlign: TextAlign.left,
                )
              : Text(
                  "\n\nPlease only send to ERC20 address. ETH and USDC withdrawals may receive insufficient funds messages due to high gas fees, try reducing your withdrawal amount to compensate for this.",
                  style: GoogleFonts.inter(
                    color: AppColors.text_field_color,
                    fontWeight: FontWeight.w400,
                    fontSize: SizeConfig.textMultiplier * 1.757532281205165,
                    letterSpacing: 0.25,
                  ),
                  textAlign: TextAlign.left,
                ),
          Text(
            "\n\nGet in touch with us through social media if you need any customer support",
            style: GoogleFonts.inter(
              color: AppColors.text_field_color,
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.textMultiplier * 1.757532281205165,
              letterSpacing: 0.25,
            ),
            textAlign: TextAlign.left,
          ),
        ]),
      ),
    ]);
  }

  Future<void> _deposit() async {
    amountController.text.toDouble();
    // print(amountController.text.toDouble());
    // print(this.amountController.text > this.amount);
    if (this.amountController.text == null ||
        this.amountController.text == "" ||
        this.amountController.text.toDouble() == 0.0) {
      DialogueService.instance
          .showErrorDialogue(context, "wrong amount in", () {});
    } else if (this.addressController.text == null ||
        this.addressController.text == "") {
      DialogueService.instance
          .showErrorDialogue(context, "address is invalid", () {});
    } else if (this.amountController.text > this.amount) {
      DialogueService.instance
          .showErrorDialogue(context, "not enough balance", () {});
    } else {
      bool result = await LocalAuthApi.authenticate();
      if (result) {
        // print("success");
        await DialogueService.instance.showLoadingDialogue(context, () async {
          // await locator.get<CacheableManager>().withdraw(amountController.text, addressController.text);
        });
      }
    }
  }
}
