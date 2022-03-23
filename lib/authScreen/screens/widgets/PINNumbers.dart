import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_space/authScreen/logic/password_cubit.dart';
import 'package:market_space/common/colors.dart';
import 'package:provider/provider.dart';

class PINNumber extends StatefulWidget {

  final OutlineInputBorder outlineInputBorder;
  final int index;

  PINNumber({Key key, this.outlineInputBorder, this.index}) : super(key: key);

  @override
  _PINNumberState createState() => _PINNumberState();
}

class _PINNumberState extends State<PINNumber> {
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordCubit,PasswordState>(
      listener: (context, state) {
        if(state ==PasswordState.pinPressed){
          setState(() {
            int number = Provider.of<PasswordCubit>(context, listen: false).pinIndex;
            if(number>=widget.index){
              isDone =true;
            }
            else{
              isDone = false;
            }
          });
        }

        // do stuff here based on BlocA's state
      },
      child: Container(
        width: 25.0,
        height: 25.0,
        margin: EdgeInsets.only(left: 18,right: 18),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(20)),

          gradient: new LinearGradient(
              begin: Alignment.topCenter,

              end: Alignment.center,
              colors: isDone?[
                AppColors.bitcoin_orange,
                AppColors.nextButtonSecondary,
              ]:[
                Colors.white,
                Colors.white,
              ]
          ),
        ),


      ),
    );
  }
}