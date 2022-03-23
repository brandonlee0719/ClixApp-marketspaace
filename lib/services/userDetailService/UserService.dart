import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market_space/services/pathService.dart';
import 'package:market_space/services/userDetailService/userDetail.dart';

class UserService{

  Future<UserDetail> getUser(String id)  async {
    await Future.delayed(Duration(seconds:1));
    var user = await PathService.userPath.getPath().doc(id).get();
    var map = user.data();
    UserDetail detail= UserDetail.fromJson(map);
    return detail;
  }

}