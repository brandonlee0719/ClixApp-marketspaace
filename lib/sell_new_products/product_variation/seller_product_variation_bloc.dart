import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'seller_product_variation_event.dart';
part 'seller_product_variation_state.dart';

class SellerProductVariationBloc
    extends Bloc<SellerProductVariationEvent, SellerProductVariationState> {
  SellerProductVariationBloc(SellerProductVariationState initialState)
      : super(initialState);

  @override
  Stream<SellerProductVariationState> mapEventToState(
    SellerProductVariationEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
