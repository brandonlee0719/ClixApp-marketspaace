import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:market_space/model/bank_account_model/bank_account_model.dart';
import 'package:market_space/model/bank_account_model/bank_details_request_model.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/repositories/sending_payment_repository/sending_payment_repository.dart';
import 'package:meta/meta.dart';

part 'add_new_sending_event.dart';
part 'add_new_sending_state.dart';

class AddNewSendingBloc extends Bloc<AddNewSendingEvent, AddNewSendingState> {
  AddNewSendingBloc(Initial initial) : super(AddNewSendingInitial());

  SendingPaymentRepository _sendingPaymentRepository =
      SendingPaymentRepository();
  BankAccountModel bankAccountModel;
  BankDetailsRequestModel bankDetailsRequestModel;
  String saveBankText;
  String bankStatus;
  AuthRepository _authRepository = AuthRepository();
  File pickFile;
  String uploadFile;
  String accountName, accountDetails;
  String accountRemovedText;

  @override
  Stream<AddNewSendingState> mapEventToState(
    AddNewSendingEvent event,
  ) async* {
    if (event is AddNewSendingScreenEvent) {
      // bankAccountModel = await _sendingPaymentRepository.getBankDetails();
      accountName = await _authRepository.getName();
      var bankDet = await _authRepository.getBankDetails();
      if (bankDet == null || bankDet == "\"empty\"") {
        accountDetails = null;
      } else {
        dynamic bankDetDecoded = jsonDecode(bankDet);
        bankDetailsRequestModel =
            BankDetailsRequestModel.fromJson(bankDetDecoded);
        accountDetails = bankDetailsRequestModel.accountNum;
      }
      if (accountDetails != null) {
        yield Loaded();
      } else {
        yield Failure();
      }
    }
    if (event is SaveBankDetailsEvent) {
      saveBankText = await _sendingPaymentRepository
          .saveBankDetails(bankDetailsRequestModel);
      await _authRepository.saveBankDetails(bankDetailsRequestModel);
      if (saveBankText != null) {
        yield SaveBankDetails();
      } else {
        yield SaveBankDetailsFailure();
      }
    }

    if (event is BankStatusEvent) {
      bankStatus = await _sendingPaymentRepository.getBankStatus();
      if (bankStatus != null) {
        yield BankStatusSuccess();
      } else {
        yield BankStatusFailure();
      }
    }

    if (event is PickFileEvent) {
      pickFile = await _pickFile();
      if (pickFile != null) {
        uploadFile =
            await _sendingPaymentRepository.uploadBankStatement(pickFile);
      }
      if (uploadFile != null) {
        yield PickFileSuccess();
      } else {
        yield PickFileFailure();
      }
    }

    if (event is RemoveBankAccountEvent) {
      accountRemovedText = await _sendingPaymentRepository.removeBankAccount();
      if (accountRemovedText != null) {
        await _authRepository.saveBankDetails("empty");

        yield BankAccountRemovedSuccess();
      } else {
        yield BankAccountRemovedFailure();
      }
    }
  }

  Future<File> _pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    File file;
    if (result != null) {
      file = File(result.files.single.path);
      // print(result.files.single.name);
      String s = result.files.single.name;
      s.split(".");
      List<String> splitStr = s.split(".").map((unit) {
        return unit;
      }).toList();
      // print(s);
    } else {}
    return file;
  }
}
