import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:market_space/l10n/I10n.dart';
import 'package:market_space/services/l10n_services.dart';

enum _LKeys {
  next,
  country,
  firstName,
  lastName,
  address,
  line2,
  city,
  state,
  pNumber,
  zipCode,
  shippingInst,
  confirmAdd,
  doorText,
  addNewAddress,
  edit,
  suburb
}

class AddNewAddressL10n {
  static final Map<String, Map<_LKeys, String>> _localizedValues = {
    L10nService.enUS.toString(): {
      _LKeys.next: "NEXT",
      _LKeys.country: "Country",
      _LKeys.firstName: "First Name",
      _LKeys.lastName: "Last Name",
      _LKeys.address: "Address",
      _LKeys.line2: "Address line 2",
      _LKeys.city: "City",
      _LKeys.state: "State",
      _LKeys.pNumber: "Phone number",
      _LKeys.zipCode: "Zip code",
      _LKeys.shippingInst: "Instructions for shipping",
      _LKeys.confirmAdd: "CONFIRM NEW SHIPPING ADDRESS",
      _LKeys.doorText: "Door number, leave at the door, etc.",
      _LKeys.addNewAddress: "ADD NEW ADDRESS",
      _LKeys.edit: "EDIT",
      _LKeys.suburb: "Suburb"
    },
    L10nService.ptZh.toString(): {
      _LKeys.next: "下一个",
      _LKeys.country: "国家",
      _LKeys.firstName: "名字",
      _LKeys.lastName: "姓",
      _LKeys.address: "地址",
      _LKeys.line2: "地址行2",
      _LKeys.city: "市",
      _LKeys.state: "州",
      _LKeys.pNumber: "电话号码",
      _LKeys.zipCode: "邮政编码",
      _LKeys.shippingInst: "运输说明",
      _LKeys.confirmAdd: "确认新的送货地址",
      _LKeys.doorText: "门号，留在门口等",
      _LKeys.addNewAddress: "添加新地址",
      _LKeys.edit: "编辑",
      _LKeys.suburb: "市郊"
    },
  };

  String get next => _localizedValues[locale.toString()][_LKeys.next];
  String get country => _localizedValues[locale.toString()][_LKeys.country];
  String get firstName => _localizedValues[locale.toString()][_LKeys.firstName];
  String get lastName => _localizedValues[locale.toString()][_LKeys.lastName];
  String get address => _localizedValues[locale.toString()][_LKeys.address];
  String get line2 => _localizedValues[locale.toString()][_LKeys.line2];
  String get city => _localizedValues[locale.toString()][_LKeys.city];
  String get state => _localizedValues[locale.toString()][_LKeys.state];
  String get pNumber => _localizedValues[locale.toString()][_LKeys.pNumber];
  String get zipCode => _localizedValues[locale.toString()][_LKeys.zipCode];
  String get shippingInst =>
      _localizedValues[locale.toString()][_LKeys.shippingInst];
  String get confirmAdd =>
      _localizedValues[locale.toString()][_LKeys.confirmAdd];
  String get doorText => _localizedValues[locale.toString()][_LKeys.doorText];
  String get addNewAddress =>
      _localizedValues[locale.toString()][_LKeys.addNewAddress];
  String get edit => _localizedValues[locale.toString()][_LKeys.edit];
  String get suburb => _localizedValues[locale.toString()][_LKeys.suburb];

  final Locale locale;

  AddNewAddressL10n(this.locale);

  static const LocalizationsDelegate<dynamic> delegate =
      _AddNewAddressL10nDelegate();
}

class _AddNewAddressL10nDelegate extends AL10nDelegate<AddNewAddressL10n> {
  const _AddNewAddressL10nDelegate();

  @override
  Future<AddNewAddressL10n> load(Locale locale) =>
      SynchronousFuture<AddNewAddressL10n>(AddNewAddressL10n(locale));
}
