import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:market_space/profile_settings/network/vaultProvider.dart';

enum CreditEvent {
  uploadCredit,
}

enum CreditState {
  init,
  uploadingCard,
  uploadingSuccess,
  uploadingFail,
}

class CreditBloc extends Bloc<CreditEvent, CreditState> {
  int result;
  CreditBloc() : super(CreditState.init);
  VaultProvider vault = new VaultProvider();

  @override
  Stream<CreditState> mapEventToState(
    CreditEvent event,
  ) async* {
    if (event == CreditEvent.uploadCredit) {
      yield CreditState.uploadingCard;
      result = await vault.uploadVaultData();
      // ignore: unrelated_type_equality_checks

      yield CreditState.uploadingSuccess;
    }
  }
}
