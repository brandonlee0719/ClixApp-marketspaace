import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_space/apis/orderApi/orderManager.dart';
import 'package:market_space/services/locator.dart';

class CardResponseWidget extends StatelessWidget {
  final TextEditingController card2faController = TextEditingController();
  final TextEditingController smsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  CupertinoAlertDialog(
      title: Text("complete 2fa authentication"),
      content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            if(locator<OrderManager>().cardAuth["type"] == "ALL" || locator<OrderManager>().cardAuth["type"] == "CARD2FA")
                Column(children: [
                  Text("card2fa"),
                  CupertinoTextField(
                    controller: card2faController,
                  ),

                ],),

            if(locator<OrderManager>().cardAuth["type"] == "ALL" || locator<OrderManager>().cardAuth["type"] == "SMS")
              Column(children: [
                Text("sms"),
                CupertinoTextField(
                  controller: smsController,
                ),

              ],),

          ]
      ),
      actions: <Widget>[

        FlatButton(
          child: new Text("Save"),
          onPressed:() => {
            if(card2faController != null || card2faController != null){
              setData(),
              Navigator.pop(context),
            }


          },
        )


      ],

    );

  }


  void setData(){
    if(locator<OrderManager>().cardAuth["type"] == "ALL" || locator<OrderManager>().cardAuth["type"] == "SMS"){
      locator<OrderManager>().cardAuth["sms"] = smsController.text;

    }
    if(locator<OrderManager>().cardAuth["type"] == "ALL" || locator<OrderManager>().cardAuth["type"] == "CARD2FA"){
      locator<OrderManager>().cardAuth["card2fa"] = card2faController.text;
    }
  }
}
