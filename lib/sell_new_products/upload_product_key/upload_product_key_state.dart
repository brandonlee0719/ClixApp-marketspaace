part of 'upload_product_key_bloc.dart';

@immutable
abstract class UploadProductKeyState {}

class UploadProductKeyInitial extends UploadProductKeyState {}

class Initial extends UploadProductKeyState {}

class Loading extends UploadProductKeyState {}

class Loaded extends UploadProductKeyState {}
