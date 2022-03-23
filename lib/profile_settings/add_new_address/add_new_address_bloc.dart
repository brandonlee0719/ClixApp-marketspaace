import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market_space/apis/userApi/UserApi.dart';
import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';
import 'package:market_space/providers/api_provider.dart';
import 'package:market_space/repositories/profile_setting_repository/profile_setting_repository.dart';
import 'package:meta/meta.dart';

part 'add_new_address_event.dart';
part 'add_new_address_state.dart';

class AddNewAddressBloc extends Bloc<AddNewAddressEvent, AddNewAddressState> {
  AddNewAddressBloc(AddNewAddressState initialState) : super(initialState);
  final ProfileSettingRepository _profileSettingRepository =
      ProfileSettingRepository();
  UpdateAddressModel updateAddressModel;

  @override
  AddNewAddressState get initialState => Initial();
  @override
  Stream<AddNewAddressState> mapEventToState(
    AddNewAddressEvent event,
  ) async* {
    if (event is AddNewAddressScreenEvent) {
      yield Loading();
      await Future.delayed(Duration(microseconds: 200));
      yield Loaded();
    }
    if (event is AddNewAddressButtonEvent) {
      yield Loading();
      int status = await _addNewAddress();
      if (status == 200) {
        yield AddNewAddressSuccessfully();
      } else {
        yield AddNewAddressFailed();
      }
    }
    if (event is UploadingBillingAddress) {
      yield Loading();
      String uid = await AuthProvider().getUserUID();
      UserApi(FirebaseFirestore.instance, uid)
          .updateAddress(this.updateAddressModel);
      yield AddNewAddressSuccessfully();
    }
    if (event is EditAddressButtonEvent) {
      yield Loading();
      int status = await _editAddress();
      if (status == 200) {
        yield EditAddressSuccessfully();
      } else {
        yield EditAddressFailed();
      }
    }
  }

  Future<int> _addNewAddress() async {
    return await _profileSettingRepository.addNewAddress(updateAddressModel);
  }

  Future<int> _editAddress() async {
    return await _profileSettingRepository.editAddress(updateAddressModel);
  }
}

class UploadingBillingAddress extends AddNewAddressEvent {}
