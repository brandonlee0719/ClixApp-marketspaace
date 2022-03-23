import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:market_space/notification/logics/controllers/TextFieldScreenController.dart';
import 'package:market_space/notification/representation/widgets/components/TextInputDisplayer.dart';
import 'package:market_space/profile/logics/orderProvider.dart';
import 'package:market_space/providers/orderProvider.dart';
import 'package:market_space/representation/buttons.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/dialogueServices/dialogueService.dart';

class TextInputScreen extends StatelessWidget {
  final TextFieldScreenController controller;
  final TextInputDisplayer displayer = TextInputDisplayer();

  TextInputScreen({Key key, this.controller}) : super(key: key);
  double calculateLength(){
    double i =.0;
    for(var view in controller.viewModelList){
      if(view.instructionText == null){
        i+= SizeConfig.heightMultiplier*10;
      }
      else{
        i+=SizeConfig.heightMultiplier*13;
      }
    }
    return i;
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: calculateLength(),
      child: ListView.builder(

          itemCount: controller.viewModelList.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context,index){
            return displayer.render(controller.viewModelList[index]);

          }
      ),
    );
  }
}

class SubmitTrackingScreen extends StatefulWidget {
  final String orderNumber;
  final TextFieldScreenController controller = TextFieldScreenController(
      viewModelList: [
        // TextInputViewModel(
        //     labelText:'Input cruise service',
        //     hintText:'Input cruise service',
        //     // instructionText:'Cruise Service'
        // ),
        TextInputViewModel(
            labelText:'Tracking number',
            hintText:'Tracking number',
            // instructionText:'tracking number'
        ),
      ],
      );

  SubmitTrackingScreen({Key key, this.orderNumber}) : super(key: key);

  @override
  _SubmitTrackingScreenState createState() => _SubmitTrackingScreenState();
}

enum _SubmitStatus{
  awaitingSubmit,
  submitting,
  submitted,
}

class _SubmitTrackingScreenState extends State<SubmitTrackingScreen> {
  _SubmitStatus _status = _SubmitStatus.awaitingSubmit;
  Future<void> submit() async{
    String text = widget.controller.viewModelList[0].controller.text;
    if(_status == _SubmitStatus.submitting){
      return;
    }
    if(text == null){
      DialogueService.instance.showErrorDialogue(context, "Tracking number must be filled", null);
    }

    setState(() {
      _status = _SubmitStatus.submitting;
    });
    int result = await CancelOrderProvider().submitCruiseService(
        widget.orderNumber,
        (){
          var date = DateTime.now();
          return DateFormat('dd-MM-yyyy').format(date);
        }(),
        widget.controller.viewModelList[0].controller.text
    );
    if(result == 200){
      setState(() {
        _status = _SubmitStatus.submitted;
      });

    }
    else{
      DialogueService.instance.showErrorDialogue(
          context,
          "Something goes wrong, the cruise service isn't updated properly!",
          null);
    }
  }
  @override
  Widget build(BuildContext context) {
    return _status==_SubmitStatus.submitted?Container():
      SizedBox(
      height: SizeConfig.heightMultiplier*19,
      child: Column(
        children: [
          TextInputScreen(controller: widget.controller,),
          SizedBox(height: 10,),
          // if(_status ==_SubmitStatus.awaitingSubmit)
          ButtonBuilder().build(ButtonSection(ButtonSectionType.confirmButton, (_status ==_SubmitStatus.awaitingSubmit||_status==_SubmitStatus.submitted)?'Confirm Shipping Details'.toUpperCase():'uploading..'.toUpperCase(), submit))
        ],
      ),
    );

  }
}

