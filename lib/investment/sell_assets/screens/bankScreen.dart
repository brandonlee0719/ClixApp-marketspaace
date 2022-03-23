import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_space/common/loading_progress.dart';
import 'package:market_space/common/toolbar.dart';
import 'package:market_space/investment/sell_assets/assetProvider/bankAccountProvider.dart';
import 'package:market_space/responsive_layout/size_config.dart';

import 'UploadBankScreen.dart';

class BankScreen extends StatefulWidget {
  @override
  _BankScreenState createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  bool _isLoading = true;
  IBankProvider provider  = LocalBankProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    load();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(),
      body: _isLoading?LoadingProgress():Container(
          padding: EdgeInsets.all(SizeConfig.widthMultiplier*3),
          child: UploadBankScreen()),
    );
  }

  Future<void> load() async {
    bool b = await provider.hasBank();
    if(b){
      Navigator.pop(context,'bank account detected');
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }
}
