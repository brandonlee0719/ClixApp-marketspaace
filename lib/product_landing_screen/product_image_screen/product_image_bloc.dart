import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'product_image_event.dart';
part 'product_image_state.dart';

class ProductImageBloc extends Bloc<ProductImageEvent, ProductImageState> {
  ProductImageBloc(Initial initial) : super(initial);

  @override
  Stream<ProductImageState> mapEventToState(
    ProductImageEvent event,
  ) async* {}
}
