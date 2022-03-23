class UserAddress{
  final int addressNum;

  final String country;

  final String firstName;

  final String instructions;

  final String lastName;

  final String phoneNumber;

  final String postcode;

  final String streetAddress;

  final String streetAddressTwo;
  final String suburb;
  final String state;

  UserAddress(this.addressNum, this.country, this.firstName, this.instructions,
      this.lastName, this.phoneNumber, this.postcode, this.streetAddress, this.streetAddressTwo, this.suburb,this.state);

  static UserAddress fromJson(Map<String, dynamic> map)
  {
    return UserAddress(map["addressNum"], map["country"], map["firstName"],
        map["instructions"], map["lastName"], map["phoneNumber"], map["postcode"],
        map["streetAddress"], map["streetAddressTwo"], map["suburb"], map["state"]);
  }

}