import 'package:market_space/forgotPasswordOtp/forgot_password_otp_route.dart';
import 'package:market_space/services/RouterServices.dart';

class NavigationApi{
  static  void navigateTo(String path,{String param, String varID} ){
    switch(path){
      case "toOTPScreen":
        if(varID == null){
          RouterService.appRouter
              .navigateTo('/ForgotPassOtp/$param');
        }

        RouterService.appRouter
            .navigateTo('/ForgotPassOtp/$param?varId=$varID');

        break;
      default:
        break;
    }
  }
}