import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:market_space/model/bank_account_model/bank_account_model.dart';
import 'package:market_space/model/bank_account_model/bank_details_request_model.dart';
import 'package:market_space/profile_settings/model/debit_card_model.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/repositories/sending_payment_repository/sending_payment_repository.dart';
import 'package:meta/meta.dart';

part 'receiving_payment_event.dart';
part 'receiving_payment_state.dart';

class ReceivingPaymentBloc
    extends Bloc<ReceivingPaymentEvent, ReceivingPaymentState> {
  ReceivingPaymentBloc(ReceivingPaymentState initialState)
      : super(initialState);

  SendingPaymentRepository _sendingPaymentRepository =
      SendingPaymentRepository();
  BankAccountModel bankAccountModel;
  BankDetailsRequestModel bankDetailsRequestModel;
  String saveBankText;
  String bankStatus;
  AuthRepository _authRepository = AuthRepository();
  File pickFile;
  String uploadFile;
  String passPhrase;
  String cardNumber, name, expire;
  String debitCardToken, vaultToken;
  DebitCardModel debitCardDetails;
  String credintials;

  @override
  ReceivingPaymentState get initialState => Initial1();
  @override
  Stream<ReceivingPaymentState> mapEventToState(
    ReceivingPaymentEvent event,
  ) async* {
    if (event is ReceivingPaymentScreenEvent) {
      bankAccountModel = await _sendingPaymentRepository.getBankDetails();
      if (bankAccountModel != null) {
        yield Loaded1();
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

    if (event is SaveDebitEvent) {
      if (passPhrase == null) {
        passPhrase = await _sendingPaymentRepository.getPassPhrase();
      }
      await _sendingPaymentRepository.addKey(passPhrase);
      debitCardToken = await _sendingPaymentRepository.saveDebitCardDetails(
          cardNumber, name, expire);
      if (debitCardToken != null) {
        yield SaveDebitCardSuccess();
      } else {
        yield SaveBankDetailsFailure();
      }
    }

    if (event is SaveOtherDebitDetailsEvent) {
      await _sendingPaymentRepository.paymentMethodProvider.saveKeyServer();
      await _sendingPaymentRepository.paymentMethodProvider
          .saveVaultDataServer();
    }

    if (event is GetBasicCredentialsEvent) {
      credintials = await _sendingPaymentRepository.getVaultBasicCreds();
      if (credintials != null) {
        passPhrase = await _sendingPaymentRepository.paymentMethodProvider
            .getKeyServer();
        if (passPhrase != null) {
          vaultToken = await _sendingPaymentRepository.paymentMethodProvider
              .getVaultData();
          // await _authRepository.saveVaultToken(vaultToken);
          debitCardDetails = await _sendingPaymentRepository
              .paymentMethodProvider
              .getDebitCard();
          if (debitCardDetails != null) {
            yield GetVaultSuccess();
          } else {
            yield GetVaultFailure();
          }
        } else {
          yield GetVaultFailure();
        }
      } else {
        yield GetVaultFailure();
      }
    }
    if (event is SaveDebitCardServerEvent) {
      String vaultStatus;
      // await _sendingPaymentRepository.paymentMethodProvider.saveKeyServer();
      vaultStatus = await _sendingPaymentRepository.paymentMethodProvider
          .saveVaultDataServer();
      if (vaultStatus != null) {
        yield SaveDebitCardServerSuccess();
      } else {
        SaveDebitCardServerFailure();
      }
    }
    if (event is RemoveDebitDetailsEvent) {
      String removeCard;
      removeCard = await _sendingPaymentRepository.paymentMethodProvider
          .removeDebitCard();
      if (removeCard != null) {
        yield RemoveVaultSuccess();
        await _sendingPaymentRepository.paymentMethodProvider
            .deleteVaultDataServer();
        await _sendingPaymentRepository.paymentMethodProvider.deleteKeyServer();
      } else {
        yield RemoveVaultFailure();
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
