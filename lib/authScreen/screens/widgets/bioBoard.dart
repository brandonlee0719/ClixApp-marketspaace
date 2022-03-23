import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_space/authScreen/logic/password_cubit.dart';
import 'package:market_space/common/colors.dart';

import 'package:provider/provider.dart';

import '../../authApi.dart';

class BioBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PasswordCubit cubit = context.watch<PasswordCubit>();
    PasswordState state = cubit.state;
    return Builder(
      builder: (BuildContext context) {
        if (state == PasswordState.initial ||
            state == PasswordState.readingBioKind) {
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            child: MaterialButton(
              padding: EdgeInsets.all(8),
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60.0)),
              height: 90,
              child: Text(
                "?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.bitcoin_orange,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor * 26,
                ),
              ),
            ),
          );
        }
        return Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          child: MaterialButton(
              padding: EdgeInsets.all(8),
              onPressed: () async {
                bool result = await LocalAuthApi.authenticate();
                if (result) {
                  // print("AuthSuccess");
                  Navigator.pop(context);
                } else {
                  // print("AuthFail");
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60.0)),
              height: 90,
              child: Icon(
                cubit.iconData,
                color: AppColors.app_orange,
              )),
        );
      },
    );
  }
}
