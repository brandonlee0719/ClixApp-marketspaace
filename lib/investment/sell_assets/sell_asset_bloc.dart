import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sell_asset_event.dart';
part 'sell_asset_state.dart';

class SellAssetBloc extends Bloc<SellAssetEvent, SellAssetState> {
  SellAssetBloc(SellAssetInitial initial) : super(SellAssetInitial());

  @override
  Stream<SellAssetState> mapEventToState(
    SellAssetEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
