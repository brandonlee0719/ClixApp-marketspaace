part of 'banners_bloc.dart';

@immutable
abstract class BannersState extends Equatable {
  const BannersState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class InitialBannersState extends BannersState {}

class BannerLoading extends BannersState {}

class BannerLoaded extends BannersState {
  final BannerImagesModel bannerList;

  const BannerLoaded(this.bannerList);

  @override
  List<Object> get props => [];
}

class BannerLoadingFailed extends BannersState {
  final String errorMessage;

  const BannerLoadingFailed(this.errorMessage);

  @override
  List<Object> get props => [];
}
