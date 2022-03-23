import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_space/common/colors.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WyrePolicyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(title: 'Wyre Policy'),
      body: WebView(
        initialUrl: 'https://www.sendwyre.com/user-agreement/',
      ),
    );
  }
}

mixin WebViewMixin<T extends StatefulWidget> on State<T>{

  Widget wyrePolicyWidget(){
    return GestureDetector(
        onTap: push,
        child: RichText(
          text: TextSpan(
            text: '*By click this button I agree with the ',
            style: TextStyle(
              color: AppColors.black
            ),
            children: const <TextSpan>[
              TextSpan(text: 'wyre policy', style: TextStyle(decoration: TextDecoration.underline,color: AppColors.black)),
            ],
          ),
        )
        // Text("*By click this button I agree with the wyre policy")
    );
  }
  void push(){
    Navigator.of(context).push( MaterialPageRoute(builder: (context) => WyrePolicyView()));
  }
}