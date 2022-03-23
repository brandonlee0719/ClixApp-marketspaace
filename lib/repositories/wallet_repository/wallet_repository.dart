import 'dart:convert';

import 'package:market_space/investment/models/wallet.dart';
import 'package:market_space/investment/network/wallet_provider.dart';
import 'package:market_space/model/image_banner/image_banner_model.dart';

class WalletRepository {
  WalletProvider walletProvider = WalletProvider();
  Wallet wallet;

  Future<BannerImagesModel> getBanners() async {
    return walletProvider.getBannersList();
  }

  Future<int> getWalletCode() async {
    int statusCode = await walletProvider.getResponse();
    // print(walletProvider.response.data);
    if (walletProvider.response.data is String) {
      return 404;
    }
    Map<String, dynamic> map = walletProvider.response.data;
    wallet = Wallet.fromJson(map);
    return statusCode;
  }
}
