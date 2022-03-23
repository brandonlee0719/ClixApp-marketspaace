class OrderException implements Exception {
  String cause;
  OrderException(this.cause);
}