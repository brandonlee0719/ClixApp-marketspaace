import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/dashboard/dashboard_bloc.dart';
import 'package:market_space/model/rates_model/rates_model.dart';
import 'package:market_space/notification/logics/blocs/notification_bloc.dart';
import 'package:market_space/repositories/dashboardRepository/dashboard_repository.dart';
import 'package:meta/meta.dart';

enum RateEvent {
  init,
  doit,
}
enum RateState {
  init,
  rateTraced,
  rateTracedFailed,
}

class RateBloc extends Bloc<RateEvent, RateState> {
  DashboardRepository dash = new DashboardRepository();
  RateBloc(this.notification) : super(RateState.init);
  final NotificationBloc notification;

  @override
  Stream<RateState> mapEventToState(
    RateEvent event,
  ) async* {
    if (event == RateEvent.doit) {
      // RatesModel rate = await dash.dashboardProvider.getCryptoRate();
      // Constants.aud = rate.fiatRates.aud;
      // Constants.btc = rate.cryptoRates.btc;
      // print("diyicizhixing");
      yield RateState.rateTraced;
      await Future.delayed(Duration(seconds: 20));
      const oneSec = const Duration(seconds: 500);
      // print("1st excuted");
      // notification.add(NotificationScreenEvent());
      dash.dashboardProvider.getCryptoRate();

      Timer.periodic(oneSec, (Timer timer) {
        // print("2nd excuted");
        notification.add(NotificationScreenEvent());
        dash.dashboardProvider.getCryptoRate();
      });
    }
  }
}
