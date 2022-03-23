import 'package:market_space/model/sell_item_req_model/sell_item_req_model.dart';
import 'dart:io';

class SellingItems {
  static String productType;
  static String productTitle;
  static String condition;
  static String category;
  static String subCategory;
  static String description;
  static String packageWidth;
  static String packageHeight;
  static String packageLength;
  static String packageWeight;
  static String price,paymentCurrency,fiatPrice;
  static String brandName;
  static String customBrandName;
  static String customBrandingImage;
  static String saleCondition;
  static String courierServices;
  static String shippingMethod;
  static String estimatedShippingPrice, deliveryInfo;
  static String handlingTime, deliveryTime;
  static List<String> itemTags;
  static bool freeShipping,mailCheck;
  static List<Variations> variations = List();
  static List<Variation> variatorList = List();
  static bool agreePolicy;
  static bool fileUploadLink;
  static List<File> productImages;
  static List<String> tagList;
}
