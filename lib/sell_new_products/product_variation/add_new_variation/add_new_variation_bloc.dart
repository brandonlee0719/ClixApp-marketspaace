import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:market_space/model/sell_item_req_model/sell_item_req_model.dart';
import 'package:meta/meta.dart';

part 'add_new_variation_event.dart';
part 'add_new_variation_state.dart';

class AddNewVariationBloc
    extends Bloc<AddNewVariationEvent, AddNewVariationState> {
  AddNewVariationBloc(AddNewVariationState initialState) : super(initialState);
  List<Variation> _variationList = List();

  @override
  Stream<AddNewVariationState> mapEventToState(
    AddNewVariationEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
