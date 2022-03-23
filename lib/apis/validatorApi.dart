class ValidatorApi{
  bool _validatePhoneNumber(String phoneNumber){
    bool isPhone = RegExp(
      // r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        r'^(?:[+])?[0-9]{11}$')
        .hasMatch(phoneNumber);
    return isPhone;
  }

  bool _validateEmailAddress(String emailAddress){
    bool isEmail = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
    .hasMatch(emailAddress);
    return isEmail;
  }

  VarType validate(String input){
    if(_validatePhoneNumber(input)){
      return VarType.phoneNumber;
    }

    else if(_validateEmailAddress(input)){
      return VarType.email;
    }

    return VarType.none;
  }



}

enum VarType{
  email,
  phoneNumber,
  none,
}