import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'buy_assets_event.dart';
part 'buy_assets_state.dart';

class BuyAssetsBloc extends Bloc<BuyAssetsEvent, BuyAssetsState> {
  BuyAssetsBloc(Initial initial) : super(BuyAssetsInitial());

  @override
  Stream<BuyAssetsState> mapEventToState(
    BuyAssetsEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
