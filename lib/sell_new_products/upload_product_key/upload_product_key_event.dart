part of 'upload_product_key_bloc.dart';

@immutable
abstract class UploadProductKeyEvent {}

class UploadProductKeyScreenEvent extends UploadProductKeyEvent {}

class UploadFileSuccessfully extends UploadProductKeyEvent {}

class UploadFileFailed extends UploadProductKeyEvent {}
