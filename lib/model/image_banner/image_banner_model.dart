import 'package:equatable/equatable.dart';

class BannerImagesModel extends Equatable {
  final List<String> imgUrLs;

  const BannerImagesModel({this.imgUrLs});

  factory BannerImagesModel.fromJson(Map<String, dynamic> json) =>
      BannerImagesModel(
        imgUrLs: List<String>.from(json['imgURLs']),
      );

  Map<String, dynamic> toJson() => {
        'imgURLs': imgUrLs,
      };

  @override
  List<Object> get props => [imgUrLs];
}
