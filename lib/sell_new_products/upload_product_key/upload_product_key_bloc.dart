import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'upload_product_key_event.dart';
part 'upload_product_key_state.dart';

class UploadProductKeyBloc
    extends Bloc<UploadProductKeyEvent, UploadProductKeyState> {
  UploadProductKeyBloc(Initial initial) : super(UploadProductKeyInitial());

  @override
  Stream<UploadProductKeyState> mapEventToState(
    UploadProductKeyEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
