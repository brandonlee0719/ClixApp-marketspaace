part of 'flash_bloc.dart';

abstract class FlashState extends Equatable {
  const FlashState();

  @override
  List<Object> get props => [];
}

class FlashInitial extends FlashState {}

// class FlashHide extends FlashState {}

// class FlashShow extends FlashState {
//   final List<FlashPromoAlgoliaObj> flashList;
//
//   const FlashShow(this.flashList);
// }

class FlashLoadingState extends FlashState {
  @override
  List<Object> get props => [];
}

class FlashLoadSuccessState extends FlashState {
  final List<FlashPromoAlgoliaObj> flashList;

  final showFlash;

  final bool showLoader;

  const FlashLoadSuccessState(this.flashList, this.showFlash, {this.showLoader=true});

  @override
  List<Object> get props => [flashList,showFlash,showLoader];
}

class FlashLoadFailedState extends FlashState {
  final String errorMessage;
  const FlashLoadFailedState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
