import 'package:market_space/apis/userApi/models/addressModel.dart';
import 'package:market_space/apis/userApi/shoppingCartManager.dart';
import 'package:market_space/order_checkout/model/update_address_model/update_address_model.dart';
import 'package:market_space/order_checkout/presentation/widgets/addressCard.dart';
import 'package:market_space/services/locator.dart';

class CheckModel {
  List<int> productList;
  String paymentType = "CRYPTOCURRENCY";
  String paymentCurrency = "ETH";
  String paymentMethod = "WALLET";
  bool isBillingSame = true;

  //to-do wait to be fixed
  String uid;
  UpdateAddressModel address;
  AddressOptions shippingAddress;
  UpdateAddressModel billingAddress;
  String ip;

  Map<String, dynamic> toJson() => {
        'productNum': [204],
        // 'productNum': [195],
        "userPaymentType": paymentType,
        "userPaymentCurrency": paymentCurrency,
        "userPaymentMethod": this.paymentMethod,
        "userCountry": "Australia",
        "firstName": address.firstName,
        "lastName": address.lastName,
        "postcode": address.postcode,
        "state": address.state,
        "streetAddress": address.streetAddress,
        "cvv": "123",
        if (address.streetAddressTwo != null)
          "streetAddressTwo": address.streetAddressTwo,
        "suburb": address.suburb,
        // "uid":uid,
        "ipAddress": ip,
        "billingCountry": billingAddress.country,
        "billingSuburb": billingAddress.suburb,
        "billingStreetAddress": billingAddress.streetAddress,
        "billingPostCode": billingAddress.postcode,
        "billingLastName": billingAddress.lastName,
        "billingFirstName": billingAddress.firstName,
        if (billingAddress.streetAddressTwo != null)
          "billingStreetAddressTwo": billingAddress.streetAddressTwo,

        "billingState": billingAddress.state,
        "billingAddressSame": isBillingSame,
        "phoneNumber": address.phoneNumber,
        "billingPhoneNumber": billingAddress.phoneNumber
      };
}
