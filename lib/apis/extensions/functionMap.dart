import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension functionMap on State{

  void callSelfFunction(String funcName){}
}

class FunctionHandler<B extends State>{
  void mapFunction(B b,String funcName){
    b.callSelfFunction(funcName);
  }
}