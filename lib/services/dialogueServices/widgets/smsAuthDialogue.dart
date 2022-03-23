import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_space/apis/smsAuthApi.dart';
import 'package:market_space/responsive_layout/size_config.dart';
import 'package:market_space/services/dialogueServices/dialogueService.dart';

class SmsAuthDialogue extends StatefulWidget {
  @override
  _SmsAuthDialogueState createState() => _SmsAuthDialogueState();
}

class _SmsAuthDialogueState extends State<SmsAuthDialogue> {
  SmsAuthController controller;
  @override
  void initState() {
    controller =SmsAuthController();
    controller.stream.stream.listen((event) {
      if(event==status.Success){
        pop(context);
      }
    });
    // TODO: implement initState
    super.initState();
  }
  Future<void> pop(BuildContext context) async{
    await Future.delayed(Duration(milliseconds: 800));
    Navigator.of(context).pop("success");
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      titlePadding: EdgeInsets.zero,
      content: StreamBuilder<status>(
        stream: controller.stream.stream,
        builder: (context, snap){

          if(snap.data == status.Success){
            controller.dispose();
            return StatusBar(text: "success");
          }
          if(snap.data == status.Fail){
            return InputCode(onClick: (code){
              controller.verify(code);
            }, isFail: true,);
          }
          if(snap.data == status.AwaitSending){
            return StatusBar(text: "Message Sending....",);
          }
          if(snap.data ==status.Verifying){
            return StatusBar(text:"Verify your message...");
          }

          return InputCode(onClick: (code){
            controller.verify(code);
          }, isFail: false,);
        },
      )
    );
  }
}

enum status{
  AwaitSending,
  AwaitInput,
  Fail,
  Success,
  Verifying,

}
class SmsAuthController{
  String verificationID;
  StreamController<status> stream = StreamController.broadcast();
  StreamSink<status> sink;

  SmsAuthController(){
    sink =stream.sink;
    sink.add(status.AwaitSending);
    SmsAuthApi.sendSms((verificationId){
      this.verificationID =verificationId;
      sink.add(status.AwaitInput);
    }, "+61403208238");
  }

  Future<void> verify(String code) async{
    sink.add(status.Verifying);
    bool result = await SmsAuthApi.verifySMS(verificationID, code);
    result?sink.add(status.Success):sink.add(status.Fail);
  }
  void dispose(){
    stream.close();
    sink.close();
  }


}

Widget buildDialogueContainer(Widget child){
  return Container(
    width: SizeConfig.widthMultiplier*60,
    height: SizeConfig.heightMultiplier*45,
    child: Center(
      child: child,
    ),
  );
}

class StatusBar extends StatelessWidget {
  final String text;

  const StatusBar({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return buildDialogueContainer(Text(text));
  }
}



class InputCode extends StatelessWidget {
  final TextEditingController controller =  TextEditingController();
  final Function(String smsCode) onClick;
  final bool isFail;

  InputCode({Key key, this.onClick, this.isFail}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return buildDialogueContainer(
      Column(
        children: [
          isFail?Text('auth fail please enter the code again'):Text('Input code!'),
          TextField(controller: controller,),
          TextButton(onPressed: (){
            onClick(controller.text);
          }, child: Text('confirm sms code'))
        ],
      )
    );
  }
}

