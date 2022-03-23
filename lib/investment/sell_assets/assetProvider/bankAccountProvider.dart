import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/providers/marketSpaaceParentProvider.dart';

class IBankProvider{
  // ignore: missing_return
  Future<bool> uploadBank(String accountNumber, String bsb) async{

  }

  // ignore: missing_return
  Future<bool> hasBank() async{

  }
}

class RemoteBankProvider extends MarketSpaceParentProvider implements IBankProvider  {
  String  uploadBankEnd ="";
  String checkBankEnd = "";
  @override
  Future<bool> uploadBank(String accountNumber, String bsb) async{
    // post(endPoint, data);
    return true;
  }

  @override
  Future<bool> hasBank() async{
    // post(endPoint, data);

    return true;
  }


}

class LocalBankProvider  implements IBankProvider{
  final FlutterSecureStorage _storage = Constants.singletonSecureStorage;
  String _bankKey = "bank_account";
  IBankProvider provider = RemoteBankProvider();
  @override
  Future<bool> hasBank() async{
    String s = await _storage.read(key: _bankKey);
    if(s!=null){
      return true;
    }

    bool b = await provider.hasBank();
    return b;


  }

  @override
  Future<bool> uploadBank(String accountNumber, String bsb) async {
    bool b = await provider.uploadBank(accountNumber, bsb);
    if(b){
      await _storage.write(key: _bankKey, value: "has_bank");
    }

    return b;
  }

}