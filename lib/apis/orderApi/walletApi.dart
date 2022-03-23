import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:market_space/apis/firebaseManager.dart';
import 'package:market_space/investment/models/wallet.dart';
import 'package:market_space/investment/network/wallet_provider.dart';
import 'package:market_space/repositories/wallet_repository/wallet_repository.dart';

class WalletApi{
  WalletRepository walletProvider = WalletRepository();
  ValueNotifier<Wallet> wallet = ValueNotifier(null);

  void setWallet(Wallet walletModel){
    this.wallet.value = walletModel;
  }

  loadWallet() async {
    if(FirebaseManager.instance.getUID()!=null){
      int code = await walletProvider.getWalletCode();
      if(code == 200){
        this.wallet.value = walletProvider.wallet;
      }
    }
  }
}