import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/proxy/Icacher.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/investment/sell_assets/routes/chooseCoinRoute.dart';
import 'package:market_space/investment/sell_assets/screens/widgets/previewWidgets.dart';
import 'package:market_space/representation/buttons.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/dialogueServices/dialogueService.dart';
import 'package:market_space/services/locator.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/services/RouterServices.dart';

class WithdrawPreview extends StatefulWidget {
  @override
  _WithdrawPreviewState createState() => _WithdrawPreviewState();
}

class _WithdrawPreviewState extends State<WithdrawPreview> {
  bool _isLoading = true;
  bool _retrievedOrderData = false;
  bool _showButton = true;
  var _data;
  var _confirmData;
  final Color background = AppColors.toolbarBlue;
  final Color fill = AppColors.lightgrey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _load();
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
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          // resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: Toolbar(),
          body: Container(
            padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
            child: Column(
              children: [
                PreviewTitleWidget(
                  title: "Order Preview",
                ),
                CryptoAmountWidget(
                  text: PayPreviewRoute.number +
                      " " +
                      PayPreviewRoute.coinType.toUpperCase(),
                ),
                Divider(),
                _isLoading
                    ? SizedBox(
                        child: Center(
                            child: Column(
                          children: [
                            Text("Loading please wait"),
                            SizedBox(
                              height: 40,
                            ),
                            LoadingProgress()
                          ],
                        )),
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.heightMultiplier * 3),
                        child: _detailColumn(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailColumn() {
    return _retrievedOrderData
        ? Column(
            children: [
              PreviewRow(
                title: "Payment method",
                number: "Wallet",
              ),
              SizedBox(height: 15),
              PreviewRow(
                title: "Withdrawal Amount",
                number: _data[0]['withdrawal'].toString(),
              ),
              PreviewRow(
                title: "Transaction Fee",
                number: _data[0]['wyreTransferFee'].toString(),
              ),
              SummaryRow(
                title: "Payout Amount",
                number: _data[0]['amountReceived'].toString(),
              ),
              SizedBox(height: 125),
              _showButton
                  ? ButtonBuilder().build(ButtonSection(
                      ButtonSectionType.confirmButton,
                      "CONFIRM",
                      () => _confirmWithdrawal()))
                  : Container()
            ],
          )
        : Container();
  }

  _confirmWithdrawal() async {
    // DialogueService.instance.showSuccessDialogue(context);
    String transferID = _data[0]['transferID'];
    await RouterService.appRouter.navigateTo("/BiometricsAuth/0");

    setState(() {
      _isLoading = true;
    });

    _confirmData =
        await locator.get<CacheableManager>().confirmWithdraw(transferID, true);
    if (_confirmData == 200) {
      setState(() {
        _isLoading = false;
        _showButton = false;
      });
      DialogueService.instance.showSuccessDialogue(context);
    } else {
      DialogueService.instance.showErrorDialogue(
          context,
          "Error confirming withdrawal, please click the back button then try again",
          () {});
    }
  }

  _load() async {
    _data = await locator.get<CacheableManager>().withdraw(
        PayPreviewRoute.number,
        PayPreviewRoute.address,
        PayPreviewRoute.coinType);
    if (_data[0] == {} || _data[1] != 200) {
      // print('data here');
      // print(_data);
      // print(_data.runtimeType);
      if (_data[0] == "Insufficient funds") {
        DialogueService.instance.showErrorDialogue(
            context,
            "Insufficient funds, this is likely due to network fees. Please go back, reduce the withdrawal amount and try again.",
            () {});
      } else {
        DialogueService.instance.showErrorDialogue(
            context,
            "Error attempting to withdraw, please click the back button then try to withdraw again",
            () {});
      }
    }
    if (_data[1] == 200) {
      setState(() {
        _isLoading = false;
        _retrievedOrderData = true;
      });
    }
  }
}
