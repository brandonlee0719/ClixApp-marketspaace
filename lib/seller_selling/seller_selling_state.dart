part of 'seller_selling_bloc.dart';

@immutable
abstract class SellerSellingState {}

class SellerSellingInitial extends SellerSellingState {}

class Initial extends SellerSellingState {}

class Loading extends SellerSellingState {}

class Loaded extends SellerSellingState {}

class ImagePick extends SellerSellingState {}

class ImagePickFailed extends SellerSellingState {}

class CameraPick extends SellerSellingState {}

class CameraPickFailed extends SellerSellingState {}
