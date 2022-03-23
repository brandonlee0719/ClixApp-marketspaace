import 'dart:async';

import 'package:market_space/common/constants.dart';



class LocalPasswordApi{
  static String _passwordKey ="passwordKey";
  static Future<bool> setPassword(String pass) async{
    await storage.write(key: _passwordKey, value: pass);
    return true;
  }
  static Future<bool> hasPass() async{
    String password = await storage.read(key: _passwordKey);
    if(password==null){
      return false;
    }
    return true;
  }
  static Future<bool> authenticate(String pass) async{
    String password = await storage.read(key: _passwordKey);
    return password == pass;
  }



}