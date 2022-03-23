part of 'flash_bloc.dart';

@immutable
abstract class FlashEvent {}


class LoadMoreFlashPromoEvent extends FlashEvent {
  LoadMoreFlashPromoEvent();

}

class LoadFlashPromoEvent extends FlashEvent {
      LoadFlashPromoEvent();
}
