import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:market_space/apis/orderApi/walletApi.dart';
import 'package:market_space/repositories/wallet_repository/wallet_repository.dart';
import 'package:market_space/services/locator.dart';
import 'package:meta/meta.dart';
import 'package:market_space/model/image_banner/image_banner_model.dart';

enum InvestmentState {
  initial,
  reloadSuccess,
  reloadFail,
  loading,
}

enum InvestmentEvent { InvestmentScreenEvent }

class InvestmentBloc extends Bloc<InvestmentEvent, InvestmentState> {
  InvestmentBloc(InvestmentState initialState) : super(initialState);

  WalletRepository walletRepository = WalletRepository();
  Stream<List<String>> get bannerStream =>
      walletRepository.walletProvider.bannerStream;

  //to-do deal with the reload fail state on the code.
  @override
  Stream<InvestmentState> mapEventToState(
    InvestmentEvent event,
  ) async* {
    if (event == InvestmentEvent.InvestmentScreenEvent) {
      yield InvestmentState.loading;
      // int bannerStatus = await _getBanner();
      int walletStatus = await walletRepository.getWalletCode();
      locator<WalletApi>().setWallet(walletRepository.wallet);
      if (walletStatus == 200 && walletRepository.wallet.ETH != null) {
        yield InvestmentState.reloadSuccess;
      } else {
        yield InvestmentState.reloadFail;
      }
    }
  }

  Future<BannerImagesModel> _getBanner() async {
    return walletRepository.getBanners();
  }
}
