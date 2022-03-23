class ConvertModel{
  final double conversion;
  final double exchangeRate;
  final String id;
  final double totalPayout;
  final double wyreFees;

  ConvertModel(this.conversion, this.exchangeRate, this.id, this.totalPayout, this.wyreFees);

  static ConvertModel fromJson(Map<String, dynamic> map){
    return ConvertModel(map["conversion"], map["exchangeRate"],
        map["id"], map["totalPayout"], map["wyreFees"]);
  }
}