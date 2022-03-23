import 'package:flutter/cupertino.dart';
import 'package:market_space/investment/sell_assets/assetProvider/bankAccountProvider.dart';
import 'package:market_space/notification/logics/controllers/TextFieldScreenController.dart';
import 'package:market_space/notification/representation/widgets/components/TextInputDisplayer.dart';
import 'package:market_space/notification/representation/widgets/screen/textInputScreen.dart';
import 'package:market_space/representation/buttons.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/dialogueServices/dialogueService.dart';

class UploadBankScreen extends StatefulWidget {
  final TextFieldScreenController controller = TextFieldScreenController(
    viewModelList: [
      TextInputViewModel(
          labelText: 'Input bank account',
          hintText: 'Input bank account',
          instructionText: 'Bank Account'),
      TextInputViewModel(
          labelText: 'Input BSB',
          hintText: 'Input BSB',
          instructionText: 'BSB'),
      TextInputViewModel(
          labelText: 'Input bank name',
          hintText: 'Input bank name',
          instructionText: 'Bank Name'),
    ],
  );

  @override
  _UploadBankScreenState createState() => _UploadBankScreenState();
}

enum _SubmitStatus {
  awaitingSubmit,
  submitted,
}

class _UploadBankScreenState extends State<UploadBankScreen> {
  _SubmitStatus _status = _SubmitStatus.awaitingSubmit;
  IBankProvider provider = LocalBankProvider();
  Future<void> submit() async {
    setState(() {
      _status = _SubmitStatus.awaitingSubmit;
    });
    // print(widget.controller.viewModelList[0].controller.text);
    // print(widget.controller.viewModelList[1].controller.text);
    bool b = await provider.uploadBank(
        widget.controller.viewModelList[0].controller.text,
        widget.controller.viewModelList[1].controller.text);
    if (b) {
      await DialogueService.instance.showErrorDialogue(
          context, "Success", () {},
          buttonText: 'ok', title: 'Upload success');
      Navigator.pop(context, "upload bank success");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: SizeConfig.heightMultiplier*19,
      child: Column(
        children: [
          TextInputScreen(
            controller: widget.controller,
          ),
          SizedBox(
            height: 10,
          ),
          ButtonBuilder().build(ButtonSection(
              ButtonSectionType.confirmButton,
              (_status == _SubmitStatus.awaitingSubmit ||
                      _status == _SubmitStatus.submitted)
                  ? 'Confirm bank account'.toUpperCase()
                  : 'uploading..'.toUpperCase(),
              _status == _SubmitStatus.awaitingSubmit ? submit : () {}))
        ],
      ),
    );
  }
}
