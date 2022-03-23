import 'package:market_space/model/address_model/address_model.dart';
import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';
import 'package:market_space/profile_settings/model/debit_card_model.dart';
import 'package:market_space/providers/checkout_provider/checkout_provider.dart';

class CheckoutRepository {
  //provider responsible for cloud function
  CheckoutProvider _checkoutProvider = CheckoutProvider();

  //get addresses form this method
  Future<List<UpdateAddressModel>> viewAddresses() async {
    return await _checkoutProvider.viewAddresses();
  }

  //Add a new address
  Future<int> addNewAddress(UpdateAddressModel addressModel) async {
    return await _checkoutProvider.addNewAddress(addressModel);
  }

  //return the debit card details
  Future<DebitCardModel> getDebitCardDetails() async {
    await _checkoutProvider.getVaultBasicCredentials();
    return await _checkoutProvider.getDebitCard();
  }
}
