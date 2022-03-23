import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:market_space/common/constants.dart';
import 'package:market_space/common/selling_item.dart';
import 'package:market_space/model/sell_item_req_model/sell_item_req_model.dart';
import 'package:market_space/repositories/auth/auth_repository.dart';
import 'package:market_space/common/selling_item.dart';

class SellerSellingProvider {
  final AuthRepository _authRepository = AuthRepository();
  final _baseUrl =
      'https://australia-southeast1-market-spaace.cloudfunctions.net';
  Dio dio = new Dio();
  String _token;
  int _status;

  Future<String> sellItem(SellItemReqModel reqModel) async {
    String _uid = await _authRepository.getUserId();
    // print(_uid);
    final createUserUrl = '$_baseUrl${Constants.sell_item}';
    _token = await _authRepository.getUserFirebaseToken();
    // print('token ${_token}');
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer $_token";
    dio.options.baseUrl = _baseUrl;
    reqModel.category = reqModel.category.replaceAll("'", "-");
    reqModel.category = reqModel.category.replaceAll(" ", "_");
    reqModel.subCategory = reqModel.subCategory.replaceAll("'", "-");
    reqModel.subCategory = reqModel.subCategory.replaceAll(" ", "_");
    // print(reqModel.desiredPaymentCurrency.runtimeType);
    // print('reqModel free shipping: ' + reqModel.freeShipping.toString());
    final Map<String, dynamic> data = {
      "agreeMSPolicy": reqModel.agreeMSPolicy,
      "category": reqModel.category,
      "condition": reqModel.condition,
      "description": reqModel.description,
      "desiredPaymentCurrency": reqModel.desiredPaymentCurrency,
      "fiatPrice": reqModel.fiatPrice,
      "productImages": reqModel.productImgLinks,
      "productTitle": reqModel.productTitle,
      "productType": reqModel.productType,
      "fiatCurrency": reqModel.fiatCurrency,
      "language": reqModel.language,
      "deliveryTime": reqModel.deliveryTime,
      "sellerHandlingTime": reqModel.sellerHandlingTime,
      "freeShipping": reqModel.freeShipping,
      // reqModel.sellerHandlingTime,
      "sellerUID": _uid,
      "subCategory": reqModel.subCategory,
      // "tags": SellingItems.tagList,
      "freeShipping": reqModel.freeShipping,
      "courierService": reqModel.courierService,
      "shippingMethod": reqModel.shippingMethod,
      "thumbnailLink": reqModel.thumbnailLink,
      // "packageWidth": reqModel.packageWidth,
      // "packageHeight": reqModel.packageHeight,
      // "packageLength": reqModel.packageLength,
      // "fileUploadLink": "",
      // "productKey": "",
      // "customBrandName": reqModel.customBrandName,
      // "customBrandDescription": reqModel.customBrandName,
      // "customBrandImg": "",
      // "variations": reqModel.variations,
      // reqModel.saleConditions
    };

    if (reqModel.freeShipping == "false") {
      data["packageWidth"] = reqModel.packageWidth;
      data["packageHeight"] = reqModel.packageHeight;
      data["packageLength"] = reqModel.packageLength;
      data["shippingPrice"] = reqModel.estimatedShippingPrice;
    }

    if (reqModel.isCustomBrand != null && !reqModel.isCustomBrand) {
      data["brandName"] = reqModel.brandName;
    } else if (reqModel.isCustomBrand != null && reqModel.isCustomBrand) {
      data["customBrandName"] = reqModel.customBrandName;
      data["customBrandDescription"] = reqModel.customBrandDescription;
      data["customBrandImg"] = reqModel.customBrandImgLink;
    }

    if (reqModel.saleConditions != null) {
      data["saleConditions"] = reqModel.saleConditions;
    }

    if (reqModel.deliveryInformation != null &&
        reqModel.deliveryInformation != "") {
      data["deliveryInformation"] = reqModel.deliveryInformation;
    }

    // // print(
    //     'Selling items estimated price: ${SellingItems.estimatedShippingPrice}');
    // // print('selling item data: ' + data.toString());
    final Response response = await dio.post(
      createUserUrl,
      data: data,
      options: Options(
          followRedirects: false,
          validateStatus: (status) {
            _status = status;
            return status <= 500;
          }),
    );

    // print(response.data.toString());
    // print(createUserUrl);
    // print(response.headers);

    if (_status == 200) {
      // print("success ${response.data.toString()}");
      return response.data.toString();
    } else {
      return response.data.toString();
    }
  }
}
