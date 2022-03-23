import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:market_space/common/AppIcons.dart';

extension bioPicTure on BiometricType {
  IconData getIcon() {
    switch (this) {
      case BiometricType.face:
        return AppIcons.face;
        break;
      case BiometricType.fingerprint:
        return AppIcons.fingerprint;
        break;
      default:
        return null;
        break;
    }
  }
}

class LocalAuthApi {
  static final _auth = LocalAuthentication();
  static Future<bool> authenticate() async {
    try {
      final bool isAvailable = await hasBiometrics();
      if (!isAvailable) {
        return false;
      }
    } on PlatformException catch (e) {
      // print(e);
    }
    try {
      return await _auth.authenticateWithBiometrics(
        localizedReason: "scan face to continue with the wallet",
        androidAuthStrings:
            AndroidAuthMessages(signInTitle: "face id required"),
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      // print(e);
    }
  }

  static Future<bool> hasBiometrics() async {
    List<BiometricType> results = await _auth.getAvailableBiometrics();
    for (BiometricType result in results) {
      // print(result.toString());
      // print(result.index);
    }
    return await _auth.canCheckBiometrics;
  }

  static Future<BiometricType> getBioType() async {
    List<BiometricType> results = await _auth.getAvailableBiometrics();
    BiometricType result;
    try {
      // print(results.length);
      result = results[0];
    } catch (e) {
      return BiometricType.face;
    }
    return result;
  }
}
